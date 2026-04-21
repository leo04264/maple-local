#!/usr/bin/env bash
set -euo pipefail

: "${STAGING_RELEASE_DIR:?Set STAGING_RELEASE_DIR}"
: "${ARTIFACT_DIR:?Set ARTIFACT_DIR}"

mkdir -p "$STAGING_RELEASE_DIR"
rsync -av --delete "$ARTIFACT_DIR"/ "$STAGING_RELEASE_DIR"/

echo "staging deploy complete: $STAGING_RELEASE_DIR"
echo "NOTE: replace this script with your actual service restart / symlink / container rollout logic."
