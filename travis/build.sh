#!/usr/bin/env bash

set -euo pipefail

echo "Linting..."
./batect lint
echo

echo "Running unit tests..."
./batect unitTest
echo

echo "Running integration tests..."
./batect integrationTest
echo

echo "Running journey tests..."
./batect journeyTest
echo

