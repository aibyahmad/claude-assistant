#!/bin/bash

# =============================================================================
# ONE-CLICK INSTALL — Claude Assistant
# =============================================================================
# Usage: bash <(curl -sSL https://raw.githubusercontent.com/aibyahmad/claude-assistant/main/install.sh)
# By the end of this script you will be texting your assistant and getting replies.
# =============================================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

log()     { echo -e "${GREEN}[✓]${NC} $1"; }
warn()    { echo -e "${YELLOW}[!]${NC} $1"; }
error()   { echo -e "${RED}[✗]${NC} $1"; exit 1; }
section() { echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n${BLUE}  $1${NC}\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"; }
ask()     { echo -e "${CYAN}[?]${NC} $1"; }
pause()   { echo -e "${YELLOW}[→]${NC} $1"; read -p "    Press ENTER when done... " _; }

clear
echo -e "${BLUE}${BOLD}"
echo ""
echo "   ██████╗██╗      █████╗ ██╗   ██╗██████╗ ███████╗"
echo "  ██╔════╝██║     ██╔══██╗██║   ██║██╔══██╗██╔════╝"
echo "  ██║     ██║     ███████║██║   ██║██║  ██║█████╗  "
echo "  ██║     ██║     ██╔══██║██║   ██║██║  ██║██╔══╝  "
echo "  ╚██████╗███████╗██║  ██║╚██████╔╝██████╔╝███████╗"
echo "   ╚═════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚══════╝"
echo ""
echo "   █████╗ ███████╗███████╗██╗███████╗████████╗ █████╗ ███╗   ██╗████████╗"
echo "  ██╔══██╗██╔════╝██╔════╝██║██╔════╝╚══██╔══╝██╔══██╗████╗  ██║╚══██╔══╝"
echo "  ███████║███████╗███████╗██║███████╗   ██║   ███████║██╔██╗ ██║   ██║   "
echo "  ██╔══██║╚════██║╚════██║██║╚════██║   ██║   ██╔══██║██║╚██╗██║   ██║   "
echo "  ██║  ██║███████║███████║██║███████║   ██║   ██║  ██║██║ ╚████║   ██║   "
echo "  ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝   "
echo ""
echo -e "${NC}"
echo -e "${BOLD}  Welcome.${NC}"
echo ""
echo -e "  You're about to set up your own personal AI assistant."
echo -e "  One that runs 24/7 on your server, never sleeps,"
echo -e "  and is always one Telegram message away."
echo ""
echo -e "  This isn't a chatbot. This is your assistant."
echo -e "  It knows who you are. It remembers everything."
echo -e "  It works while you sleep."
echo ""
echo -e "${BLUE}  ─────────────────────────────────────────────────${NC}"
echo ""
echo -e "  When we're done, you will have:"
echo ""
echo -e "  ${GREEN}✓${NC}  A personal AI assistant running 24/7"
echo -e "  ${GREEN}✓${NC}  Telegram as your interface — text it like a person"
echo -e "  ${GREEN}✓${NC}  Browser automation with persistent logins"
echo -e "  ${GREEN}✓${NC}  Scheduled tasks that run automatically"
echo -e "  ${GREEN}✓${NC}  Memory that carries across every conversation"
echo ""
echo -e "${BLUE}  ─────────────────────────────────────────────────${NC}"
echo ""
echo -e "  ${YELLOW}Takes about 10-15 minutes. Let's build it.${NC}"
echo ""
pause "Press ENTER to start"

# =============================================================================
# COLLECT INFO UPFRONT
# =============================================================================
section "Step 1 of 8 — Your Information"
echo ""
echo -e "Have these ready before continuing:"
echo -e "  ${BOLD}Telegram Bot Token${NC}  → message @BotFather on Telegram, send /newbot"
echo -e "  ${BOLD}Telegram User ID${NC}    → message @userinfobot on Telegram"
echo ""
pause "I have these ready"

# ── Anthropic login method ──
echo ""
echo -e "${CYAN}─── Claude Login ───${NC}"
echo ""
echo -e "How do you access Claude?"
echo -e "  ${BOLD}1)${NC} Claude.ai subscription (Pro / Max / Team)"
echo -e "  ${BOLD}2)${NC} Anthropic API key"
echo ""
ask "Enter 1 or 2:"
read -r AUTH_METHOD

ANTHROPIC_API_KEY=""

if [[ "$AUTH_METHOD" == "2" ]]; then
  echo ""
  echo -e "Get your API key at: ${BOLD}console.anthropic.com/settings/keys${NC}"
  echo ""
  ask "Paste your API key (starts with sk-ant-):"
  read -r ANTHROPIC_API_KEY
  while [[ ! "$ANTHROPIC_API_KEY" == sk-ant-* ]]; do
    warn "Should start with sk-ant- — try again"
    ask "API key:"
    read -r ANTHROPIC_API_KEY
  done
  log "API key saved"
else
  echo ""
  log "Using Claude.ai subscription — you will log in during Step 8"
  warn "Note: subscription auth expires every 30 days and requires re-login via SSH"
fi

echo ""
ask "Telegram Bot Token:"
read -r TELEGRAM_BOT_TOKEN
log "Bot token saved"

echo ""
echo -e "To get your Telegram User ID: message ${BOLD}@userinfobot${NC} on Telegram"
ask "Telegram User ID (numbers only):"
read -r TELEGRAM_USER_ID
log "User ID saved"

echo ""
ask "Name your assistant (e.g. Nova, Rex, Aria, Sage):"
read -r AGENT_NAME
log "Agent name: $AGENT_NAME"

ask "Your name (what the assistant calls you):"
read -r USER_NAME
log "Your name: $USER_NAME"

ask "Your timezone (e.g. GMT, EST, PST):"
read -r USER_TIMEZONE
log "Timezone: $USER_TIMEZONE"

ask "Your location (e.g. London UK):"
read -r USER_LOCATION
log "Location: $USER_LOCATION"

echo ""
echo -e "${CYAN}─── Morning Brief ───${NC}"
echo ""
echo -e "Every morning at ${BOLD}8:00am${NC} your assistant will send you a personalised"
echo -e "news brief based on your location and interests."
echo ""
ask "What are your interests? (e.g. tech, crypto, football, startups, AI, finance):"
read -r USER_INTERESTS
log "Interests: $USER_INTERESTS"

echo ""
echo -e "${CYAN}─── Permission Level ───${NC}"
echo ""
echo -e "How much control do you want over what your assistant does?"
echo ""
echo -e "  ${BOLD}1) Full auto${NC} — runs everything without asking"
echo -e "     Best for: power users who trust the bot fully"
echo ""
echo -e "  ${BOLD}2) Telegram approvals${NC} — asks you in Telegram before running commands"
echo -e "     Best for: most users — you stay in control"
echo ""
ask "Enter 1 or 2:"
read -r PERMISSION_LEVEL
while [[ "$PERMISSION_LEVEL" != "1" && "$PERMISSION_LEVEL" != "2" ]]; do
  warn "Please enter 1 or 2"
  ask "Enter 1 or 2:"
  read -r PERMISSION_LEVEL
done
if [[ "$PERMISSION_LEVEL" == "1" ]]; then
  log "Permission level: Full auto — no prompts"
else
  log "Permission level: Telegram approvals — you confirm commands"
fi

echo ""
echo -e "${CYAN}─── Model Selection ───${NC}"
echo ""
echo -e "Which Claude model should your assistant use?"
echo ""
echo -e "  ${BOLD}1) Sonnet 4.6${NC} — ${GREEN}Recommended${NC}"
echo -e "     Best for most people. Opus-level intelligence at Sonnet speed."
echo -e "     Fast, smart, handles 90%+ of tasks. \$3/\$15 per million tokens."
echo ""
echo -e "  ${BOLD}2) Opus 4.6${NC} — Maximum intelligence"
echo -e "     Deep reasoning, 1M context window, agent teams."
echo -e "     Best for complex tasks, large codebases. \$5/\$25 per million tokens."
echo ""
echo -e "  ${BOLD}3) Haiku 4.5${NC} — Fastest & cheapest"
echo -e "     Near-frontier speed. Best for quick tasks and high-volume use."
echo -e "     \$1/\$5 per million tokens."
echo ""
ask "Enter 1, 2 or 3 (default: 1):"
read -r MODEL_CHOICE
MODEL_CHOICE="${MODEL_CHOICE:-1}"

case "$MODEL_CHOICE" in
  2)
    CLAUDE_MODEL="claude-opus-4-6"
    MODEL_NAME="Opus 4.6"
    ;;
  3)
    CLAUDE_MODEL="claude-haiku-4-5-20251001"
    MODEL_NAME="Haiku 4.5"
    ;;
  *)
    CLAUDE_MODEL="claude-sonnet-4-6"
    MODEL_NAME="Sonnet 4.6"
    ;;
