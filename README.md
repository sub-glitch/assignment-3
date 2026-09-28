# Assignment 3 — CI/CD with GitHub Actions

## Overview

This project demonstrates a basic CI/CD pipeline for a Bash-based system and network diagnostic application.

The application can:

* Display system information
* Check host connectivity
* Check whether a TCP port is reachable
* Display available commands
* Validate incorrect user input

The project also includes automated tests, lint and build checks, Docker support, and a GitHub Actions CI pipeline.

## Project Structure

```text
assignment-3/
├── README.md
├── app/
│   └── app.sh
├── scripts/
│   ├── lint.sh
│   └── build.sh
├── tests/
│   └── test.sh
├── .github/
│   └── workflows/
│       └── ci.yml
├── Dockerfile
├── compose.yaml
├── .dockerignore
└── grade.sh
```

## Application Commands

### System Information

```bash
./app/app.sh system-info
```

Displays:

* Hostname
* Kernel version
* System uptime
* Memory information
* CPU information

### Check Host

```bash
./app/app.sh check-host <host>
```

Example:

```bash
./app/app.sh check-host google.com
```

The command uses `ping` to check host connectivity.

### Check Port

```bash
./app/app.sh check-port <host> <port>
```

Example:

```bash
./app/app.sh check-port google.com 443
```

The command checks TCP connectivity to the specified port.

### Help

```bash
./app/app.sh help
```

Displays the available commands and their usage.

## Exit Codes

| Exit Code | Meaning                              |
| --------- | ------------------------------------ |
| `0`       | Command completed successfully       |
| `1`       | Runtime or connectivity check failed |
| `2`       | Invalid command or input             |

Invalid ports must be numeric and within the range `1–65535`.

## Testing

The project includes an automated test script:

```bash
./tests/test.sh
```

The test suite checks:

* Help command
* System information
* Valid host
* Missing host
* Missing port
* Non-numeric port
* Out-of-range port
* Invalid commands

## Linting

Run the lint checks with:

```bash
./scripts/lint.sh
```

The lint script verifies that required files exist and checks Bash syntax using:

```bash
bash -n
```

## Build Checks

Run:

```bash
./scripts/build.sh
```

The build script checks that the application and test scripts are executable and have valid Bash syntax.

## Docker

Build the Docker image:

```bash
docker build -t assignment-3 .
```

Run the application:

```bash
docker run --rm assignment-3 help
```

Example:

```bash
docker run --rm assignment-3 system-info
```

The Docker image is based on Ubuntu and installs the packages required by the application.

## Docker Compose

Validate the Compose configuration:

```bash
docker compose config
```

Run the application through Compose:

```bash
docker compose run --rm app help
```

## CI/CD Pipeline

GitHub Actions is used to automate the project checks.

The pipeline runs when code is:

* Pushed to the repository
* Submitted through a pull request

The CI pipeline contains three stages:

```text
Validate
   ↓
Test
   ↓
Docker
```

The jobs use dependencies so that each stage only runs after the previous stage succeeds.

### Validate

The validation stage runs the lint and build checks.

### Test

The test stage runs:

```bash
./tests/test.sh
```

### Docker

The Docker stage builds the Docker image and performs smoke tests against the container.

## Failure Demonstration

The CI pipeline is designed to stop when a validation or test stage fails.

A syntax error or failing test can be introduced on a separate branch and pushed to GitHub to demonstrate a failed CI run.

After correcting the problem, another push should trigger the workflow again and allow the pipeline to complete successfully.

## Technologies

* Bash
* Linux
* Docker
* Docker Compose
* Git
* GitHub Actions
* Ubuntu

