#!/bin/bash
# Test script for aparok-cli

set -e

echo "======================================"
echo "Testing Aparok CLI Integration"
echo "======================================"
echo

echo "1. Checking aparok-cli service status..."
docker compose ps aparok-cli
echo

echo "2. Checking authentication status..."
docker compose exec aparok-cli anytype auth status
echo

echo "3. Listing spaces..."
docker compose exec aparok-cli anytype space list
echo

echo "4. Checking health..."
if docker compose ps aparok-cli | grep -q "healthy"; then
    echo "✓ Service is healthy"
else
    echo "✗ Service is not healthy"
    exit 1
fi
echo

echo "======================================"
echo "All tests passed!"
echo "======================================"
