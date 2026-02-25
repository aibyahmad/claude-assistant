# Claude Assistant

> Your personal AI assistant. Runs 24/7 on a VPS. Text it from anywhere via Telegram.

![Claude Assistant](https://img.shields.io/badge/Claude-Assistant-blue?style=flat-square)
![License](https://img.shields.io/badge/license-MIT-green?style=flat-square)
![Platform](https://img.shields.io/badge/platform-Ubuntu-orange?style=flat-square)

_Want to make your first $10k/month with AI skills like this? → <a href="https://www.fixeonai.com/ai-income-accelerator" target="_blank">AI Income Accelerator</a>_

---

## What Is This?

Claude Assistant is a one-command installer that turns a bare VPS into a fully configured personal AI assistant powered by Claude Code, accessible 24/7 via Telegram.

Text it like a person. It remembers everything. It runs tasks while you sleep.

---

## What You Get

- **Telegram interface** — text your assistant from anywhere, on any device, 24/7
- **Custom identity** — your assistant has a name, personality, and tone defined by you. Not a generic bot.
- **Persistent memory** — MEMORY.md auto-updated across every session. It never forgets what matters.
- **Full conversation history** — every message logged to SQLite. Claude queries it before ever saying "I don't remember."
- **Morning brief** — personalised daily news based on your interests and location, sent at 8am
- **Proactive scheduling** — mention a recurring task or reminder once, it creates the script and schedules it automatically
- **Web search** — searches the web when it needs current information, knows when to use it vs browser automation
- **Browser automation** — logs into Gmail, Twitter, LinkedIn, and more on your behalf via Patchright (anti-detection)
- **Skills system** — install from [skills.sh](https://skills.sh) with one command, or write your own. The assistant applies relevant skills automatically.
- **File uploads** — send files via Telegram, Claude reads and works with them directly
- **Git integration** — built in, can manage repos from Telegram
- **Task execution** — runs bash commands, writes and debugs code, manages files, calls APIs
- **Model choice** — pick Sonnet 4.6, Opus 4.6, or Haiku 4.5 during setup
- **Permission control** — full auto mode or Telegram approval prompts, your choice

---

## One-Command Install

```bash
bash <(curl -sSL https://raw.githubusercontent.com/aibyahmad/claude-assistant/main/install.sh)
```

By the end of the installer, you will text your bot **hello** and get a reply.

---

## How It Works

```
You text Telegram
      ↓
Telegram bot receives it
      ↓
Bot passes it to Claude Code
      ↓
Claude thinks, does the work, produces output
      ↓
Bot sends that output back to you
```

For scheduled tasks (morning brief, reminders):

```
OS scheduler fires at set time
      ↓
Runs a .sh script in ~/.claude/scheduler/
      ↓
Script calls Claude, captures output
      ↓
Script sends directly to your Telegram via curl
      ↓
Your reply continues the conversation normally
```

Claude never touches Telegram directly. It just produces output. The bot or script handles delivery. All scheduled messages are logged to `conversations.db` so when you reply, Claude has full context.

---

## What the Installer Does

The installer walks you through everything interactively. No config files to edit manually.

**It asks you for:**

- Anthropic API key or Claude.ai subscription login
- Telegram Bot Token (from @BotFather)
- Your Telegram User ID (from @userinfobot)
- Your assistant's name, your name, timezone, location
- Your interests (used for the morning brief)
- Permission level — full auto or Telegram approvals
- Model — Sonnet 4.6, Opus 4.6, or Haiku 4.5

**It installs:**

- Node.js, Claude Code, PM2
- Python, Patchright, Chromium
- The Telegram bot (RichardAtCT/claude-code-telegram)
- UFW firewall (SSH only)

**It creates and configures:**

- `CLAUDE.md` — operational rulebook
- `SOUL.md` — assistant personality and identity
- `USER.md` — your profile, interests, preferences
- `MEMORY.md` — long-term memory, auto-updated
- `CRON.md` — scheduler rules and script templates
- `settings.json` — model and permission config
- `~/.claude/scheduler/` — all scheduled scripts live here
- Cron jobs wired to the scheduler scripts
- PM2 auto-restart on reboot

**It starts everything and tests it live.**

---

## Requirements

- Ubuntu 20.04+ VPS (DigitalOcean, Hetzner, Linode, etc.)
- Root or sudo access
- A Telegram account
- Either a Claude.ai subscription (Pro/Max/Team) or an Anthropic API key

---

## Models

| Model                          | Best For                                       | API Cost              |
| ------------------------------ | ---------------------------------------------- | --------------------- |
| **Sonnet 4.6** _(recommended)_ | Daily use, coding, general tasks               | $3 / $15 per M tokens |
| **Opus 4.6**                   | Complex reasoning, large codebases, 1M context | $5 / $25 per M tokens |
| **Haiku 4.5**                  | Fast tasks, high-volume, budget use            | $1 / $5 per M tokens  |

You choose during setup. Change it later: `nano ~/.claude/settings.json`

---

## Permission Levels

| Level                  | Behaviour                                                                  |
| ---------------------- | -------------------------------------------------------------------------- |
| **Full auto**          | Claude runs everything without asking. Best for power users.               |
| **Telegram approvals** | Claude asks you in Telegram before running commands. Best for most people. |

---

## File Structure

```
~/.claude/
  CLAUDE.md          ← operational rulebook
  SOUL.md            ← personality and identity
  USER.md            ← your profile, interests, preferences
  MEMORY.md          ← long-term memory, auto-updated
  CRON.md            ← scheduler rules and script templates
  settings.json      ← model + permission config
  .env               ← credentials (chmod 600)
  /sessions/         ← saved browser sessions (Gmail, Twitter, etc.)
  /skills/           ← specialised skill files
  /scheduler/
    morning_brief.sh ← 8am daily news brief
    auth_reminder.sh ← 25th monthly auth expiry reminder

~/agent/             ← working directory — everything runs from here
~/telegram-bot/      ← Telegram bot code
~/venv/              ← Python venv (Patchright)
```

---

## Morning Brief

Every day at **8:00am** your assistant searches the web for news relevant to your interests and location, picks the 3-5 most important stories, and sends a clean brief to your Telegram.

```
Good morning Alex. Here is your morning brief.

🔹 OpenAI releases new reasoning model
A new model outperforms o3 on math benchmarks.
Relevant to AI — could affect Claude's market position.

🔹 Bitcoin hits new ATH at $140k
Institutional demand drove the move overnight.
Relevant to crypto — watch for corrections in altcoins.

🔹 Arsenal go top of the Premier League
Won 2-1 away at Chelsea in a late comeback.
Relevant to football — title race is live.

Today is Wednesday, 25 February 2026.
```

---

## Scheduling

The assistant creates and manages scheduled jobs proactively. Just tell it what you want:

> _"Remind me every Monday to check invoices"_
> _"Prep me before my Thursday 3pm call with James"_
> _"Check my portfolio every morning and flag anything down more than 5%"_

It will write the script, drop it in `~/.claude/scheduler/`, add it to crontab, and tell you it's done. No asking. No waiting.

Two types of scheduled jobs:

- **Simple reminder** — fixed message, no Claude, just a curl to Telegram
- **AI task** — Claude does the work, captures output, sends to Telegram

All scripts run from `~/agent/` and log to `conversations.db` so replies continue the conversation normally.

---

## Useful Commands

```bash
pm2 list                        # check what's running
pm2 logs telegram-bot           # live bot logs
pm2 restart telegram-bot        # restart the bot
crontab -l                      # see scheduled jobs
tail -f /var/log/agent-cron.log # live cron logs
~/.claude/scheduler/morning_brief.sh  # test manually

nano ~/.claude/USER.md          # edit your profile
nano ~/.claude/SOUL.md          # edit personality
nano ~/.claude/settings.json    # change model or permissions
```

---

## Skills

Skills are instruction files that give your assistant specialised expertise. The assistant checks the skills folder before any specialised task and applies the relevant one automatically.

Two meta-skills come pre-installed:

**find-skills** — when the assistant needs a capability it doesn't have, it searches [skills.sh](https://skills.sh) automatically to find an existing skill rather than starting from scratch.

**skill-creator** — when you say "that was perfect" or "remember how you did that", the assistant packages that behaviour into a reusable skill and saves it permanently. It can also suggest doing this proactively when it handles something especially well.

**Install any skill from [skills.sh](https://skills.sh):**

```bash
npx skillsadd owner/repo/skill-name
```

**Or write your own** in `~/.claude/skills/`:

- `trading.md` — your strategy, exchanges, risk rules
- `content.md` — your brand voice, tone, audience
- `dev.md` — your stack, conventions, deployment process

Over time the skills folder grows to reflect exactly how you work. You never have to explain context twice.

---

## Re-authentication (Subscription Users)

Claude.ai subscription auth expires every 30 days. Your assistant messages you on the 25th of each month as a reminder.

```bash
ssh your-vps
claude auth login
```

API key users never need to re-authenticate.

---

## Security

All of these are configured automatically by the installer:

- **Firewall (UFW)** — blocks all incoming traffic except SSH
- **Telegram whitelist** — bot only responds to your Telegram user ID, ignores everyone else
- **.env file** — all credentials stored in `~/.claude/.env`, never hardcoded anywhere
- **File permissions** — `.env` and `/sessions/` set to `chmod 600`/`chmod 700`, only the agent user can read them
- **Non-root user** — everything runs as a dedicated `agent` user, never root

> **SSH keys** — disable password login manually once you've confirmed key-based access works. Too risky to automate.
> **Auto updates** — run `apt update && apt upgrade` regularly to patch security holes.

---

## Stack

| Component                                                                   | Role                                        |
| --------------------------------------------------------------------------- | ------------------------------------------- |
| [Claude Code](https://claude.ai/code)                                       | The AI brain                                |
| [claude-code-telegram](https://github.com/RichardAtCT/claude-code-telegram) | Telegram interface                          |
| [Patchright](https://github.com/Kaliiiiiiiiii-Vinyzu/patchright)            | Browser automation (anti-detection)         |
| PM2                                                                         | Process management + auto-restart on reboot |
| SQLite                                                                      | Conversation history across sessions        |
| UFW                                                                         | Firewall                                    |

---

## Want to monetize AI skills like this?

If you can build this, you can sell it. I teach you exactly how to package AI into offers, find clients, and hit $10k/month → <a href="https://www.fixeonai.com/ai-income-accelerator" target="_blank">AI Income Accelerator</a>

---

## License

MIT — use it, fork it, build on it.

---

_Built with Claude Code. Powered by Anthropic._
