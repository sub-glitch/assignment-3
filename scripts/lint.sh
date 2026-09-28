#!/bin/bash

echo "Running lint checks..."

echo

echo "Checking required files..."

if [ -f "app/app.sh" ] && [ -f "tests/test.sh" ]

then

    echo "PASS: Required files exist"

else

    echo "FAIL: Required files are missing"

    exit 1

fi

echo

echo "Checking Bash syntax..."

bash -n app/app.sh

if [ $? -eq 0 ]

then

    echo "PASS: app/app.sh syntax"

else

    echo "FAIL: app/app.sh syntax"

    exit 1

fi

bash -n tests/test.sh

if [ $? -eq 0 ]

then

    echo "PASS: tests/test.sh syntax"

else

    echo "FAIL: tests/test.sh syntax"

    exit 1

fi

echo

echo "Lint checks passed!"