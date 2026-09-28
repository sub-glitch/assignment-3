#!/bin/bash

APP="./app/app.sh"

echo "Running application tests..."

echo

echo "Test 1: help"

"$APP" help

if [ $? -eq 0 ]

then

    echo "PASS"

else

    echo "FAIL"

    exit 1

fi

echo

echo "Test 2: system-info"

"$APP" system-info

if [ $? -eq 0 ]

then

    echo "PASS"

else

    echo "FAIL"

    exit 1

fi

echo

echo "Test 3: check-host with valid host"

"$APP" check-host localhost

if [ $? -eq 0 ]

then

    echo "PASS"

else

    echo "FAIL"

    exit 1

fi

echo

echo "Test 4: check-host with missing host"

"$APP" check-host

EXIT_CODE=$?

if [ "$EXIT_CODE" -eq 2 ]

then

    echo "PASS"

else

    echo "FAIL (expected exit code 2, got $EXIT_CODE)"

    exit 1

fi

echo

echo "Test 5: check-port with missing host"

"$APP" check-port

EXIT_CODE=$?

if [ "$EXIT_CODE" -eq 2 ]

then

    echo "PASS"

else

    echo "FAIL (expected exit code 2, got $EXIT_CODE)"

    exit 1

fi

echo

echo "Test 6: check-port with missing port"

"$APP" check-port localhost

EXIT_CODE=$?

if [ "$EXIT_CODE" -eq 2 ]

then

    echo "PASS"

else

    echo "FAIL (expected exit code 2, got $EXIT_CODE)"

    exit 1

fi

echo

echo "Test 7: check-port with non-numeric port"

"$APP" check-port localhost abc

EXIT_CODE=$?

if [ "$EXIT_CODE" -eq 2 ]

then

    echo "PASS"

else

    echo "FAIL (expected exit code 2, got $EXIT_CODE)"

    exit 1

fi

echo

echo "Test 8: check-port with out-of-range port"

"$APP" check-port localhost 70000

EXIT_CODE=$?

if [ "$EXIT_CODE" -eq 2 ]

then

    echo "PASS"

else

    echo "FAIL (expected exit code 2, got $EXIT_CODE)"

    exit 1

fi

echo

echo "Test 9: invalid command"

"$APP" nonsense

EXIT_CODE=$?

if [ "$EXIT_CODE" -eq 2 ]

then

    echo "PASS"

else

    echo "FAIL (expected exit code 2, got $EXIT_CODE)"

    exit 1

fi

echo

echo "All tests passed!"