# Module 7: Power User

## What You'll Learn
- Worktrees for isolated work
- Parallel agent strategies
- Context window optimization
- Advanced workflows
- Productivity tips and tricks

## Worktrees: Parallel Workspaces

Worktrees let you work on multiple branches simultaneously without stashing or switching.

### How It Works

Two ways to use worktrees:

**1. From the CLI:**
```bash
claude --worktree    # or -w
```
This starts Claude in an isolated git worktree — a separate copy of your repo on its own branch. Your main branch stays clean.

**2. From a conversation:**
Say "start a worktree" and Claude creates one for you.

Worktrees are created at `<repo>/.claude/worktrees/<n>` with a branch named `worktree-<n>`.

### Agents + Worktrees
Subagents can also use worktrees. When Claude launches an agent with `isolation: worktree`, that agent gets its own copy of the repo. If the agent makes no changes, the worktree is automatically cleaned up.

This enables true parallel development: multiple agents working on different features simultaneously without interfering with each other.

### When to Use
- Exploring a risky refactor while keeping your stable code
- Working on a hotfix while in the middle of a feature
- Running long tasks that shouldn't block your main work
- Parallel agent tasks that need to modify files

## Context Window Management

Claude Code has a limited context window. The more efficiently you use it, the longer and more complex your sessions can be.

### Tips for Context Efficiency

**Use `/compact` regularly**
When the conversation gets long, `/compact` compresses the history while keeping essential context. Do this proactively, not just when you hit limits.

**Use `/clear` for fresh starts**
If you're switching to a completely different task, `/clear` gives you a clean slate. Your memory and CLAUDE.md persist, so Claude still knows your preferences.

**Be specific in prompts**
"Fix the bug in src/auth.ts line 42" uses way less context than "there's a bug somewhere in the auth system, can you find it and fix it?"

**Let agents handle exploration**
Instead of having Claude read 20 files in the main conversation, say "explore the auth module". The agent does the heavy lifting in its own context.

**Break large tasks into sessions**
Instead of one massive session, break work into logical chunks:
- Session 1: Plan the feature
- Session 2: Implement core logic
- Session 3: Add tests and polish

Claude's memory persists between sessions, so it remembers the plan.

## Advanced Workflows

### The Feature Development Flow
For significant features, use this pattern:

1. **Plan first**: "I need to add user profiles. Plan this before implementing."
2. **Review the plan**: Check Claude's approach, suggest changes
3. **Implement in stages**: One piece at a time, verifying as you go
4. **Test**: "Run the tests and fix any failures"
5. **Simplify**: Run `/simplify` to clean up the code you just wrote
6. **Review**: "Review the changes for any issues" (or `/review-pr` for a thorough review)
7. **Ship it**: Run `/commit-push-pr` to commit, push, and open a PR in one shot

Steps 6-7 replace the old manual flow of commit → push → create PR. One command does it all.

### The Debug Flow
When something's broken:

1. **Describe the symptom**: "The app crashes when I click 'Save'. Here's the error: [paste error]"
2. **Let Claude explore**: It reads relevant code, traces the issue
3. **Review the fix**: Claude suggests a fix and explains why
4. **Verify**: "Run the tests to make sure this doesn't break anything"

### The Review Flow
For code quality:

1. **Ask for review**: "Review the changes I've made in this branch"
2. **Get specific**: "Focus on security and error handling"
3. **Iterate**: Fix issues Claude finds, then review again

## Parallel Agent Strategies

### When to parallelize
- Reviewing different aspects of code (security, performance, tests)
- Exploring multiple parts of a codebase
- Researching multiple topics

### How to trigger it
Be explicit about independent tasks:
"I need you to: 1) check all API endpoints for auth middleware, 2) find unused dependencies in package.json, 3) list all TODO comments"

Claude recognizes these as independent and launches parallel agents.

## The `/loop` Command

`/loop` is a built-in command that runs a prompt or slash command on a recurring interval. Great for monitoring tasks.

```
/loop 5m check the deploy status
/loop 10m /review-pr 42
/loop 30s run the tests
```

Default interval is 10 minutes if you don't specify. Use cases:
- Monitoring a deployment
- Watching CI/CD status
- Polling for PR review updates
- Re-running tests periodically during development

## Model Selection

Claude Code supports different models. Use `/model` to switch:

| Model | Best for |
|-------|---------|
| **Opus** | Complex reasoning, architecture, nuanced tasks |
| **Sonnet** | Daily coding, balanced speed/quality |
| **Haiku** | Quick questions, simple tasks, fast responses |

### Fast Mode
Toggle with `/fast` - same model, faster output. Great for straightforward tasks where you don't need deep reasoning.

## Headless & Pipe Mode

Claude Code isn't just interactive. You can use it in scripts, CI/CD, and automation.

### One-shot with `--print`
Ask a question, get an answer, exit. No interactive session:
```bash
claude --print "what does this function do?" < src/utils.ts
```

### Pipe mode
Pipe any output into Claude:
```bash
# Fix a failing test
npm test 2>&1 | claude --print "fix this test failure"

# Explain an error
cat error.log | claude --print "what went wrong and how to fix it"

# Generate code
echo "write a TypeScript function that retries failed HTTP requests 3 times" | claude --print
```

