# Claude.vim Troubleshooting Guide

## ClaudeChat Hanging Issues

If `:ClaudeChat` appears to hang without any response, follow these steps:

### 1. Enable Verbose Mode

Add this to your `.vimrc`:
```vim
let g:claude_verbose = 1
```

This will show detailed progress messages during API/CLI calls.

### 2. Check Your CLI Path Configuration

The plugin supports two variable names for the CLI path:
- `g:claude_code_cli` (preferred)
- `g:claude_cli_path` (backwards compatibility)

Make sure you have one of these set correctly:
```vim
" Use the full path to your Claude CLI executable
let g:claude_code_cli = '/home/username/.claude/local/claude'
" OR
let g:claude_cli_path = '/home/username/.claude/local/claude'
```

### 3. Use the Debug Buffer

Run `:ClaudeDebug` to open the debug buffer, which shows:
- Configuration status
- CLI executable detection
- Debug log messages
- CLI test results

### 4. Run the Debug Script

Test your CLI integration directly:
```bash
vim -S debug_cli.vim
```

This script will:
- Test the CLI directly with simple commands
- Check for timeout issues
- Test the Vim job API integration
- Show detailed error messages

### 5. Test CLI Manually

Test your Claude CLI outside of Vim:
```bash
# Check if CLI is accessible
which claude

# Test a simple prompt
/path/to/claude -p "Say hello" --output-format json

# Check with timeout
timeout 10 /path/to/claude -p "Say hello" --output-format json
```

### Common Issues and Solutions

#### Issue: "Claude CLI not found"
**Solution**: Make sure the path in `g:claude_code_cli` points to the actual executable and is executable:
```bash
ls -la /path/to/claude
chmod +x /path/to/claude  # if needed
```

#### Issue: CLI hangs indefinitely
**Possible causes**:
1. CLI is waiting for authentication
2. CLI is trying to read from stdin
3. Network issues

**Solutions**:
1. Run the CLI manually to check for auth prompts
2. Make sure the CLI is properly configured
3. Check your internet connection

#### Issue: No output but no errors
**Solution**: Check the `:ClaudeDebug` buffer for hidden errors. Enable verbose mode to see progress messages.

#### Issue: "Job exited with status X"
**Common status codes**:
- 124: Timeout (CLI took too long)
- 127: Command not found
- 1: General error (check stderr in debug log)

### Getting More Help

1. Check the full debug log in `:ClaudeDebug`
2. Run the test script with verbose mode enabled
3. Look for error messages in `:messages`
4. Check if the issue occurs with both Vim and Neovim

### Reporting Issues

When reporting issues, please include:
1. Output of `:ClaudeDebug`
2. Your Vim/Neovim version (`:version`)
3. Your `.vimrc` Claude configuration
4. Results from running `debug_cli.vim`