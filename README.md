times_takuya-valheim
===

- [Compute Engine](https://cloud.google.com/compute?hl=ja) の[プリエンプティブルインスタンス](https://cloud.google.com/compute/docs/instances/preemptible?hl=ja)で Valheim サーバーを立てる
  - プリエンプティブルインスタンスは費用が約 1/3 の代わりに GCP の都合でインスタンスが停止する
  - ゲームデータはマウントした永続ディスクに書く
- Discord Bot でインスタンスを start/stop したり IP を確認できるようにする
## Usage

### サーバーを立てる

- 編集する
  - Makefile の `PROJECT`
  - `terraform/variables.tf`
  - `terraform/cloud-init.yaml` サーバー設定
- 以下を実行する

```sh
$ make init
$ cd terraform && terraform apply
```

### Discord Bot

- [Discord Developer Portal](https://discord.com/developers/applications) からアプリケーションを作成
  - Bot をサーバーに追加
    - `OAuth2` > `applications.commands` スコープを有効にし、下の URL からサーバーを選択
  - slash command を定義
    - `$ CLIENT_ID=... BOT_TOKEN=... GUILD_ID=... node scripts/register_command.js`
    - `CLIENT_ID`: `General Information` にある値
    - `BOT_TOKEN`: `Bot` ページの `TOKEN` 値
    - `GUILD_ID`: Discord サーバーの ID、クライアントを開発モードにしてサーバー右クリックでコピーできる
- Cloud Functions をデプロイ
  - `bot/.env.yaml` を編集
    - `COMPUTE_ENGINE_ZONE`: 操作する対象の GCE インスタンスの ZONE (これ固定したくないけどサボっている)
    - `APP_PUBLIC_KEY`: Discord App の `General Information` にある値
    - `COMMAND_NAME` slash command のコマンド名
  - `make deploy-bot` でデプロイ
- Discord App の `INTERACTIONS ENDPOINT URL` へ Function URL を設定

## Instance Types

- n1-standard-2 以上がいい
- n1-standard-1 だと起動に15分ぐらいかかるけど一応遊べる
  - 起動時のアセットの展開などがめっちゃ CPU バウンド?
- 費用: https://cloud.google.com/compute/all-pricing?hl=ja

## Docker image

これ使っている

- [lloesche/valheim-server-docker: Valheim dedicated gameserver in Docker with automatic update and world backup support](https://github.com/lloesche/valheim-server-docker)
