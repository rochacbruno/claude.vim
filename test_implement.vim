" Test script for ClaudeImplement
" Usage: vim test_implement.vim
"        Select lines 10-15 with V
"        Run :ClaudeImplement fix the error

" Set verbose mode
let g:claude_verbose = 1

" Configure Claude CLI path
let g:claude_code_cli = '/home/rochacbruno/.claude/local/claude'

" Source the plugin
source plugin/claude.vim

" Create test content with an intentional error
call setline(1, [
  \ '# Test Python code with error',
  \ '',
  \ 'def fibonacci(n):',
  \ '    if n <= 0:',
  \ '        return []',
  \ '    elif n == 1:',
  \ '        return [0]',
  \ '    elif n == 2:',
  \ '        return [0, 1]',
  \ '    else:',
  \ '        fib = [0, 1]',
  \ '        for i in range(2, n):',
  \ '            # Error: wrong calculation',
  \ '            fib.append(fib[i-1] + fib[i-1])  # Should be fib[i-1] + fib[i-2]',
  \ '        return fib',
  \ '',
  \ 'print(fibonacci(10))',
  \ ])

" Set filetype for syntax highlighting
set filetype=python

echo "Test file loaded. Instructions:"
echo "1. Select lines 3-15 with V (visual line mode)"
echo "2. Run :ClaudeImplement fix the fibonacci calculation error"
echo "3. Check :ClaudeDebug for debugging info"
echo ""
echo "Or test with a simple selection:"
echo "1. Select lines 13-14"
echo "2. Run :ClaudeImplement fix this line"