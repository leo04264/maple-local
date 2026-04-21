#!/usr/bin/env bash
set -euo pipefail

: "${PROD_RELEASE_DIR:?Set PROD_RELEASE_DIR}"
: "${ARTIFACT_DIR:?Set ARTIFACT_DIR}"

mkdir -p "$PROD_RELEASE_DIR"
rsync -av --delete "$ARTIFACT_DIR"/ "$PROD_RELEASE_DIR"/

echo "production deploy complete: $PROD_RELEASE_DIR"
echo "NOTE: replace this script with your actual service restart / blue-green / symlink switch logic."
