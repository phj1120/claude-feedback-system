# 📊 Claude Feedback System

> Automatically track your Claude Code conversations and satisfaction ratings

A lightweight hook system for Claude Code that automatically logs all your prompts, responses, and satisfaction ratings to a CSV file - **without consuming tokens for feedback**.

## ✨ Features

- ✅ **Automatic Logging** - Every conversation is automatically saved
- ✅ **1-5 Star Ratings** - Quick satisfaction feedback after each response
- ✅ **Zero Token Usage** - Feedback doesn't consume Claude API tokens
- ✅ **CSV Export** - Easy data analysis with any spreadsheet tool
- ✅ **Human-Readable Timestamps** - `2025-10-02 23:42:01` format
- ✅ **Privacy First** - All data stays local on your machine

## 🚀 Quick Install

### One-Line Install (Recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/claude-feedback-system/main/install.sh | bash
```

### Manual Installation

1. **Download the repository:**
   ```bash
   git clone https://github.com/YOUR_USERNAME/claude-feedback-system.git
   cd claude-feedback-system
   ```

2. **Copy hook files:**
   ```bash
   mkdir -p ~/.claude/hooks
   mkdir -p ~/.claude/logs
   mkdir -p ~/.claude/temp
   cp hooks/* ~/.claude/hooks/
   chmod +x ~/.claude/hooks/*
   ```

3. **Configure Claude Code:**

   Add to `~/.claude/settings.json`:
   ```json
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
   ```

## 📖 How to Use

1. **Use Claude Code normally** - Just chat as you always do

2. **Rate your satisfaction** - After each response, simply type a number:
   - `1` ⭐ Very Bad
   - `2` ⭐⭐ Bad
   - `3` ⭐⭐⭐ Okay
   - `4` ⭐⭐⭐⭐ Good
   - `5` ⭐⭐⭐⭐⭐ Excellent

3. **Access your data** - Find your conversation history at:
   ```
   ~/.claude/logs/claude-conversations.csv
   ```

## 📊 CSV Format

The CSV file contains the following columns:

| Column | Description | Example |
|--------|-------------|---------|
| `id` | Unique ID (timestamp-based) | `20251002234219` |
| `request` | Your prompt | `"How do I...?"` |
| `response` | Claude's response | `"To do that, you..."` |
| `star` | Satisfaction rating (1-5) | `5` |
| `star_desc` | Optional feedback comment | `""` |
| `request_dtm` | Request timestamp | `2025-10-02 23:42:19` |
| `response_dtm` | Response timestamp | `2025-10-02 23:43:04` |
| `star_dtm` | Feedback timestamp | `2025-10-02 23:43:17` |

## 🔧 How It Works

This system uses Claude Code's [hook mechanism](https://docs.claude.com/en/docs/claude-code/hooks) to intercept conversation events:

```
┌─────────────────────────────────────────┐
│  Claude Code                            │
│                                         │
│  User Input → [UserPromptSubmit Hook]  │
│                    ↓                    │
│               Save to CSV               │
│                    ↓                    │
│              Claude Response            │
│                    ↓                    │
│            [Stop Hook]                  │
│                    ↓                    │
│          Update CSV + Show Rating UI    │
│                    ↓                    │
│        User Types 1-5 (Feedback)        │
│                    ↓                    │
│    [UserPromptSubmit Hook - Blocked]    │
│                    ↓                    │
│          Save Rating (No tokens!)       │
└─────────────────────────────────────────┘
```

## 🛠️ Files Structure

```
~/.claude/
├── hooks/
│   ├── csv-updater.py           # CSV management
│   ├── user-prompt-submit       # Captures prompts & feedback
│   ├── stop                     # Captures responses
│   └── stop-parse-transcript.py # Response parser
├── logs/
│   └── claude-conversations.csv # Your conversation data
└── temp/
    └── current-session.json     # Session tracking
```

## 🔍 Example Data

```csv
id,request,response,star,star_desc,request_dtm,response_dtm,star_dtm
20251002234729,가나다,"네, 듣고 있습니다. 무엇을 도와드릴까요?",5,,2025-10-02 23:47:29,2025-10-02 23:47:43,2025-10-02 23:47:45
```

## 🤔 FAQ

**Q: Does rating consume Claude API tokens?**
A: No! The feedback is blocked before reaching Claude, so it's completely free.

**Q: Can I use this with Claude Desktop?**
A: This is designed for Claude Code. For Claude Desktop, you'd need to adapt the hook configuration.

**Q: Where is my data stored?**
A: All data is stored locally in `~/.claude/logs/claude-conversations.csv`. Nothing is sent to external servers.

**Q: Can I disable the feedback prompts?**
A: Yes, simply remove the hooks from your `settings.json` or delete the hook files.

**Q: What if I accidentally type a number?**
A: Only standalone numbers 1-5 are treated as feedback. "I have 5 questions" won't trigger it.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📝 License

MIT License - see [LICENSE](LICENSE) for details

## 🙏 Acknowledgments

- Built for [Claude Code](https://claude.com/claude-code) by Anthropic
- Inspired by the need to track AI interaction quality

## 📬 Support

- 🐛 [Report a Bug](https://github.com/YOUR_USERNAME/claude-feedback-system/issues)
- 💡 [Request a Feature](https://github.com/YOUR_USERNAME/claude-feedback-system/issues)
- ⭐ [Star this repo](https://github.com/YOUR_USERNAME/claude-feedback-system) if you find it useful!

---

Made with ❤️ for the Claude Code community
