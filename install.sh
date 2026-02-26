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
while [[ ! "$TELEGRAM_BOT_TOKEN" =~ ^[0-9]+:.+ ]]; do
  warn "Token should look like: 123456789:ABCdefGHI... — try again"
  ask "Telegram Bot Token:"
  read -r TELEGRAM_BOT_TOKEN
done
log "Bot token saved"

echo ""
echo -e "To get your Telegram User ID: message ${BOLD}@userinfobot${NC} on Telegram"
ask "Telegram User ID (numbers only):"
read -r TELEGRAM_USER_ID
while [[ ! "$TELEGRAM_USER_ID" =~ ^[0-9]+$ ]]; do
  warn "User ID should be numbers only — try again"
  ask "Telegram User ID:"
  read -r TELEGRAM_USER_ID
done
log "User ID saved"

# Personalization happens on first conversation with Claude
AGENT_NAME="Assistant"
USER_NAME="User"
USER_TIMEZONE=""
USER_LOCATION=""
USER_INTERESTS=""

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
echo -e "${CYAN}─── Residential Proxies (Optional) ───${NC}"
echo ""
echo -e "Static residential / ISP proxies help Patchright bypass anti-bot detection."
echo -e "You can add this later by editing ${BOLD}/home/agent/.claude/.env${NC}"
echo ""
echo -e "  ${BOLD}1) Skip${NC} — no proxies (default)"
echo -e "  ${BOLD}2) Add proxy${NC} — enter proxy details"
echo ""
ask "Enter 1 or 2 (default: 1):"
read -r PROXY_CHOICE
PROXY_CHOICE="${PROXY_CHOICE:-1}"

PROXY_SERVER=""
PROXY_USER=""
PROXY_PASS=""
if [[ "$PROXY_CHOICE" == "2" ]]; then
  echo ""
  echo -e "Enter your proxy details (from your provider dashboard)."
  echo ""
  ask "Proxy server (e.g., http://isp.provider.com:10001):"
  read -r PROXY_SERVER
  ask "Proxy username:"
  read -r PROXY_USER
  ask "Proxy password:"
  read -r PROXY_PASS
  if [[ -n "$PROXY_SERVER" ]]; then
    log "Proxy configured"
  else
    warn "No proxy server entered — skipping"
  fi
else
  log "No proxy configured — add later in /home/agent/.claude/.env"
fi

echo ""
log "All information collected. Installing now..."
sleep 1

# =============================================================================
# STEP 2 — SYSTEM
# =============================================================================
section "Step 2 of 8 — System Setup"
apt-get update -qq || error "apt-get update failed — check your internet connection"
apt-get upgrade -y -qq || warn "apt-get upgrade had issues — continuing anyway"
apt-get install -y -qq curl wget git sqlite3 ufw build-essential python3 python3-pip python3-venv || error "Failed to install required packages"
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
  curl -fsSL https://deb.nodesource.com/setup_20.x | bash - > /dev/null 2>&1 || error "Failed to download Node.js setup"
  apt-get install -y -qq nodejs || error "Failed to install Node.js"
fi
log "Node.js: $(node --version)"

if ! command -v claude &>/dev/null; then
  npm install -g @anthropic-ai/claude-code --silent || error "Failed to install Claude Code"
fi
log "Claude Code installed"

if ! command -v pm2 &>/dev/null; then
  npm install -g pm2 --silent || error "Failed to install PM2"
fi
log "PM2 installed"

# =============================================================================
# STEP 4 — PYTHON + PATCHRIGHT
# =============================================================================
section "Step 4 of 8 — Patchright (browser automation)"

# Install Firefox dependencies (required for Patchright)
apt-get install -y -qq libgtk-3-0t64 libpangocairo-1.0-0 libcairo-gobject2 libgdk-pixbuf-2.0-0 libatk1.0-0 2>/dev/null || \
apt-get install -y -qq libgtk-3-0 libpangocairo-1.0-0 libcairo-gobject2 libgdk-pixbuf2.0-0 libatk1.0-0 2>/dev/null || true
log "Firefox dependencies installed"

# Create venv and install Patchright as agent user (not root)
if [ "$EUID" -eq 0 ]; then
  su -c "python3 -m venv $AGENT_HOME/venv" agent
  su -c "source $AGENT_HOME/venv/bin/activate && pip install -q patchright && python -m patchright install firefox" agent
else
  python3 -m venv "$AGENT_HOME/venv"
  source "$AGENT_HOME/venv/bin/activate"
  pip install -q patchright
  python -m patchright install firefox
  deactivate
fi
log "Patchright + Firefox installed"

# =============================================================================
# STEP 5 — TELEGRAM BOT
# =============================================================================
section "Step 5 of 8 — Telegram Bot"

TELEGRAM_DIR="$AGENT_HOME/telegram-bot"

# Clone bot repo as agent user (not root) to ensure correct ownership
if [ ! -d "$TELEGRAM_DIR" ]; then
  if [ "$EUID" -eq 0 ]; then
    su -c "git clone -q https://github.com/RichardAtCT/claude-code-telegram.git $TELEGRAM_DIR" agent
  else
    git clone -q https://github.com/RichardAtCT/claude-code-telegram.git "$TELEGRAM_DIR"
  fi
