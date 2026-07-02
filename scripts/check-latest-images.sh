#!/usr/bin/env bash
set -euo pipefail

# --- Helper functions ---

fetch_latest_tag() {
  local slug="$1" version="$2"
  curl -sG 'https://api.apps.rancher.io/v1/artifacts' \
    --data-urlencode "packaging_formats=CONTAINER" \
    --data-urlencode "component_slug_name=${slug}" \
    --data-urlencode "version=${version}" \
    --data-urlencode "page_number=1" \
    --data-urlencode "page_size=100" \
    | jq -r '
      .items
      | map(select(.architecture == "x86_64"))
      | sort_by(.revision | split(".") | map(tonumber))
      | last
      | .name
      | split(":") | last
    '
}

extract_slug() {
  echo "$1" | awk -F/ '{print $NF}'
}

extract_image_ref() {
  echo "$1" | awk -F/ '{print $(NF-1)"/"$NF}'
}

extract_version() {
  echo "$1" | sed 's/^v//' | cut -d'-' -f1
}

pull_and_extract_chart() {
  local version="$1"
  helm pull "oci://dp.apps.rancher.io/charts/suse-storage" --version "${version}"
  tar zxf "suse-storage-${version}.tgz"
}

collect_images() {
  local values_file="$1" images_tmp="$2"

  for section in longhorn csi; do
    local keys
    keys=$(yq e ".image.${section} | keys | .[]" "${values_file}" 2>/dev/null)
    [ -z "$keys" ] && continue

    while IFS= read -r key; do
      local registry repo tag slug image_ref version latest
      registry=$(yq e ".image.${section}.${key}.registry" "${values_file}")
      repo=$(yq e ".image.${section}.${key}.repository" "${values_file}")
      tag=$(yq e ".image.${section}.${key}.tag" "${values_file}")

      [[ "$repo" == "null" || -z "$repo" ]] && continue
      [[ "$tag" == "null" || -z "$tag" ]] && continue

      slug=$(extract_slug "$repo")
      if [[ -n "$registry" && "$registry" != "null" ]]; then
        image_ref="${registry}/${repo}"
      else
        image_ref="$repo"
      fi
      version=$(extract_version "$tag")
      latest=$(fetch_latest_tag "$slug" "$version")

      if [[ -n "$latest" && "$latest" != "null" ]]; then
        echo "${slug}:${latest}"
        echo "${image_ref}:${latest}" >> "$images_tmp"
        echo "| ${slug} | ${tag} | ${latest} |" >> "$SUMMARY_FILE"
      else
        echo "${slug}: (no version found for version=${version})"
        echo "| ${slug} | ${tag} | N/A |" >> "$SUMMARY_FILE"
      fi
    done <<< "$keys"
  done
}

create_update_pr() {
  local chart_version="$1" images_tmp="$2"
  local major_minor target_branch update_branch

  major_minor=$(echo "$chart_version" | sed 's/\([0-9]*\.[0-9]*\)\..*/\1/')
  target_branch="v${major_minor}.x"
  update_branch="update-images-v${chart_version}-$(date +%Y%m%d%H%M%S)"

  pushd "$REPO_DIR" > /dev/null

  git fetch origin "${target_branch}"
  git checkout -B "${update_branch}" "origin/${target_branch}"

  mkdir -p deploy
  cp "$images_tmp" deploy/longhorn-images.txt

  git add deploy/longhorn-images.txt
  if git diff --cached --quiet; then
    echo "No changes to deploy/longhorn-images.txt for v${target_branch}, skipping PR."
  else
    git commit -m "Update longhorn-images.txt for ${target_branch}"
    git push origin "${update_branch}"
    local pr_url
    pr_url=$(gh pr create \
      --base "${target_branch}" \
      --head "${update_branch}" \
      --title "chore: update longhorn-images.txt for ${target_branch}" \
      --body "Auto-generated PR to update image versions for SUSE Storage ${target_branch}.")
    echo "Created PR: ${pr_url}"
    auto_merge_if_no_conflict "${pr_url}"
  fi

  git checkout - 2>/dev/null || true
  popd > /dev/null
}

auto_merge_if_no_conflict() {
  local pr_url="$1"
  local mergeable="" attempt=0

  # GitHub computes mergeable state asynchronously; poll briefly.
  while (( attempt < 10 )); do
    mergeable=$(gh pr view "${pr_url}" --json mergeable -q .mergeable 2>/dev/null || echo "")
    if [[ "$mergeable" == "MERGEABLE" || "$mergeable" == "CONFLICTING" ]]; then
      break
    fi
    attempt=$((attempt + 1))
    sleep 3
  done

  case "$mergeable" in
    MERGEABLE)
      echo "PR is mergeable, merging: ${pr_url}"
      gh pr merge "${pr_url}" --squash --delete-branch
      ;;
    CONFLICTING)
      echo "PR has conflicts, leaving it open for manual resolution: ${pr_url}"
      ;;
    *)
      echo "PR mergeable state is '${mergeable:-unknown}', leaving it open: ${pr_url}"
      ;;
  esac
}

# --- Main ---

if [[ $# -eq 0 ]]; then
  echo "Error: no versions provided." >&2
  echo "Usage: $0 <versions...>" >&2
  echo "Example: $0 \"1.11.2 1.10.4 1.9.6\"" >&2
  exit 1
fi

VERSIONS="$1"
SUMMARY_FILE="${GITHUB_STEP_SUMMARY:-/dev/null}"
WORKDIR=$(mktemp -d)
REPO_DIR="$PWD"

echo "## Latest Image Versions" >> "$SUMMARY_FILE"
echo "" >> "$SUMMARY_FILE"

for CHART_VERSION in ${VERSIONS}; do
  echo "========================================="
  echo "Processing SUSE Storage chart v${CHART_VERSION}"
  echo "========================================="

  echo "### Chart v${CHART_VERSION}" >> "$SUMMARY_FILE"
  echo "" >> "$SUMMARY_FILE"
  echo "| Image | Current Tag | Latest |" >> "$SUMMARY_FILE"
  echo "|-------|-------------|--------|" >> "$SUMMARY_FILE"

  IMAGES_TMP=$(mktemp)

  pushd "$WORKDIR" > /dev/null
  pull_and_extract_chart "${CHART_VERSION}"
  collect_images "suse-storage/values.yaml" "$IMAGES_TMP"
  rm -rf suse-storage "suse-storage-${CHART_VERSION}.tgz"
  popd > /dev/null

  create_update_pr "${CHART_VERSION}" "$IMAGES_TMP"

  rm -f "$IMAGES_TMP"
  echo "" >> "$SUMMARY_FILE"
done

rm -rf "$WORKDIR"

if [[ "$SUMMARY_FILE" != "/dev/null" ]]; then
  cat "$SUMMARY_FILE"
fi
