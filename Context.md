# Claude Assistant — Project Context Dump

> Handoff document for Claude Code. Read this fully before doing anything.

---

## What This Project Is

A one-command installer (`install.sh`) that turns a bare Ubuntu VPS into a 24/7 personal AI assistant powered by Claude Code, accessible via Telegram. The user texts it like a person. It remembers everything, runs tasks, sends a morning news brief, creates scheduled jobs proactively, and does browser automation.

**One-liner install:**

```bash
curl -sSL https://raw.githubusercontent.com/YOURNAME/claude-assistant/main/install.sh | bash
```

By the end the user texts their bot "hello" and gets a reply.

---

## Files in This Project

```
install.sh     ← the one-click installer (1000+ lines)
README.md      ← GitHub readme
```

Both files are complete and ready. The next task is pushing to GitHub.

---

## Stack

| Component                        | Role                                                       |
| -------------------------------- | ---------------------------------------------------------- |
| Claude Code                      | The AI brain                                               |
| RichardAtCT/claude-code-telegram | Telegram bot interface                                     |
| Patchright                       | Browser automation (anti-detection Playwright replacement) |
| PM2                              | Process management + auto-restart on reboot                |
| SQLite (`conversations.db`)      | Conversation history                                       |
| UFW                              | Firewall                                                   |
| Ubuntu (20.04+)                  | VPS OS                                                     |

---

## Architecture — How It All Works

### Normal conversation flow:

```
User texts Telegram
  → Telegram bot (PM2, always running) receives it
  → Bot passes message + conversation history to Claude Code
  → Claude thinks, does work, produces output text
  → Bot sends that output back to Telegram
  → User sees reply
```

Claude never touches Telegram directly. It just produces text. The bot handles all delivery.

### Scheduled jobs (cron):

```
OS scheduler fires at set time
  → Runs .sh script from ~/.claude/scheduler/
  → Script calls Claude Code, captures output
  → Script sends output to Telegram via curl (direct Telegram Bot API)
  → Output also logged to conversations.db so replies continue the conversation
```

Key rule: **all scripts run from `~/agent/` always**. Never change directory. This is how conversation context stays consistent — the bot and cron scripts all operate from the same directory, so conversations.db links up.

### Why conversations.db matters:

When a cron job sends the morning brief and the user replies "expand on point 2", the bot loads `~/agent/` conversation history from conversations.db, sees the morning brief that was sent, and Claude picks up the thread. No broken context.

---

## File Structure Created on VPS

```
~/.claude/
  CLAUDE.md          ← operational rulebook (read on every startup)
  SOUL.md            ← agent personality and identity
  USER.md            ← user profile, interests, timezone, preferences
  MEMORY.md          ← long-term memory, auto-updated by Claude
  CRON.md            ← scheduler rules, script templates, how to add jobs
  settings.json      ← model + permission config
  .env               ← credentials (chmod 600) — API key, Telegram tokens
  /sessions/         ← browser sessions (gmail.json, twitter.json etc.) chmod 700
  /skills/           ← skill files, including find-skills + skill-creator
  /scheduler/
    morning_brief.sh ← 8am daily AI task
    auth_reminder.sh ← 25th monthly simple curl reminder

~/agent/             ← working directory — everything runs from here
~/telegram-bot/      ← RichardAtCT/claude-code-telegram bot code
~/venv/              ← Python venv for Patchright
```

---

## What the Installer Does (Step by Step)

**Onboarding — collects upfront:**

1. Auth method: API key (recommended, never expires) or Claude.ai subscription (expires 30 days)
2. If API key: collects it now
3. Telegram Bot Token (from @BotFather)
4. Telegram User ID (from @userinfobot)
5. Agent name (e.g. Nova, Rex)
6. User's name, timezone, location
7. User's interests (for morning brief)
8. Permission level: Full auto (dangerouslySkipPermissions: true) OR Telegram approvals
9. Model: Sonnet 4.6 (recommended), Opus 4.6, or Haiku 4.5

**Installation steps:**

