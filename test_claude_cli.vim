" Test script for Claude CLI integration
" Run with: nvim -S test_claude_cli.vim

" Set up Claude CLI path (adjust to your actual path)
let g:claude_code_cli = 'claude'

" Source the plugin
source plugin/claude.vim

" Open debug buffer to see what's happening
ClaudeDebug

" Test if CLI is detected
if executable(g:claude_code_cli)
  echo "Claude CLI found at: " . g:claude_code_cli
else
  echo "Claude CLI not found! Please set g:claude_code_cli to the correct path"
endif

" Create a test buffer with some code
new
put ='function hello() {'
put ='  console.log(\"Hello\");'
put ='}'

" Save current buffer for testing
write test_sample.js

echo "Setup complete. You can now:"
echo "1. Use :ClaudeChat to open chat"
echo "2. Select code and use :ClaudeImplement to modify it"
echo "3. Check :ClaudeDebug for debugging info"