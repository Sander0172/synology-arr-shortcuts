#!/bin/sh
# Builds ArrLinks.spk from src/
set -e
cd "$(dirname "$0")/src"
VER=$(sed -n 's/^version="\(.*\)"/\1/p' INFO)
tmp=$(mktemp -d)
tar czf "$tmp/package.tgz" -C package .
cp -r INFO scripts conf WIZARD_UIFILES PACKAGE_ICON.PNG PACKAGE_ICON_256.PNG "$tmp/"
(cd "$tmp" && tar cf "$OLDPWD/../ArrLinks-$VER.spk" INFO package.tgz scripts conf WIZARD_UIFILES PACKAGE_ICON.PNG PACKAGE_ICON_256.PNG)
rm -rf "$tmp"
echo "Built ArrLinks-$VER.spk"
