#!/bin/bash
set -eo pipefail
shopt -s nullglob

echo "Hi there!"

gosu mysql mysqld