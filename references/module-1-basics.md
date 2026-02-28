# Module 1: The Basics

## What You'll Learn
- How to talk to Claude Code effectively
- Essential slash commands
- The permission system
- How Claude Code thinks and works

## How Claude Code Works

Claude Code is an AI coding assistant that lives in your terminal. It can read files, write code, run commands, search the web, and much more. But it's only as good as what you tell it.

Think of it as a very capable junior developer who:
- Knows a lot but needs context about YOUR project
- Can do many things at once but needs clear instructions
- Gets better the more context you give it

## Talking to Claude Code

### Be Specific
Bad: "fix the bug"
Good: "fix the login form - it crashes when the email field is empty"

### Give Context
Bad: "add a button"
Good: "add a delete button to the user profile page, it should call the DELETE /api/users/:id endpoint"

### Tell It What You Know
"The error is in src/auth.ts around line 50. The JWT token isn't being refreshed correctly."

### Let It Explore First
For complex tasks, let Claude Code explore the codebase before jumping to solutions:
"Look at how authentication works in this project, then suggest how to add OAuth support"

## Essential Slash Commands

These are commands you type directly in Claude Code:

| Command | What it does |
|---------|-------------|
| `/help` | Show all available commands and features |
| `/clear` | Clear the conversation history and start fresh |
| `/compact` | Compress the conversation to save context space |
| `/status` | Show current session info |
| `/mcp` | List connected MCP servers and their tools |
| `/model` | Switch between models (Opus, Sonnet, Haiku) |
| `/fast` | Toggle fast mode (same model, faster output) |

Other built-in commands: `/login`, `/logout`, `/doctor` (diagnose issues), `/config`.

Pro tip: You don't need to memorize all commands. Just type `/` and you'll see what's available.

## CLI Flags

You can customize Claude Code's behavior when you launch it:

```bash
# Choose a model
claude --model sonnet       # Use Sonnet (faster, cheaper)
claude --model opus         # Use Opus (smartest)

# One-shot mode (answer and exit, no interactive session)
claude --print "explain this error: ENOENT"

# Resume or continue a previous session
claude --resume             # Pick a recent session to resume
claude --continue           # Continue the most recent session

# Verbose output (see what's happening under the hood)
claude --verbose
```

### Pipe mode
You can pipe text into Claude Code from the terminal:
```bash
# Explain a file
cat src/utils.ts | claude --print "explain this code"

# Fix a bug from an error message
npm test 2>&1 | claude --print "fix this test failure"

# Generate from a description
echo "write a function that validates emails" | claude --print
```

This is powerful for scripting and automation (more in Module 7).

## Input Types

Claude Code doesn't just take text. You can also:
- **Paste images** directly into the chat (screenshots, diagrams)
- **Drag & drop files** into the terminal
- **Reference images by path**: "look at this screenshot: /path/to/screenshot.png"

This is great for: "Here's the design mockup, implement this UI" or "Here's the error screenshot, fix it."

## Keyboard Shortcuts

| Shortcut | What it does |
|----------|-------------|
| **Esc** | Cancel the current operation / stop Claude |
| **Ctrl+C** | Interrupt Claude or exit |
| **Up arrow** | Scroll through previous prompts |
| **Tab** | Autocomplete slash commands |

## The Permission System

Every time Claude wants to run a tool (edit a file, run a command, etc.), it needs permission. How that works depends on your permission mode.

### The 3 Modes

**1. Default Mode (ask for everything)**
Every tool call shows a prompt. You press `y` to approve or `n` to deny.
This is what you get out of the box. Great for learning since you see everything.

**2. Auto-approve with `--allowedTools`**
You can pre-approve specific tools so Claude doesn't ask for them:
```bash
claude --allowedTools "Read,Write,Edit,Glob,Grep"
```
Now Claude can read and write files without asking, but still asks before running Bash commands.

Common setups:
```bash
# Approve file tools only (safe default)
claude --allowedTools "Read,Write,Edit,Glob,Grep"

# Approve everything except Bash
claude --allowedTools "Read,Write,Edit,Glob,Grep,Agent,WebSearch"

# Approve specific bash patterns
claude --allowedTools "Read,Write,Edit,Glob,Grep,Bash(npm test),Bash(npm run *)"
```

**3. Yolo / Dangerous Mode**
Auto-approves almost everything, including bash commands:
```bash
claude --dangerouslySkipPermissions
```
Use this only in throwaway environments, containers, or when you really know what you're doing.

### Persistent Permissions in settings.json

Instead of passing flags every time, you can configure permissions in `~/.claude/settings.json`:
```json
{
  "permissions": {
    "allow": [
      "Read", "Write", "Edit", "Glob", "Grep",
      "Bash(npm test)", "Bash(npm run *)"
    ]
  }
}
```

### The Permission Prompt

When Claude asks for permission, you'll see numbered options you navigate with arrow keys:

- **1 Yes** — approve this one time
- **2 Yes, allow [pattern] for this project** — approve and save the rule permanently (won't ask again). This option appears depending on context.
- **3 No** — deny this action

You can also type a message to tell Claude what to do instead, or press **Esc** to cancel.

The number of options varies depending on the tool. Sometimes you'll see 2 options, sometimes 3.

### Pro tip
Start with default mode to understand what Claude does. After a few sessions, you'll know which tools you trust and can set up auto-approve for them. Most experienced users auto-approve file tools (Read, Write, Edit, Glob, Grep) and keep Bash on manual approval.

## How Tools Work

When you ask Claude Code to do something, it uses **tools** behind the scenes:

- **Read** - reads files from your project
- **Edit** - modifies existing files
- **Write** - creates new files
- **Bash** - runs terminal commands
- **Glob** - finds files by pattern
- **Grep** - searches file contents

You'll see these tool calls as Claude works. Each one will show you what's happening.

---

## Exercise

Let's try a few things right now:

1. **Try `/help`** - Type it to see all available commands
2. **Ask Claude Code to read a file** - Ask: "What files are in the current directory?"
3. **Ask about your system** - Ask: "What operating system am I running and what shell do I use?"

Try these one at a time and see how Claude Code responds.

---

## Quick Quiz

**Q1: What's the best way to ask Claude Code to fix a bug?**
A) "there's a bug somewhere"
B) "fix it"
C) "fix the crash in src/auth.ts when the token expires - it should refresh automatically"

Answer: C - Specific context helps Claude Code find and fix the issue faster.

**Q2: Which slash command clears the conversation?**
A) `/clear`
B) `/reset`
C) `/new`

Answer: A - `/clear` wipes the conversation and starts fresh.

**Q3: How can you let Claude edit files without asking, but still require approval for bash commands?**
A) You can't, it's all or nothing
B) Use `--dangerouslySkipPermissions`
C) Use `--allowedTools "Read,Write,Edit,Glob,Grep"`

Answer: C - `--allowedTools` lets you pick exactly which tools are auto-approved. Anything not in the list still requires manual approval.

---

## What's Next

Nice work! You now know the fundamentals. In **Module 2: Files & Code**, you'll learn how to navigate and modify code like a pro - finding functions, editing files, and searching through entire codebases in seconds.
