# Module 6: Customization

## What You'll Learn
- The `.claude/` directory: what goes where
- `settings.json`: permissions, allowed tools, hooks
- CLAUDE.md files: rules and conventions
- Memory, Skills, and Plugins
- How to stop Claude from asking permission for every little thing

## The .claude/ Directory

This is where ALL your Claude Code configuration lives. There are two levels:

### Global: `~/.claude/` (your home directory)
Applies to everything, everywhere.

```
~/.claude/
├── CLAUDE.md              # Global rules (applies to all projects)
├── settings.json          # Permissions, hooks, allowed tools
├── skills/                # Installed skills
│   ├── cc-onboarding/     # This skill!
│   └── git-commit/        # /commit skill
├── plugins/               # Installed plugins
└── projects/              # Auto-generated per-project data
    └── <project-hash>/
        └── memory/
            └── MEMORY.md  # Persistent memory for this project
```

### Project: `your-repo/.claude/` (at repo root)
Applies only to this project. Can be committed to git for team sharing.

```
your-repo/
├── .claude/
│   └── settings.json      # Project-level permissions & hooks
├── CLAUDE.md              # Project rules & conventions
└── src/
    └── CLAUDE.md          # Subdirectory-specific rules (optional)
```

### Which file wins?
Project settings **merge with** global settings. For CLAUDE.md, more specific files override more general ones:
`~/.claude/CLAUDE.md` < `project/CLAUDE.md` < `project/src/CLAUDE.md`

## settings.json: The Permission Bible

This is the file that fixes the "Claude asks for EVERYTHING" problem.

### Location
- **Global**: `~/.claude/settings.json` → applies to all projects
- **Project**: `your-repo/.claude/settings.json` → applies to this project only

### The Full Structure

```json
{
  "permissions": {
    "allow": [
      "Read",
      "Write",
      "Edit",
      "Glob",
      "Grep",
      "Bash(git status)",
      "Bash(git diff *)",
      "Bash(git log *)",
      "Bash(npm test)",
      "Bash(npm run *)",
      "Bash(npx *)",
      "Bash(ls *)",
      "Bash(cat *)",
      "Bash(pwd)",
      "Bash(which *)",
      "Bash(echo *)"
    ],
    "deny": [
      "Bash(rm -rf *)",
      "Bash(git push --force*)"
    ]
  },
  "hooks": {},
  "statusLine": {}
}
```

### Permission Patterns Explained

The `allow` list supports **exact matches** and **glob patterns**:

| Pattern | What it allows |
|---------|---------------|
| `"Read"` | The Read tool (all files) |
| `"Bash(git status)"` | Exactly `git status` |
| `"Bash(git *)"` | Any git command |
| `"Bash(npm run *)"` | Any npm script |
| `"Bash(npx *)"` | Any npx command |
| `"Bash(ls *)"` | ls with any args |

The `deny` list **blocks** matching commands even if another rule allows them. Deny always wins.

### Starter Configs

**Conservative (recommended for beginners)**
Auto-approve file operations, approve bash manually:
```json
{
  "permissions": {
    "allow": ["Read", "Write", "Edit", "Glob", "Grep"]
  }
}
```

**Balanced (recommended for daily use)**
File ops + safe bash commands:
```json
{
  "permissions": {
    "allow": [
      "Read", "Write", "Edit", "Glob", "Grep",
      "Agent", "WebSearch", "TodoWrite",
      "Bash(git *)", "Bash(ls *)", "Bash(pwd)",
      "Bash(cat *)", "Bash(head *)", "Bash(tail *)",
      "Bash(wc *)", "Bash(which *)", "Bash(echo *)",
      "Bash(node *)", "Bash(npm *)", "Bash(npx *)",
      "Bash(pnpm *)", "Bash(bun *)"
    ],
    "deny": [
      "Bash(rm -rf *)",
      "Bash(git push --force*)",
      "Bash(git reset --hard*)"
    ]
  }
}
```

**Wide open (for containers / throwaway envs)**
Or just launch with the flag:
```bash
claude --dangerouslySkipPermissions
```

### CLI Flags vs settings.json

| Method | Scope | Persists? |
|--------|-------|-----------|
| `--allowedTools "Read,Edit"` | This session only | No |
| `~/.claude/settings.json` | All projects | Yes |
| `.claude/settings.json` (project) | This project | Yes (committable) |
| `--dangerouslySkipPermissions` | This session only | No |

