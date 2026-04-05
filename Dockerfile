# syntax=docker/dockerfile:1

FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

ADD --chmod=644 https://apt.mopidy.com/mopidy-archive-keyring.gpg /etc/apt/keyrings/mopidy.gpg
RUN echo "deb [arch=arm64 signed-by=/etc/apt/keyrings/mopidy.gpg] http://apt.mopidy.com/ bookworm main contrib non-free" > /etc/apt/sources.list.d/mopidy.list

RUN rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    --mount=type=cache,target=/var/cache/debconf \
    apt-get update && \
    apt-get install --no-install-recommends -y mopidy gstreamer1.0-plugins-bad python3-pip

RUN --mount=type=cache,target=/root/.cache,sharing=locked \
    python3 -m pip install --break-system-packages --root-user-action ignore \
        mopidy_musicbox_webclient

COPY docker/mopidy.conf /etc/mopidy/mopidy.conf
COPY docker/entrypoint.sh /entrypoint.sh
RUN chmod 0755 /entrypoint.sh && \
    chmod 0644 /etc/mopidy/mopidy.conf

EXPOSE 6680

CMD ["/entrypoint.sh"]