esac
log "Model: $MODEL_NAME"

echo ""
log "All information collected. Installing now..."
sleep 1

# =============================================================================
# STEP 2 — SYSTEM
# =============================================================================
section "Step 2 of 8 — System Setup"
apt-get update -qq && apt-get upgrade -y -qq
apt-get install -y -qq curl wget git sqlite3 ufw build-essential python3 python3-pip python3-venv
log "System updated"

if [ "$EUID" -eq 0 ]; then
  if ! id "agent" &>/dev/null; then
    useradd -m -s /bin/bash agent
    usermod -aG sudo agent
    log "Created user: agent"
  else
    log "User agent already exists"
  fi
  AGENT_HOME="/home/agent"
  AGENT_USER="agent"
  # All subsequent commands that should run as agent will use: su -c "..." agent
  # or have chown applied after
else
  AGENT_HOME="$HOME"
  AGENT_USER="$(whoami)"
  log "Running as: $AGENT_USER"
fi

# =============================================================================
# STEP 3 — NODE + CLAUDE CODE + PM2
# =============================================================================
section "Step 3 of 8 — Node.js + Claude Code + PM2"

if ! command -v node &>/dev/null; then
  curl -fsSL https://deb.nodesource.com/setup_20.x | bash - > /dev/null 2>&1
  apt-get install -y -qq nodejs
