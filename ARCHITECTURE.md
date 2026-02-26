# Claude Assistant - System Architecture

## What It Is

Personal AI assistant running 24/7 on a VPS, accessible via Telegram.

---

## Key Design Decisions

| Decision | Why |
|----------|-----|
| **Camoufox over Patchright** | C++ level fingerprint spoofing bypasses Google/YouTube bot detection |
| **Split proxy format** | PROXY_SERVER/USER/PASS instead of single URL for proper auth |
| **force_new=True** | Each message starts fresh Claude session, history injected via hooks |
| **Never cd** | Always use absolute paths from /home/agent/agent/ |
| **Pending task file** | Survives bot restarts for multi-step operations |

---

## Core Components

```
┌─────────────────────────────────────────────────────────┐
│                      TELEGRAM                           │
│              (User sends message/voice/image)           │
└────────────────────────┬────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────┐
│                   TELEGRAM BOT                          │
│            /home/agent/telegram-bot/                    │
│  • Receives messages                                    │
│  • Handles voice → transcribes with faster-whisper      │
│  • Handles images → saves to /home/agent/agent/images/  │
│  • Passes text to Claude Code                           │
│  • Sends Claude's response back to Telegram             │
│  • Logs everything to bot.db                            │
└────────────────────────┬────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────┐
│                    CLAUDE CODE                          │
│             (runs from /home/agent/agent/)              │
│  • Reads identity files before every response           │
│  • Has web search, bash, file access                    │
│  • Uses Camoufox for browser automation                 │
│  • Updates MEMORY.md with important info                │
└─────────────────────────────────────────────────────────┘
```

---

## File Structure

```
/home/agent/
├── .claude/
│   ├── CLAUDE.md       ← Operational rules (read every message)
│   ├── SOUL.md         ← Agent personality & identity
│   ├── USER.md         ← Info about the user
│   ├── MEMORY.md       ← Long-term memory (auto-updated)
│   ├── CRON.md         ← How scheduled tasks work
│   ├── .env            ← Credentials (API keys, passwords)
│   ├── settings.json   ← Claude Code permissions
│   ├── sessions/       ← Browser login sessions (gmail.json, etc.)
│   └── scheduler/      ← Cron job scripts
│       ├── auth_reminder.sh
│       └── morning_brief.sh
│
├── agent/              ← Working directory (all tasks run here)
│   └── images/         ← Saved images from Telegram
│
├── telegram-bot/       ← The Telegram bot
│   ├── .env            ← Bot config (token, user ID)
│   ├── run_bot.py      ← Entry point (sends startup ping)
│   ├── data/
│   │   └── bot.db      ← All conversation history
│   └── src/
│       ├── main.py
│       ├── startup_hook.py
│       ├── voice_handler.py
│       └── bot/
│           ├── orchestrator.py
│           └── features/
│               ├── registry.py
│               ├── image_handler.py
│               └── voice_handler.py
│
└── venv/               ← Python venv with Camoufox
```

---

## Features

| Feature                  | How It Works                                                                        |
| ------------------------ | ----------------------------------------------------------------------------------- |
| **Text messages**        | User → Bot → Claude Code → Bot → User                                               |
| **Voice notes**          | User sends voice → Bot downloads → faster-whisper transcribes → Text sent to Claude |
| **Images**               | User sends image → Bot saves to /agent/images/ → Claude reads with Read tool        |
| **Restart notification** | Bot sends "🟢 Online" message on startup, logs to bot.db                            |
| **Conversation history** | All messages saved to bot.db, Claude queries it for context                         |
| **Browser automation**   | Camoufox (stealth Firefox) with proxy support, geoip, session persistence           |
| **Scheduled tasks**      | Cron runs scripts → Scripts call Claude or send direct messages → Log to bot.db     |
| **Memory**               | Claude updates MEMORY.md with important info automatically                          |

---

## Message Flow

