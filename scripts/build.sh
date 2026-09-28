#!/bin/bash

echo "Running build checks..."

echo

echo "Checking app..."

if [ -x "app/app.sh" ]

then

    echo "PASS: app/app.sh is executable"

else

    echo "FAIL: app/app.sh is not executable"

    exit 1

fi

echo

echo "Checking tests..."

if [ -x "tests/test.sh" ]

then

    echo "PASS: tests/test.sh is executable"

else

    echo "FAIL: tests/test.sh is not executable"

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

echo "Build checks passed!"