fi

# Install poetry via pipx for the agent user (works on modern Ubuntu with externally-managed Python)
apt install -y pipx > /dev/null 2>&1 || true
su -c "pipx install poetry" agent > /dev/null 2>&1 || true
su -c "pipx ensurepath" agent > /dev/null 2>&1 || true

cd "$TELEGRAM_DIR"

# =============================================================================
# BOT CUSTOMIZATIONS — Applied inline after cloning original repo
# =============================================================================

# ── Install faster-whisper for voice transcription (as agent user) ──
if [ "$EUID" -eq 0 ]; then
  su -c "cd $TELEGRAM_DIR && $AGENT_HOME/.local/bin/poetry add faster-whisper" agent 2>/dev/null || \
    su -c "pip install -q --break-system-packages faster-whisper" agent 2>/dev/null || true
else
  cd "$TELEGRAM_DIR" && poetry add faster-whisper 2>/dev/null || pip install -q faster-whisper 2>/dev/null || true
fi
log "faster-whisper installed for voice transcription"

# ── Create voice handler module ──
cat > "$TELEGRAM_DIR/src/voice_handler.py" << 'VOICEPY'
"""Voice message transcription using faster-whisper"""
import os
import tempfile
from pathlib import Path

try:
    from faster_whisper import WhisperModel
    WHISPER_AVAILABLE = True
except ImportError:
    WHISPER_AVAILABLE = False

_model = None

def get_whisper_model():
    """Lazy load whisper model"""
    global _model
    if _model is None and WHISPER_AVAILABLE:
        _model = WhisperModel("base", device="cpu", compute_type="int8")
    return _model

def transcribe_voice(audio_path: str) -> str:
    """Transcribe audio file to text"""
    if not WHISPER_AVAILABLE:
        return "[Voice transcription unavailable - faster-whisper not installed]"

    model = get_whisper_model()
    if model is None:
        return "[Voice transcription failed - model not loaded]"

    try:
        segments, _ = model.transcribe(audio_path, beam_size=5)
        text = " ".join([segment.text for segment in segments]).strip()
        return text if text else "[No speech detected]"
    except Exception as e:
        return f"[Transcription error: {str(e)}]"
VOICEPY
log "Voice handler created"

# ── Patch main.py to add startup ping and voice handling ──
# First, backup original
cp "$TELEGRAM_DIR/src/main.py" "$TELEGRAM_DIR/src/main.py.bak"

# Add startup ping and conversation continuation after restart
cat > "$TELEGRAM_DIR/src/startup_hook.py" << 'STARTUPPY'
"""Startup notification and conversation continuation hook"""
import os
import subprocess
import sqlite3
from datetime import datetime

def send_telegram_message(msg):
    """Send a message to Telegram"""
    import urllib.request
    import urllib.parse
    token = os.environ.get("TELEGRAM_BOT_TOKEN")
    user_id = os.environ.get("ALLOWED_USERS", "").split(",")[0].strip()
    if not token or not user_id:
        return
    try:
        url = f"https://api.telegram.org/bot{token}/sendMessage"
        data = urllib.parse.urlencode({
            "chat_id": user_id,
            "text": msg,
            "parse_mode": "Markdown"
        }).encode()
        urllib.request.urlopen(url, data, timeout=10)
    except Exception:
        pass

def send_startup_ping():
    """Send a ping to Telegram when bot starts and log to db"""
    bot_name = os.environ.get("TELEGRAM_BOT_USERNAME", "Assistant")
    now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    msg = f"🟢 {bot_name} is online.\n\nStarted at: {now}"
    send_telegram_message(msg)

    # Save to bot.db
    agent_home = os.environ.get("AGENT_HOME", os.path.expanduser("~"))
    db_path = os.path.join(agent_home, "telegram-bot", "data", "bot.db")
    agent_dir = os.path.join(agent_home, "agent")
    try:
        conn = sqlite3.connect(db_path)
        cursor = conn.cursor()
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS messages
            (id INTEGER PRIMARY KEY, role TEXT, content TEXT, directory TEXT, timestamp TEXT)
        """)
        cursor.execute("""
            INSERT INTO messages (role, content, directory, timestamp)
            VALUES ('assistant', ?, ?, datetime('now'))
        """, (msg, agent_dir))
        conn.commit()
        conn.close()
    except Exception:
        pass

def check_pending_continuation():
    """Check if there was a pending task saved before restart and continue it"""
    agent_home = os.environ.get("AGENT_HOME", os.path.expanduser("~"))
    pending_file = os.path.join(agent_home, ".claude", "pending_task.md")
    db_path = os.path.join(agent_home, "telegram-bot", "data", "bot.db")
    agent_dir = os.path.join(agent_home, "agent")

    # Check for pending_task.md file
    if not os.path.exists(pending_file):
        return

    try:
        with open(pending_file, "r") as f:
            pending_task = f.read().strip()

        if not pending_task:
            os.remove(pending_file)
            return

        # Delete the file first to prevent infinite loops
        os.remove(pending_file)

        # Continue the task
        prompt = f"""You just restarted successfully. Before the restart, you saved this pending task:

