#syntax=docker/dockerfile:1.4
arg BASE=radio

FROM python:alpine as mopidy
ENV PIP_CACHE_DIR=/var/cache/pip
RUN --mount=type=cache,target=/etc/apk/cache <<-EOF
    apk update
    apk add mopidy
EOF

from mopidy as local
RUN --mount=type=cache,target=/var/cache/pip <<-EOF
    pip install mopidy-local
EOF

from local as tidal
RUN --mount=type=cache,target=/var/cache/pip <<-EOF
    pip install mopidy-tidal
EOF

from tidal as radio
RUN --mount=type=cache,target=/var/cache/pip <<-EOF
    pip install Mopidy-RadioNet
EOF


from ${BASE} as tidal-iris
RUN --mount=type=cache,target=/var/cache/pip <<-EOF
    pip install mopidy-iris
EOF



