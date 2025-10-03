#!/bin/bash
###
### Claude Feedback System - Installation Script
### https://github.com/phj1120/claude-feedback-system
###

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Claude Feedback System Installer            ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════╝${NC}"
echo ""

# Detect OS
OS="$(uname -s)"
case "$OS" in
    Linux*)     MACHINE=Linux;;
    Darwin*)    MACHINE=Mac;;
    CYGWIN*|MINGW*|MSYS*) MACHINE=Windows;;
    *)          MACHINE="UNKNOWN:${OS}"
esac

echo -e "${BLUE}🖥️  Detected OS: ${MACHINE}${NC}"
echo ""

# Claude directory setup
CLAUDE_DIR="$HOME/.claude"
HOOKS_DIR="$CLAUDE_DIR/hooks"
LOGS_DIR="$CLAUDE_DIR/logs"
TEMP_DIR="$CLAUDE_DIR/temp"

# Check if Claude Code is installed
if [ ! -d "$CLAUDE_DIR" ]; then
    echo -e "${YELLOW}⚠️  Warning: ~/.claude directory not found.${NC}"
    echo -e "${YELLOW}   This might mean Claude Code is not installed yet.${NC}"
    echo -e "${YELLOW}   Creating directory anyway...${NC}"
    echo ""
fi

# Create directories
echo -e "${BLUE}📁 Creating directories...${NC}"
mkdir -p "$HOOKS_DIR"
mkdir -p "$LOGS_DIR"
mkdir -p "$TEMP_DIR"
echo -e "${GREEN}✓ Directories created${NC}"
echo ""

# GitHub raw content base URL
GITHUB_RAW_URL="https://raw.githubusercontent.com/phj1120/claude-feedback-system/main/hooks"

# Download files
echo -e "${BLUE}⬇️  Downloading hook files...${NC}"

FILES=(
    "csv-updater.py"
    "user-prompt-submit"
    "stop"
    "stop-parse-transcript.py"
)

for file in "${FILES[@]}"; do
    echo -e "${BLUE}   Downloading ${file}...${NC}"
    if curl -fsSL "${GITHUB_RAW_URL}/${file}" -o "${HOOKS_DIR}/${file}"; then
        echo -e "${GREEN}   ✓ ${file}${NC}"
    else
        echo -e "${RED}   ✗ Failed to download ${file}${NC}"
        exit 1
    fi
done

echo ""

# Set permissions
echo -e "${BLUE}🔐 Setting permissions...${NC}"
chmod +x "$HOOKS_DIR"/*.py 2>/dev/null || true
chmod +x "$HOOKS_DIR"/user-prompt-submit
chmod +x "$HOOKS_DIR"/stop
echo -e "${GREEN}✓ Permissions set${NC}"
echo ""

# Check for existing settings.json
SETTINGS_FILE="$CLAUDE_DIR/settings.json"
if [ ! -f "$SETTINGS_FILE" ]; then
    echo -e "${BLUE}⚙️  Creating settings.json...${NC}"
    cat > "$SETTINGS_FILE" << 'EOF'
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/user-prompt-submit"
          }
        ]
      }
    ],
    "Stop": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/stop"
          }
        ]
      }
    ]
  }
}
EOF
    echo -e "${GREEN}✓ settings.json created${NC}"
else
    echo -e "${YELLOW}⚠️  settings.json already exists${NC}"
    echo -e "${YELLOW}   Please manually add hooks configuration:${NC}"
    echo -e ""
    echo -e "   UserPromptSubmit: ~/.claude/hooks/user-prompt-submit"
    echo -e "   Stop: ~/.claude/hooks/stop"
fi

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   ✨ Installation Complete! ✨                 ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}📊 Conversation logs will be saved to:${NC}"
echo -e "   ${LOGS_DIR}/claude-conversations.csv"
echo ""
echo -e "${BLUE}💡 How to use:${NC}"
echo -e "   1. Use Claude Code as usual"
echo -e "   2. After each response, type 1-5 to rate satisfaction"
echo -e "      [1] ⭐ Very Bad"
echo -e "      [2] ⭐⭐ Bad"
echo -e "      [3] ⭐⭐⭐ Okay"
echo -e "      [4] ⭐⭐⭐⭐ Good"
echo -e "      [5] ⭐⭐⭐⭐⭐ Excellent"
echo -e "   3. Check your CSV file for conversation history"
echo ""
echo -e "${BLUE}🔗 For more information:${NC}"
echo -e "   https://github.com/phj1120/claude-feedback-system"
echo ""
