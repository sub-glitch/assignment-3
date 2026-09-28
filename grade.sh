#!/usr/bin/env bash

set -u

PASS=0
FAIL=0

pass() {
    echo "PASS: $1"
    PASS=$((PASS+1))
}

fail() {
    echo "FAIL: $1"
    FAIL=$((FAIL+1))
}

echo "======================================"
echo "Assignment 3 - Local Grader"
echo "GitHub Actions / Docker / Bash"
echo "======================================"
echo

for f in README.md app/app.sh scripts/lint.sh scripts/build.sh tests/test.sh Dockerfile compose.yaml .dockerignore .github/workflows/ci.yml
do
    [[ -f "$f" ]] && pass "Required file exists: $f" || fail "Missing required file: $f"
done

echo

for f in app/*.sh scripts/*.sh tests/*.sh
do
    [[ -f "$f" ]] || continue

    bash -n "$f" > /dev/null 2>&1

    if [ $? -eq 0 ]
    then
        pass "Bash syntax: $f"
    else
        fail "Bash syntax error: $f"
    fi
done

echo

for f in app/app.sh scripts/lint.sh scripts/build.sh tests/test.sh
do
    [[ -x "$f" ]] && pass "Executable: $f" || fail "Not executable: $f"
done

echo

WORKFLOW=".github/workflows/ci.yml"

if [[ -f "$WORKFLOW" ]]
then

    grep -Eq 'push:' "$WORKFLOW" && pass "Workflow triggers on push" || fail "Workflow missing push trigger"

    grep -Eq 'pull_request:' "$WORKFLOW" && pass "Workflow triggers on pull_request" || fail "Workflow missing pull_request trigger"

    grep -Eq 'validate:' "$WORKFLOW" && pass "Workflow has validate job" || fail "Workflow missing validate job"

    grep -Eq 'test:' "$WORKFLOW" && pass "Workflow has test job" || fail "Workflow missing test job"

    grep -Eq 'docker:' "$WORKFLOW" && pass "Workflow has docker job" || fail "Workflow missing docker job"

    if grep -A12 -E '^[[:space:]]*test:' "$WORKFLOW" | grep -Eq 'needs:[[:space:]]*validate'
    then
        pass "Test job depends on validate"
    else
        fail "Test job should use needs: validate"
    fi

    if grep -A12 -E '^[[:space:]]*docker:' "$WORKFLOW" | grep -Eq 'needs:[[:space:]]*test'
    then
        pass "Docker job depends on test"
    else
        fail "Docker job should use needs: test"
    fi

fi

echo

if [[ -x ./app/app.sh ]]
then

    ./app/app.sh help > /tmp/assignment3-app.log 2>&1

    if [ $? -eq 0 ]
    then
        pass "app.sh help succeeds"
    else
        fail "app.sh help failed"
    fi

    ./app/app.sh system-info > /tmp/assignment3-app.log 2>&1

    if [ $? -eq 0 ]
    then
        pass "app.sh system-info succeeds"
    else
        fail "app.sh system-info failed"
    fi

    ./app/app.sh > /dev/null 2>&1

    if [ $? -eq 2 ]
    then
        pass "app.sh rejects missing command with exit code 2"
    else
        fail "app.sh should return 2 for missing command"
    fi

    ./app/app.sh check-port localhost abc > /dev/null 2>&1

    if [ $? -eq 2 ]
    then
        pass "app.sh rejects non-numeric port"
    else
        fail "app.sh should reject non-numeric port with exit code 2"
    fi

    ./app/app.sh check-port localhost 0 > /dev/null 2>&1

    if [ $? -eq 2 ]
    then
        pass "app.sh rejects port 0"
    else
        fail "app.sh should reject port 0"
    fi

    ./app/app.sh check-port localhost 65536 > /dev/null 2>&1

    if [ $? -eq 2 ]
    then
        pass "app.sh rejects port 65536"
    else
        fail "app.sh should reject port 65536"
    fi

fi

echo

if [[ -x ./scripts/lint.sh ]]
then

    if ./scripts/lint.sh > /tmp/assignment3-lint.log 2>&1
    then
        pass "scripts/lint.sh passes"
    else
        fail "scripts/lint.sh fails"
        cat /tmp/assignment3-lint.log
    fi

fi

echo

if command -v docker > /dev/null 2>&1
then

    IMAGE="student-devops-ci-grader"

    if docker build -t "$IMAGE" . > /tmp/assignment3-docker-build.log 2>&1
    then
        pass "Docker image builds successfully"
    else
        fail "Docker image failed to build"
        cat /tmp/assignment3-docker-build.log
    fi

    docker run --rm "$IMAGE" help > /tmp/assignment3-docker.log 2>&1

    if [ $? -eq 0 ]
    then
        pass "Docker help smoke test passes"
    else
        fail "Docker help smoke test failed"
    fi

    docker run --rm "$IMAGE" system-info > /tmp/assignment3-docker.log 2>&1

    if [ $? -eq 0 ]
    then
        pass "Docker system-info smoke test passes"
    else
        fail "Docker system-info smoke test failed"
    fi

    docker run --rm "$IMAGE" invalid-command > /tmp/assignment3-docker.log 2>&1

    if [ $? -ne 0 ]
    then
        pass "Docker invalid command returns non-zero"
    else
        fail "Docker invalid command should fail"
    fi

    docker image rm "$IMAGE" > /dev/null 2>&1 || true

else

    echo "ERROR: Docker is required for Assignment 3 Docker checks."
    FAIL=$((FAIL+1))

fi

echo

if [[ -x ./tests/test.sh ]]
then

    if ./tests/test.sh > /tmp/assignment3-tests.log 2>&1
    then
        pass "Student test suite passes"
    else
        fail "Student test suite fails"
        cat /tmp/assignment3-tests.log
    fi

else

    if bash ./tests/test.sh > /tmp/assignment3-tests.log 2>&1
    then
        pass "Student test suite passes"
    else
        fail "Student test suite fails"
        cat /tmp/assignment3-tests.log
    fi

fi

echo

if command -v git > /dev/null 2>&1 && git rev-parse --is-inside-work-tree > /dev/null 2>&1
then

    commits=$(git rev-list --count HEAD 2>/dev/null || echo 0)

    if [ "$commits" -ge 5 ]
    then
        pass "Git has at least 5 commits"
    else
        echo "WARN: fewer than 5 commits; inspect manually"
    fi

    branch_count=$(git for-each-ref --format='%(refname:short)' refs/heads 2>/dev/null | grep -vE '^(main|master)$' | wc -l | tr -d ' ')

    if [ "$branch_count" -ge 1 ]
    then
        pass "Feature/non-main branch exists locally"
    else
        echo "WARN: no local feature branch found; inspect Git history manually"
    fi

else

    echo "WARN: Git checks skipped"

fi

echo
echo "======================================"
echo "Passed: $PASS"
echo "Failed: $FAIL"
echo "======================================"

[[ $FAIL -eq 0 ]]
