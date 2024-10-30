# docker-verify-BIRDS

BIRDS の verification 処理を開発するための docker 環境。
`-it` オプションでコンテナに接続して使うことを想定しています。


### How to use

```bash
$ docker pull cedretaber/vebirds

$ docker run --rm -it -v ${BIRDSへのパスに置き換えてください}:/birds cedretaber/vebirds bash

# コンテナの中
$ cd /birds
```


### How to build

CPU が Apple silicon の場合は、 Docker のオプションで `Use Rosetta for x86_64/amd64 emulation on Apple Silicon` を無効にしてください（ Rosetta が有効だとビルドが失敗します）。

```bash
$ docker build -t vebirds .
```
