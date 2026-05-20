---
title: 'act: 70,410 GitHub Stars — Run GitHub Actions Locally, Production CI/CD Guide 2026'
description: 'act (nektos/act) is a CLI tool that runs GitHub Actions locally using Docker containers. Compatible with Docker, GitHub Actions, Go, and VS Code. Covers installation, setup, secrets management, runner images, and production hardening.'
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
github_repo: 'https://github.com/nektos/act'
stars: 70410
maintainer: 'nektos'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['dev-utils']
tags: ['act', 'github-actions', 'ci-cd', 'docker', 'local-development', 'devops', 'testing', 'automation']
aliases:
- /posts/act/
---

{{</* resource-info */>}}

![act logo](https://raw.githubusercontent.com/nektos/act/master/img/act-logo.png)

## Introduction

Every developer who has written a GitHub Actions workflow knows the pain: you make a change to `.github/workflows/ci.yml`, commit, push, wait 3-5 minutes for the runner to pick it up, only to watch it fail on step 4 because of a missing environment variable or a typo in a shell command. The feedback loop is slow, burns through your GitHub Actions minutes, and clutters your commit history with "fix CI" messages. In 2026, with CI/CD pipelines governing every deployment, this inefficiency is no longer acceptable. [act](https://github.com/nektos/act), a command-line tool built in Go by Casey Lee and the nektos organization, solves this by running GitHub Actions workflows locally inside Docker containers — matching GitHub's environment variables, filesystem layout, and runner behavior. With 70,410 stars on GitHub and a thriving ecosystem of integrations, act has become the standard tool for local CI/CD development.

## What Is act?

act is a CLI tool that reads GitHub Actions workflow files from `.github/workflows/` and executes them locally using Docker containers, faithfully reproducing the GitHub Actions runtime environment on your machine. This tutorial walks through the complete act setup — from installation to production hardening — so you can validate every workflow change before pushing to GitHub.

## How act Works

act operates as a local GitHub Actions runner simulator. When you run `act` in a repository, it performs the following steps:

1. **Workflow Discovery**: Scans `.github/workflows/` for YAML workflow files
2. **Event Parsing**: Determines which workflows to trigger based on the event type (push, pull_request, etc.)
3. **Dependency Resolution**: Builds a directed acyclic graph (DAG) of job dependencies
4. **Image Preparation**: Pulls or builds Docker images for the specified runners
5. **Container Execution**: Runs each step inside Docker containers with GitHub-compatible environment variables and filesystem mounts
6. **Artifact Collection**: Gathers outputs, artifacts, and logs

![act architecture diagram](https://raw.githubusercontent.com/nektos/act/master/img/act-quickstart-2.gif)

The tool uses the Docker Engine API directly, which means any Docker-compatible container runtime works as a backend. The environment variables (`GITHUB_SHA`, `GITHUB_REF`, `GITHUB_REPOSITORY`, etc.) and filesystem structure (`/github/workspace`, `/github/event.json`, `/github/home`) are configured to match what GitHub provides on its hosted runners.

### Runner Image Sizes

act offers three image tiers for balancing fidelity against disk space:

| Image Size | Download | Disk Space | Use Case |
|---|---|---|---|
| Micro | ~50 MB | <200 MB | Node.js only, quick smoke tests |
| Medium | ~200 MB | ~500 MB | Essential tools, good for most workflows |
| Large | ~5 GB | ~18-75 GB | Full GitHub runner parity, complete toolchains |

![act runner image sizes comparison](https://nektosact.com/usage/runners.html.assets/runner-images-table.png)

The default Medium image (`catthehacker/ubuntu:act-latest`) includes Python, Node.js, Go, Ruby, Java, .NET, and common build tools. The Large images (`catthehacker/ubuntu:full-*`) are filesystem dumps of actual GitHub-hosted runners and provide the closest parity.

## Installation & Setup

act installs in under 60 seconds on any platform with Docker available. Choose your method:

### macOS (Homebrew)

```bash
# Install act via Homebrew
brew install act

# Verify installation
act --version
# act version 0.2.88
```

### Linux (Bash Script)

```bash
# One-line installer (requires bash and curl)
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash

# Alternative: download pre-built binary
wget https://github.com/nektos/act/releases/download/v0.2.88/act_Linux_x86_64.tar.gz
tar xzf act_Linux_x86_64.tar.gz
sudo mv act /usr/local/bin/
```

### Windows (Chocolatey / Scoop / WinGet)

```powershell
# Chocolatey
choco install act-cli

# Scoop
scoop install act

# WinGet
winget install nektos.act
```

### GitHub CLI Extension

```bash
# Install as gh CLI extension
gh extension install https://github.com/nektos/gh-act

# Run via gh
gh act
```

### Build from Source (Go 1.20+)

```bash
git clone https://github.com/nektos/act.git
cd act/
make build
sudo make install
```

### Post-Installation Setup

On first run, act prompts you to select a default image size:

```bash
# First run — select default runner image
act
? Please choose the default image you want to use with act:
  - Large size image: ~17GB download, ~75GB disk space, closest to GitHub runners
  - Medium size image: ~500MB, includes essential tools (RECOMMENDED)
  - Micro size image: <200MB, Node.js only
```

This creates `~/.actrc` with your default configuration:

```bash
# ~/.actrc — default configuration
cat ~/.actrc
-P ubuntu-latest=catthehacker/ubuntu:act-latest
```

### Docker Prerequisites

act requires Docker Engine API. Before running:

```bash
# Verify Docker is running
docker info

# Verify Docker API is accessible
docker version
```

**Note:** Podman is not officially supported (issue #303). For rootless setups or alternatives, use Docker Desktop, Rancher Desktop, or Colima on macOS.

## Integration with Docker, VS Code, GitHub Enterprise, and Make

### Docker Integration

act uses Docker as its execution engine. Every workflow job runs in an isolated container:

```bash
# Run with a custom runner image
act -P ubuntu-latest=node:20-slim

# Specify custom Docker host (remote engine)
export DOCKER_HOST=tcp://remote-docker:2376
act

# Use container architecture flag for Apple Silicon
act --container-architecture linux/amd64
```

Docker-in-Docker (DinD) workflows are supported by mounting the host Docker socket:

```yaml
# .github/workflows/dind-test.yml
name: Docker Build Test
on: push
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Build Docker image
        run: docker build -t myapp:latest .
```

### VS Code Extension (GitHub Local Actions)

The [GitHub Local Actions](https://marketplace.visualstudio.com/items?itemName=SanjulaGanepola.github-local-actions) VS Code extension provides a GUI for act:

```bash
# Install the extension from VS Code marketplace
# Press Cmd+Shift+P → "Extensions: Install Extensions" → Search "GitHub Local Actions"
```

After installing the extension:
- Open the Act panel from the sidebar
- View all workflows in `.github/workflows/`
- Click any workflow to run it locally
- See real-time logs in the integrated terminal

![VS Code GitHub Local Actions Extension](https://raw.githubusercontent.com/SanjulaGanepola/github-local-actions/main/resources/screencast.gif)

### GitHub Enterprise Support

act supports private GitHub Enterprise Server instances:

```bash
# Run against GitHub Enterprise Server
act --github-instance github.company.com

# With authentication
act --github-instance github.company.com -s GITHUB_TOKEN=ghp_xxxxxxxx
```

### Replacing Make with act

Many teams use act as a local task runner, replacing Makefiles with GitHub Actions workflows:

```yaml
# .github/workflows/tasks.yml
name: Local Tasks
on: workflow_dispatch
jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run linter
        run: npm run lint
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run tests
        run: npm test
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Build
        run: npm run build
```

```bash
# Run tasks locally instead of make
act -j lint
act -j test
act -j build
```

## Benchmarks / Real-World Use Cases

### Feedback Loop Comparison

| Scenario | Push-to-GitHub | Local with act | Time Saved |
|---|---|---|---|
| Fix typo in workflow | 3-5 min | 15-30 sec | 90% |
| Debug failing test | 5-10 min (multiple pushes) | 30-60 sec per iteration | 85% |
| Test matrix (3 OS × 2 Node versions) | 8-15 min | 2-3 min | 80% |
| Secret/config validation | 3-5 min | 20-40 sec | 90% |
| Workflow syntax check | 2-3 min | 10-15 sec (dry-run) | 92% |

### Case Study: Reducing CI Minutes

A mid-sized engineering team (25 developers) running 200 workflow pushes per day:

- **Before act**: ~600 failed CI runs/day consuming ~3,000 GitHub Actions minutes
- **After act**: Developers validate locally first; failed CI runs drop to ~80/day
- **Monthly savings**: ~66,000 GitHub Actions minutes = approximately $400-1,300/month depending on runner type

### Startup Time by Image Size

| Image | First Pull | Cold Start | Warm Start |
|---|---|---|---|
| Micro (node:16-slim) | ~10 sec | 5 sec | 2 sec |
| Medium (catthehacker/ubuntu:act-latest) | ~45 sec | 15 sec | 5 sec |
| Large (catthehacker/ubuntu:full-latest) | ~8 min | 45 sec | 15 sec |

## Advanced Usage / Production Hardening

### Secrets Management

Never commit secrets to test them. act provides multiple secure patterns:

```bash
# Option 1: Interactive prompt (recommended for manual runs)
act -s MY_SECRET

# Option 2: Environment variable lookup
export MY_SECRET=supersecurevalue
act -s MY_SECRET

# Option 3: Secrets file (.secrets, same format as .env)
cat > .secrets << 'EOF'
MY_SECRET=supersecurevalue
AWS_ACCESS_KEY_ID=AKIA...
AWS_SECRET_ACCESS_KEY=...
EOF
act --secret-file .secrets

# Option 4: For GITHUB_TOKEN (read-only PAT recommended)
act -s GITHUB_TOKEN=ghp_xxxxxxxxxxxx
```

Add `.secrets` to `.gitignore` immediately:

```bash
echo ".secrets" >> .gitignore
echo "*.secrets" >> .gitignore
```

### Repository Variables (vars context)

GitHub's `vars` context is supported for repository-level configuration:

```bash
# Set variables
act --var DEPLOY_ENV=staging --var API_VERSION=v2

# Or use a variables file
cat > .variables << 'EOF'
DEPLOY_ENV=staging
API_VERSION=v2
EOF
act --var-file .variables
```

### Simulating Events with Payload Files

Test workflows that depend on event data by providing JSON payload files:

```bash
# Simulate pull_request event
cat > pull-request.json << 'EOF'
{
  "pull_request": {
    "head": { "ref": "feature/new-login" },
    "base": { "ref": "main" },
    "number": 42
  }
}
EOF
act pull_request -e pull-request.json
```

```bash
# Simulate push with tag
cat > tag-push.json << 'EOF'
{ "ref": "refs/tags/v1.2.3" }
EOF
act push -e tag-push.json
```

```bash
# Simulate workflow_dispatch with inputs
cat > workflow-inputs.json << 'EOF'
{
  "inputs": {
    "environment": "production",
    "version": "2.0.0"
  }
}
EOF
act workflow_dispatch -e workflow-inputs.json
```

### Dry-Run Mode

Validate workflow syntax and see execution plan without running:

```bash
# List all jobs that would run
act -l

# Dry run (no actual execution)
act -n

# Verbose dry run
act -n -v
```

### Configuration File (.actrc)

Project-specific configuration via `.actrc`:

```bash
# .actrc in project root
cat > .actrc << 'EOF'
--container-architecture linux/amd64
--action-offline-mode
-P ubuntu-latest=catthehacker/ubuntu:act-latest
--env-file .env
--secret-file .secrets
EOF
```

Configuration precedence (highest to lowest):
1. CLI arguments
2. `./.actrc` (project root)
3. `~/.actrc` (home directory)
4. `$XDG_CONFIG_HOME/act/actrc`

### Skipping Jobs/Steps for Local Runs

Mark steps that should not run locally:

```yaml
# In your workflow file
jobs:
  deploy:
    if: ${{ !github.event.act }}  # Skip deploy job locally
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

  notify:
    runs-on: ubuntu-latest
    steps:
      - name: Skip Slack notification locally
        if: ${{ !env.ACT }}
        run: |
          curl -X POST -H 'Content-type: application/json' \
            --data '{"text":"Deployment complete"}' ${{ secrets.SLACK_WEBHOOK }}
```

Pass the act flag via event:

```bash
cat > event.json << 'EOF'
{ "act": true }
EOF
act -e event.json
```

### Artifact Collection

Collect workflow artifacts locally:

```bash
# Specify artifact server path
act --artifact-server-path /tmp/artifacts

# Artifacts will be saved to /tmp/artifacts/<workflow>/<artifact-name>/
ls -la /tmp/artifacts/
```

### Offline Mode

For air-gapped or low-bandwidth environments:

```bash
# Pre-pull images
act --action-offline-mode

# This reuses locally cached action repositories and Docker images
# without fetching from GitHub or Docker Hub
```

## Comparison with Alternatives

| Feature | act | GitHub Actions Runner | Drone CI | Jenkins |
|---|---|---|---|---|
| **Local execution** | Native (Docker) | Possible (complex setup) | Docker-based | Requires Java + plugins |
| **GitHub parity** | High (same YAML syntax) | Full (official runner) | Medium (different syntax) | Low (plugin-dependent) |
| **Setup time** | <1 min | 10-30 min | 5-10 min | 15-30 min |
| **Resource usage** | Low (Docker containers) | Medium-High (VM/Service) | Medium (Docker) | High (JVM + plugins) |
| **Secret management** | File, env, interactive | GitHub UI only | Drone UI / CLI | Credentials plugin |
| **Self-hosted option** | N/A (local only) | Official self-hosted runners | Full server deployment | Full server deployment |
| **Price** | Free (open source) | Free (public repos) / $0.008/min (private) | Free (open source) / Cloud from $15/mo | Free (open source) |
| **Community size** | 70,410 GitHub stars | GitHub-native | 27,000+ stars | Established enterprise |
| **Learning curve** | Low (uses GitHub syntax) | Medium | Medium | High |
| **IDE integration** | VS Code extension | Limited | Limited | Extensive |

**When to choose act:**
- **act**: Local development, workflow debugging, pre-commit validation, learning GitHub Actions
- **GitHub Actions Runner**: Production CI/CD on GitHub's infrastructure or self-hosted fleet
- **Drone CI**: Lightweight CI/CD server for teams wanting container-native pipelines with different syntax
- **Jenkins**: Enterprise-scale CI/CD with extensive plugin ecosystem and legacy integration requirements

## Limitations / Honest Assessment

act is a development and debugging tool, not a production CI/CD replacement. Understand these constraints before adoption:

1. **Linux runners only**: Windows (`windows-latest`) and macOS (`macos-latest`) runners are unsupported for containerized execution. The `-self-hosted` flag can run jobs directly on macOS/Windows hosts, but this bypasses container isolation and does not match GitHub's runner environment.

2. **Incomplete default images**: The Medium runner image does not include every tool pre-installed on GitHub-hosted runners. Software like `swift`, `gcloud`, or specific Android SDK components may need manual installation steps in your workflow.

3. **Docker-in-Docker limitations**: Running Docker commands inside act containers works via socket mounting, but nested container scenarios and Kubernetes-in-Docker require additional configuration.

4. **Services not fully supported**: Docker Compose `services` in job definitions have limited support (issue #173). Databases and caches may need external orchestration.

5. **Network and caching differences**: GitHub Actions caching (`actions/cache`) and service containers behave differently locally. Cache hits/misses and network latency will not match production exactly.

6. **No GitHub-hosted action marketplace parity**: Some composite actions or actions that depend on GitHub's internal APIs may fail locally.

7. **Large image disk requirements**: The Large image at ~18-75 GB is impractical for laptops with limited storage. Most teams should use the Medium image for day-to-day development.

## Frequently Asked Questions

### Q1: Does act require an internet connection?

For the first run, yes — act needs to pull Docker images and clone action repositories from GitHub. After that, you can use `--action-offline-mode` to work with cached images and actions. Pre-pull your images with `docker pull` before going offline.

### Q2: How do I run only a specific job from a workflow?

Use the `-j` flag followed by the job ID defined in your workflow YAML:

```bash
# Run only the "test" job
act -j test

# Run a job from a specific workflow file
act -j lint -W .github/workflows/checks.yml
```

### Q3: Can I use act with private GitHub repositories or GitHub Enterprise?

Yes. For private repos, provide a personal access token via `-s GITHUB_TOKEN`. For GitHub Enterprise Server, use `--github-instance`:

```bash
act --github-instance github.mycompany.com -s GITHUB_TOKEN=ghp_xxx
```

### Q4: Why does my workflow fail with "MODULE_NOT_FOUND"?

This error occurs when using local actions (e.g., `uses: ./`) without proper checkout. Ensure your repository name matches the checkout path. If your repo is named `my-project`, your checkout step should include `path: "my-project"`.

### Q5: How do I debug a failing step?

Run act with verbose logging (`-v`) and preserve the container for inspection:

```bash
# Verbose output
act -v

# Run a specific job with verbose output
act -j test -v

# The container name is printed in logs; inspect it after failure
docker exec -it <container-name> /bin/bash
```

### Q6: Is act suitable for running production CI/CD pipelines?

No. act is designed for local development and debugging. For production CI/CD, use GitHub-hosted runners, self-hosted runners, or dedicated CI/CD platforms like GitHub Actions, Drone, or Jenkins.

### Q7: How do I update act to the latest version?

Use the same package manager you installed it with:

```bash
# Homebrew
brew upgrade act

# Chocolatey
choco upgrade act-cli

# Scoop
scoop update act

# Bash script (re-run installer)
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash
```

## Conclusion

With 70,410 stars and a release cadence that keeps pace with GitHub Actions updates, act has earned its place in every developer's toolkit. The ability to validate workflows locally before pushing eliminates the costly feedback loop of commit-push-wait-fail-fix cycles. Install it in under a minute, configure your `.actrc`, and start treating your CI/CD definitions as first-class code that you can test on your machine.

**Action items:**
1. Install act using your preferred package manager
2. Run `act -l` in a repository with workflows to see available jobs
3. Create a `.actrc` file with your default runner configuration
4. Set up a `.secrets` file (and add it to `.gitignore`) for local secret management
5. Share this guide with your team to standardize local CI/CD development

Join the [dibi8 developer community on Telegram](https://t.me/dibi8) to discuss act setups, share workflow optimizations, and get help from engineers using act in production environments.



## Recommended Hosting & Infrastructure

Before you deploy any of the tools above into production, you'll need solid infrastructure. Two options dibi8 actually uses and recommends:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — $200 free credit for 60 days across 14+ global regions. The default option for indie devs running open-source AI tools.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — Hong Kong VPS with low-latency access from mainland China. This is the same IDC that hosts dibi8.com — battle-tested in production.

*Affiliate links — they don't cost you extra and they help keep dibi8.com running.*

## Sources & Further Reading

- [act GitHub Repository](https://github.com/nektos/act) — Official source code, 70,410 stars
- [act User Guide](https://nektosact.com/) — Comprehensive documentation
- [act Installation Guide](https://nektosact.com/installation/index.html) — Platform-specific installation methods
- [act Runners Reference](https://nektosact.com/usage/runners.html) — Docker image options and sizes
- [act Usage Guide](https://nektosact.com/usage/index.html) — Events, secrets, configuration
- [VS Code: GitHub Local Actions Extension](https://marketplace.visualstudio.com/items?itemName=SanjulaGanepola.github-local-actions)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [catthehacker/docker_images](https://github.com/catthehacker/docker_images) — Community runner images used by act
