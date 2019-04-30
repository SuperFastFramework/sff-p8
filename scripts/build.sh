#!/usr/bin/env bash
. ./scripts/env.sh

echo Using output name: $OUTPUT_NAME
echo "================="
sff -c $OUTPUT_NAME
