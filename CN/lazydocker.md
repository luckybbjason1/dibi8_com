---
title: 'LazyDocker: 51,092 GitHub Stars — Complete Terminal Docker UI Setup Guide 2026'
description: 'LazyDocker (LD) is a terminal UI for managing Docker containers, images, volumes, and logs. Compatible with Docker, Docker Compose, Go, and Terminal. Covers installation, keybindings, configuration, and production hardening.'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Dev Utils
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/jesseduffield/lazydocker'
stars: 51092
maintainer: 'jesseduffield'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['dev-utils']
tags: ['lazydocker', 'docker', 'terminal-ui', 'devops', 'containers', 'cli-tools', 'docker-compose', 'tui']
aliases:
- /posts/lazydocker/
---

{{</* resource-info */>}}

Managing Docker from the command line means memorizing dozens of flags, piping output through `grep`, and constantly switching between `docker ps`, `docker logs`, and `docker exec`. For developers who spend hours in the terminal, this friction adds up. LazyDocker solves this with a single binary that wraps your Docker workflow into a keyboard-driven terminal interface — no browser, no daemon, no setup overhead. With over 51,000 GitHub stars and a thriving ecosystem, it has become the default TUI tool for Docker management in 2026.

![LazyDocker Banner](https://raw.githubusercontent.com/jesseduffield/lazydocker/master/docs/resources/split_assets/banner.png)

## What Is LazyDocker?

LazyDocker is a terminal user interface (TUI) for Docker and Docker Compose, written in Go using the `gocui` framework. It provides a keyboard-navigable interface for viewing containers, images, volumes, networks, and logs — all in a split-pane layout within your terminal. A single binary connects directly to the Docker daemon via the same API the Docker CLI uses. No background service, no open ports, no additional attack surface.

Created by Jesse Duffield (also the author of LazyGit), LazyDocker targets developers who want immediate visual feedback without leaving the terminal. It is MIT-licensed, actively maintained, and has accumulated 51,092 stars and 1,600+ forks on GitHub.

## How LazyDocker Works

LazyDocker follows a simple architecture: the binary reads from and writes to the Docker Engine API through the local Unix socket (`/var/run/docker.sock`) or named pipe on Windows. All rendering happens inside the terminal via a character-based UI framework.

```
┌─────────────────────────────────────────┐
│              Terminal                    │
│  ┌──────────────────────────────────┐   │
│  │        LazyDocker TUI            │   │
│  │  ┌────────┐  ┌────────────────┐  │   │
│  │  │Containers│  │   Logs / Stats  │  │   │
│  │  ├────────┤  │                │  │   │
│  │  │ Images   │  │  Real-time     │  │   │
│  │  ├────────┤  │  output from   │  │   │
│  │  │ Volumes  │  │  Docker API    │  │   │
│  │  ├────────┤  │                │  │   │
│  │  │Networks  │  │                │  │   │
│  │  └────────┘  └────────────────┘  │   │
│  └──────────────────────────────────┘   │
│                   │                      │
│         ┌─────────▼──────────┐           │
│         │ /var/run/docker.sock│           │
│         └─────────┬──────────┘           │
│                   │                      │
│         ┌─────────▼──────────┐           │
│         │   Docker Daemon    │           │
│         └────────────────────┘           │
└─────────────────────────────────────────┘
```

Core concepts you need to understand:

- **Panels**: The left side shows categorized lists (Containers, Services, Images, Volumes, Networks). The right side shows details, logs, or stats for the selected item.
- **Context-aware actions**: The same key performs different actions depending on which panel is focused. Pressing `d` on a container removes it; pressing `d` on an image removes the image.
- **Docker Compose integration**: When launched inside a directory with a `docker-compose.yml` file, LazyDocker groups services by project and adds Compose-specific actions like `up` and `down`.

## Installation & Setup

LazyDocker installs in under 60 seconds on any platform. You need Docker installed and your user added to the `docker` group (or equivalent access to the Docker socket).

### Prerequisites

```bash
# Verify Docker is installed and running
docker --version
docker ps

# Add your user to the docker group (Linux)
sudo usermod -aG docker $USER
# Log out and back in for group change to take effect
```

### Method 1: Homebrew (macOS & Linux)

```bash
# Tap the official formula for frequent updates
brew install jesseduffield/lazydocker/lazydocker

# Verify installation
lazydocker --version
# Output: Version: v0.24.5, Build date: 2026-04-15, Commit: abc1234
```

### Method 2: Official Install Script (Linux)

```bash
# Automated install to ~/.local/bin
curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash

# Add to PATH if needed
echo 'export PATH=$PATH:$HOME/.local/bin' >> ~/.bashrc
source ~/.bashrc
```

### Method 3: Binary Download (All Platforms)

```bash
# Fetch latest release version
LAZYDOCKER_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazydocker/releases/latest" | grep '"tag_name":' | sed 's/.*"v\([^"]*\)".*/\1/')

# Download Linux x86_64 binary
curl -Lo lazydocker.tar.gz "https://github.com/jesseduffield/lazydocker/releases/download/v${LAZYDOCKER_VERSION}/lazydocker_${LAZYDOCKER_VERSION}_Linux_x86_64.tar.gz"

# Extract and install system-wide
tar xf lazydocker.tar.gz lazydocker
sudo install lazydocker /usr/local/bin/
rm lazydocker lazydocker.tar.gz
```

### Method 4: Go Install

```bash
# Requires Go >= 1.19
go install github.com/jesseduffield/lazydocker@latest

# Binary lands in ~/go/bin
export PATH=$PATH:$HOME/go/bin
```

### Method 5: Docker (Sandboxed)

```bash
# Run without installing — mounts Docker socket for full access
docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock \
  -v ~/.config/lazydocker:/.config/jesseduffield/lazydocker \
  lazyteam/lazydocker:latest

# Create a shell alias for convenience
echo "alias lzd='docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock -v ~/.config/lazydocker:/.config/jesseduffield/lazydocker lazyteam/lazydocker'" >> ~/.bashrc
```

### First Launch

```bash
# Launch LazyDocker
lazydocker

# Launch with debug output for troubleshooting
lazydocker --debug
```

On first launch, LazyDocker auto-detects running containers and displays the main interface. The layout splits into left navigation panels and a right content panel showing logs or stats for the selected item.

![LazyDocker Interface Demo](https://raw.githubusercontent.com/jesseduffield/lazydocker/master/assets/demo.gif)

![LazyDocker Screenshot](https://raw.githubusercontent.com/jesseduffield/lazydocker/master/docs/resources/split_assets/screenshot.png)

## Essential Keybindings

LazyDocker's efficiency comes from its vim-like keybindings. Navigation uses arrow keys or `hjkl`, and actions are single keystrokes.

### Global Navigation

| Key | Action |
|-----|--------|
| `Tab` / `Shift+Tab` | Cycle between left panels |
| `↑` `↓` / `k` `j` | Navigate items in a panel |
| `Enter` | Focus main panel / select |
| `Escape` / `q` | Go back / quit |
| `[` / `]` | Previous / next tab |
| `?` | Show help overlay |
| `/` | Filter current list |

### Container Actions

| Key | Action |
|-----|--------|
| `r` | Restart container |
| `s` | Stop container |
| `d` | Remove container (with confirmation) |
| `p` | Pause / unpause container |
| `e` | Hide/show stopped containers |
| `E` | Exec into container (open shell) |
| `a` | Attach to container |
| `m` | View logs |
| `u` | View CPU/memory stats |
| `w` | Open exposed port in browser |
| `b` | View bulk commands |
| `c` | Run custom predefined command |

### Docker Compose Service Actions

| Key | Action |
|-----|--------|
| `u` | Up service |
| `U` | Up entire project |
| `d` | Remove service containers |
| `D` | Down entire project |
| `s` | Stop service |
| `S` | Start service |
| `r` | Restart service |
| `R` | View restart options |
| `E` | Exec shell in service container |

### Image & Volume Actions

| Key | Action (Images) | Action (Volumes) |
|-----|-----------------|------------------|
| `d` | Remove image | Remove volume |
| `p` | Pull latest image | — |
| `Enter` | Inspect image details | Inspect volume |

### Log Navigation

| Key | Action |
|-----|--------|
| `PageUp` / `PageDown` | Scroll through logs |
| `g` | Jump to beginning of logs |
| `G` | Jump to end of logs |
| `/` | Search in logs |
| `n` | Next search match |
| `[` / `]` | Previous / next log page |

## Configuration & Customization

LazyDocker stores configuration in platform-specific paths. Press `o` in the Project panel (or `e` to edit in your default editor) to open the config file directly from the TUI.

### Config File Locations

| OS | Path |
|----|------|
| Linux | `~/.config/lazydocker/config.yml` |
| macOS | `~/Library/Application Support/jesseduffield/lazydocker/config.yml` |
| Windows | `C:\Users\<User>\AppData\Roaming\lazydocker\config.yml` |

### Custom Theme Configuration

```yaml
# ~/.config/lazydocker/config.yml
gui:
  language: "en"  # auto | en | fr | de | es | pl | nl | tr | zh
  border: "rounded"  # rounded | single | double | hidden
  theme:
    activeBorderColor:
      - cyan
      - bold
    inactiveBorderColor:
      - white
    selectedLineBgColor:
      - black
    selectedLineFgColor:
      - yellow
    optionsTextColor:
      - blue
  scrollHeight: 2
  sidePanelWidth: 0.333
  screenMode: "normal"  # normal | half | fullscreen
```

### Log Display Settings

```yaml
logs:
  timestamps: true
  since: "60m"    # Show logs from last 60 minutes; '' = all time
  tail: "200"     # Number of lines to display
```

### Custom Commands

Add your own commands accessible via the `c` key:

```yaml
customCommands:
  containers:
    - name: bash
      attach: true
      command: "docker exec -it {{ .Container.ID }} bash"
      serviceNames: []
    - name: debug-network
      attach: false
      command: "docker inspect {{ .Container.ID }} --format='{{range $k, $v := .NetworkSettings.Networks}}{{$k}}: {{.IPAddress}}\n{{end}}'"
```

Available template variables: `{{ .Container.ID }}`, `{{ .Container.Name }}`, `{{ .Service.Name }}`, `{{ .DockerCompose }}`.

### Podman Support

LazyDocker works with Podman by swapping the command templates:

```yaml
commandTemplates:
  docker: "podman"
  dockerCompose: "podman-compose"
  containerInspect: "podman inspect {{ .Container.ID }}"
```

## Integration with Popular Tools

### Docker Compose Projects

LazyDocker automatically detects `docker-compose.yml` or `compose.yml` in the current directory. Services appear grouped under the Services panel with project-level actions.

```bash
# Navigate to your Compose project
cd ~/projects/my-app

# Launch — services panel populates automatically
lazydocker
```

Within the Services panel:
- Press `u` to bring up a single service
- Press `U` to start the entire project
- Press `D` to tear down the full stack
- Press `E` to exec into a service container

### Tmux Integration

For tmux users, add a keybinding to launch LazyDocker in a popup or split:

```bash
# ~/.tmux.conf
# Open LazyDocker in a popup window
bind D display-popup -E -w 90% -h 90% "lazydocker"

# Or open in a new vertical split
bind d split-window -h "lazydocker"
```

Reload and use `Ctrl+b D` to open:

```bash
tmux source-file ~/.tmux.conf
```

### Zsh / Bash Aliases

```bash
# ~/.bashrc or ~/.zshrc
alias lzd="lazydocker"
alias lzd-logs="lazydocker --logs"

# Quick jump to project and launch
alias lzd-here="cd $PWD && lazydocker"

# Source your shell config
source ~/.bashrc
```

### VS Code Integration

Add a VS Code task to launch LazyDocker in the integrated terminal:

```json
// .vscode/tasks.json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "LazyDocker",
      "type": "shell",
      "command": "lazydocker",
      "problemMatcher": [],
      "presentation": {
        "echo": true,
        "reveal": "always",
        "focus": true,
        "panel": "new"
      }
    }
  ]
}
```

### CI/CD Pipeline Integration

LazyDocker works well in GitHub Actions for debugging container states during builds:

```yaml
# .github/workflows/debug.yml
name: Debug Containers
on: workflow_dispatch
jobs:
  debug:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Install LazyDocker
        run: |
          curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
          sudo mv ~/.local/bin/lazydocker /usr/local/bin/

      - name: Start services
        run: docker compose up -d

      - name: Inspect with LazyDocker
        run: |
          lazydocker --version
          # Export container list for logs
          docker ps --format "table {{.Names}}\t{{.Status}}"
```

## Benchmarks & Real-World Use Cases

### Resource Overhead Comparison

LazyDocker adds virtually no resource overhead because it runs as an ephemeral client process — not a persistent daemon.

| Scenario | Binary Size | RAM (running) | Startup Time | Background Process |
|----------|------------|---------------|--------------|-------------------|
| LazyDocker | ~15 MB | ~20 MB | <200 ms | None |
| Docker Desktop | ~1.5 GB | ~400-800 MB | 10-30 s | Yes (VM) |
| Portainer CE | ~80 MB image | ~100-200 MB | 5-10 s | Yes (container) |
| Rancher | ~300 MB image | ~500 MB+ | 30-60 s | Yes (cluster) |

### Real-World Scenarios

**Scenario 1: Home Lab Server (20 containers)**
A developer manages a media stack (Plex, Sonarr, Radarr, Traefik, Authelia) on a headless Ubuntu server. LazyDocker provides instant container status, live log tailing, and quick restarts over SSH without running a web service. Resource footprint: zero when not running.

**Scenario 2: Microservices Development (8 services)**
A team runs 8 Docker Compose services locally. LazyDocker groups services by project, shows which containers are restarting, and lets developers exec into failing services with a single keystroke. Average debugging workflow reduced from 45 seconds of CLI typing to 5 seconds of keyboard navigation.

**Scenario 3: CI/CD Debugging**
A DevOps engineer uses LazyDocker in GitHub Actions to capture container state and logs at the end of failing test runs. The TUI is not interactive in CI, but the `--logs` export and container list commands provide structured debug output.

## Advanced Usage & Production Hardening

### Running on Remote Hosts via SSH

LazyDocker does not natively support remote Docker hosts, but you can forward the Docker socket over SSH:

```bash
# Forward remote Docker socket to local machine
ssh -nNT -L /tmp/docker_remote.sock:/var/run/docker.sock user@remote-server &

# Point LazyDocker at the forwarded socket
export DOCKER_HOST=unix:///tmp/docker_remote.sock
lazydocker

# Clean up when done
kill %1
rm /tmp/docker_remote.sock
```

Alternatively, use SSH context directly:

```bash
# Create Docker context for remote host
docker context create remote --docker "host=ssh://user@remote-server"
docker context use remote

# LazyDocker uses the active context automatically
lazydocker
```

### Non-Root User Setup

```bash
# Create docker group if it doesn't exist
sudo groupadd -f docker

# Add current user
sudo usermod -aG docker $USER

# Apply without logout (Linux only)
newgrp docker

# Verify
lazydocker
```

### Automated Cleanup Workflow

```bash
#!/bin/bash
# ~/bin/docker-cleanup.sh
# One-key cleanup script integrated with LazyDocker

echo "Removing stopped containers..."
docker container prune -f

echo "Removing dangling images..."
docker image prune -f

echo "Removing unused volumes..."
docker volume prune -f

echo "Removing unused networks..."
docker network prune -f

echo "Cleanup complete. Remaining resources:"
docker system df
```

Bind this in LazyDocker via custom commands for one-key access.

### Monitoring Integration

Export LazyDocker stats to external monitoring by piping `docker stats` to Prometheus Node Exporter textfile collector:

```bash
#!/bin/bash
# cron job every 60 seconds
while true; do
  docker stats --no-stream --format \
    "container_cpu_usage{name=\"{{.Name}}\"} {{.CPUPerc}}\ncontainer_memory_usage{name=\"{{.Name}}\"} {{.MemUsage}}" \
    > /var/lib/node_exporter/textfile_collector/docker_stats.prom
  sleep 60
done
```

## Comparison with Alternatives

| Feature | LazyDocker | Docker Desktop | Portainer CE | Rancher |
|---------|------------|----------------|--------------|---------|
| Interface | Terminal TUI | Native desktop GUI | Web GUI | Web GUI |
| Install size | ~15 MB | ~1.5 GB | ~80 MB image | ~300 MB image |
| RAM overhead | ~20 MB (ephemeral) | ~400-800 MB | ~100-200 MB | ~500 MB+ |
| Multi-host | No (SSH workarounds) | Limited | Yes (agents) | Yes (clusters) |
| Kubernetes | No | Yes (local) | Yes | Yes (primary) |
| Docker Compose | Full support | Full support | Stack-based | Limited |
| Multi-user / RBAC | No | No | Yes (BE edition) | Yes |
| Works over SSH | Yes | No | Via browser | Via browser |
| Offline capable | Yes | Yes (local) | Needs network for UI | Needs network |
| Open source | MIT | Proprietary | AGPL / SSPL | Apache-2.0 |
| Startup time | <200 ms | 10-30 s | 5-10 s | 30-60 s |
| Best for | Terminal users | Local dev | Team management | Enterprise K8s |

## Limitations / Honest Assessment

LazyDocker is not the right tool for every situation. Here are the constraints:

- **No multi-host management**: You cannot manage multiple Docker hosts from a single LazyDocker instance. For that, use Portainer with agents or Rancher.
- **No web interface**: LazyDocker requires terminal access. If you need to manage containers from a phone or tablet, Portainer's responsive web UI is the better choice.
- **No RBAC or user management**: LazyDocker inherits your OS user's Docker permissions. There is no concept of teams, roles, or audit trails.
- **No Kubernetes support**: LazyDocker handles Docker and Docker Compose only. For Kubernetes workloads, use `k9s`, Rancher, or `kubectl` directly.
- **Single-user only**: Two engineers cannot simultaneously use the same LazyDocker session. Each user runs their own instance.
- **TUI learning curve**: Engineers unfamiliar with keyboard-driven interfaces (vim, tmux) may find the initial learning curve steeper than clicking through a web UI.
- **Read-heavy, write-cautious**: While LazyDocker supports destructive actions (remove, stop), it adds confirmation prompts that slow down bulk operations compared to scripted CLI workflows.

## Frequently Asked Questions

**Q: Does LazyDocker replace the Docker CLI?**

No. LazyDocker complements the CLI by providing a visual overview and quick actions. For scripting, automation, and CI/CD pipelines, the Docker CLI remains the correct tool. Many developers use both: LazyDocker for interactive exploration and `docker` commands for reproducible workflows.

**Q: Can I use LazyDocker with Podman?**

Yes. LazyDocker supports Podman through configuration overrides. Set `commandTemplates.docker` to `podman` and `commandTemplates.dockerCompose` to `podman-compose` in your `config.yml`. A community wrapper called `lazypodman` also exists for seamless Podman integration.

**Q: How do I view logs from a crashed container?**

Navigate to the Containers panel, press `e` to toggle visibility of stopped containers, select the crashed container, and press `m` to view its logs. Use `g` to jump to the start of the log stream and `G` to jump to the end.

**Q: Is LazyDocker safe to use in production?**

LazyDocker is safe because it is a client-side tool with no background service. It connects to the Docker socket with whatever permissions your user has. In production, limit Docker socket access to authorized users, avoid running LazyDocker on production hosts unless necessary, and prefer read-only operations (viewing logs and stats) over destructive actions.

**Q: Can I run LazyDocker inside a Docker container?**

Yes. Mount the host's Docker socket into the container with `-v /var/run/docker.sock:/var/run/docker.sock`. This gives LazyDocker full visibility into host containers. The official image is `lazyteam/lazydocker:latest`. This pattern works well for air-gapped environments or quick testing.

**Q: Why does LazyDocker show "Cannot connect to Docker daemon"?**

This error occurs when your user cannot access `/var/run/docker.sock`. Ensure your user is in the `docker` group, the Docker daemon is running (`sudo systemctl status docker`), and the `DOCKER_HOST` environment variable is not set to an invalid value. On macOS, verify Docker Desktop is running.

**Q: How do I customize keybindings?**

LazyDocker does not support full keybinding remapping through config, but you can add custom commands via the `customCommands` block in `config.yml`. For conflicting shortcuts with your terminal emulator, configure your terminal to pass the raw key through to the TUI.

## Conclusion

LazyDocker fills a specific niche: fast, lightweight, terminal-native Docker management. With 51,092 GitHub stars, a single-binary distribution, and sub-200-millisecond startup, it eliminates the friction of context-switching between browser tabs or memorizing CLI flags. For individual developers, homelab operators, and anyone who lives in the terminal, it is a practical addition to the toolkit.

**Action items to get started:**

1. Install LazyDocker via Homebrew or the official script (under 60 seconds)
2. Launch `lazydocker` in a project with running containers
3. Memorize 5 essential keys: `r` (restart), `s` (stop), `d` (remove), `m` (logs), `E` (exec shell)
4. Open the config with `o` and customize your theme and log settings
5. Add shell aliases for `lzd` and integrate with tmux for popup access

Join the [dibi8 Telegram community](https://t.me/dibi8_chat) to share your LazyDocker workflow tips and get help from other developers managing containers at scale.



## Recommended Hosting & Infrastructure

Before you deploy any of the tools above into production, you'll need solid infrastructure. Two options dibi8 actually uses and recommends:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — $200 free credit for 60 days across 14+ global regions. The default option for indie devs running open-source AI tools.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — Hong Kong VPS with low-latency access from mainland China. This is the same IDC that hosts dibi8.com — battle-tested in production.

*Affiliate links — they don't cost you extra and they help keep dibi8.com running.*

## Sources & Further Reading

- [LazyDocker GitHub Repository](https://github.com/jesseduffield/lazydocker)
- [Official Keybindings Reference](https://github.com/jesseduffield/lazydocker/blob/master/docs/keybindings/Keybindings_en.md)
- [Configuration Documentation](https://github.com/jesseduffield/lazydocker/blob/master/docs/Config.md)
- [LazyDocker Installation Guide](https://github.com/jesseduffield/lazydocker#installation)
- [LazyDocker Official Website](https://lazydocker.com)
- [Portainer vs LazyDocker Comparison (OneUptime)](https://oneuptime.com/blog/post/2026-03-20-portainer-vs-lazydocker-terminal/view)
- [DataCamp LazyDocker Tutorial](https://www.datacamp.com/tutorial/lazydocker)
- [LazyDocker Podman Extension](https://github.com/szchan/lazydocker-podman)