1. User sends message to Telegram bot
2. Bot receives it via python-telegram-bot
3. If voice: transcribe with faster-whisper, convert to text
4. If image: save to disk, add "[Image saved to: path]" to message
5. Bot calls Claude Code with the message
6. Claude reads SOUL.md, USER.md, MEMORY.md, CRON.md (via hook)
7. Claude processes and responds
8. Bot sends response to Telegram
9. Both user message and response saved to bot.db

---

## Cron Jobs

- Run as `agent` user
- Scripts in `/home/agent/.claude/scheduler/`
- Two types:
  - **Simple reminder**: curl to Telegram, no Claude
  - **AI task**: Claude generates response, then curl to Telegram
- All output logged to bot.db for conversation continuity

---

## When Restarts Are Needed

| Change Type | Restart Required? |
|-------------|-------------------|
| Python bot code (orchestrator.py, facade.py) | Yes |
| CLAUDE.md, SOUL.md, USER.md, MEMORY.md | No (read fresh via hooks) |
| .env file changes | No (read fresh each message) |
| Claude Code updates | Yes (bot restart after update) |

---

## Pending Task Mechanism

For tasks that require a bot restart mid-way:

1. Claude saves task to `/home/agent/.claude/pending_task.md`
2. Bot restarts
3. On startup, `startup_hook.py` reads the file
4. Runs `claude --print "continue this task..."`
5. Sends result to Telegram
6. Deletes the file

Use case: "Update Claude Code then check what version" - Claude can update, restart, then continue.

---

## Permissions

- Everything owned by `agent` user
- Never runs as root
- Two modes:
  - **Full auto**: Claude runs everything without asking
  - **Telegram approvals**: Claude asks before running commands

---

## Security

| Layer                  | What It Does                                              |
| ---------------------- | --------------------------------------------------------- |
| **Firewall (UFW)**     | Blocks all incoming traffic except SSH (port 22)          |
| **User isolation**     | Everything runs as `agent` user, never root               |
| **Telegram whitelist** | Only your Telegram user ID can talk to the bot            |
| **Proxy support**      | Residential proxies for Camoufox with geoip alignment      |

### Protected Files (chmod 600/700 = only owner can read)

```
~/.claude/.env              # API keys, Telegram token, passwords
~/.claude/settings.json     # Claude Code config
~/.claude/sessions/         # Browser login cookies (gmail.json, twitter.json, etc.)
~/telegram-bot/.env         # Bot token and allowed users
```

### What Claude Never Does

- Expose credentials in responses
- Run as root
- Hardcode secrets in scripts
- Take irreversible actions without confirmation
- Share personal info with unauthorized users

---

## Browser Automation (Camoufox)

**Why Camoufox?** Camoufox is a stealth Firefox fork with C++ level fingerprint spoofing. Unlike Patchright (JS patches), Camoufox bypasses bot detection on Google, YouTube, Gmail, and other strict sites.

**Key features:**
- **geoip=True** — aligns browser timezone/locale with proxy location
- **BrowserForge** — realistic fingerprint rotation
- **Playwright-compatible API** — same methods as Playwright/Patchright

### Setup

```
/home/agent/venv/             ← Camoufox venv (separate from bot's Poetry venv)
/home/agent/.claude/sessions/ ← Saved cookies (gmail.json, twitter.json, google.json, etc.)
/home/agent/.claude/.env      ← Proxy credentials (PROXY_SERVER, PROXY_USER, PROXY_PASS)
```

### Proxy Format

```bash
# In .env - split format for proper authentication
PROXY_SERVER=http://isp.provider.com:10001
PROXY_USER=your-username
PROXY_PASS=your-password
```

### Running Scripts

```bash
# Always use the Camoufox venv
/home/agent/venv/bin/python3 /home/agent/agent/my-script.py
```

---

## Communication Style

Claude is configured to give clean, human-readable responses:

**Bad:** "I've set up a cron job at 00:20 that will execute a bash script..."
**Good:** "Done. I'll message you at 00:20."

No technical jargon, no file paths, no explaining the process. Just results.