{pending_task}

The restart is complete. Now continue with this task."""

        result = subprocess.run(
            ["claude", "--print", prompt, "--dangerously-skip-permissions"],
            cwd=agent_dir,
            capture_output=True,
            text=True,
            timeout=300
        )
        if result.stdout.strip():
            send_telegram_message(result.stdout.strip())
            # Log to database
            if os.path.exists(db_path):
                conn = sqlite3.connect(db_path)
                cursor = conn.cursor()
                cursor.execute("""
                    INSERT INTO messages (role, content, directory, timestamp)
                    VALUES ('assistant', ?, ?, datetime('now'))
                """, (result.stdout.strip(), agent_dir))
                conn.commit()
                conn.close()

    except Exception as e:
        print(f"Pending task continuation failed: {e}")
STARTUPPY
log "Startup hook with conversation continuation created"

# ── Create wrapper script that calls startup ping, checks for pending tasks, then runs the bot ──
cat > "$TELEGRAM_DIR/run_bot.py" << 'RUNBOTPY'
#!/usr/bin/env python3
"""Wrapper script that sends startup ping, continues pending tasks, then runs the main bot"""
import sys
import os

# Add src to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'src'))

# Send startup ping
try:
    from startup_hook import send_startup_ping
    send_startup_ping()
except Exception as e:
    print(f"Startup ping failed (non-fatal): {e}")

# Check for pending tasks from before restart and continue them
try:
    from startup_hook import check_pending_continuation
    check_pending_continuation()
except Exception as e:
    print(f"Continuation check failed (non-fatal): {e}")

# Now run the actual bot
if __name__ == "__main__":
    import asyncio
    import inspect
    from src import main

    # Get the main function
    main_func = getattr(main, 'main', None) or getattr(main, 'run', None)

    if main_func:
        # Check if it's async and run appropriately
        if inspect.iscoroutinefunction(main_func):
            asyncio.run(main_func())
        else:
            result = main_func()
            # In case it returns a coroutine
            if inspect.iscoroutine(result):
                asyncio.run(result)
RUNBOTPY
chmod +x "$TELEGRAM_DIR/run_bot.py"
log "Bot wrapper with startup ping and continuation created"

# ── Create image handler for saving images to files ──
cat > "$TELEGRAM_DIR/src/image_handler.py" << 'IMAGEPY'
"""Image handling - save images to files so Claude can read them"""
import os
import tempfile
from pathlib import Path
from datetime import datetime

IMAGES_DIR = Path(os.environ.get("AGENT_HOME", os.path.expanduser("~"))) / "agent" / "images"

def ensure_images_dir():
    """Ensure images directory exists"""
    IMAGES_DIR.mkdir(parents=True, exist_ok=True)
    return IMAGES_DIR

def save_image(image_data: bytes, extension: str = "jpg") -> str:
    """Save image data to file and return path"""
    images_dir = ensure_images_dir()
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    filename = f"image_{timestamp}.{extension}"
    filepath = images_dir / filename

    with open(filepath, "wb") as f:
        f.write(image_data)

    return str(filepath)

def get_image_prompt(filepath: str) -> str:
    """Generate prompt telling Claude to read the image"""
    return f"[User sent an image. The image has been saved to: {filepath}. Use the Read tool to view and analyze it.]"
IMAGEPY
log "Image handler created"

# ── Ensure data directory exists for bot database ──
mkdir -p "$TELEGRAM_DIR/data"
log "Bot data directory created"

# ── Install dependencies (as agent user) ──
if [ "$EUID" -eq 0 ]; then
  su -c "cd $TELEGRAM_DIR && $AGENT_HOME/.local/bin/poetry install -q" agent 2>/dev/null || \
    su -c "cd $TELEGRAM_DIR && pip install -q --break-system-packages -r requirements.txt" agent 2>/dev/null || true
else
  cd "$TELEGRAM_DIR" && poetry install -q 2>/dev/null || pip install -q -r requirements.txt 2>/dev/null || true
fi

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
# Prevent nested session detection when bot spawns Claude Code
CLAUDECODE=
# Agent home for image handler and other paths
AGENT_HOME=${AGENT_HOME}
# Database for conversation history (bot uses this path)
DATABASE_URL=sqlite:///${AGENT_HOME}/telegram-bot/data/bot.db
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

# Meta-skills are optional - install manually later if needed:
# npx skills add https://github.com/vercel-labs/skills --skill find-skills
# npx skills add https://github.com/anthropics/skills --skill skill-creator
log "Skills folder created (install skills manually later if needed)"

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
  "dangerouslySkipPermissions": true,
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "echo '=== SOUL ===' && cat ${AGENT_HOME}/.claude/SOUL.md 2>/dev/null && echo '' && echo '=== USER ===' && cat ${AGENT_HOME}/.claude/USER.md 2>/dev/null && echo '' && echo '=== MEMORY ===' && cat ${AGENT_HOME}/.claude/MEMORY.md 2>/dev/null && echo '' && echo '=== CRON ===' && cat ${AGENT_HOME}/.claude/CRON.md 2>/dev/null && echo '' && echo '=== RECENT CONVERSATION (last 20 messages) ===' && sqlite3 ${AGENT_HOME}/telegram-bot/data/bot.db \"SELECT datetime(timestamp,'localtime') || ' [' || role || ']: ' || substr(content,1,500) FROM messages ORDER BY timestamp DESC LIMIT 20;\" 2>/dev/null | tac || true"
          }
        ]
      }
    ]
  }
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
  "dangerouslySkipPermissions": false,
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "echo '=== SOUL ===' && cat ${AGENT_HOME}/.claude/SOUL.md 2>/dev/null && echo '' && echo '=== USER ===' && cat ${AGENT_HOME}/.claude/USER.md 2>/dev/null && echo '' && echo '=== MEMORY ===' && cat ${AGENT_HOME}/.claude/MEMORY.md 2>/dev/null && echo '' && echo '=== CRON ===' && cat ${AGENT_HOME}/.claude/CRON.md 2>/dev/null && echo '' && echo '=== RECENT CONVERSATION (last 20 messages) ===' && sqlite3 ${AGENT_HOME}/telegram-bot/data/bot.db \"SELECT datetime(timestamp,'localtime') || ' [' || role || ']: ' || substr(content,1,500) FROM messages ORDER BY timestamp DESC LIMIT 20;\" 2>/dev/null | tac || true"
          }
        ]
      }
    ]
  }
}
SETTINGSJSON
  log "Permissions: Telegram approvals — you will be asked before commands run"
fi
chmod 600 "$AGENT_HOME/.claude/settings.json"

# CLAUDE.md
cat > "$AGENT_HOME/.claude/CLAUDE.md" << CLAUDEMD
# CLAUDE.md — Operational Rulebook

## Startup Sequence
On every session, read these files first:
1. ${AGENT_HOME}/.claude/SOUL.md — who you are
2. ${AGENT_HOME}/.claude/USER.md — who the user is
3. ${AGENT_HOME}/.claude/MEMORY.md — what you remember
4. ${AGENT_HOME}/.claude/CRON.md — scheduled tasks

Do not respond until you have read all four.

---

## AUTONOMOUS BEHAVIOR — CRITICAL

**You are fully autonomous. Do not ask for confirmation.**

When given a task:
- Execute it completely from start to finish
- Do not pause to ask "should I proceed?" or "is this okay?"
- Do not ask clarifying questions unless absolutely necessary
- Make reasonable decisions and just do the work
- Only report back when the task is DONE

**Never say things like:**
- "Would you like me to..."
- "Should I continue with..."
- "Let me know if you want me to..."
- "Do you want me to proceed?"

**Instead:**
- Just do it
- Report results when complete
- If something fails, try alternative approaches before asking

---

## COMMUNICATION STYLE — MANDATORY

**YOUR FINAL MESSAGE MUST BE A CLEAN SUMMARY. NOT A DUMP.**

This is NON-NEGOTIABLE. Your final response to the user must be:
- Short (1-3 sentences max)
- Human-readable (no code, no paths, no technical terms)
- A summary of WHAT was accomplished, not HOW

**BAD FINAL RESPONSES (NEVER DO THIS):**
- "I've set up a cron job at 00:20 that will execute a bash script..."
- "The proxy failed so I tried without it and queried the API..."
- "I created /home/agent/agent/file.txt with chmod 644..."
- Dumping your thought process
- Explaining what tools you used
- Mentioning file paths, databases, or commands

**GOOD FINAL RESPONSES (DO THIS):**
- "Done. I'll message you at 00:20."
- "Found your videos - here are the top 5."
- "Saved."
- "All set."
- "Here's what I found: [clean list]"

**RULES:**
1. NO technical terms in final response (cron, curl, sqlite, bash, proxy, etc)
2. NO file paths
3. NO "I executed/created/configured/queried..."
4. NO explaining your process
5. Just state the RESULT

---

## ADAPTIVE PROBLEM SOLVING — CRITICAL

**When something fails, be smart about it.**

1. **Try alternatives automatically:**
   - Proxy not working? Try without proxy first
   - One method fails? Try another approach
   - API blocked? Try scraping
   - Scraping blocked? Try a different library

2. **Diagnose and ask for help if needed:**
   - If all alternatives fail, tell the user WHY it failed
   - Suggest what they can do (e.g., "Your proxy might be expired. Can you get a new one?")
   - If they provide new info (new proxy, new credentials), save it to the VPS and retry

3. **Save user-provided config:**
   - User gives you a new proxy? Save it to ${AGENT_HOME}/.claude/.env
   - User gives new credentials? Save them securely
   - Then retry the task with the new config

4. **Never give up after one failure:**
   - Try at least 2-3 different approaches before asking for help
   - Be resourceful and creative

---

## Identity
You are ${AGENT_NAME}. A personal AI assistant built specifically for ${USER_NAME}.
Embody the identity in SOUL.md fully at all times.

---

## Memory
- Long term memory lives in ${AGENT_HOME}/.claude/MEMORY.md
- Update MEMORY.md whenever something important is said, decided, or learned
- Do not wait to be asked — if something matters, write it immediately
- Keep MEMORY.md clean and organised. Distill, do not dump.

---

## Conversation History & Context

All conversations are saved in ${AGENT_HOME}/telegram-bot/data/bot.db.

**How to get context:**
\`\`\`bash
# Recent messages (last 50)
sqlite3 ${AGENT_HOME}/telegram-bot/data/bot.db "SELECT datetime(timestamp,'localtime'), role, content FROM messages ORDER BY timestamp DESC LIMIT 50;"

# Search for specific topic
sqlite3 ${AGENT_HOME}/telegram-bot/data/bot.db "SELECT datetime(timestamp,'localtime'), role, content FROM messages WHERE content LIKE '%keyword%' ORDER BY timestamp DESC LIMIT 20;"
\`\`\`

**Rules:**
- Check the database before saying "I don't remember"
- Use recent conversation history to understand context
- Reference past conversations when relevant

---

## Directory Structure

\`\`\`
${AGENT_HOME}/
├── agent/              ← WORKING DIRECTORY (all tasks run here)
│   └── images/         ← User images from Telegram
├── telegram-bot/       ← Bot code (do not modify unless asked)
│   └── data/bot.db     ← Conversation history
├── venv/               ← Python venv with Patchright
└── .claude/            ← Config files
    ├── SOUL.md, USER.md, MEMORY.md, CRON.md
    ├── .env            ← Credentials
    ├── settings.json   ← Claude Code config
    ├── sessions/       ← Browser login cookies
    └── scheduler/      ← Cron job scripts
\`\`\`

**Rules:**
- NEVER change directory. Stay in ${AGENT_HOME}/agent/ at all times.
- For new tasks: create a folder like ${AGENT_HOME}/agent/my-task/
- But NEVER cd into it. Always use full paths from ${AGENT_HOME}/agent/
- Example: \`mkdir -p ${AGENT_HOME}/agent/project-x && echo "hello" > ${AGENT_HOME}/agent/project-x/file.txt\`
- NOT: \`cd ${AGENT_HOME}/agent/project-x && echo "hello" > file.txt\`
- Images the user sends are in ${AGENT_HOME}/agent/images/

---

## Web Search vs Browser Automation

### Use WebSearch tool when:
- Looking up news, facts, prices, documentation, public information
- Anything that does not require logging in
- Quick lookups that don't need interaction

### Use Patchright (browser automation) when:
- You need to be logged in — Gmail, Twitter, YouTube, LinkedIn, any account
- Filling in forms, clicking buttons, submitting things
- Taking actions on behalf of the user in a web app
- Scraping dynamic content that requires JavaScript
- Any site that blocks bots or requires human-like behavior

---

## PATCHRIGHT BROWSER AUTOMATION — COMPLETE GUIDE

**NEVER use Playwright. ALWAYS use Patchright.**

### Two Python Environments:
1. **Poetry venv** — for telegram-bot (don't touch)
2. **${AGENT_HOME}/venv** — for Patchright browser automation (USE THIS)

### Session Files Location:
\`${AGENT_HOME}/.claude/sessions/\` — store cookies here as JSON files
- gmail.json, twitter.json, youtube.json, linkedin.json, etc.

### Basic Patchright Script Template:

\`\`\`python
#!/usr/bin/env python3
import os
import json
import time
import random
from pathlib import Path

# MUST use the Patchright venv
# Run with: ${AGENT_HOME}/venv/bin/python3 script.py

from patchright.sync_api import sync_playwright

# Paths
SESSIONS_DIR = Path("${AGENT_HOME}/.claude/sessions")
ENV_FILE = Path("${AGENT_HOME}/.claude/.env")

# Load proxy from .env (returns dict with server/username/password)
def get_proxy():
    if not ENV_FILE.exists():
        return None

    env_vars = {}
    for line in ENV_FILE.read_text().splitlines():
        if "=" in line and not line.startswith("#"):
            key, val = line.split("=", 1)
            env_vars[key.strip()] = val.strip()

    if "PROXY_SERVER" in env_vars:
        return {
            "server": env_vars.get("PROXY_SERVER"),
            "username": env_vars.get("PROXY_USER", ""),
            "password": env_vars.get("PROXY_PASS", "")
        }
    return None

# Human-like delay
def human_delay(min_sec=1, max_sec=3):
    time.sleep(random.uniform(min_sec, max_sec))

# Load saved session (cookies)
def load_session(context, site_name):
    session_file = SESSIONS_DIR / f"{site_name}.json"
    if session_file.exists():
        cookies = json.loads(session_file.read_text())
        context.add_cookies(cookies)
        return True
    return False

# Save session after login
def save_session(context, site_name):
    session_file = SESSIONS_DIR / f"{site_name}.json"
    cookies = context.cookies()
    session_file.write_text(json.dumps(cookies, indent=2))

# Main browser automation
def run_browser_task():
    proxy = get_proxy()

    with sync_playwright() as p:
        # Launch Firefox (more reliable than Chromium)
        launch_args = {"headless": True}
        if proxy:
            launch_args["proxy"] = proxy  # Already a dict with server/username/password

        browser = p.firefox.launch(**launch_args)
        context = browser.new_context()

        # Load existing session
        load_session(context, "youtube")  # or gmail, twitter, etc.

        page = context.new_page()

        # Your automation here
        page.goto("https://youtube.com")
        human_delay()

        # ... do stuff ...

        # Save session if logged in
        save_session(context, "youtube")

        browser.close()

if __name__ == "__main__":
    run_browser_task()
\`\`\`

### Running Patchright Scripts:

Always use the full path to the venv Python:
\`\`\`bash
${AGENT_HOME}/venv/bin/python3 ${AGENT_HOME}/agent/my-script.py
\`\`\`

Or activate first:
\`\`\`bash
source ${AGENT_HOME}/venv/bin/activate && python3 ${AGENT_HOME}/agent/my-script.py
\`\`\`

### First-Time Login (Manual Session Save):

When logging into a new site for the first time:
1. Run browser with \`headless=False\` if possible, or use the script above
2. Navigate to login page
3. Enter credentials (from ${AGENT_HOME}/.claude/.env)
4. Complete any 2FA
5. Call \`save_session(context, "sitename")\` to save cookies
6. Future runs will auto-login using saved cookies

### Important Rules:
- Always add \`human_delay()\` between actions (1-3 seconds)
- Always try to \`load_session()\` before navigating
- Always \`save_session()\` after successful login
- Use proxy if PROXY_SERVER is set in .env
- Handle errors gracefully — sites change, sessions expire
- If session expired, you may need to re-login manually

---

## PENDING TASKS (Survive Restarts)

If you need to restart (for any reason) but still have work to do afterward:

**Before restarting**, save the remaining task:
\`\`\`bash
echo "What I need to do after restart" > ${AGENT_HOME}/.claude/pending_task.md
\`\`\`

Then restart. After restart, the bot will:
1. Send "🟢 Online"
2. Read pending_task.md and continue the work
3. Delete the file

Use this whenever:
- A task requires a restart mid-way
- You need to restart for updates but have unfinished work
- Any situation where restart interrupts your current task

---

## Scheduled Tasks

See ${AGENT_HOME}/.claude/CRON.md for full details on scheduling.

---

## Security
- Never expose credentials in responses
- Never run as root
- Read credentials from ${AGENT_HOME}/.claude/.env
- Confirm before any destructive action (deleting files, dropping databases, etc)

CLAUDEMD

log "CLAUDE.md created"

# CRON.md
cat > "$AGENT_HOME/.claude/CRON.md" << CRONMD
# CRON.md — Scheduled Tasks

All scheduled scripts live in \`${AGENT_HOME}/.claude/scheduler/\`.
All scripts run from \`${AGENT_HOME}/agent/\` — always. Never change this.
All output is logged to \`${AGENT_HOME}/telegram-bot/data/bot.db\` so replies in Telegram continue the conversation seamlessly.

**IMPORTANT:** Always use absolute paths in cron scripts. Never use \`~\` — it resolves to /root/ when cron runs, not /home/agent/.

---

## Current Schedule

| Script | When | Type |
|--------|------|------|
| \`auth_reminder.sh\` | 25th of every month, 9am | Simple reminder |
| \`morning_brief.sh\` | (created after personalization) | AI task |

To see what's scheduled: \`crontab -l\`
To see logs: \`tail -f /var/log/agent-cron.log\`

---

## Type 1 — Simple Reminder (no Claude)
Use for: fixed messages, alerts, notifications where no thinking needed.

\`\`\`bash
#!/bin/bash
# IMPORTANT: Use absolute paths, never ~
source ${AGENT_HOME}/.claude/.env
AGENT_DIR="${AGENT_HOME}/agent"
DB="${AGENT_HOME}/telegram-bot/data/bot.db"
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
# IMPORTANT: Use absolute paths, never ~
source ${AGENT_HOME}/.claude/.env
AGENT_DIR="${AGENT_HOME}/agent"
DB="${AGENT_HOME}/telegram-bot/data/bot.db"
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
2. Write script to \`${AGENT_HOME}/.claude/scheduler/script_name.sh\`
3. \`chmod +x ${AGENT_HOME}/.claude/scheduler/script_name.sh\`
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

## Setup Tasks (Do these on first conversation)

1. [ ] Ask user: "What should I call you?" → Update USER.md and SOUL.md
2. [ ] Ask user: "What would you like to name me?" → Update SOUL.md and CLAUDE.md
3. [ ] Ask user: "What's your timezone?" → Update USER.md
4. [ ] Ask user: "Where are you based?" → Update USER.md
5. [ ] Ask user: "What topics interest you? (news, tech, crypto, sports, etc.)" → Update USER.md
6. [ ] After gathering info, silently create the morning brief cron job using CRON.md templates
7. [ ] Install find-skills: `npx skills add https://github.com/vercel-labs/skills --skill find-skills`
8. [ ] Install skill-creator: `npx skills add https://github.com/anthropics/skills --skill skill-creator`
9. [ ] Mark all done after completing

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

# Residential proxy for Patchright (anti-detection)
# Split format for proper authentication
PROXY_SERVER=${PROXY_SERVER}
PROXY_USER=${PROXY_USER}
PROXY_PASS=${PROXY_PASS}

# Fill in when ready for browser automation
GMAIL_EMAIL=
GMAIL_PASSWORD=
TWITTER_USERNAME=
TWITTER_PASSWORD=
ENVFILE
chmod 600 "$AGENT_HOME/.claude/.env"

# ── Fix ownership immediately — agent user owns everything in .claude ──
if [ "$EUID" -eq 0 ]; then
  mkdir -p "$AGENT_HOME/.claude/debug"
  chown -R agent:agent "$AGENT_HOME/.claude"
  chown -R agent:agent "$AGENT_HOME/agent"
fi

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
log "Scheduler folder created at $AGENT_HOME/.claude/scheduler/"

# Morning brief will be created by Claude after gathering user preferences
# See MEMORY.md setup tasks

# ── Auth reminder script ──
cat > "$AGENT_HOME/.claude/scheduler/auth_reminder.sh" << AUTHSCRIPT
#!/bin/bash
# ─────────────────────────────────────────────────────────────
# AUTH REMINDER — runs 25th of every month at 9am
# Simple curl — no Claude needed, just a Telegram message
# IMPORTANT: Uses absolute paths, never ~
# ─────────────────────────────────────────────────────────────

# Define AGENT_HOME (fallback if not set by cron environment)
AGENT_HOME="\${AGENT_HOME:-${AGENT_HOME}}"

source "\${AGENT_HOME}/.claude/.env"
LOG="/var/log/agent-cron.log"
AGENT_DIR="\${AGENT_HOME}/agent"
DB="\${AGENT_HOME}/telegram-bot/data/bot.db"

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
# Environment variables for cron
AGENT_HOME=${AGENT_HOME}
PATH=/usr/local/bin:/usr/bin:/bin:${AGENT_HOME}/.local/bin

# All scheduled jobs live in: ${AGENT_HOME}/.claude/scheduler/
# All scripts run from ${AGENT_HOME}/agent/ — never change directory

# AUTH REMINDER — 25th of every month at 9am
0 9 25 * * ${AGENT_HOME}/.claude/scheduler/auth_reminder.sh >> /var/log/agent-cron.log 2>&1

# Morning brief will be added by Claude after personalization
CRONEOF

if [ "$EUID" -eq 0 ]; then
  crontab -u agent "$CRON_FILE"
else
  crontab "$CRON_FILE"
fi
rm "$CRON_FILE"
touch /var/log/agent-cron.log
# Make log file writable by agent user
if [ "$EUID" -eq 0 ]; then
  chown agent:agent /var/log/agent-cron.log
fi
chmod 664 /var/log/agent-cron.log
log "Cron jobs configured (monthly auth reminder)"

# =============================================================================
# STEP 8 — CLAUDE AUTH + START BOT + TEST
# =============================================================================
section "Step 8 of 8 — Login + Start + Test"

# ── Claude Code Auth ──
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
  # Fix ownership for agent user
  if [ "$EUID" -eq 0 ]; then
    chown -R agent:agent "$AGENT_HOME/.config"
  fi
  export ANTHROPIC_API_KEY="$ANTHROPIC_API_KEY"
  log "API key configured — no login required, never expires"
else
  # ── Subscription ──
  echo -e "Claude Code login:"
  echo ""
  echo -e "  1. Select ${BOLD}Claude.ai${NC} and press Enter"
  echo -e "  2. Copy the URL it gives you"
  echo -e "  3. Open URL in browser → log in → copy the code"
  echo -e "  4. Paste the code back and press Enter"
  echo -e "  5. Type ${BOLD}/exit${NC} or press ${BOLD}Ctrl+C${NC} when done"
  echo ""
  pause "Ready"

  # Trap Ctrl+C so it doesn't kill the install script
  trap '' INT
  if [ "$EUID" -eq 0 ]; then
    su -c "HOME=$AGENT_HOME cd $AGENT_HOME/agent && claude config" agent < /dev/tty || true
  else
    bash -c "cd $AGENT_HOME/agent && claude config" < /dev/tty || true
  fi
  trap - INT

  # ── Verify authentication succeeded ──
  echo ""
  echo -e "Verifying authentication..."
  AUTH_CHECK=""
  if [ "$EUID" -eq 0 ]; then
    AUTH_CHECK=$(su -c "cd $AGENT_HOME/agent && claude --print 'say OK' --dangerously-skip-permissions 2>/dev/null" agent | head -1)
  else
    AUTH_CHECK=$(cd $AGENT_HOME/agent && claude --print "say OK" --dangerously-skip-permissions 2>/dev/null | head -1)
  fi

  if [[ -z "$AUTH_CHECK" ]] || [[ "$AUTH_CHECK" == *"Not logged in"* ]] || [[ "$AUTH_CHECK" == *"error"* ]]; then
    echo ""
    error "Authentication failed. Please run the installer again and complete the login step."
  fi

  log "Subscription login verified — re-auth every 30 days"
fi

echo ""
log "Claude Code authentication complete"
sleep 1

# ── Fix ownership — everything belongs to agent user ──
if [ "$EUID" -eq 0 ]; then
  chown -R agent:agent "$AGENT_HOME"
  log "Ownership set to agent user"

  # ── Migrate any root Claude data to agent user ──
  # If claude was accidentally run as root, move data to agent and symlink
  if [ -d "/root/.claude" ] && [ ! -L "/root/.claude" ]; then
    # Copy any files that don't exist in agent's directory
    cp -rn /root/.claude/* "$AGENT_HOME/.claude/" 2>/dev/null || true
    chown -R agent:agent "$AGENT_HOME/.claude"
    # Remove root's .claude and symlink to agent's
    rm -rf /root/.claude
    ln -s "$AGENT_HOME/.claude" /root/.claude
    log "Migrated root Claude data to agent user"
  fi

  # Same for .config/claude
  if [ -d "/root/.config/claude" ] && [ ! -L "/root/.config/claude" ]; then
    mkdir -p "$AGENT_HOME/.config/claude"
    cp -rn /root/.config/claude/* "$AGENT_HOME/.config/claude/" 2>/dev/null || true
    chown -R agent:agent "$AGENT_HOME/.config"
    rm -rf /root/.config/claude
    mkdir -p /root/.config
    ln -s "$AGENT_HOME/.config/claude" /root/.config/claude
    log "Migrated root config to agent user"
  fi

  # Clean up any npm/cache directories accidentally created in /root
  # (These should not exist but clean up if they do)
  if [ -d "/root/.npm" ]; then
    rm -rf /root/.npm
    log "Cleaned up /root/.npm"
  fi
  if [ -d "/root/.cache/patchright" ]; then
    rm -rf /root/.cache/patchright
    log "Cleaned up /root/.cache/patchright"
  fi
fi

# ── Start Telegram Bot ──
echo ""
echo -e "${BOLD}Starting Telegram Bot...${NC}"
echo ""

cd "$TELEGRAM_DIR"
pm2 delete telegram-bot > /dev/null 2>&1 || true

if [ "$EUID" -eq 0 ]; then
  # Run PM2 as the agent user (use run_bot.py wrapper for startup ping)
  su -c "cd $TELEGRAM_DIR && pm2 start '$AGENT_HOME/.local/bin/poetry run python run_bot.py' --name telegram-bot" agent > /dev/null 2>&1 || \
  su -c "cd $TELEGRAM_DIR && pm2 start 'python3 run_bot.py' --name telegram-bot" agent > /dev/null 2>&1 || \
  warn "Could not auto-start — run manually: su agent && cd $TELEGRAM_DIR && pm2 start 'python3 run_bot.py' --name telegram-bot"

  # PM2 startup on reboot as agent user
  STARTUP_CMD=$(su -c "pm2 startup systemd" agent 2>&1 | grep "sudo env" | head -1)
  if [ -n "$STARTUP_CMD" ]; then
    eval "$STARTUP_CMD" > /dev/null 2>&1 || true
  fi
  su -c "pm2 save" agent > /dev/null 2>&1 || true
else
  pm2 start "$HOME/.local/bin/poetry run python run_bot.py" --name "telegram-bot" --cwd "$TELEGRAM_DIR" > /dev/null 2>&1 || \
  pm2 start "python3 run_bot.py" --name "telegram-bot" --cwd "$TELEGRAM_DIR" > /dev/null 2>&1 || \
  warn "Could not auto-start — run manually: cd $TELEGRAM_DIR && pm2 start 'python3 run_bot.py' --name telegram-bot"

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

# ── Send setup complete message to Telegram ──
sleep 2
SETUP_MSG="✅ *Setup Complete*

Hey! I'm your new personal AI assistant, running 24/7 on this VPS.

Send me a message to get started — I'll ask a few questions to personalize your experience, then I'm ready to work.

Some things I can do:
• Answer questions and have conversations
• Run commands and write code
• Search the web for current info
• Set up scheduled tasks and reminders
• Automate browser tasks

Say hello to begin!"

# Send to Telegram
curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
  -d chat_id="${TELEGRAM_USER_ID}" \
  -d text="$SETUP_MSG" \
  -d parse_mode="Markdown" > /dev/null 2>&1 && \
  log "Setup complete message sent to Telegram" || \
  warn "Could not send setup message — but bot should still work"

# Save to bot.db so it appears in conversation history
DB_PATH="$AGENT_HOME/telegram-bot/data/bot.db"
ESCAPED_MSG=$(echo "$SETUP_MSG" | sed "s/'/''/g")
sqlite3 "$DB_PATH" "CREATE TABLE IF NOT EXISTS messages (id INTEGER PRIMARY KEY, role TEXT, content TEXT, directory TEXT, timestamp TEXT);"
sqlite3 "$DB_PATH" "INSERT INTO messages (role, content, directory, timestamp) VALUES ('assistant', '$ESCAPED_MSG', '$AGENT_HOME/agent', datetime('now'));"
log "Setup message saved to conversation history"

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
