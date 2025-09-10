" Test Claude CLI Integration
" Usage: nvim -S test_cli_integration.vim

" Configure Claude CLI path (adjust to your actual CLI command)
let g:claude_code_cli = '/home/rochacbruno/.claude/local/claude'

" Source the plugin
source plugin/claude.vim

" Open debug buffer first
ClaudeDebug

" Create a simple test
function! TestCLI()
  echo "Testing Claude CLI integration..."
  
  " Check if CLI is available
  if !executable(g:claude_code_cli)
    echo "ERROR: Claude CLI not found at: " . g:claude_code_cli
    echo "Please install Claude CLI or set g:claude_code_cli to the correct path"
    return
  endif
  
  echo "Claude CLI found at: " . g:claude_code_cli
  
  " Test a simple CLI call
  echo "Testing CLI directly..."
  let output = system(g:claude_code_cli . ' -p "Say hello" --output-format json 2>&1')
  echo "CLI output: " . strpart(output, 0, 200) . "..."
  
  " Now test through the plugin
  echo ""
  echo "Now testing through the plugin..."
  echo "Opening Claude Chat..."
  ClaudeChat
  
  echo ""
  echo "To test:"
  echo "1. Type a message in the chat window"
  echo "2. Press Ctrl+] to send"
  echo "3. Check :ClaudeDebug for debugging info"
  echo "4. Watch the status messages at the bottom"
endfunction

" Run the test
call TestCLI()