### In scripts and CI/CD
```bash
#!/bin/bash
# Auto-generate PR description from diff
DIFF=$(git diff main...HEAD)
DESCRIPTION=$(echo "$DIFF" | claude --print "write a PR description for these changes")
gh pr create --title "Feature: ..." --body "$DESCRIPTION"
```

### `--resume` and `--continue`
```bash
claude --continue     # Pick up the most recent session
claude --resume       # Choose from recent sessions
```

This is great for long tasks: close the terminal, come back later, continue where you left off.

## Session Management

### `/rename` — Name Your Sessions
Give your session a descriptive title so you can find it later:
```
/rename dark mode feature
```

### `--resume` and `--continue`
```bash
claude --continue     # Pick up the most recent session
claude --resume       # Choose from recent sessions
```

Close the terminal, come back later, continue where you left off. Claude remembers everything.

### `/context` — See What Claude Knows
Visualizes your current context: loaded skills, agents, files, and memory. Useful to understand what Claude has access to.

### `/usage` — Check Your Plan
See how much of your plan you've used.

## Productivity Tips

### 1. Chain operations naturally
"Create the file, add the tests, and run them" — Claude handles multi-step requests.

### 2. Use `/simplify` after writing code
It catches things you miss: duplicate logic, naming inconsistencies, unnecessary complexity.

### 3. Use `/commit-push-pr` for the full flow
Don't manually commit, push, then create a PR. One command does it all.

### 4. Iterate quickly
"That's almost right, but change X to Y" — small corrections are cheap.

### 5. Use plugins for your stack
GitHub user? Install the `github` plugin. Using Vercel? Install `vercel`. These save enormous time.

### 6. Set up CLAUDE.md early
10 minutes of CLAUDE.md setup saves hours of repeated corrections.

### 7. Use memory for patterns
"Remember: in this project, API errors should use the AppError class from src/errors.ts"

### 8. Don't over-specify
Bad: "Use the Read tool to read the file src/auth.ts, then use the Edit tool to change..."
Good: "In src/auth.ts, rename handleLogin to authenticateUser"

Claude knows which tools to use. Tell it WHAT you want, not HOW to do it.

### 9. Use `/compact` proactively
Don't wait until you hit context limits. Compact after completing a major task.

### 10. Use `/loop` for monitoring
Need to keep an eye on something? `/loop 5m check the CI status` — Claude checks every 5 minutes.

---

## Exercise

Let's put it all together with a real workflow:

1. **Full feature flow**: Ask Claude: "Let's do a complete workflow exercise. Create a simple TODO list module with: a data model, basic CRUD functions, and a test file. Plan first, then implement, then review the result."

2. **Simplify**: After the implementation, run `/simplify` to see if there's anything to clean up.

3. **Context management**: Try `/compact` after completing the feature, and `/context` to see what Claude has loaded.

4. **Model switching**: Try `/model` to see available models, and `/fast` to toggle fast mode.

5. **Session naming**: Try `/rename TODO feature exercise` to name this session for later.

---

## Quick Quiz

**Q1: When should you use `/compact`?**
A) At the start of every conversation
B) Only when Claude tells you to
C) Proactively after completing major tasks, before hitting context limits

Answer: C - Regular compaction keeps your session efficient without losing important context.

**Q2: What does `/loop 5m check CI` do?**
A) Runs `check CI` once after 5 minutes
B) Runs `check CI` every 5 minutes on repeat
C) Loops through 5 CI jobs

Answer: B - `/loop` runs a prompt on a recurring interval. Great for monitoring tasks.

**Q3: What's the fastest way to go from code to PR?**
A) Manually commit, push, and create PR
B) Use `/commit-push-pr` to do all three in one shot
C) Use `/commit` then manually push and create PR

Answer: B - `/commit-push-pr` handles the entire flow: analyzes changes, commits, pushes, and creates a PR with a proper description.

**Q4: How does Claude's memory persist between sessions?**
A) It doesn't, every session starts fresh
B) Through memory files stored in `.claude/projects/` that are loaded automatically
C) Through browser cookies

Answer: B - Memory files are stored locally and loaded at the start of each session.

---

## Congratulations!

You've completed all 7 modules of the Claude Code Onboarding!

Here's what you've mastered:
- **Module 1**: Effective communication, commands, permissions
- **Module 2**: File operations, search, codebase navigation
- **Module 3**: Essential bash commands and terminal skills
- **Module 4**: Git workflow, smart commits, PRs
- **Module 5**: Agents, Plan Mode, MCP, Plugins
- **Module 6**: CLAUDE.md, Memory, Skills, Plugins, Hooks
- **Module 7**: Power user workflows, worktrees, session management, and productivity tips

### What's Next?
- **Build something!** The best way to learn is by doing
- **Install key plugins**: `/plugin` to browse — start with `github` and `commit-commands`
- **Explore skills**: `npx skills search` to find specialized skills
- **Try `/simplify`**: Run it after writing code to catch quality issues
- **Customize**: Refine your CLAUDE.md as you develop preferences
- **Share**: Help others get started with Claude Code
