#syntax=docker/dockerfile:1.4
arg BASE=radio
arg GST_VERSION=1.24.10-r0
arg PYTHON_VERSION=3.12.8
arg MOPIDY_IRIS=3.69.3
arg MOPIDY_TIDAL=v0.3.9
arg MOPIDY_LOCAL=3.2.1
arg MOPIDY_RADIONET=7b19c20

FROM python:${PYTHON_VERSION}-alpine as mopidy
ENV PIP_CACHE_DIR=/var/cache/pip
ARG GST_VERSION
ARG PYTHON_VERSION
RUN --mount=type=cache,id=apk-${TARGETARCH},sharing=locked,target=/etc/apk/cache <<-EOF
    apk update
    # Pinned version are for cache busting.  Most of our rebuilds are just for python updates, so they should be smaller.
    apk add \
      pipewire \
      gst-plugin-pipewire \
      gst-plugins-base=${GST_VERSION} \
      gst-plugins-good=${GST_VERSION} \
      gst-plugins-ugly=${GST_VERSION} \
      gst-plugins-bad=${GST_VERSION} \
      py3-gst \
      git
EOF
RUN --mount=type=cache,id=apk-${TARGETARCH},sharing=locked,target=/etc/apk/cache \
    --mount=type=cache,id=pip-${TARGETARCH},target=/var/cache/pip <<-EOF
    apk update
    apk add \
      build-base \
      cairo-dev \
      gobject-introspection-dev

    pip install mopidy pygobject
    apk del build-base cairo-dev gobject-introspection-dev
EOF
CMD ["mopidy", "--config", "/var/run/mopidy/config/mopidy.conf"]

from mopidy as local
ARG MOPIDY_LOCAL
RUN --mount=type=cache,id=pip-${TARGETARCH},target=/var/cache/pip <<-EOF
    pip install mopidy-local==${MOPIDY_LOCAL}
EOF

from local as tidal
ARG MOPIDY_TIDAL
RUN --mount=type=cache,id=pip-${TARGETARCH},sharing=locked,target=/var/cache/pip <<-EOF
    pip install git+https://github.com/tehkillerbee/mopidy-tidal@${MOPIDY_TIDAL}
EOF

from tidal as radio
ARG MOPIDY_RADIONET
RUN --mount=type=cache,id=pip-${TARGETARCH},sharing=locked,target=/var/cache/pip <<-EOF
    pip install git+https://github.com/plintx/mopidy-radionet@${MOPIDY_RADIONET}
EOF


from ${BASE} as tidal-iris
ARG MOPIDY_IRIS
RUN --mount=type=cache,id=pip-${TARGETARCH},sharing=locked,target=/var/cache/pip <<-EOF
    pip install mopidy-iris==${MOPIDY_IRIS}
EOF
