# Module 2: Files & Code

## What You'll Learn
- How Claude Code reads, writes, and edits files
- Finding files and searching code efficiently
- When to use which tool
- Navigating a codebase like a pro

## The File Tools

Claude Code has dedicated tools for file operations. These are better than bash commands because they're safer, show you what's happening, and are optimized for the task.

### Read - View file contents
- Reads any file: code, images, PDFs, Jupyter notebooks
- Shows line numbers for easy reference
- Can read specific line ranges for large files

When you say: "show me src/index.ts" → Claude uses **Read**

### Write - Create new files
- Creates a file with the content you specify
- Overwrites if the file already exists
- Use this for brand new files

When you say: "create a new utils.ts file with a slugify function" → Claude uses **Write**

### Edit - Modify existing files
- Makes targeted changes to existing files
- Only sends the diff (what changed), not the whole file
- Safer than Write for modifications - less risk of losing content

When you say: "rename the function from getData to fetchUserData" → Claude uses **Edit**

### The Golden Rule
- **New file?** → Write
- **Change existing file?** → Edit (preferred) or Write (for complete rewrites)
- **Just looking?** → Read

## Searching Your Codebase

### Glob - Find files by name/pattern
Think of it as a smart "find" command.

Examples of what you can ask:
- "Find all TypeScript files in the src folder" → `**/*.ts`
- "Where is the package.json?" → `**/package.json`
- "Find all test files" → `**/*.test.*` or `**/*.spec.*`

### Grep - Search file contents
Think of it as a supercharged "grep" across your entire project.

Examples of what you can ask:
- "Find where the function handleLogin is defined"
- "Search for all TODO comments in the project"
- "Find every file that imports from @auth/core"

### Glob vs Grep
- **Know the filename?** → Glob (fast file pattern matching)
- **Know what's inside?** → Grep (content search)
- **Not sure?** → Just describe what you're looking for, Claude picks the right tool

## Pro Tips

### Let Claude explore first
For complex tasks, let Claude understand the codebase:
"Look at the project structure and tell me how authentication works"

This is way more effective than trying to point Claude at specific files when you're not sure where things are.

### Be specific about changes
Instead of: "update the API"
Say: "in src/api/users.ts, add a new endpoint GET /api/users/:id/profile that returns the user's profile data"

### Reference line numbers
When you see something in the output, you can reference it:
"On line 42 of that file, change the timeout from 5000 to 10000"

---

## Exercise

Let's practice with a real codebase exploration. Ask Claude Code:

1. **Find files**: "What's the structure of this project? Show me the top-level files and folders."
2. **Search content**: "Find all files that contain the word 'TODO' in this project."
3. **Read + Understand**: Pick any interesting file from the results and ask: "Read [filename] and explain what it does."

If you're in an empty project, that's okay! Ask Claude Code to create a small demo file and then practice reading and editing it.

---

## Quick Quiz

**Q1: You want to rename a variable in an existing file. Which tool should Claude use?**
A) Write
B) Read
C) Edit

Answer: C - Edit makes targeted changes to existing files, which is perfect for renaming.

**Q2: You need to find all files that import React. What's the best approach?**
A) Grep for `import.*React` or `from 'react'`
B) Read every file one by one
C) Glob for `*.jsx` files

Answer: A - Grep searches inside files, so it finds exactly what imports React regardless of file extension.

**Q3: When should you prefer Edit over Write for an existing file?**
A) Only for very small files
B) Never, Write is always better
C) When making targeted changes (rename, add a function, fix a line)

Answer: C - Edit only sends the diff, making it safer and more efficient for modifications.

---

## What's Next

You can now navigate code like a pro. In **Module 3: Bash Essentials**, you'll learn the terminal commands that every developer should know - they'll make you faster whether you're using Claude Code or not.
