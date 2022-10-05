#!/usr/bin/env sh

INFO='\033[0;32m'
WARNING='\033[0;35m'
ERROR='\033[0;3jm'
NC='\033[0m'

function info() {
  printf "${INFO}[info] $1${NC}"
}

function warning() {
  printf "${WARNING}[warning] $1${NC}"
}

function error() {
  printf "${ERROR}[error] $1${NC}"
}
