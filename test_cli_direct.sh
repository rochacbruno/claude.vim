#!/bin/bash

# Direct CLI test script
CLI_PATH="/home/rochacbruno/.claude/local/claude"

echo "Testing Claude CLI directly..."
echo "================================"

# Check if CLI exists
if [ ! -f "$CLI_PATH" ]; then
    echo "ERROR: CLI not found at $CLI_PATH"
    exit 1
fi

echo "CLI found at: $CLI_PATH"
echo ""

# Test 1: Check version/help
echo "Test 1: Checking CLI help/version..."
echo "Command: $CLI_PATH --help"
$CLI_PATH --help 2>&1 | head -20
echo ""

# Test 2: Simple prompt with JSON output
echo "Test 2: Testing simple prompt with JSON output..."
echo "Command: $CLI_PATH -p 'Say hello' --output-format json"
timeout 10 $CLI_PATH -p "Say hello" --output-format json 2>&1
EXIT_CODE=$?
echo "Exit code: $EXIT_CODE"
if [ $EXIT_CODE -eq 124 ]; then
    echo "ERROR: Command timed out!"
fi
echo ""

# Test 3: Check if it needs stdin
echo "Test 3: Testing with empty stdin..."
echo "Command: echo '' | $CLI_PATH -p 'Say hello' --output-format json"
echo "" | timeout 10 $CLI_PATH -p "Say hello" --output-format json 2>&1
EXIT_CODE=$?
echo "Exit code: $EXIT_CODE"
echo ""

# Test 4: Check stderr separately
echo "Test 4: Checking stderr output..."
echo "Command: $CLI_PATH -p 'Say hello' --output-format json 2>stderr.log"
timeout 10 $CLI_PATH -p "Say hello" --output-format json 2>stderr.log 1>stdout.log
EXIT_CODE=$?
echo "Exit code: $EXIT_CODE"
echo "STDOUT:"
cat stdout.log 2>/dev/null || echo "(empty)"
echo "STDERR:"
cat stderr.log 2>/dev/null || echo "(empty)"
rm -f stdout.log stderr.log
echo ""

# Test 5: Check environment
echo "Test 5: Checking environment..."
echo "HOME: $HOME"
echo "PATH: $PATH"
echo "Claude CLI config:"
ls -la ~/.claude 2>/dev/null || echo "No .claude directory found"
echo ""

echo "================================"
echo "Test complete. Check output above for issues."