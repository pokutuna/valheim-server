times_takuya-valheim
===

## Usage

- 編集する
  - Makefile の `PROJECT`
  - `terraform/variables.tf`
- 以下を実行する

```sh
$ make init
$ cd terraform && terraform apply
```

## Instance Types

- n1-standard-1 だと起動に15分ぐらいかかる
  - 起動時のアセットの展開などがめっちゃ CPU バウンド?
- 費用: https://cloud.google.com/compute/all-pricing?hl=ja

## Docker image

https://github.com/lloesche/valheim-server-docker
