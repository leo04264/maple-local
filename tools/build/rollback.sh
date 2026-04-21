#!/usr/bin/env bash
set -euo pipefail

: "${TARGET_LINK:?Set TARGET_LINK}"
: "${ROLLBACK_TO:?Set ROLLBACK_TO}"

ln -sfn "$ROLLBACK_TO" "$TARGET_LINK"
echo "rollback complete: $TARGET_LINK -> $ROLLBACK_TO"
