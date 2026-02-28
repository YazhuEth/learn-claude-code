# Module 4: Git Workflow

## What You'll Learn
- Git essentials with Claude Code
- Smart commits (natural language or `/commit` skill)
- Pull request workflows
- Code review with Claude Code
- Installing useful git skills

## Git Basics with Claude Code

You don't need to memorize git commands. Just tell Claude Code what you want:

| What you want | What to say |
|--------------|-------------|
| See what changed | "what files have I changed?" |
| Check branch status | "what branch am I on and is it up to date?" |
| View recent history | "show me the last 5 commits" |
| See a diff | "show me the diff for src/auth.ts" |
| Create a branch | "create a new branch called feature/user-profile" |
| Switch branch | "switch to the main branch" |

Claude Code translates your intent into the right git commands. But knowing the basics helps:

```bash
git status              # What's changed?
git diff                # See unstaged changes
git diff --staged       # See staged changes
git log --oneline -10   # Last 10 commits, compact
git branch              # List branches
git checkout -b new     # Create and switch to branch
```

## Smart Commits

You don't need a special command to commit. Just tell Claude what you want:

- "commit my changes" → Claude analyzes the diff, writes a message, and commits
- "commit only the auth changes" → partial commit
- "commit with message: fix login bug" → uses your message

Claude will:
1. Run `git status` and `git diff` to understand your changes
2. Generate a clear commit message
3. Stage the right files
4. Ask for your approval before committing

### Conventional Commits Format
```
type(scope): description

feat(auth): add OAuth2 login flow
fix(api): handle null response from user endpoint
refactor(utils): extract date formatting to shared helper
docs(readme): add setup instructions for new contributors
```

Common types: `feat`, `fix`, `refactor`, `docs`, `test`, `chore`, `style`, `perf`

### Want a dedicated /commit command?

`/commit` is **not built-in** — it's an installable **skill**. Many useful slash commands come from skills you can add. To install the commit skill:

```bash
npx skills add anthropics/claude-code-skills --skill git-commit -g -y
```

After installing, `/commit` becomes available and gives you a more structured commit workflow with auto-detection of type, scope, and description.

This is a great example of how **skills extend Claude Code**. You'll learn more about this in Module 6.

### Pro tips
- Claude reads recent commits to match your project's style
- It never auto-pushes unless you ask
- You can say "commit only the changes in src/auth/" for partial commits

## Branch Workflow

A typical feature workflow with Claude Code:

```
1. "create a branch called feature/dark-mode"
2. ... do your work ...
3. "commit my changes"
4. "push this branch and create a PR"
```

Claude handles the whole flow. It will:
- Create the branch
- Stage the right files
- Write a good commit message
- Push with `-u` flag
- Create a PR with a proper title and description

## Pull Requests

### Creating a PR
Just say: "create a pull request"

Claude will:
1. Check what's changed vs the base branch
2. Look at ALL commits (not just the latest)
3. Draft a title and description
4. Create it with `gh pr create`

### Reviewing a PR
Say "review PR #123" or paste a PR URL. Claude will:
- Read the full diff
- Check for bugs, security issues, performance problems
- Look at code quality and test coverage
- Give actionable feedback

Note: There's also a `/review-pr` skill you can install for a more structured review workflow.

## Common Git Scenarios

### "I need to undo my last commit"
Say: "undo the last commit but keep the changes"
(Claude will use `git reset --soft HEAD~1`)

### "I have merge conflicts"
Say: "help me resolve the merge conflicts"
Claude will read the conflicting files and help you choose the right resolution.

### "I accidentally committed to main"
Say: "move my last commit to a new branch called feature/oops"

### "I need to update my branch with main"
Say: "rebase my branch on main" or "merge main into my branch"

## Safety Rules

Claude Code follows these git safety rules by default:
- Never force-pushes unless you explicitly ask
- Never amends published commits
- Prefers new commits over amending
- Never skips hooks (pre-commit, etc.)
- Warns you about sensitive files (.env, credentials)

---

## Exercise

If you're in a git repository, try these:

1. **Check status**: "What's the current git status? What branch am I on?"
2. **View history**: "Show me the last 5 commits with their messages"
3. **Try committing**: If you have changes, say "commit my changes" and see what Claude generates

If you're NOT in a git repo:
1. Ask Claude: "Initialize a git repo here and create a sample file"
2. Then try the steps above

---

## Quick Quiz

**Q1: What happens when you say "commit my changes" to Claude?**
A) It pushes your code to GitHub
B) It immediately commits all files with a generic message
C) It analyzes your diff, generates a commit message, and asks for your approval

Answer: C - Claude reads your changes, drafts a message, and waits for you to approve before committing.

**Q2: You need to create a PR. What's the easiest way?**
A) Tell Claude: "push and create a PR"
B) Run `git push` then `gh pr create` manually
C) Go to GitHub and click "New Pull Request"

Answer: A - Claude handles the entire flow: push + PR creation with proper description.

**Q3: Claude Code never does which of the following by default?**
A) Read your git history
B) Force push to a branch
C) Create new branches

Answer: B - Force push is destructive and Claude never does it unless you explicitly ask.

---

## What's Next

Git mastered. In **Module 5: Advanced Tools**, you'll discover agents, plan mode, and MCP servers - the features that make Claude Code truly powerful.
