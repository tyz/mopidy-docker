# syntax=docker/dockerfile:1.7-labs

FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

ADD --chmod=644 https://apt.mopidy.com/mopidy-archive-keyring.gpg /etc/apt/keyrings/mopidy.gpg
RUN echo "deb [arch=arm64 signed-by=/etc/apt/keyrings/mopidy.gpg] http://apt.mopidy.com/ bookworm main contrib non-free" > /etc/apt/sources.list.d/mopidy.list

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt update && \
    apt upgrade -y && \
    apt install -y mopidy gstreamer1.0-plugins-bad python3-pip python3-yaml

RUN --mount=type=cache,target=/root/.cache,sharing=locked \
    python3 -m pip install --break-system-packages --root-user-action ignore \
        mopidy_musicbox_webclient

COPY docker/mopidy.conf /etc/mopidy/mopidy.conf
COPY docker/entrypoint.sh /entrypoint.sh
COPY docker/yaml2ini.py /usr/local/bin/yaml2ini
RUN chmod 0755 /entrypoint.sh /usr/local/bin/yaml2ini && \
    chmod 0644 /etc/mopidy/mopidy.conf

EXPOSE 6680

CMD ["/entrypoint.sh"]