### The Permission Prompt

When Claude asks for permission, you'll see numbered options (navigate with arrow keys):

- **1 Yes** → approve once
- **2 Yes, allow [pattern] for this project** → approve and save the rule permanently to your local settings (won't ask again). This option appears depending on context.
- **3 No** → deny

You can also type a message to redirect Claude, or press **Esc** to cancel.

When you pick option 2, the permission rule gets saved to `.claude/settings.local.json` — so you never get asked for that pattern again.

## CLAUDE.md: Rules for Claude

CLAUDE.md tells Claude HOW to work. It's loaded at the start of every session.

### Global `~/.claude/CLAUDE.md`
Your personal preferences across all projects:

```markdown
# My Preferences

## Git
- Never add Co-Authored-By lines in commit messages
- Use conventional commits

## Code Style
- Prefer functional over class-based
- Use TypeScript strict mode
- Indent with 2 spaces

## Workflow
- Never run build/lint automatically after a task
- Always ask before deleting files
```

### Project `CLAUDE.md`
Project-specific rules (committable, shared with team):

```markdown
# Project: MyApp

## Tech Stack
- Next.js 15 with App Router
- Tailwind CSS v4
- PostgreSQL with Drizzle ORM

## Conventions
- Components in src/components/, kebab-case filenames
- API routes in src/app/api/
- Tests next to source: feature.ts → feature.test.ts

## Commands
- Dev: pnpm dev
- Test: pnpm test
- Build: pnpm build
```

### Pro tip
Don't overthink it. Start with 5-10 rules. Add more as you notice Claude doing things you'd rather it didn't.

## Memory System

Memory persists facts across sessions. Different from CLAUDE.md (rules vs notes).

| | CLAUDE.md | Memory |
|---|----------|--------|
| **Purpose** | Rules and conventions | Facts and decisions |
| **Location** | Repo root / `~/.claude/` | `~/.claude/projects/<hash>/memory/` |
| **Example** | "Use pnpm, not npm" | "Auth middleware is in src/middleware/auth.ts" |
| **Shared?** | Yes (via git) | No (local only) |

### How it works under the hood

There's no magic. MEMORY.md is just a regular markdown file that Claude reads and writes with its normal tools.

**At the start of every session:**
Claude automatically reads `~/.claude/projects/<project-hash>/memory/MEMORY.md`. That's how it "remembers" things from last time.

**When you say "remember X":**
Claude uses the **Write** or **Edit** tool to add a line to MEMORY.md. You'll see the tool call in your session — it's not invisible. It literally edits a file.

**When Claude decides to remember on its own:**
Occasionally, if Claude discovers something important (a recurring pattern, an architecture decision), it may proactively write it to MEMORY.md. But this is rare — most of the time it only writes when you explicitly ask.

**You can edit it yourself:**
It's just a file. Open it in your editor, add notes, delete outdated stuff. Claude reads whatever is in there next session.

```bash
# Find your memory files
find ~/.claude/projects -name "MEMORY.md"

# Read one
cat ~/.claude/projects/<hash>/memory/MEMORY.md
```

### What to store
- "Remember that the auth middleware is in src/middleware/auth.ts"
- "Remember to always run migrations before tests"
- "Remember that the database schema is in prisma/schema.prisma"

### What NOT to store
- Temporary debugging info (will clutter the file)
- Things already in CLAUDE.md (redundant)
- Session-specific context (won't be useful next time)

## Skills & Plugins

Claude Code has two extension systems: **Skills** and **Plugins**. They complement each other.

### Skills vs Plugins

| | Skills | Plugins |
|---|--------|---------|
| **What** | Instruction files (SKILL.md) | Bundles of MCP servers, skills, hooks, agents |
| **Install** | `npx skills add <repo>` | `/plugin` UI or `/plugin install` |
| **Location** | `~/.claude/skills/` | `~/.claude/plugins/` |
| **Trigger** | Slash commands or auto-detect | Slash commands, tools, auto-detect |
| **Examples** | `/commit`, `/simplify` | `github`, `notion`, `pr-review-toolkit` |

### Skills: Slash Commands & Context-Triggered Capabilities

Skills are folders with a `SKILL.md` file that tells Claude how to handle specific tasks. Some are triggered by slash commands, others activate automatically based on context.

This onboarding you're doing right now? It's a skill.

#### Finding and Installing Skills
```bash
# Search for skills
npx skills search commit

# Install a skill globally
npx skills add <repo> --skill <name> -g -y
```

#### Where Skills Live
- Global: `~/.claude/skills/<skill-name>/`
- Each skill has a `SKILL.md` file with instructions
- Skills hot-reload: add or modify a skill and it's available instantly, no restart needed

#### Must-Have Skills

Here are some of the most useful skills to install:

| Skill | Slash command | What it does |
|-------|--------------|-------------|
| **git-commit** | `/commit` | Smart conventional commits with auto-detection |
| **find-skills** | (auto) | Helps you discover skills when you ask "is there a skill for X?" |
| **skill-creator** | (auto) | Interactive guide to create your own skills |
| **claude-api** | (auto) | Patterns for building with the Claude API |

#### Creating Your Own Skills

A skill is just a folder with a `SKILL.md` file. Here's the minimal structure:

```markdown
---
name: my-skill
description: "What this skill does and when to trigger it"
---

# My Skill

Instructions for Claude when this skill is activated...
```

Drop it in `~/.claude/skills/my-skill/SKILL.md` and it's live.

### Plugins: The Integration Ecosystem

Plugins are more powerful than skills — they can include MCP servers, subagents, hooks, and slash commands all in one package.

#### Managing Plugins
- `/plugin` — Browse, install, and manage plugins
- `/plugin install <name>@<marketplace>` — Install from command line
- After installing a plugin, **restart Claude Code** to load it

#### Must-Have Plugins

Here are the most useful plugins from the official marketplace:

| Plugin | Slash commands | What it does |
|--------|---------------|-------------|
| `commit-commands` | `/commit`, `/commit-push-pr`, `/clean_gone` | Git commit, push+PR in one shot, branch cleanup |
| `code-simplifier` | `/simplify` | Reviews recent code for quality, reuse, efficiency — then fixes issues |
| `pr-review-toolkit` | `/review-pr` | Specialized PR review with parallel agents |
| `code-review` | `/code-review` | Code review a pull request |
| `feature-dev` | `/feature-dev` | Guided feature development with architecture focus |
| `claude-md-management` | `/revise-claude-md` | Update CLAUDE.md with learnings from a session |

Install any of them via `/plugin` or:
```
/plugin install commit-commands@claude-plugins-official
```

#### `/simplify` — Your Code Quality Buddy

After writing code, run `/simplify` (from the `code-simplifier` plugin). It:
1. Looks at your recently modified code
2. Checks for reuse opportunities, code quality, and efficiency
3. Fixes any issues it finds automatically

It's like having a code reviewer that also fixes things.

#### `/commit-push-pr` — Ship in One Command

The `commit-commands` plugin gives you:

| Command | What it does |
|---------|-------------|
| `/commit` | Create a smart git commit |
| `/commit-push-pr` | Commit + push + open a PR in one shot |
| `/clean_gone` | Clean up local branches deleted on remote |

The `/commit-push-pr` workflow is a game-changer: it analyzes your changes, creates a commit with a good message, pushes the branch, and opens a PR with a proper description — all in one command.

#### The `pr-review-toolkit` Plugin

Installs specialized review agents:

| Command / Agent | What it does |
|----------------|-------------|
| `/review-pr` | Full PR review with multiple specialized agents |
| code-reviewer | Bugs, logic errors, security, code quality |
| silent-failure-hunter | Finds swallowed errors and bad fallbacks |
| code-simplifier | Simplifies code while preserving functionality |
| comment-analyzer | Checks comment accuracy and maintainability |
| pr-test-analyzer | Reviews test coverage quality |
| type-design-analyzer | Analyzes type design and invariants |

These agents run in parallel when reviewing a PR, each focusing on a different aspect.

#### Hands-on: Install your first skill

Let's install the `git-commit` skill step by step:

1. **Search**: Run `npx skills search git` to see available git skills
2. **Install**: Run `npx skills add anthropics/claude-code-skills --skill git-commit -g -y`
3. **Verify**: Check that it's installed: `ls ~/.claude/skills/git-commit/`
4. **Use it**: Type `/commit` in Claude Code — it should now be available!

If `npx skills` doesn't work, you can also install manually:
```bash
# Clone the repo and copy the skill folder
git clone https://github.com/anthropics/claude-code-skills /tmp/cc-skills
cp -r /tmp/cc-skills/skills/git-commit ~/.claude/skills/
rm -rf /tmp/cc-skills
```

#### Community Skills & Plugins

The ecosystem is growing fast:
- **Official**: `anthropics/skills` — PDF, DOCX, PPTX, XLSX, webapp testing, and more
- **Community**: Search `npx skills search <keyword>` or browse curated lists on GitHub
- **Make your own**: Use the `skill-creator` skill to build custom skills interactively

## IDE Integrations

Claude Code works in the terminal, but it also integrates with IDEs:

### VSCode
- Install the **Claude Code** extension from the VSCode marketplace
- Opens Claude Code in a panel inside VSCode
- Can see your open files, selections, and project context
- Keyboard shortcut to send selected code to Claude

### JetBrains (IntelliJ, WebStorm, PyCharm, etc.)
- Claude Code plugin available in the JetBrains marketplace
- Similar integration: panel, file context, selections

### Terminal-only (no IDE)
Works perfectly fine standalone. Many power users prefer the raw terminal experience for speed.

## Hooks: Event-Driven Automation

Hooks run scripts when Claude does things. Configured in `settings.json`.

```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Bash",
      "command": "echo 'About to run a bash command'"
    }],
    "PostToolUse": [{
      "matcher": "Write|Edit",
      "command": "prettier --write $CLAUDE_FILE_PATH"
    }],
    "Stop": [{
      "command": "echo 'Claude finished a task'"
    }]
  }
}
```

| Event | When | Use case |
|-------|------|----------|
| `PreToolUse` | Before a tool runs | Block dangerous commands, validate |
| `PostToolUse` | After a tool runs | Auto-format, lint, log |
| `Stop` | Claude finishes | Verify completeness, notify |
| `Notification` | Claude notifies you | Custom alerts |

---

## Exercise

Let's set up YOUR config right now:

1. **Check your current config**: Ask Claude: "Read my ~/.claude/settings.json and ~/.claude/CLAUDE.md and show me what's configured"

2. **Set up auto-approve**: Ask Claude: "Create a balanced settings.json for me that auto-approves file tools and safe bash commands like git, ls, npm. Put it in ~/.claude/settings.json"

3. **Create a global CLAUDE.md**: Ask Claude: "Help me create a ~/.claude/CLAUDE.md with my preferences. Ask me questions about my coding style and conventions."

4. **Explore plugins**: Type `/plugin` to see what's available. Try installing the `commit-commands` plugin if you use git regularly.

5. **Try /simplify**: If you have recently modified code, try running `/simplify` to see it in action.

---

## Quick Quiz

**Q1: You're tired of Claude asking permission for `git status`. How do you fix this permanently?**
A) Add `"Bash(git status)"` to `permissions.allow` in your settings.json
B) Delete settings.json
C) Use `--dangerouslySkipPermissions` every time

