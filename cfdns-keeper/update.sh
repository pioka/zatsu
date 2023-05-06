#!/bin/bash

set -eu
CF_TOKEN="$CF_TOKEN"
CF_ZONE_ID="$CF_ZONE_ID"
CF_DNS_RECORD_NAME="${CF_DNS_RECORD_NAME}"

CF_DNS_RECORD_TTL="${CF_DNS_RECORD_TTL:-60}"



trap "echo '  -> ERROR'" ERR

function _call_cloudflare_api() {
  CF_ENDPOINT="https://api.cloudflare.com/client/v4"
  method="$1"
  endpoint="${CF_ENDPOINT}$2"
  body="${3:-}"
  response=$(curl -s "$endpoint" \
    -X "$method" \
    -H "Authorization: Bearer $CF_TOKEN" \
    -H "Content-Type:application/json" \
    -d "$body")
  echo "$response"
  if [ "$(echo $response | jq -r ".success")" != "true" ]; then
    return 1
  fi
}



# ifconfig.ioからグローバルIPを取得
echo "Get current IP"
DNS_RECORD_IP=$(curl -s "https://ifconfig.io")
echo "  -> OK"

# ゾーン内のDNSレコードの一覧を取得
echo "Get Record list in zone"
response=$(_call_cloudflare_api "GET" "/zones/$CF_ZONE_ID/dns_records")
echo "  -> OK"

# 取得した情報から$CF_DNS_RECORD_NAMEでホスト名が一致するレコードのIDを抽出, (無い場合はnull)
DNS_RECORD_ID=$(echo $response | jq -r "[.result[] | select(.name == \"$CF_DNS_RECORD_NAME\")][0].id")

# レコード内容組み立て
body="{\"type\":\"A\", \"name\":\"$CF_DNS_RECORD_NAME\", \"content\":\"$DNS_RECORD_IP\", \"ttl\":$CF_DNS_RECORD_TTL}"

# レコード内容更新,なければ新規作成
if [ "$DNS_RECORD_ID" != "null" ]; then
  echo "UPDATE record: $CF_DNS_RECORD_NAME -> $DNS_RECORD_IP"
  response=$(_call_cloudflare_api "PUT" "/zones/$CF_ZONE_ID/dns_records/$DNS_RECORD_ID" "$body")
else
  echo "CREATE record: $CF_DNS_RECORD_NAME -> $DNS_RECORD_IP"
  response=$(_call_cloudflare_api "POST" "/zones/$CF_ZONE_ID/dns_records" "$body")
fi
echo "  -> OK"
