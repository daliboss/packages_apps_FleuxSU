#!/usr/bin/env bash
# Refresh FleuxSU.apk from a published FleuxSU release.
#
#   ./scripts/update-apk.sh 2.0
#
# Downloads the APK from the FleuxSU release page, verifies it is an APK, replaces the prebuilt
# and refreshes FleuxSU.apk.sha256. Commit both files afterwards.
set -euo pipefail

version="${1:-}"
if [ -z "$version" ]; then
    echo "usage: $0 <version>   (e.g. $0 2.0)" >&2
    exit 1
fi

root="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/.." && pwd)"
url="https://gitlab.com/daliboss/fleux-app/-/releases/${version}/downloads/Fleux-${version}.apk"
tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT

echo "downloading $url"
curl -fL --retry 3 --retry-delay 2 "$url" -o "$tmp"

if ! unzip -l "$tmp" 2>/dev/null | grep -q 'AndroidManifest.xml'; then
    echo "error: downloaded file is not an APK" >&2
    exit 1
fi

cp "$tmp" "$root/FleuxSU.apk"
sha256sum "$root/FleuxSU.apk" | awk '{print $1}' > "$root/FleuxSU.apk.sha256"

echo "FleuxSU.apk updated to $version"
cat "$root/FleuxSU.apk.sha256"
