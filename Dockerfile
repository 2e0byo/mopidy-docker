#syntax=docker/dockerfile:1.4
arg BASE=radio

FROM python:alpine as mopidy
ENV PIP_CACHE_DIR=/var/cache/pip
RUN --mount=type=cache,id=apk-${TARGETARCH},sharing=locked,target=/etc/apk/cache \
    --mount=type=cache,id=pip-${TARGETARCH},target=/var/cache/pip <<-EOF
    apk update
    # Install mopidy to pull in deps; install pip later on top. Wasted space is pretty small.
    apk add \
      mopidy \
      build-base \
      cairo-dev \
      gobject-introspection-dev

    pip install mopidy pygobject
    apk del build-base cairo-dev gobject-introspection-dev
EOF
CMD ["mopidy", "--config", "/etc/config/mopidy.conf"]

from mopidy as local
RUN --mount=type=cache,id=pip-${TARGETARCH},target=/var/cache/pip <<-EOF
    pip install mopidy-local
EOF

from local as tidal
RUN --mount=type=cache,id=pip-${TARGETARCH},sharing=locked,target=/var/cache/pip <<-EOF
    pip install mopidy-tidal
EOF

from tidal as radio
RUN --mount=type=cache,id=pip-${TARGETARCH},sharing=locked,target=/var/cache/pip <<-EOF
    pip install Mopidy-RadioNet
EOF


from ${BASE} as tidal-iris
RUN --mount=type=cache,id=pip-${TARGETARCH},sharing=locked,target=/var/cache/pip <<-EOF
    pip install mopidy-iris
EOF




