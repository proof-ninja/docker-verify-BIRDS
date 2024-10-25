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

```bash
$ docker build -t vebirds .
```
