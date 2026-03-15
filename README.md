# NodeJS App Pipeline 🚀

A CI/CD pipeline for a Node.js application that automates version incrementing, testing, Docker image building, and pushing to Docker Hub — all powered by Jenkins.

---

## 📋 Table of Contents

- [Overview](#overview)
- [Tech Stack](#tech-stack)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Pipeline Stages](#pipeline-stages)
- [Docker](#docker)
- [Jenkins Configuration](#jenkins-configuration)

---

## Overview

This project sets up a fully automated CI/CD pipeline for a Node.js application. On every run, the pipeline:

1. Automatically increments the app's patch version in `package.json`
2. Installs dependencies and runs tests
3. Builds a multi-stage Docker image
4. Tags the image using `<VERSION>-<BUILD_NUMBER>` (e.g. `1.0.3-42`)
5. Pushes the image to Docker Hub

---

## Tech Stack

| Tool | Purpose |
|------|---------|
| **Node.js 18** | Application runtime |
| **Docker** (multi-stage build) | Containerization |
| **Jenkins** | CI/CD automation (Pipeline-as-Code) |
| **Docker Hub** | Container image registry |
| **npm** | Package management & version control |

---

## Prerequisites

- [Node.js 18+](https://nodejs.org/)
- [Docker](https://www.docker.com/)
- [Jenkins](https://www.jenkins.io/) with the following configured:
  - **NodeJS Plugin** — tool named `nodejs18`
  - **Credentials** — Docker Hub credentials with ID `docker-hub-repo`

---

## Project Structure

```
NodeJS-App-Pipeline/
├── app/
│   ├── package.json       # App dependencies & version
│   ├── package-lock.json
│   ├── server.js          # Application entry point
│   └── ...
├── Dockerfile             # Multi-stage Docker build
├── Jenkinsfile            # Pipeline definition
└── README.md
```

---

## Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/Vatcharadze/NodeJS-App-Pipeline.git
cd NodeJS-App-Pipeline
```

### 2. Install dependencies

```bash
cd app && npm install
```

### 3. Run tests

```bash
cd app && npm test
```

### 4. Start the application

```bash
node app/server.js
```

The app runs on **port 3000**.

---

## Pipeline Stages

The `Jenkinsfile` defines the following stages:

```
Debug → Increment Version → Get New Version → Build → Test → Build Image → Deploy
```

| Stage | Description |
|-------|-------------|
| **Debug** | Verifies Node.js and npm versions, prints working directory and file listing |
| **Increment Version** | Runs `npm version patch` inside `/app` to bump the patch version in `package.json` (no git tag) |
| **Get New Version** | Reads the updated version from `package.json` and stores it as `VERSION` pipeline variable |
| **Build** | Runs `npm ci` inside `/app` for a clean, reproducible dependency install |
| **Test** | Runs the test suite via `npm test` inside `/app` |
| **Build Image** | Builds the Docker image, logs into Docker Hub using stored credentials, and pushes the image |
| **Deploy** | *(Placeholder — deployment logic to be added)* |

### Image Tagging Strategy

Each image is tagged as:

```
<DOCKER_REPO>:<VERSION>-<BUILD_NUMBER>
```

For example: `vatcharadze/demo-app:1.0.3-42`

This ensures every build produces a **unique, traceable image**.

### Environment Variables (Jenkinsfile)

| Variable | Description |
|----------|-------------|
| `VERSION` | Auto-populated from `package.json` during the pipeline run |
| `DOCKER_REPO` | Your Docker Hub repository (e.g. `yourname/demo-app`) — set this before running |
| `BUILD_NUMBER` | Jenkins built-in variable, appended to the image tag |

> ⚠️ Before running the pipeline, update `DOCKER_REPO` in the `environment` block of the `Jenkinsfile` to point to your own Docker Hub repository:
> ```groovy
> DOCKER_REPO = "yourname/your-repo"
> ```

---

## Docker

The `Dockerfile` uses a **multi-stage build** to keep the final image lean:

```
Stage 1 (build)  →  node:18-alpine  →  installs npm dependencies
Stage 2 (final)  →  node:18-alpine  →  copies node_modules + source, runs app
```

- **Exposed port:** `3000`
- **User:** `node` (non-root, for security)
- **Entrypoint:** `node server.js`

### Build & run locally

```bash
# Build the image
docker build -t demo-app:local .

# Run the container
docker run -p 3000:3000 demo-app:local
```

App available at: `http://localhost:3000`

---

## Jenkins Configuration

### 1. Required Credentials

Go to **Jenkins → Manage Jenkins → Credentials** and add:

| Credential ID | Type | Description |
|---------------|------|-------------|
| `docker-hub-repo` | Username & Password | Your Docker Hub username and password/token |

### 2. Required Tools

Go to **Jenkins → Manage Jenkins → Tools** and configure:

| Tool Name | Type |
|-----------|------|
| `nodejs18` | NodeJS installation (via NodeJS Plugin) |

### 3. Pipeline Setup

1. Create a new **Pipeline** job in Jenkins
2. Set **Pipeline definition** to *Pipeline script from SCM*
3. Point it to this repository
4. Jenkins will automatically detect and use the `Jenkinsfile`

---

## Author

**Vatcharadze** — [GitHub Profile](https://github.com/Vatcharadze)
