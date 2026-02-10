# 🎵 mopidy-docker

A lightweight, optimized Docker container for [Mopidy](https://mopidy.com/), the extensible music server.

This image is purpose-built for **ARM64** (Raspberry Pi 3/4/5) and is specifically tuned for low-latency audio via **ALSA**. It is designed to run seamlessly in both standalone Docker environments and orchestrated Kubernetes (K3s) clusters.

## ✨ Features

* **ARM64 Native:** Optimized for Raspberry Pi hardware.
* **ALSA Shared Audio:** Pre-configured for `dmix` support, allowing multiple apps to share the soundcard.
* **Zeroconf/mDNS:** Ready for network discovery out of the box.
* **Hybrid Config:** Support for both native `.conf` (INI) and Kubernetes `ConfigMap` (YAML) formats.

## 🚀 Deployment

### 1. Docker Compose

Perfect for a standalone Raspberry Pi. This configuration ensures Mopidy has direct access to the hardware while remaining accessible on the local network via Zeroconf.

```yaml
# See docker-compose.yaml for the full configuration
services:
  mopidy:
    image: ghcr.io/tyz/mopidy-docker:latest
    network_mode: host      # Required for Zeroconf/mDNS
    ipc: host               # Required for ALSA dmix (shared memory)
    privileged: true        # Direct hardware access
    devices:
      - /dev/snd:/dev/snd
    group_add:
      - audio               # Permission to access sound devices

```

### 2. Kubernetes (K3s)

Designed for homelab clusters. The deployment includes specific security contexts to bridge the gap between container isolation and physical hardware.

* **Audio Pass-through:** Uses `hostPath` for `/dev/snd` and `/etc/asound.conf`.
* **Permissions:** Specifically uses `supplementalGroups: [29]` (the standard `audio` GID) to ensure the Mopidy process can use the hardware.
* **Config Mapping:** Supports mounting a YAML-based `ConfigMap` which is processed into the Mopidy INI format.

## ⚙️ Configuration Specs

| Feature | Docker Compose | Kubernetes | Why? |
| --- | --- | --- | --- |
| **Networking** | `network_mode: host` | `hostNetwork: true` | Enables mDNS/Avahi discovery. |
| **IPC** | `ipc: host` | `hostIPC: true` | Essential for ALSA `dmix` (shared audio). |
| **Permissions** | `group_add: [audio]` | `supplementalGroups: [29]` | Grants access to `/dev/snd/*` nodes. |
| **Config Path** | `./docker/mopidy.conf` | `ConfigMap` (YAML) | Flexible configuration management. |

## 🛠️ Important Notes on Audio

### ALSA & Dmix

To allow Mopidy to play audio alongside other system sounds, we mount the host's `/etc/asound.conf`. By setting `ipc: host` (or `hostIPC: true`), the container can access the host's shared memory segments required for the ALSA `dmix` plugin.

### Hardware Access

Accessing physical soundcards requires the container to run with elevated privileges.

> [!WARNING]
> This image requires `privileged: true` to bypass standard container isolation for direct hardware interaction. Use with caution in public-facing environments.

## 🏗️ Build

If you want to build the image manually for your specific architecture:

```bash
docker build -t mopidy-docker .

```