Answer: A - Adding the pattern to `permissions.allow` in settings.json means Claude won't ask for that command again.

**Q2: Where should project-specific rules go so your whole team benefits?**
A) `~/.claude/settings.json`
B) `~/.claude/CLAUDE.md`
C) `CLAUDE.md` at the repo root (committable to git)

Answer: C - A project CLAUDE.md at the repo root can be committed to git and shared.

**Q3: What's the difference between `permissions.allow` and `permissions.deny`?**
A) `deny` always wins - it blocks commands even if `allow` would permit them
B) `allow` always wins
C) They're the same thing

Answer: A - Deny rules take priority, so you can broadly allow `Bash(git *)` while specifically denying `Bash(git push --force*)`.

**Q4: What does `/commit-push-pr` do?**
A) Only creates a commit
B) Commits, pushes, and opens a PR in one command
C) Only pushes to remote

Answer: B - The `commit-commands` plugin gives you `/commit-push-pr` which handles the entire flow: commit + push + PR creation.

**Q5: What's the difference between a skill and a plugin?**
A) They're the same thing
B) Skills are instruction files (SKILL.md), plugins can bundle MCP servers, agents, hooks, and skills together
C) Plugins are only for VSCode

Answer: B - Skills are lightweight instruction files. Plugins are full packages that can include MCP servers, subagents, hooks, and slash commands.

---

## What's Next

Your Claude Code is now fully configured. In the final **Module 7: Power User**, you'll learn the advanced workflows that make experts so productive.
