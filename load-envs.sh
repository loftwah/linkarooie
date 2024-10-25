#!/bin/bash

# Check if the script is being sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "❌ Don't run this script directly!"
    echo "✅ Instead, use this command:"
    echo ""
    echo "    source load-envs.sh"
    echo ""
    exit 1
fi

if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
    echo "✨ Environment variables loaded from .env"
else
    echo "❌ .env file not found"
    exit 1
fi