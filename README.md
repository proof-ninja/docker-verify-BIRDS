# docker-verify-BIRDS

BIRDS の verification 処理を開発するための docker 環境。


### How to use

```bash
$ docker pull cedretaber/vebirds

$ docker run --rm -it -v path/to/BIRDS:/birds cedretaber/vebirds bash
```


### How to build

```bash
$ docker build -t vebirds .
```
