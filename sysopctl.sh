#!/bin/bash

VERSION="v0.1.0"

# Function to display the help message
show_help() {
    echo "Usage: sysopctl [command] [options]"
    echo ""
    echo "Commands:"
    echo "  service list                List all active services"
    echo "  service start <name>        Start a service"
    echo "  service stop <name>         Stop a service"
    echo "  system load                 Show system load averages"
    echo "  disk usage                  Show disk usage by partition"
    echo "  process monitor             Monitor real-time process activity"
    echo "  logs analyze                Analyze recent critical log entries"
    echo "  backup <path>               Backup files in the specified path"
    echo "  --help                      Show this help message"
    echo "  --version                   Show command version"
}

# Function to show version information
show_version() {
    echo "sysopctl version $VERSION"
}

# Function to list active services
list_services() {
    echo "Active Services:"
    systemctl list-units --type=service
}

# Function to start a service
start_service() {
    if [ -z "$1" ]; then
        echo "Service name required"
        exit 1
    fi
    sudo systemctl start "$1"
    echo "Service $1 started."
}

# Function to stop a service
stop_service() {
    if [ -z "$1" ]; then
        echo "Service name required"
        exit 1
    fi
    sudo systemctl stop "$1"
    echo "Service $1 stopped."
}

# Function to show system load averages
show_system_load() {
     echo "System Load Averages:"
    wmic cpu get loadpercentage
}

# Function to check disk usage
check_disk_usage() {
    echo "Disk Usage by Partition:"
    df -h
}

# Function to monitor real-time process activity
monitor_processes() {
    echo "Monitoring Processes:"
    top
}

# Function to analyze recent critical log entries
analyze_logs() {
    echo "Analyzing Critical Logs:"
    sudo journalctl -p 3 -xb
}

# Function to backup files
backup_files() {
    if [ -z "$1" ]; then
        echo "Path required"
        exit 1
    fi
    rsync -av --progress "$1" /backup/$(basename "$1")_$(date +%F_%T)
    echo "Backup of $1 completed."
}

# Main script logic
case "$1" in
    --help)
        show_help
        ;;
    --version)
        show_version
        ;;
    service)
        case "$2" in
            list)
                list_services
                ;;
            start)
                start_service "$3"
                ;;
            stop)
                stop_service "$3"
                ;;
            *)
                echo "Invalid service command. Use --help for usage."
                ;;
        esac
        ;;
    system)
        if [ "$2" == "load" ]; then
            show_system_load
        else
            echo "Invalid system command. Use --help for usage."
        fi
        ;;
    disk)
        if [ "$2" == "usage" ]; then
            check_disk_usage
        else
            echo "Invalid disk command. Use --help for usage."
        fi
        ;;
    process)
        if [ "$2" == "monitor" ]; then
            monitor_processes
        else
            echo "Invalid process command. Use --help for usage."
        fi
        ;;
    logs)
        if [ "$2" == "analyze" ]; then
            analyze_logs
        else
            echo "Invalid logs command. Use --help for usage."
        fi
        ;;
    backup)
        backup_files "$2"
        ;;
    *)
        echo "Invalid command. Use --help for usage."
        ;;
esac