1. System update + dependencies
2. Create `agent` user (non-root), set AGENT_HOME=/home/agent
3. Node.js + Claude Code + PM2 (installed as root, run as agent)
4. Python venv + Patchright + Chromium
5. Clone RichardAtCT/claude-code-telegram, install dependencies, write .env
6. Create all workspace files (CLAUDE.md, SOUL.md, USER.md, MEMORY.md, CRON.md, settings.json, .env)
7. Install meta-skills: `npx skillsadd vercel-labs/skills/find-skills` and `npx skillsadd anthropics/skills/skill-creator`
8. Create scheduler folder + morning_brief.sh + auth_reminder.sh
9. UFW firewall (SSH only)
10. chmod 600 .env, chmod 700 sessions/
11. Set crontab for agent user (8am brief, 25th auth reminder)
12. chown -R agent:agent everything
13. Authenticate Claude Code (API key → credentials.json, or subscription → claude auth login flow)
14. Start Telegram bot via PM2 as agent user
15. PM2 startup hook so bot survives reboots
16. Live test: user texts "hello", confirms reply

---

## Workspace Files — What They Do

**CLAUDE.md** — read by Claude Code on every single session startup. Contains:

- Startup sequence (read SOUL → USER → MEMORY → CRON before responding)
- Identity rules
- Memory rules (update MEMORY.md proactively)
- Conversation history (query conversations.db before saying "I don't remember")
- Web search vs Patchright decision rules
- Directory rules (always ~/agent/, never change)
- How Telegram works (Claude produces text, bot/script delivers it)
- Scheduler reference (points to CRON.md)
- Skills rules (find-skills, skill-creator behaviour)
- Security rules

**SOUL.md** — agent identity. Name, personality, tone. Makes it feel like a real assistant not a robot. "On it." not "That's a great question!"

**USER.md** — user profile. Name, timezone, location, businesses, accounts, interests, communication preferences, working hours.

**MEMORY.md** — long-term memory. Auto-updated by Claude whenever something important is said/decided/learned. Distilled, not dumped. Survives context resets.

**CRON.md** — full scheduler documentation. Two script types with templates, how to add new jobs, cron syntax reference. Claude reads this to know how to proactively create scheduled jobs.

**settings.json** — Claude Code config. Contains chosen model and permission level. Written during install based on user's choices.

---

## Scheduler — Key Details

All scripts in `~/.claude/scheduler/`. All run from `~/agent/`. All log to conversations.db.

**Two types:**

Type 1 — Simple reminder (no Claude):

```bash
#!/bin/bash
source ~/.claude/.env
AGENT_DIR="/home/agent/agent"
DB="/home/agent/.claude/conversations.db"
cd "$AGENT_DIR"
MSG="Your message"
curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
  -d chat_id="${TELEGRAM_USER_ID}" -d text="$MSG"
sqlite3 "$DB" "INSERT INTO messages (role,content,directory,timestamp) VALUES ('assistant','$MSG','$AGENT_DIR',datetime('now'));"
```

Type 2 — AI task:

```bash
#!/bin/bash
source ~/.claude/.env
AGENT_DIR="/home/agent/agent"
DB="/home/agent/.claude/conversations.db"
cd "$AGENT_DIR"
OUTPUT=$(claude --print "Your prompt" --dangerously-skip-permissions)
curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
  -d chat_id="${TELEGRAM_USER_ID}" -d text="$OUTPUT" -d parse_mode="Markdown"
ESCAPED=$(echo "$OUTPUT" | sed "s/'/''/g")
sqlite3 "$DB" "INSERT INTO messages (role,content,directory,timestamp) VALUES ('assistant','$ESCAPED','$AGENT_DIR',datetime('now'));"
```

Claude should create new scheduled jobs proactively — when user implies a recurring task, just do it without being asked.

---

## Skills System

- `~/.claude/skills/` — skill files live here
- Two meta-skills pre-installed:
  - **find-skills** (`vercel-labs/skills`) — searches skills.sh when a capability is needed
  - **skill-creator** (`anthropics/skills`) — packages good behaviour into reusable skills
- Public skill directory: https://skills.sh
- Install: `npx skillsadd owner/repo/skill-name`
- Claude should proactively suggest creating a skill when it handles something especially well
- When user says "remember that" or "that was perfect" → run skill-creator

---

## Security — What's Implemented