fi
log "Node.js: $(node --version)"

if ! command -v claude &>/dev/null; then
  npm install -g @anthropic-ai/claude-code --silent
fi
log "Claude Code installed"

if ! command -v pm2 &>/dev/null; then
  npm install -g pm2 --silent
fi
log "PM2 installed"

# =============================================================================
# STEP 4 — PYTHON + PATCHRIGHT
# =============================================================================
section "Step 4 of 8 — Patchright (browser automation)"

python3 -m venv "$AGENT_HOME/venv"
source "$AGENT_HOME/venv/bin/activate"
pip install -q patchright
python -m patchright install chromium
deactivate
log "Patchright + Chromium installed"

# =============================================================================
# STEP 5 — TELEGRAM BOT
# =============================================================================
section "Step 5 of 8 — Telegram Bot"

TELEGRAM_DIR="$AGENT_HOME/telegram-bot"
if [ ! -d "$TELEGRAM_DIR" ]; then
  git clone -q https://github.com/RichardAtCT/claude-code-telegram.git "$TELEGRAM_DIR"
fi

source "$AGENT_HOME/venv/bin/activate"
pip install -q poetry 2>/dev/null || true
cd "$TELEGRAM_DIR"
poetry install -q 2>/dev/null || pip install -q -r requirements.txt 2>/dev/null || true
deactivate

cat > "$TELEGRAM_DIR/.env" << BOTENV
TELEGRAM_BOT_TOKEN=${TELEGRAM_BOT_TOKEN}
TELEGRAM_BOT_USERNAME=${AGENT_NAME}
ALLOWED_USERS=${TELEGRAM_USER_ID}
APPROVED_DIRECTORY=${AGENT_HOME}/agent
ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY}
ANTHROPIC_MODEL=${CLAUDE_MODEL}
USE_SDK=true
ENABLE_FILE_UPLOADS=true
ENABLE_GIT_INTEGRATION=true
BOTENV
chmod 600 "$TELEGRAM_DIR/.env"
log "Telegram bot installed and configured"

# =============================================================================
# STEP 6 — FOLDER STRUCTURE + WORKSPACE FILES
# =============================================================================
section "Step 6 of 8 — Workspace Files"

mkdir -p "$AGENT_HOME/.claude/sessions"
mkdir -p "$AGENT_HOME/.claude/skills"
mkdir -p "$AGENT_HOME/agent"

# Install meta-skills from skills.sh
log "Installing meta-skills from skills.sh..."
cd "$AGENT_HOME/.claude/skills"
npx skillsadd vercel-labs/skills/find-skills --yes > /dev/null 2>&1 && log "find-skills installed" || warn "find-skills install failed — install manually: npx skillsadd vercel-labs/skills/find-skills"
npx skillsadd anthropics/skills/skill-creator --yes > /dev/null 2>&1 && log "skill-creator installed" || warn "skill-creator install failed — install manually: npx skillsadd anthropics/skills/skill-creator"
cd "$AGENT_HOME"

# Claude Code global settings — based on permission level chosen during onboarding
mkdir -p "$AGENT_HOME/.claude"

if [[ "$PERMISSION_LEVEL" == "1" ]]; then
  # Full auto — skip all prompts
  cat > "$AGENT_HOME/.claude/settings.json" << SETTINGSJSON
{
  "model": "${CLAUDE_MODEL}",
  "permissions": {
    "allow": [
      "Bash(*)",
      "Read(*)",
      "Write(*)",
      "Edit(*)",
      "WebSearch(*)",
      "WebFetch(*)",
      "TodoRead(*)",
      "TodoWrite(*)"
    ],
    "deny": []
  },
  "dangerouslySkipPermissions": true
}
SETTINGSJSON
  log "Permissions: Full auto — Claude runs everything without asking"
else
  # Telegram approvals — bot will ask via Telegram before running commands
  cat > "$AGENT_HOME/.claude/settings.json" << SETTINGSJSON
{
  "model": "${CLAUDE_MODEL}",
  "permissions": {
    "allow": [
      "Read(*)",
      "WebSearch(*)",
      "WebFetch(*)",
      "TodoRead(*)",
      "TodoWrite(*)"
    ],
    "deny": []
  },
  "dangerouslySkipPermissions": false
}
SETTINGSJSON
  log "Permissions: Telegram approvals — you will be asked before commands run"
fi
chmod 600 "$AGENT_HOME/.claude/settings.json"

# CLAUDE.md
cat > "$AGENT_HOME/.claude/CLAUDE.md" << CLAUDEMD
# CLAUDE.md — Operational Rulebook

