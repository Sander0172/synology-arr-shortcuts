#!/bin/sh
# Writes ui/config based on the wizard choices (environment variables wiz_*).
CONF="$SYNOPKG_PKGDEST/ui/config"
SAVED="$SYNOPKG_PKGVAR/wizard.env"

write_config() {
  first=1
  printf '{\n  ".url": {\n' > "$CONF"
  while IFS='|' read -r id title defport; do
    [ -z "$id" ] && continue
    eval enabled="\${wiz_${id}:-false}"
    eval port="\${wiz_${id}_port:-$defport}"
    [ "$enabled" = "true" ] || continue
    proto=http
    case "$port" in https:*) proto=https; port="${port#https:}";; esac
    [ $first -eq 1 ] || printf ',\n' >> "$CONF"
    first=0
    cat >> "$CONF" <<EOT
    "SYNO.SDS._ThirdParty.App.arrlinks.$id": {
      "type": "url",
      "title": "$title",
      "desc": "Open $title",
      "icon": "images/${id}_{0}.png",
      "allUsers": true,
      "protocol": "$proto",
      "port": "$port",
      "url": "/"
    }
EOT
  done < "$SYNOPKG_PKGDEST/apps.list"
  printf '\n  }\n}\n' >> "$CONF"
  # remember choices for later upgrades
  env | grep '^wiz_' > "$SAVED" 2>/dev/null || true
}
