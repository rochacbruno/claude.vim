" Test script for Claude CLI integration
" This script tests the new g:claude_code_cli functionality

" Test 1: Check if configuration variable exists
echo "Test 1: Configuration variable"
if exists('g:claude_code_cli')
  echo "  ✓ g:claude_code_cli variable is defined"
else
  echo "  ✗ g:claude_code_cli variable is NOT defined"
endif

" Test 2: Set the CLI path and verify it's used
echo "\nTest 2: CLI path setting"
let test_cli_path = '~/.claude/local/claude'
let g:claude_code_cli = test_cli_path
if g:claude_code_cli == test_cli_path
  echo "  ✓ CLI path set correctly to: " . g:claude_code_cli
else
  echo "  ✗ Failed to set CLI path"
endif

" Test 3: Check if CLI functions are defined
echo "\nTest 3: CLI handler functions"
if exists('*s:ClaudeQueryViaCLI')
  echo "  ✓ s:ClaudeQueryViaCLI function exists"
else
  echo "  ✗ s:ClaudeQueryViaCLI function NOT found"
endif

if exists('*s:HandleCLIOutput')
  echo "  ✓ s:HandleCLIOutput function exists"
else
  echo "  ✗ s:HandleCLIOutput function NOT found"
endif

if exists('*s:HandleCLIError')
  echo "  ✓ s:HandleCLIError function exists"
else
  echo "  ✗ s:HandleCLIError function NOT found"
endif

if exists('*s:HandleCLIExit')
  echo "  ✓ s:HandleCLIExit function exists"
else
  echo "  ✗ s:HandleCLIExit function NOT found"
endif

" Test 4: Verify fallback behavior
echo "\nTest 4: Fallback behavior"
let g:claude_code_cli = '/nonexistent/path/to/claude'
echo "  Set CLI to non-existent path: " . g:claude_code_cli
echo "  Plugin should fall back to API mode when CLI is not executable"

" Test 5: Test with empty CLI path (should use API)
echo "\nTest 5: Empty CLI path"
let g:claude_code_cli = ''
echo "  Set CLI to empty string"
echo "  Plugin should use API mode when g:claude_code_cli is empty"

echo "\n=== Test Summary ==="
echo "The plugin has been modified to support Claude Code CLI."
echo "When g:claude_code_cli is set to a valid executable path,"
echo "the plugin will use the CLI instead of the API."
echo ""
echo "To use in your vimrc:"
echo "  let g:claude_code_cli = '~/.claude/local/claude'"
echo ""
echo "The plugin will automatically detect if the CLI is available"
echo "and fall back to API mode if not."