| Feature             | Status | How                                                   |
| ------------------- | ------ | ----------------------------------------------------- |
| Firewall            | ✅     | UFW, SSH only                                         |
| Telegram whitelist  | ✅     | ALLOWED_USERS in bot .env                             |
| .env credentials    | ✅     | ~/.claude/.env                                        |
| chmod 600 .env      | ✅     | Applied during install                                |
| chmod 700 sessions/ | ✅     | Applied during install                                |
| Non-root agent user | ✅     | Everything runs as `agent`                            |
| SSH keys only       | ❌     | Disabled — too risky to automate, do manually         |
| Auto updates        | ❌     | Disabled — do manually with apt update && apt upgrade |

---

## Models Available

| Model      | API string                  | Cost         | Notes                      |
| ---------- | --------------------------- | ------------ | -------------------------- |
| Sonnet 4.6 | `claude-sonnet-4-6`         | $3/$15 per M | Recommended default        |
| Opus 4.6   | `claude-opus-4-6`           | $5/$25 per M | Best reasoning, 1M context |
| Haiku 4.5  | `claude-haiku-4-5-20251001` | $1/$5 per M  | Fastest, cheapest          |

Chosen during onboarding. Written into settings.json and telegram-bot .env.

---

## Permission Levels

| Level              | settings.json                                                  | Behaviour                             |
| ------------------ | -------------------------------------------------------------- | ------------------------------------- |
| Full auto          | `dangerouslySkipPermissions: true` + all tools allowed         | Runs everything without asking        |
| Telegram approvals | `dangerouslySkipPermissions: false` + read/search pre-approved | Bot asks user before running commands |

---

## Auth Methods

**API key (recommended):**

- Never expires
- Written to `~/.config/claude/credentials.json`
- Set as `ANTHROPIC_API_KEY` env var
- Works headlessly forever

**Claude.ai subscription:**

- Run `claude auth login`
- Opens URL, user logs in on phone/laptop, pastes code back
- Expires every 30 days
- auth_reminder.sh sends Telegram message on 25th of each month

---

## Telegram Bot (.env)

```
TELEGRAM_BOT_TOKEN=...
TELEGRAM_BOT_USERNAME=[AGENT_NAME]
ALLOWED_USERS=[TELEGRAM_USER_ID]
APPROVED_DIRECTORY=/home/agent/agent
ANTHROPIC_API_KEY=...
ANTHROPIC_MODEL=[claude-sonnet-4-6 or chosen model]
USE_SDK=true
ENABLE_FILE_UPLOADS=true
ENABLE_GIT_INTEGRATION=true
```

---

## PM2

Bot runs as `agent` user via PM2. Startup hook ensures it survives reboots.

```bash
pm2 list                        # check status
pm2 logs telegram-bot           # live logs
pm2 restart telegram-bot        # restart
pm2 startup systemd             # regenerate startup hook if needed
pm2 save                        # save process list
```

---

## Crontab (installed for agent user)

```
0 8 * * *    /home/agent/.claude/scheduler/morning_brief.sh
0 9 25 * *   /home/agent/.claude/scheduler/auth_reminder.sh
```

View: `crontab -u agent -l`
Logs: `tail -f /var/log/agent-cron.log`

---

## What Still Needs Doing

1. **Push to GitHub** — user needs to create repo and push install.sh + README.md
2. **Update install URL** — replace `YOURNAME` in README one-liner with actual GitHub username
3. **Fill in USER.md** — businesses, accounts, priorities sections are placeholders
4. **Set up browser sessions** — log into Gmail/Twitter etc. and save session files to ~/.claude/sessions/
5. **Add personal skills** — create skill files for the user's specific domains

---

## Key Decisions Made in This Conversation

- Use RichardAtCT/claude-code-telegram (not OpenClaw/ClaudeBot) — has file uploads, git integration, approval flow
- All cron scripts run from `~/agent/` (not a separate cron directory) — keeps conversations.db context unified
- Only one pre-built scheduler script (morning_brief.sh) — user creates others proactively via Claude
- Auth reminder is a simple curl script, not an AI task — no Claude needed for a fixed message
- SSH hardening disabled from installer — too risky, do manually
- Auto-updates disabled from installer — do manually
- Two meta-skills pre-installed: find-skills + skill-creator
- Model and permission level chosen during onboarding, baked into settings.json
- Agent user created and everything chown'd to it — bot and cron run as agent, never root
- CRON.md is a separate file from CLAUDE.md — keeps operational rules clean
- CLAUDE.md startup sequence: SOUL → USER → MEMORY → CRON (reads all four before responding)
