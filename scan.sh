#!/bin/bash

clear

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_bordered_message() {
    local message=$1
    local color=$2
    local border_width=50
    local padding=$(( (border_width - ${#message} - 2) / 2 ))
    local padded_message=$(printf "%${padding}s%s%${padding}s" "" "${message}" "")
    echo -e "${color}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${color}║${padded_message}║${NC}"
    echo -e "${color}╚══════════════════════════════════════════════════╝${NC}"
}

print_bordered_message "m85.68: Starting masscan for port 8080..." "${BLUE}"
masscan -iL iprange.txt -p8080 --rate=1000000 -oL result8080.txt
print_bordered_message "m85.68: Masscan for port 8080 completed!" "${GREEN}"
awk '{print $4 ":" $3}' result8080.txt > proxie8080.txt
print_bordered_message "m85.68: Unchecked proxies saved to proxie8080.txt" "${YELLOW}"

print_bordered_message "m85.68: Starting masscan for port 80..." "${BLUE}"
masscan -iL iprange.txt -p80 --rate=1000000 -oL result80.txt
print_bordered_message "m85.68: Masscan for port 80 completed!" "${GREEN}"
awk '{print $4 ":" $3}' result80.txt > proxie80.txt
print_bordered_message "m85.68: Unchecked proxies saved to proxie80.txt" "${YELLOW}"

rm -rf result8080.txt
rm -rf result80.txt
print_bordered_message "m85.68: Temporary result files cleaned up" "${GREEN}"

print_bordered_message "m85.68: Starting the proxy checker..." "${BLUE}"
go run checker.go
