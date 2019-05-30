#!/bin/bash
# wipe ara reports

rm -rf "$(git rev-parse --show-toplevel)/reports/ara/"
mkdir -p "$(git rev-parse --show-toplevel)/reports/ara/"
