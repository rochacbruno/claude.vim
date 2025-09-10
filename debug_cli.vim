" Debug script for Claude CLI integration
" Usage: vim -S debug_cli.vim

" Set verbose mode
let g:claude_verbose = 1

" Configure Claude CLI path (adjust to your actual CLI command)
let g:claude_code_cli = '/home/rochacbruno/.claude/local/claude'

" Source the plugin
source plugin/claude.vim

" Open debug buffer first
ClaudeDebug

function! TestCLIDirectly()
  echo "========================================="
  echo "Testing Claude CLI directly..."
  echo "========================================="
  
  " Check if CLI is available
  if !executable(g:claude_code_cli)
    echohl ErrorMsg
    echo "ERROR: Claude CLI not found at: " . g:claude_code_cli
    echohl None
    return
  endif
  
  echo "CLI found at: " . g:claude_code_cli
  echo ""
  
  " Test 1: Simple echo test
  echo "Test 1: Testing with simple prompt..."
  let cmd = g:claude_code_cli . ' -p "Say hello" --output-format json 2>&1'
  echo "Command: " . cmd
  let output = system(cmd)
  echo "Exit code: " . v:shell_error
  echo "Output (first 500 chars):"
  echo strpart(output, 0, 500)
  echo ""
  
  " Test 2: Test with timeout
  echo "Test 2: Testing with timeout..."
  let cmd = 'timeout 10 ' . g:claude_code_cli . ' -p "Say hello" --output-format json 2>&1'
  echo "Command: " . cmd
  let output = system(cmd)
  echo "Exit code: " . v:shell_error
  if v:shell_error == 124
    echohl ErrorMsg
    echo "ERROR: CLI timed out after 10 seconds!"
    echohl None
  endif
  echo "Output (first 500 chars):"
  echo strpart(output, 0, 500)
  echo ""
  
  " Test 3: Check if CLI is waiting for input
  echo "Test 3: Testing if CLI expects stdin..."
  let cmd = 'echo "" | ' . g:claude_code_cli . ' -p "Say hello" --output-format json 2>&1'
  echo "Command: " . cmd
  let output = system(cmd)
  echo "Exit code: " . v:shell_error
  echo "Output (first 500 chars):"
  echo strpart(output, 0, 500)
  echo ""
endfunction

function! TestJobAPI()
  echo "========================================="
  echo "Testing Vim job API with CLI..."
  echo "========================================="
  
  let g:test_output = []
  let g:test_errors = []
  let g:test_completed = 0
  
  function! TestHandleOutput(channel, msg)
    call add(g:test_output, a:msg)
    echo "Output: " . strpart(a:msg, 0, 100)
  endfunction
  
  function! TestHandleError(channel, msg)
    call add(g:test_errors, a:msg)
    echohl WarningMsg
    echo "Error: " . a:msg
    echohl None
  endfunction
  
  function! TestHandleExit(job, status)
    let g:test_completed = 1
    echo "Job exited with status: " . a:status
    echo "Total output lines: " . len(g:test_output)
    echo "Total error lines: " . len(g:test_errors)
    
    if !empty(g:test_output)
      echo "Full output:"
      for line in g:test_output
        echo line
      endfor
    endif
    
    if !empty(g:test_errors)
      echohl ErrorMsg
      echo "Full errors:"
      for line in g:test_errors
        echo line
      endfor
      echohl None
    endif
  endfunction
  
  let cmd = [g:claude_code_cli, '-p', 'Say hello', '--output-format', 'json']
  echo "Starting job with command: " . join(cmd, ' ')
  
  if has('nvim')
    echo "Using Neovim job API"
    let job = jobstart(cmd, {
      \ 'on_stdout': {job_id, data, event -> map(data, {_, v -> TestHandleOutput(0, v)}),
      \ 'on_stderr': {job_id, data, event -> map(data, {_, v -> TestHandleError(0, v)}),
      \ 'on_exit': {job_id, exit_code, event -> TestHandleExit(0, exit_code)}
      \ })
    echo "Job ID: " . job
  else
    echo "Using Vim job API"
    let job = job_start(cmd, {
      \ 'out_cb': 'TestHandleOutput',
      \ 'err_cb': 'TestHandleError',
      \ 'exit_cb': 'TestHandleExit',
      \ 'out_mode': 'raw'
      \ })
    echo "Job status: " . job_status(job)
  endif
  
  " Wait for completion with timeout
  let start_time = localtime()
  while !g:test_completed && (localtime() - start_time) < 15
    sleep 100m
    redraw
    echo "Waiting... (" . (localtime() - start_time) . "s)"
  endwhile
  
  if !g:test_completed
    echohl ErrorMsg
    echo "ERROR: Job did not complete within 15 seconds!"
    echohl None
    if exists('job')
      if has('nvim')
        call jobstop(job)
      else
        call job_stop(job)
      endif
    endif
  endif
endfunction

" Run tests
call TestCLIDirectly()
echo ""
echo "Press any key to test job API..."
call getchar()
call TestJobAPI()

echo ""
echo "========================================="
echo "Debug complete. Check :ClaudeDebug for logs"
echo "========================================="