# Module 3: Bash Essentials

## What You'll Learn
- Essential terminal commands every developer needs
- Navigating the filesystem
- Pipes and redirections
- Process management
- Environment variables

## Why Bash Matters

Even with Claude Code doing heavy lifting, knowing bash makes you 10x more effective:
- You understand what Claude is doing when it runs commands
- You can give better instructions ("pipe the output through sort and uniq")
- Some things are just faster to do yourself in the terminal

## Filesystem Navigation

| Command | What it does | Example |
|---------|-------------|---------|
| `pwd` | Print current directory | `pwd` → `/Users/you/project` |
| `ls` | List files | `ls -la` (detailed + hidden files) |
| `cd` | Change directory | `cd src/components` |
| `cd ..` | Go up one level | `cd ../..` (up two levels) |
| `cd ~` | Go to home directory | `cd ~/Documents` |
| `mkdir` | Create directory | `mkdir -p src/utils` (-p creates parents) |
| `touch` | Create empty file | `touch README.md` |

### Quick tips
- `cd -` takes you back to the previous directory
- `ls -la` shows everything including hidden files (dotfiles)
- Tab completion works! Type the first few letters and press Tab

## File Operations

| Command | What it does | Example |
|---------|-------------|---------|
| `cp` | Copy file/dir | `cp file.txt backup.txt` |
| `cp -r` | Copy directory recursively | `cp -r src/ src-backup/` |
| `mv` | Move or rename | `mv old.js new.js` |
| `rm` | Delete file | `rm temp.txt` |
| `rm -rf` | Delete directory (careful!) | `rm -rf node_modules` |
| `cat` | Display file content | `cat package.json` |
| `head` | First N lines | `head -20 README.md` |
| `tail` | Last N lines | `tail -f logs/app.log` (-f = follow) |
| `wc` | Count lines/words | `wc -l src/*.ts` (count lines) |

### Warning
`rm -rf` is permanent. There's no trash can. Double check before you run it.

## Pipes & Redirections

Pipes (`|`) connect the output of one command to the input of another. This is one of the most powerful bash concepts.

```bash
# Count how many .ts files you have
find . -name "*.ts" | wc -l

# Find unique error types in a log
cat app.log | grep "ERROR" | sort | uniq -c | sort -rn

# List the 10 largest files
du -sh * | sort -rh | head -10
```

### Redirections

| Symbol | What it does | Example |
|--------|-------------|---------|
| `>` | Write output to file (overwrite) | `echo "hello" > file.txt` |
| `>>` | Append output to file | `echo "world" >> file.txt` |
| `2>` | Redirect errors | `command 2> errors.log` |
| `2>&1` | Redirect errors to stdout | `command > all.log 2>&1` |

## Searching & Filtering

| Command | What it does | Example |
|---------|-------------|---------|
| `grep` | Search text in files | `grep -r "TODO" src/` |
| `find` | Find files | `find . -name "*.test.ts"` |
| `which` | Find command location | `which node` |
| `sort` | Sort lines | `sort names.txt` |
| `uniq` | Remove duplicates (sorted input) | `sort data.txt \| uniq` |
| `xargs` | Build commands from input | `find . -name "*.tmp" \| xargs rm` |

Note: In Claude Code, prefer using **Grep** and **Glob** tools instead of `grep` and `find` commands. They're optimized and safer. But knowing the bash versions helps you understand what's happening.

## Process Management

| Command | What it does | Example |
|---------|-------------|---------|
| `ps aux` | List all processes | `ps aux \| grep node` |
| `kill` | Stop a process | `kill 12345` (by PID) |
| `kill -9` | Force kill | `kill -9 12345` |
| `top` / `htop` | Live process monitor | `top` (press q to quit) |
| `lsof -i :3000` | What's using port 3000? | `lsof -i :8080` |

### Common scenario
"My dev server won't start because port 3000 is busy"
```bash
lsof -i :3000          # Find the PID
kill -9 <PID>          # Kill it
```

## Environment & Variables

```bash
# See all environment variables
env

# See a specific one
echo $PATH
echo $HOME

# Set a variable (current session only)
export API_KEY="abc123"

# See your shell config
cat ~/.zshrc    # or ~/.bashrc
```

### The PATH variable
PATH is a list of directories where your shell looks for commands. When you type `node`, it searches each PATH directory until it finds it.

```bash
echo $PATH    # Shows all directories, separated by :
which node    # Shows which directory 'node' was found in
```

## Permissions

```bash
# View permissions
ls -la

# Output looks like: -rwxr-xr-- 1 user group 1234 Jan 1 00:00 file.sh
# r=read, w=write, x=execute
# First 3: owner | Next 3: group | Last 3: everyone

# Make a script executable
chmod +x script.sh

# Common permission numbers
chmod 755 script.sh   # owner=rwx, group=rx, others=rx
chmod 644 file.txt    # owner=rw, group=r, others=r
```

## Useful Combos

```bash
# Find and replace text across files
sed -i '' 's/oldtext/newtext/g' file.txt

# Check disk usage
df -h                  # Disk space
du -sh *              # Size of each item in current dir

# Download a file
curl -O https://example.com/file.zip

# Quick HTTP request
curl -s https://api.example.com/data | python3 -m json.tool

# Watch a command (re-run every 2s)
watch -n 2 'ls -la'
```

---

## Exercise

Try these commands right now (ask Claude Code to run them):

1. **Explore**: "Run `ls -la` in the current directory, then tell me what the biggest file is"
2. **Chain commands**: "Count how many lines of code are in all .md files in this project using `find` and `wc`"
3. **Environment**: "Show me what version of node, npm, and git I have installed"

---

## Quick Quiz

**Q1: What does `ls -la` show that `ls` doesn't?**
A) Hidden files (dotfiles) and detailed info (permissions, size, dates)
B) Files in all subdirectories
C) Only directories

Answer: A - The `-l` flag shows details, `-a` shows hidden files starting with `.`

**Q2: What does this command do: `cat log.txt | grep "ERROR" | wc -l`?**
A) Deletes error lines from log.txt
B) Shows all errors in the log
C) Counts the number of lines containing "ERROR" in log.txt

Answer: C - `cat` reads the file, `grep` filters for "ERROR" lines, `wc -l` counts them.

**Q3: Port 8080 is busy and you need to free it. What's the quickest approach?**
A) Restart the computer
B) `lsof -i :8080` to find the PID, then `kill <PID>`
C) `rm -rf /`

Answer: B - Find what's using the port, then kill that specific process.

---

## What's Next

Terminal skills unlocked. In **Module 4: Git Workflow**, you'll learn how Claude Code supercharges your git game - smart commits, PR workflows, and code reviews.
