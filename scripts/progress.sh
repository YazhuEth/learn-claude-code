#!/bin/bash
# Learn Claude Code - Progress Tracker
# Usage: progress.sh [read|complete <module_number>|reset]

PROGRESS_FILE="$HOME/.claude/cc-learn-progress.md"

MODULES=(
  "Module 1: The Basics"
  "Module 2: Files & Code"
  "Module 3: Bash Essentials"
  "Module 4: Git Workflow"
  "Module 5: Advanced Tools"
  "Module 6: Customization"
  "Module 7: Power User"
)

init_progress() {
  mkdir -p "$(dirname "$PROGRESS_FILE")"
  cat > "$PROGRESS_FILE" << 'EOF'
# Learn Claude Code — Progress

- [ ] Module 1: The Basics
- [ ] Module 2: Files & Code
- [ ] Module 3: Bash Essentials
- [ ] Module 4: Git Workflow
- [ ] Module 5: Advanced Tools
- [ ] Module 6: Customization
- [ ] Module 7: Power User
EOF
  echo "Progress initialized."
}

read_progress() {
  if [ ! -f "$PROGRESS_FILE" ]; then
    init_progress
  fi
  cat "$PROGRESS_FILE"
}

complete_module() {
  local module_num=$1
  if [ -z "$module_num" ] || [ "$module_num" -lt 1 ] || [ "$module_num" -gt 7 ]; then
    echo "Error: module number must be between 1 and 7"
    exit 1
  fi

  if [ ! -f "$PROGRESS_FILE" ]; then
    init_progress
  fi

  local module_name="${MODULES[$((module_num - 1))]}"
  sed -i '' "s/- \[ \] ${module_name}/- [x] ${module_name}/" "$PROGRESS_FILE"
  echo "Completed: ${module_name}"
}

reset_progress() {
  init_progress
  echo "Progress reset."
}

case "${1:-read}" in
  read)
    read_progress
    ;;
  complete)
    complete_module "$2"
    ;;
  reset)
    reset_progress
    ;;
  *)
    echo "Usage: progress.sh [read|complete <1-7>|reset]"
    exit 1
    ;;
esac
