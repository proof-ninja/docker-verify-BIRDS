FROM ubuntu:24.04

ENV OS_LOCALE="en_US.UTF-8" \
    LANG=${OS_LOCALE} \
    LANGUAGE=${OS_LOCALE} \
    LC_ALL=${OS_LOCALE} \
    OCAML_VERSION=5.1.1 \
    Z3_VERSION=4.13.3 \
    RACKET_VERSION=8.1

RUN apt-get update && apt-get install -y locales \
  && locale-gen ${OS_LOCALE} \
  && dpkg-reconfigure locales \
  && rm -rf /var/lib/apt/lists/*


# installing Lean and Z3
WORKDIR /root/
RUN BUILD_PKGS="wget unzip" \
  && RUNTIME_PKGS="libgomp1" \
  && apt-get update && apt-get install -y ${BUILD_PKGS} ${RUNTIME_PKGS} \
  && wget https://github.com/leanprover/lean/releases/download/v3.4.2/lean-3.4.2-linux.tar.gz \
  && tar -xzvf lean-3.4.2-linux.tar.gz \ 
  && mv lean-3.4.2-linux /usr/lib/lean \ 
  && ln -s /usr/lib/lean/bin/lean /usr/bin/lean \
  && ln -s /usr/lib/lean/bin/leanpkg /usr/bin/leanpkg \
  && ln -s /usr/lib/lean/bin/leanchecker /usr/bin/leanchecker \
  && wget https://github.com/Z3Prover/z3/releases/download/z3-${Z3_VERSION}/z3-${Z3_VERSION}-x64-glibc-2.35.zip \
  && unzip z3-${Z3_VERSION}-x64-glibc-2.35.zip \
  && mv z3-${Z3_VERSION}-x64-glibc-2.35 /usr/lib/z3 \
  && ln -s /usr/lib/z3/bin/z3 /usr/bin/z3 \
  && rm lean-3.4.2-linux.tar.gz \
  && rm z3-${Z3_VERSION}-x64-glibc-2.35.zip \
  && apt-get purge -y --auto-remove ${BUILD_PKGS} \
  && rm -rf /var/lib/apt/lists/*


# installing lean libs for birds
WORKDIR /root/
RUN BUILD_PKGS="git" \
  && RUNTIME_PKGS="" \
  && apt-get update && apt-get install -y ${BUILD_PKGS} ${RUNTIME_PKGS} \
  && git clone https://github.com/dangtv/BIRDS.git \
  && mv /root/BIRDS/ /usr/lib/birds/ \
  && cd /usr/lib/birds/verification \
  && leanpkg configure \
  && cd /usr/lib/birds/verification/_target/deps/mathlib/ && leanpkg configure && leanpkg build -- --threads=1 \
  && cd /usr/lib/birds/verification/_target/deps/super/ && leanpkg configure && leanpkg build \
  && cd /usr/lib/birds/verification/ && leanpkg build \
  && mkdir /root/.lean/ && cp /usr/lib/birds/docker/ubuntu/config/lean/leanpkg.path /root/.lean/ \
  && apt-get purge -y --auto-remove ${BUILD_PKGS} \
  && rm -rf /var/lib/apt/lists/*


# install racket and rosette
WORKDIR /root/
RUN BUILD_PKGS="wget libgtk2.0 libssl-dev" \
  && RUNTIME_PKGS="" \
  && apt-get update && apt-get install -y ${BUILD_PKGS} ${RUNTIME_PKGS} \
  && wget https://mirror.racket-lang.org/installers/${RACKET_VERSION}/racket-minimal-${RACKET_VERSION}-x86_64-linux.sh \
  && sh racket-minimal-${RACKET_VERSION}-x86_64-linux.sh --unix-style --create-dir --dest /usr/ \
  && ln -s /usr/local/racket/bin/racket /usr/local/bin/racket \
  && ln -s /usr/local/racket/bin/raco /usr/local/bin/raco \
  && raco pkg install --auto rosette \
  && rm racket-minimal-${RACKET_VERSION}-x86_64-linux.sh \
  && apt-get purge -y --auto-remove ${BUILD_PKGS} \
  && rm -rf /var/lib/apt/lists/*


# installing OCaml and dune
WORKDIR /root/
RUN BUILD_PKGS="" \
  && RUNTIME_PKGS="wget build-essential git make m4 curl unzip" \
  && apt-get update && apt-get install -y ${BUILD_PKGS} ${RUNTIME_PKGS} \
  && echo "/usr/bin" | bash -c "sh <(curl -fsSL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)" \
  && opam init --disable-sandboxing \
  && eval `opam config env` \
  && echo 'eval `opam config env`' >> /root/.bashrc \
  && opam switch create ${OCAML_VERSION} \
  && opam install -y num ocamlgraph menhir dune \
  && apt-get purge -y --auto-remove ${BUILD_PKGS} \
  && rm -rf /var/lib/apt/lists/*


CMD ["/usr/bin/bash"]
