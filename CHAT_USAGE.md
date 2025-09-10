# How to Use ClaudeChat

## Important: Message Format

When using `:ClaudeChat`, you must type your message **on the same line** as "You: ".

### Correct Usage ✅

```
You: What is the capital of France?
```

Then press `Ctrl+]` to send.

### Incorrect Usage ❌

```
You: 
What is the capital of France?
```

This won't work because the message is on a separate line.

## Step-by-Step Instructions

1. Open Claude Chat:
   ```vim
   :ClaudeChat
   ```

2. You'll see a buffer with:
   ```
   System prompt: [folded]
   Type your messages below, press C-] to send.

   You: 
   ```

3. Type your message **directly after** "You: " on the same line:
   ```
   You: Please help me write a hello world function in Python
   ```

4. Press `Ctrl+]` to send the message

5. Wait for Claude's response (with verbose mode you'll see progress)

## Multi-line Messages

If you need to send multi-line content:

1. Type the first line after "You: "
2. Continue on subsequent lines (they'll be treated as continuation)
3. Press `Ctrl+]` when done

Example:
```
You: Please review this code:
    def hello():
        print("Hello")
```

## Troubleshooting Empty Prompts

If you see "Claude: Found 0 messages" or "Empty prompt", it means:

1. You didn't type anything after "You: "
2. You typed on a new line instead of after "You: "
3. The buffer parsing failed

To fix:
1. Make sure your cursor is after "You: "
2. Type your message
3. Press `Ctrl+]` without moving to a new line first

## Enabling Verbose Mode

Add to your `.vimrc`:
```vim
let g:claude_verbose = 1
```

This will show:
- "Claude: Parsing chat buffer..."
- "Claude: Found X messages"
- "Claude: Prompt length: X chars"
- Progress during API calls

## Quick Test

1. `:ClaudeChat`
2. Type exactly: `You: Say hello`
3. Press `Ctrl+]`
4. You should see Claude's response