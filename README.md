# 🍓 Raspberry Pi 4 GitOps Homelab

Production-grade, declarative edge homelab for Raspberry Pi 4 (256 GB) featuring automated local reverse proxying, network-wide ad & telemetry blocking, container monitoring, and a unified service portal.

---

## 🏛️ Architecture Overview

```
                      [ Local Network / Wi-Fi ]
                                  │
                                  ▼
               ┌──────────────────────────────────────┐
               │         Raspberry Pi 4 (4-Core)       │
               │        IP: 192.168.68.60 (256 GB)     │
               │                                      │
               │   ┌──────────────────────────────┐   │
               │   │      Caddy Reverse Proxy     │   │
               │   │    Ports: 80 / 443 / 8080    │   │
               │   └──────────────┬───────────────┘   │
               │                  │                   │
      ┌────────┴──────────┬───────┴──────────┬────────┴─────────┐
      ▼                   ▼                  ▼                  ▼
┌──────────────┐   ┌──────────────┐   ┌──────────────┐   ┌──────────────┐
│   Homepage   │   │ AdGuard Home │   │ Uptime Kuma  │   │    Dozzle    │
│  Dashboard   │   │ DNS / AdBlock│   │ Health Watch │   │  Log Stream  │
│  Port: 3000  │   │  Port: 53/3000│  │  Port: 3001  │   │  Port: 8080  │
└──────────────┘   └──────────────┘   └──────────────┘   └──────────────┘
```

---

## 📦 Services Included

| Service | Container | Function | Access URL |
| :--- | :--- | :--- | :--- |
| **Homepage** | `homelab_homepage` | High-performance dashboard with live Pi metrics | `http://raspberrypi.local` |
| **AdGuard Home** | `homelab_adguard` | Network-wide DNS sinkhole & ad/telemetry blocking | `http://raspberrypi.local:3000` |
| **Uptime Kuma** | `homelab_uptime` | Service uptime monitoring & alert notifications | `http://raspberrypi.local:3001` |
| **Dozzle** | `homelab_dozzle` | Real-time lightweight Docker container log viewer | `http://raspberrypi.local:8080` |
| **Caddy** | `homelab_caddy` | Edge reverse proxy & local TLS termination | `http://raspberrypi.local` |

---

## 🚀 Quickstart & Setup Guide

### 1. Enable Passwordless SSH Login
Copy your Mac's SSH public key (`~/.ssh/id_ed25519.pub`) onto the Pi:
```bash
make copy-key
```
*(Enter your Pi password once when prompted. Subsequent logins will be completely passwordless!)*

### 2. Bootstrap the Node
Run the automated system provisioning script over SSH:
```bash
make bootstrap
```
This updates APT packages, installs Docker Engine, adds user permissions, and applies Linux kernel endurance tunings (`vm.swappiness=10` and Docker log rotation to safeguard the 256 GB microSD).

### 3. Deploy All Services
Launch the entire homelab stack:
```bash
make deploy
```

### 4. Verify System Health
Check live CPU temperature, memory usage, and container statuses:
```bash
make status
```

---

## 🛠️ Management CLI Commands

| Command | Action |
| :--- | :--- |
| `make ssh` | Open interactive SSH terminal shell on the Pi |
| `make sync` | Sync workspace code changes to the Pi via `rsync` |
| `make deploy` | Pull latest images and restart containers |
| `make logs` | Follow live logs from all containers |
| `make restart` | Gracefully restart all running services |
| `make down` | Tear down containers without losing data |

---

## 🔗 Ecosystem Integrations

* **Kindle Weather Display**: Monitored 24/7 by Uptime Kuma; status displayed on the Homepage portal.
* **Car Thing DeskThing**: Accessible from the homelab dashboard; can receive telemetry metrics from the Pi.

---

## 📄 License

MIT © [Nikhil Grover](https://github.com/nikhilgrover)
