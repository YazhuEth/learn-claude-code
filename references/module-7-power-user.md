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
Say "start a worktree" and Claude creates an isolated copy of your repo. You can:
- Work on a feature while keeping your main branch clean
- Test changes without affecting your current work
- Run multiple tasks in parallel on different branches

### When to Use
- Exploring a risky refactor while keeping your stable code
- Working on a hotfix while in the middle of a feature
- Running long tasks that shouldn't block your main work

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
5. **Review**: "Review the changes for any issues"
6. **Commit**: "commit my changes" for a clean commit
7. **PR**: "Create a PR with a good description"

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

## Productivity Tips

### 1. Chain operations naturally
"Create the file, add the tests, and run them" - Claude handles multi-step requests.

### 2. Use context references
"In the file you just read, change line 15 to..."

### 3. Iterate quickly
"That's almost right, but change X to Y" - small corrections are cheap.

### 4. Use Claude for code review
Before committing: "Review these changes for bugs and suggest improvements"

### 5. Ask for explanations
"Explain what this function does" is free context-building for future tasks.

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

### 10. Trust but verify
Claude is very capable but not infallible. For critical changes, always review the diff before committing.

---

## Exercise

Let's put it all together with a real workflow:

1. **Full feature flow**: Ask Claude: "Let's do a complete workflow exercise. Create a simple TODO list module with: a data model, basic CRUD functions, and a test file. Plan first, then implement, then review the result."

2. **Context management**: During the exercise above, try using `/compact` after the planning phase, and notice how the conversation stays manageable.

3. **Model switching**: Try `/model` to see available models, and `/fast` to toggle fast mode.

---

## Quick Quiz

**Q1: When should you use `/compact`?**
A) At the start of every conversation
B) Only when Claude tells you to
C) Proactively after completing major tasks, before hitting context limits

Answer: C - Regular compaction keeps your session efficient without losing important context.

**Q2: What's the best way to give Claude Code instructions?**
A) Describe WHAT you want, not HOW to do it
B) Keep it as vague as possible so Claude has freedom
C) Specify which tools to use step by step

Answer: A - Tell Claude the goal and let it choose the best tools and approach.

**Q3: How does Claude's memory persist between sessions?**
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
- **Module 5**: Agents, Plan Mode, MCP, task tracking
- **Module 6**: CLAUDE.md, Memory, Skills, Hooks
- **Module 7**: Power user workflows and productivity tips

### What's Next?
- **Build something!** The best way to learn is by doing
- **Explore skills**: `npx skills search` to find specialized skills
- **Customize**: Refine your CLAUDE.md as you develop preferences
- **Share**: Help others get started with Claude Code