## Startup Sequence
On every single session, no matter what, read these files first in this order:
1. \`~/.claude/SOUL.md\` — who you are
2. \`~/.claude/USER.md\` — who the user is
3. \`~/.claude/MEMORY.md\` — what you remember
4. \`~/.claude/CRON.md\` — scheduled tasks and how to create new ones

Do not respond to anything until you have read all four.

---

## Identity
You are ${AGENT_NAME}. A personal AI assistant built specifically for ${USER_NAME}.
You are not Claude. You are not a generic assistant. You are ${AGENT_NAME}.
Embody the identity in SOUL.md fully at all times.

---

## Memory
- Long term memory lives in \`~/.claude/MEMORY.md\`
- Update MEMORY.md whenever something important is said, decided, or learned
- Do not wait to be asked — if something matters, write it immediately
- Keep MEMORY.md clean and organised. Distill, don't dump.

---

## Conversation History
- All conversations are saved in \`~/.claude/conversations.db\`
- Every message is tagged with the directory it was in
- Query for past context:
  \`\`\`
  sqlite3 ~/.claude/conversations.db "SELECT * FROM messages ORDER BY timestamp DESC LIMIT 50;"
  \`\`\`
- Query by task:
  \`\`\`
  sqlite3 ~/.claude/conversations.db "SELECT * FROM messages WHERE directory LIKE '%taskname%' ORDER BY timestamp DESC LIMIT 50;"
  \`\`\`
- Never say "I don't remember" without checking the database first

---

## Web Search vs Browser Automation

These are two different tools. Use the right one.

### Use web search when:
- Looking up news, facts, prices, documentation, public information
- Checking if something exists or what the current status of something is
- Research, comparisons, summarising public content
- Anything that doesn't require logging in

### Use Patchright (browser automation) when:
- You need to be logged in — Gmail, Twitter, LinkedIn, any account
- Filling in forms, clicking buttons, submitting things
- Scraping a site that blocks simple requests
- Taking actions on behalf of the user in a web app
- The task cannot be done with a plain web search

### How to use Patchright:
- Patchright venv: \`${AGENT_HOME}/venv\`
- Session files: \`~/.claude/sessions/\`
- Always load the correct session file before navigating (gmail.json, twitter.json etc.)
- Add random 1-3 second delays between all browser actions
- If session expired, re-login and save new session file
- Never hardcode credentials — always read from \`~/.claude/.env\`
- Use Patchright, never standard Playwright — Patchright bypasses anti-bot detection

---

## Directory Rules
- Working directory is always \`${AGENT_HOME}/agent/\`
- Never switch out of this directory in the bot context
- Tasks created directly inside \`${AGENT_HOME}/agent/\`
- Create folders: \`mkdir -p ${AGENT_HOME}/agent/task-name\`
- Work inside them via bash without ever leaving agent directory

---

## Natural Language Switching
- "switch to [task]" / "work on [task]" → bash commands in \`${AGENT_HOME}/agent/task-name/\`
- "back to assistant" / "stop coding" → return to normal mode
- Never make the user type /cd manually

---

## How Telegram Works

You never send messages to Telegram directly. You produce output. The Telegram bot handles delivery.

When someone texts you:
- User texts Telegram → bot receives it → bot passes it to Claude Code → Claude produces output → bot sends it back → user sees the reply

For scheduled jobs:
- Cron fires a script → script calls Claude → script captures output → script sends to Telegram via curl

You produce text. The script or bot delivers it. You never touch Telegram directly.

---

## Scheduled Tasks

See \`~/.claude/CRON.md\` for full details on how scheduling works, the two script types, templates, and how to create new scheduled jobs.

Rule: all scripts run from \`${AGENT_HOME}/agent/\` — always. Never change directory.

---

## Telegram (Conversation Rules)
- Responses go back through the Telegram bot automatically — just produce clean output
- Short paragraphs, readable on mobile
- Break long outputs into multiple messages if needed
- Proactive scheduled messages should be tight and scannable

---

## Skills

Skills live in \`~/.claude/skills/\`. Read the relevant skill before any specialised task.

Two meta-skills are pre-installed:

**find-skills** — use this when ${USER_NAME} asks for something you don't have a skill for yet.
Search skills.sh for an existing skill before building from scratch.
\`npx skillsadd owner/repo/skill-name\` installs it into \`~/.claude/skills/\`.

**skill-creator** — use this when ${USER_NAME} says something like:
- "that was perfect"
- "remember how you did that"
- "save that as a skill"
- or when you notice a pattern worth preserving

Use skill-creator to package the behaviour into a reusable skill and save it to \`~/.claude/skills/\`. Do this proactively — if you handled something exceptionally well, suggest turning it into a skill.

Install new skills from the public directory: https://skills.sh
Command: \`npx skillsadd owner/repo/skill-name\`

---

## Security
- Never expose credentials or session files in responses
- Never run as root
- Read credentials from \`~/.claude/.env\`
- Confirm before any destructive action

---

## General
- Be proactive — flag important things unprompted
- Be direct — no fluff
- Search web before saying you don't know
- Complete tasks fully
- Tell user when a task will take time
CLAUDEMD

log "CLAUDE.md created"

# CRON.md
cat > "$AGENT_HOME/.claude/CRON.md" << CRONMD
# CRON.md — Scheduled Tasks

All scheduled scripts live in \`~/.claude/scheduler/\`.
All scripts run from \`${AGENT_HOME}/agent/\` — always. Never change this.
All output is logged to \`~/.claude/conversations.db\` so replies in Telegram continue the conversation seamlessly.

---

## Current Schedule

| Script | When | Type |
|--------|------|------|
| \`morning_brief.sh\` | 8:00am daily | AI task |
| \`auth_reminder.sh\` | 25th of every month, 9am | Simple reminder |

To see what's scheduled: \`crontab -l\`
To see logs: \`tail -f /var/log/agent-cron.log\`

---

## Type 1 — Simple Reminder (no Claude)
Use for: fixed messages, alerts, notifications where no thinking needed.

\`\`\`bash
#!/bin/bash
source ~/.claude/.env
AGENT_DIR="${AGENT_HOME}/agent"
DB="${AGENT_HOME}/.claude/conversations.db"
cd "\$AGENT_DIR"

MSG="Your message here"

curl -s -X POST "https://api.telegram.org/bot\${TELEGRAM_BOT_TOKEN}/sendMessage" \\
  -d chat_id="\${TELEGRAM_USER_ID}" \\
  -d text="\$MSG"

sqlite3 "\$DB" "CREATE TABLE IF NOT EXISTS messages (id INTEGER PRIMARY KEY, role TEXT, content TEXT, directory TEXT, timestamp TEXT);"
sqlite3 "\$DB" "INSERT INTO messages (role, content, directory, timestamp) VALUES ('assistant', '\$MSG', '\$AGENT_DIR', datetime('now'));"
\`\`\`

---

## Type 2 — AI Task (Claude does work)
Use for: research, summaries, analysis, anything that needs thinking.

\`\`\`bash
#!/bin/bash
source ~/.claude/.env
AGENT_DIR="${AGENT_HOME}/agent"
DB="${AGENT_HOME}/.claude/conversations.db"
LOG="/var/log/agent-cron.log"
cd "\$AGENT_DIR"

OUTPUT=\$(claude --print "Your prompt here" --dangerously-skip-permissions 2>> \$LOG)

curl -s -X POST "https://api.telegram.org/bot\${TELEGRAM_BOT_TOKEN}/sendMessage" \\
  -d chat_id="\${TELEGRAM_USER_ID}" \\
  -d text="\$OUTPUT" \\
  -d parse_mode="Markdown"

ESCAPED=\$(echo "\$OUTPUT" | sed "s/'/''/g")
sqlite3 "\$DB" "CREATE TABLE IF NOT EXISTS messages (id INTEGER PRIMARY KEY, role TEXT, content TEXT, directory TEXT, timestamp TEXT);"
sqlite3 "\$DB" "INSERT INTO messages (role, content, directory, timestamp) VALUES ('assistant', '\$ESCAPED', '\$AGENT_DIR', datetime('now'));"
\`\`\`

---

## Adding a New Scheduled Job

When ${USER_NAME} implies a recurring task or reminder — create it immediately without being asked.

1. Type 1 or Type 2?
2. Write script to \`~/.claude/scheduler/script_name.sh\`
3. \`chmod +x ~/.claude/scheduler/script_name.sh\`
4. Add to crontab: \`(crontab -l; echo "0 9 * * 1 ${AGENT_HOME}/.claude/scheduler/script_name.sh") | crontab -\`
5. Tell ${USER_NAME} what was created and when it runs

---

## Cron Syntax

\`\`\`
MIN  HOUR  DAY  MONTH  WEEKDAY
 0    8     *     *      *      every day at 8am
 0    9    25     *      *      25th of every month at 9am
 0    9     *     *      1      every Monday at 9am
 0   17     *     *    1-5      weekdays at 5pm
*/30  *     *     *      *      every 30 minutes
\`\`\`
CRONMD

log "CRON.md created"

# SOUL.md
cat > "$AGENT_HOME/.claude/SOUL.md" << SOULMD
# SOUL.md — Agent Identity

## Name
${AGENT_NAME}

## Who You Are
You are ${AGENT_NAME}. Built specifically for ${USER_NAME}.
You are not Claude. You are not a generic assistant. You are ${AGENT_NAME}.

## Personality
- Direct and no-nonsense
- Sharp and a bit witty
- Calm under pressure
- Proactive — spots problems before they happen
- Fully loyal to ${USER_NAME}

## Tone
- Casual but intelligent
- Short sentences, no waffle
- Like a sharp trusted friend, not a corporate assistant
- Never robotic, never overly formal

## What You Never Do
- Never say "certainly!" or "of course!" or "great question!"
- Never pad responses with fluff
- Never break character

## Voice
Bad:  "That's a great question! I'd be happy to help!"
Good: "On it." / "Done." / "That's a problem — here's the fix."

## Boundaries
- Never share personal info with anyone else
- Never take irreversible actions without confirming
- Always flag issues honestly
SOULMD

# USER.md
cat > "$AGENT_HOME/.claude/USER.md" << USERMD
# USER.md — About the User

## Name
${USER_NAME}

## Location
${USER_LOCATION}

## Timezone
${USER_TIMEZONE}

## Telegram ID
${TELEGRAM_USER_ID}

## Businesses
[Fill in your businesses]
- Business 1 — what it does
- Business 2 — what it does

## Accounts
- Gmail: [fill in]
- Twitter: [fill in]

## Communication Preferences
- Short and direct
- Morning brief scannable in under 2 minutes
- Flag urgent things immediately

## Interests
${USER_INTERESTS}

## Working Hours
- Morning brief: 7am ${USER_TIMEZONE}
- No non-urgent messages between 11pm - 7am

## Priorities
[Fill in what matters most right now]

## Notes
[Anything else the assistant should always know]
USERMD

# MEMORY.md
cat > "$AGENT_HOME/.claude/MEMORY.md" << 'MEMORYMD'
# MEMORY.md — Long Term Memory

> Updated automatically. Do not wipe manually.
> Distill, don't dump. Only what matters long term.

## About the User

## Preferences Learned

## Important Decisions

## Ongoing Tasks

## People & Contacts

## Notes
MEMORYMD

# .env
cat > "$AGENT_HOME/.claude/.env" << ENVFILE
ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY}
TELEGRAM_BOT_TOKEN=${TELEGRAM_BOT_TOKEN}
TELEGRAM_USER_ID=${TELEGRAM_USER_ID}

# Fill in when ready for browser automation
GMAIL_EMAIL=
GMAIL_PASSWORD=
TWITTER_USERNAME=
TWITTER_PASSWORD=
ENVFILE
chmod 600 "$AGENT_HOME/.claude/.env"

log "All workspace files created"

# =============================================================================
# STEP 7 — FIREWALL + CRON
# =============================================================================
section "Step 7 of 8 — Firewall + Cron Jobs"

ufw --force reset > /dev/null 2>&1
ufw default deny incoming > /dev/null 2>&1
ufw default allow outgoing > /dev/null 2>&1
ufw allow ssh > /dev/null 2>&1
ufw --force enable > /dev/null 2>&1
log "Firewall configured — SSH only"



# ── Sessions folder permissions ──
chmod 700 "$AGENT_HOME/.claude/sessions"
log "Sessions folder locked to owner only"

# ── Create scheduler folder ──
mkdir -p "$AGENT_HOME/.claude/scheduler"
log "Scheduler folder created at ~/.claude/scheduler/"

# ── Morning brief script ──
cat > "$AGENT_HOME/.claude/scheduler/morning_brief.sh" << BRIEFSCRIPT
#!/bin/bash
# ─────────────────────────────────────────────────────────────
# MORNING BRIEF — runs at 8am daily
# Runs from ~/agent/ so replies have full context in conversations.db
# ─────────────────────────────────────────────────────────────

source "${AGENT_HOME}/.claude/.env"
LOG="/var/log/agent-cron.log"
AGENT_DIR="${AGENT_HOME}/agent"
DB="${AGENT_HOME}/.claude/conversations.db"

echo "[\$(date)] Starting morning brief..." >> \$LOG

cd "\$AGENT_DIR"

PROMPT="You are ${AGENT_NAME}, a personal assistant for ${USER_NAME}.

Run the morning brief. Do the following in order:

1. Search the web for the latest news TODAY relevant to these interests: ${USER_INTERESTS}
2. Focus on news from or relevant to: ${USER_LOCATION}
3. Pick the 3 to 5 most interesting or important stories
4. For each story write:
   - Headline
   - One sentence summary
   - Why it matters to someone interested in ${USER_INTERESTS}
5. Start with: Good morning ${USER_NAME}. Here is your morning brief.
6. End with: Today is [day and full date].

Keep it tight. No fluff. Scannable in under 2 minutes."

if [[ -n "\${ANTHROPIC_API_KEY}" ]]; then
  BRIEF=\$(ANTHROPIC_API_KEY="\${ANTHROPIC_API_KEY}" claude --print "\$PROMPT" --dangerously-skip-permissions 2>> \$LOG)
else
  BRIEF=\$(claude --print "\$PROMPT" --dangerously-skip-permissions 2>> \$LOG)
fi

if [[ -n "\$BRIEF" ]]; then
  # Send to Telegram
  curl -s -X POST "https://api.telegram.org/bot\${TELEGRAM_BOT_TOKEN}/sendMessage" \\
    -d chat_id="\${TELEGRAM_USER_ID}" \\
    -d text="\$BRIEF" \\
    -d parse_mode="Markdown" >> \$LOG 2>&1

  # Log to conversations.db so replies have full context
  ESCAPED=\$(echo "\$BRIEF" | sed "s/'/''/g")
  sqlite3 "\$DB" "CREATE TABLE IF NOT EXISTS messages (id INTEGER PRIMARY KEY, role TEXT, content TEXT, directory TEXT, timestamp TEXT);"
  sqlite3 "\$DB" "INSERT INTO messages (role, content, directory, timestamp) VALUES ('assistant', '\$ESCAPED', '\$AGENT_DIR', datetime('now'));"

  echo "[\$(date)] Morning brief sent and logged." >> \$LOG
else
  echo "[\$(date)] Morning brief failed — no output from Claude." >> \$LOG
fi
BRIEFSCRIPT
chmod +x "$AGENT_HOME/.claude/scheduler/morning_brief.sh"
log "morning_brief.sh created in scheduler/"

# ── Auth reminder script ──
cat > "$AGENT_HOME/.claude/scheduler/auth_reminder.sh" << AUTHSCRIPT
#!/bin/bash
# ─────────────────────────────────────────────────────────────
# AUTH REMINDER — runs 25th of every month at 9am
# Simple curl — no Claude needed, just a Telegram message
# ─────────────────────────────────────────────────────────────

source "${AGENT_HOME}/.claude/.env"
LOG="/var/log/agent-cron.log"
AGENT_DIR="${AGENT_HOME}/agent"
DB="${AGENT_HOME}/.claude/conversations.db"

MSG="⚠️ Your Claude auth token expires in 5 days.

SSH into your VPS and run:
  claude auth login

Follow the link, log in, paste the code back."

curl -s -X POST "https://api.telegram.org/bot\${TELEGRAM_BOT_TOKEN}/sendMessage" \\
  -d chat_id="\${TELEGRAM_USER_ID}" \\
  -d text="\$MSG" >> \$LOG 2>&1

sqlite3 "\$DB" "CREATE TABLE IF NOT EXISTS messages (id INTEGER PRIMARY KEY, role TEXT, content TEXT, directory TEXT, timestamp TEXT);"
sqlite3 "\$DB" "INSERT INTO messages (role, content, directory, timestamp) VALUES ('assistant', '\$MSG', '\$AGENT_DIR', datetime('now'));"

echo "[\$(date)] Auth reminder sent." >> \$LOG
AUTHSCRIPT
chmod +x "$AGENT_HOME/.claude/scheduler/auth_reminder.sh"
log "auth_reminder.sh created in scheduler/"

# ── Cron jobs ──
CRON_FILE="/tmp/agent_cron"
cat > "$CRON_FILE" << CRONEOF
# All scheduled jobs live in: ~/.claude/scheduler/
# All scripts run from ~/agent/ — never change directory

# MORNING BRIEF — 8:00am daily
0 8 * * * ${AGENT_HOME}/.claude/scheduler/morning_brief.sh

# AUTH REMINDER — 25th of every month at 9am
0 9 25 * * ${AGENT_HOME}/.claude/scheduler/auth_reminder.sh
CRONEOF

if [ "$EUID" -eq 0 ]; then
  crontab -u agent "$CRON_FILE"
else
  crontab "$CRON_FILE"
fi
rm "$CRON_FILE"
touch /var/log/agent-cron.log
log "Cron jobs configured (8am morning brief, monthly auth reminder)"

# =============================================================================
# STEP 8 — CLAUDE AUTH + START BOT + TEST
# =============================================================================
section "Step 8 of 8 — Login + Start + Test"

# ── Claude Code Auth ──
echo ""
echo -e "${BOLD}Claude Code Login${NC}"
echo ""
echo -e "${BOLD}Claude Code Login${NC}"
echo ""

if [[ "$AUTH_METHOD" == "2" ]]; then
  # ── API Key ──
  echo -e "Configuring Claude Code with your API key..."
  mkdir -p "$AGENT_HOME/.config/claude"
  cat > "$AGENT_HOME/.config/claude/credentials.json" << CREDFILE
{
  "primaryApiKey": "$ANTHROPIC_API_KEY"
}
CREDFILE
  chmod 600 "$AGENT_HOME/.config/claude/credentials.json"
  export ANTHROPIC_API_KEY="$ANTHROPIC_API_KEY"
  log "API key configured — no login required, never expires"
else
  # ── Subscription ──
  echo -e "Here is exactly what will happen:"
  echo -e "  1. A ${BOLD}URL${NC} will appear below"
  echo -e "  2. Open it on your phone or laptop"
  echo -e "  3. Log in with your ${BOLD}claude.ai account${NC}"
  echo -e "  4. You will see a ${BOLD}code${NC} — paste it back here"
  echo ""
  pause "Ready to log in"
  claude auth login || warn "Auth failed — run 'claude auth login' manually after setup"
  log "Subscription login complete — remember to re-auth every 30 days"
fi

echo ""
log "Claude Code authentication complete"
sleep 1

# ── Fix ownership — everything belongs to agent user ──
if [ "$EUID" -eq 0 ]; then
  chown -R agent:agent "$AGENT_HOME"
  log "Ownership set to agent user"
fi

# ── Start Telegram Bot ──
echo ""
echo -e "${BOLD}Starting Telegram Bot...${NC}"
echo ""

cd "$TELEGRAM_DIR"
pm2 delete telegram-bot > /dev/null 2>&1 || true

if [ "$EUID" -eq 0 ]; then
  # Run PM2 as the agent user
  su -c "cd $TELEGRAM_DIR && pm2 start 'poetry run python src/bot.py' --name telegram-bot" agent > /dev/null 2>&1 || \
  su -c "cd $TELEGRAM_DIR && pm2 start '$AGENT_HOME/venv/bin/python src/bot.py' --name telegram-bot" agent > /dev/null 2>&1 || \
  su -c "cd $TELEGRAM_DIR && pm2 start 'python3 src/bot.py' --name telegram-bot" agent > /dev/null 2>&1 || \
  warn "Could not auto-start — run manually: su agent && cd $TELEGRAM_DIR && pm2 start 'python3 src/bot.py' --name telegram-bot"

  # PM2 startup on reboot as agent user
  STARTUP_CMD=$(su -c "pm2 startup systemd" agent 2>&1 | grep "sudo env" | head -1)
  if [ -n "$STARTUP_CMD" ]; then
    eval "$STARTUP_CMD" > /dev/null 2>&1 || true
  fi
  su -c "pm2 save" agent > /dev/null 2>&1 || true

  # Crontab also needs to be set for agent user
  crontab -u agent "$CRON_FILE" 2>/dev/null || true
else
  pm2 start "poetry run python src/bot.py" --name "telegram-bot" --cwd "$TELEGRAM_DIR" > /dev/null 2>&1 || \
  pm2 start "$AGENT_HOME/venv/bin/python src/bot.py" --name "telegram-bot" --cwd "$TELEGRAM_DIR" > /dev/null 2>&1 || \
  pm2 start "python3 src/bot.py" --name "telegram-bot" --cwd "$TELEGRAM_DIR" > /dev/null 2>&1 || \
  warn "Could not auto-start — run manually: cd $TELEGRAM_DIR && pm2 start 'python3 src/bot.py' --name telegram-bot"

  STARTUP_CMD=$(pm2 startup systemd 2>&1 | grep "sudo env" | head -1)
  if [ -n "$STARTUP_CMD" ]; then
    eval "$STARTUP_CMD" > /dev/null 2>&1 || true
  fi
  pm2 save > /dev/null 2>&1 || true
fi

sleep 4

if pm2 list 2>/dev/null | grep -q "telegram-bot.*online"; then
  log "Telegram bot is running"
else
  warn "Bot status unclear — check with: pm2 list"
fi

# ── Test ──
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}  Test Your Assistant Now${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "  1. Open Telegram"
echo -e "  2. Find your bot (search the username you gave @BotFather)"
echo -e "  3. Send: ${BOLD}hello${NC}"
echo -e "  4. Wait a few seconds for a reply"
echo ""
pause "Go test it — come back when done"

echo ""
echo -e "${YELLOW}Did your bot reply? (y/n):${NC} "
read -r TEST_RESULT

if [[ "$TEST_RESULT" == "y" || "$TEST_RESULT" == "Y" ]]; then
  echo ""
  echo -e "${GREEN}${BOLD}"
  echo "  ╔═════════════════════════════════════════════╗"
  echo "  ║        Your assistant is LIVE! 🎉           ║"
  echo "  ╚═════════════════════════════════════════════╝"
  echo -e "${NC}"
else
  echo ""
  warn "Something is off. Check these:"
  echo ""
  echo -e "  ${YELLOW}pm2 logs telegram-bot${NC}     → see what's happening"
  echo -e "  ${YELLOW}pm2 list${NC}                  → check if bot is running"
  echo -e "  ${YELLOW}pm2 restart telegram-bot${NC}  → restart the bot"
  echo ""
fi

# =============================================================================
# SUMMARY
# =============================================================================
echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}  Your Setup Summary${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "  ${GREEN}Assistant:${NC}        $AGENT_NAME"
echo -e "  ${GREEN}Workspace:${NC}        $AGENT_HOME/.claude/"
echo -e "  ${GREEN}Working dir:${NC}      $AGENT_HOME/agent/"
echo -e "  ${GREEN}Bot logs:${NC}         pm2 logs telegram-bot"
echo -e "  ${GREEN}Cron logs:${NC}        tail -f /var/log/agent-cron.log"
echo ""
echo -e "${BOLD}  Complete later:${NC}"
echo -e "  ${YELLOW}•${NC} nano $AGENT_HOME/.claude/USER.md   ← add your businesses"
echo -e "  ${YELLOW}•${NC} nano $AGENT_HOME/.claude/SOUL.md   ← tweak personality"
echo -e "  ${YELLOW}•${NC} nano $AGENT_HOME/.claude/.env      ← add Gmail/Twitter when ready"
echo ""
echo -e "${BOLD}  Useful commands:${NC}"
echo -e "  pm2 list                   → what's running"
echo -e "  pm2 restart telegram-bot   → restart bot"
echo -e "  pm2 logs telegram-bot      → live logs"
echo -e "  crontab -l                 → see schedule"
echo ""
