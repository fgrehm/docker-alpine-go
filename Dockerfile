FROM gliderlabs/alpine:3.3
MAINTAINER Fabio Rehm "fgrehm@gmail.com"

RUN apk-install bash \
                bash-completion \
                build-base \
                bzr \
                ca-certificates \
                curl \
                git \
                mercurial \
                python \
                wget

RUN set -x \
    && export ALPINE_GLIBC_BASE_URL="https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64" \
    && export ALPINE_GLIBC_PACKAGE="glibc-2.21-r2.apk" \
    && export ALPINE_GLIBC_BIN_PACKAGE="glibc-bin-2.21-r2.apk" \
    && wget "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE" "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_BIN_PACKAGE" \
    && apk add --no-cache --allow-untrusted "$ALPINE_GLIBC_PACKAGE" "$ALPINE_GLIBC_BIN_PACKAGE" \
    && /usr/glibc/usr/bin/ldconfig "/lib" "/usr/glibc/usr/lib" \
    && echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf \
    && rm "$ALPINE_GLIBC_PACKAGE" "$ALPINE_GLIBC_BIN_PACKAGE"

ENV HOME="/home/developer" \
    GOROOT="/usr/lib/go" \
    GOPATH="/go" \
    GOBIN="/go/bin" \
    PATH="/home/developer/bin:/go/bin:/usr/lib/go/bin:$PATH"

RUN set -x \
    && mkdir -p $HOME/bin \
    && echo 'source /etc/profile.d/bash_completion.sh' >> $HOME/.bashrc \
    && echo "alias ll='ls -lah'" >> $HOME/.bashrc \
    && curl -L https://storage.googleapis.com/golang/go1.5.3.linux-amd64.tar.gz \
       | tar xz -C $(dirname $GOROOT) \
    && go get github.com/parkghost/watchf/... \
    && go get github.com/constabulary/gb/... \
    && rm -rf /tmp/* \
    && addgroup developer -g 1000 \
    && adduser -u 1000 -D -s /bin/bash -G developer developer \
    && chown 1000:1000 -R $HOME \
    && mkdir -p $GOPATH \
    && chown 1000:1000 -R $GOPATH \
    && mkdir -p $GOROOT \
    && chown 1000:1000 -R $GOROOT

USER developer
WORKDIR /code
CMD /bin/bash
