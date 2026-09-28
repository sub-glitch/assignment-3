#!/bin/bash

COMMAND=$1

ARGUMENT=$2

PORT=$3

case "$COMMAND" in

    system-info)

        echo "System INFO"

        echo "==============================="

        echo "Hostname: $(hostname)"

        echo "Kernel: $(uname -r)"

        echo "Uptime: $(uptime -p)"

        echo

        echo "Memory:"

        free -h

        echo

        echo "CPU:"

        lscpu | grep -E 'Model name|^CPU\(s\):'

        ;;

    check-host)

        if [ -z "$ARGUMENT" ]

        then

            echo "Usage: $0 check-host <host>"

            exit 2

        fi

        echo "Host Check"

        echo "=========="

        echo "Host: $ARGUMENT"

        if ping -c 4 "$ARGUMENT" > /dev/null 2>&1

        then

            echo "Connectivity: successful"

            exit 0

        else

            echo "Connectivity: failed"

            exit 1

        fi

        ;;

    check-port)

        if [ -z "$ARGUMENT" ]

        then

            echo "Usage: $0 check-port <host> <port>"

            exit 2

        fi

        if [ -z "$PORT" ]

        then

            echo "Usage: $0 check-port <host> <port>"

            exit 2

        fi

        if ! [[ "$PORT" =~ ^[0-9]+$ ]]

        then

            echo "Invalid port: $PORT"

            exit 2

        fi

        if [ "$PORT" -lt 1 ] || [ "$PORT" -gt 65535 ]

        then

            echo "Invalid port: $PORT"

            exit 2

        fi

        echo "Port Check"

        echo "=========="

        echo "Host: $ARGUMENT"

        echo "Port: $PORT"

        if timeout 5 bash -c "</dev/tcp/$ARGUMENT/$PORT" > /dev/null 2>&1

        then

            echo "Port status: open"

            exit 0

        else

            echo "Port status: closed or unreachable"

            exit 1

        fi

        ;;

    help)

        echo "Usage: $0 <command> [arguments]"

        echo "Commands:"

        echo "  system-info              Display system information"

        echo "  check-host <host>        Check host connectivity"

        echo "  check-port <host> <port> Check port connectivity"

        echo "  help                     Show this help message"

        ;;

    "")

        echo "No command provided. Use '$0 help' for usage information."

        exit 2

        ;;

    *)

        echo "Unknown command: $COMMAND. Use '$0 help' for usage information."

        exit 2

        ;;

esac