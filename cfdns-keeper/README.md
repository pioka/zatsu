# cfdns-keeper
CloudFlare DNSに登録したAレコードのIPを更新/登録するやつ。

事前インストールが必要なコマンド:
* `curl`
* `jq`

設定が必要な環境変数
* `CF_TOKEN`
* `CF_ZONE_ID`
* `CF_DNS_RECORD_NAME`
