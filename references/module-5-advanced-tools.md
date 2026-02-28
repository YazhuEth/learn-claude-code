# Module 5: Advanced Tools

## What You'll Learn
- Agents and subagents
- Plan Mode for complex tasks
- MCP Servers for external integrations
- Task management with TodoWrite

## Agents: Your AI Team

Agents are specialized sub-instances of Claude that handle specific tasks. Think of them as team members you can delegate to.

### Built-in Agent Types

| Agent | What it does | When to use |
|-------|-------------|-------------|
| **Explore** | Deep codebase exploration | "How does auth work in this project?" |
| **Plan** | Architecture and planning | "Design the implementation for feature X" |
| **websearch** | Web search | "What's the latest React Router API?" |
| **action** | Conditional task execution | Batch operations with conditions |

### How Agents Work
When you ask something complex, Claude can launch agents in the background:

1. You ask: "Find all API endpoints and document them"
2. Claude launches an Explore agent to scan the codebase
3. The agent searches through files, reads code, traces patterns
4. It returns findings to Claude
5. Claude presents the organized results to you

### Key Insight
Agents run **in parallel**. Claude can launch multiple agents at once for independent tasks. This makes complex operations much faster.

Example: "Review this PR for security issues, test coverage, and code quality"
→ Claude can launch 3 agents simultaneously, each focusing on one aspect.

## Plan Mode

Plan Mode lets Claude explore and design a solution BEFORE writing any code. This is crucial for complex tasks.

### When to Use Plan Mode
- New features that touch multiple files
- Refactoring or architectural changes
- When you're not sure about the approach
- When the task has multiple valid solutions

### How It Works
1. Claude enters plan mode (it might suggest this, or you can ask)
2. It explores the codebase (read-only, no modifications)
3. It writes a plan file with the proposed approach
4. You review and approve (or ask for changes)
5. Only then does Claude start implementing

### Pro tip
For anything non-trivial, say: "Plan this first before implementing."
This saves time and prevents wasted work.

## MCP Servers: External Integrations

MCP (Model Context Protocol) lets Claude Code connect to external tools and services.

### What MCP Can Do
- **Database tools** - Query PostgreSQL, MySQL directly
- **Browser automation** - Playwright for testing and scraping
- **Cloud services** - AWS, Supabase management
- **Design tools** - Figma, Pencil design files
- **Documentation** - Live docs from Context7
- **Communication** - Slack, GitHub integrations

### Checking Your MCP Servers
Type `/mcp` to see what's connected. Each MCP server provides tools that Claude can use.

### Example
If you have a database MCP server connected:
"Show me the schema of the users table"
→ Claude queries the database directly and shows you the schema.

## Task Management

For complex tasks, Claude uses **TodoWrite** to track progress:

```
Implementing dark mode

  [done] Analyze current theme system
  [done] Create theme context
  > Updating components to use theme    <-- in progress
    Add toggle switch to settings
    Run tests
```

This helps you:
- See what Claude is working on
- Track progress on multi-step tasks
- Know what's been completed and what's left

You don't need to ask for this - Claude creates todo lists automatically for complex tasks.

## WebSearch

Claude can search the web for current information:

- "What's the latest version of Next.js?"
- "How do I configure Tailwind v4?"
- "Find the docs for the Stripe API refund endpoint"

Results include source links so you can verify.

## Combining Tools

The real power comes from combining these features:

### Example workflow
"I need to add Stripe payments to this Next.js app"

1. Claude enters **Plan Mode** to explore your codebase
2. It uses **WebSearch** to check latest Stripe SDK docs
3. It creates a **Todo list** with implementation steps
4. It uses **Agents** to explore your existing payment code
5. It presents a plan for your approval
6. After approval, it implements step by step

---

## Exercise

Try one of these:

1. **Agent exploration**: "Explore this project and tell me the overall architecture - what frameworks are used, how is the code organized, and what are the main features?"
2. **Web search**: "Search the web for the latest Claude Code features released in 2025"
3. **Plan mode**: "I want to add a simple logging system to this project. Plan it first before implementing."

Pick whichever makes sense for your current project. If you're in an empty directory, option 2 works great.

---

## Quick Quiz

**Q1: What's the main benefit of Plan Mode?**
A) It lets you review and approve the approach before any code is written
B) It automatically writes tests
C) It makes Claude Code faster

Answer: A - Plan Mode separates planning from execution, so you can course-correct before any work is done.

**Q2: Agents can run in parallel. What does this mean practically?**
A) They use multiple computers
B) Claude can work on multiple independent tasks simultaneously, making complex operations faster
C) They conflict with each other

Answer: B - Parallel agents can explore different parts of a codebase or handle different aspects of a review at the same time.

**Q3: What command shows your connected MCP servers?**
A) `/servers`
B) `/tools`
C) `/mcp`

Answer: C - `/mcp` lists all connected MCP servers and their available tools.

## Keeping Claude Code Updated

Claude Code updates regularly with new features and fixes:

```bash
claude update
```

If something feels broken, try `/doctor` — it runs diagnostics and tells you what's wrong (auth issues, outdated version, config problems).

## Notifications

When Claude is working on a long task, it sends you a **notification** when it's done. This means you can:
- Switch to another terminal tab while Claude works
- Come back when you hear/see the notification
- Check the result

This works out of the box on macOS and most Linux desktop environments.

---

## What's Next

You're getting powerful. In **Module 6: Customization**, you'll learn how to make Claude Code truly yours - CLAUDE.md files, memory, hooks, and skills.
