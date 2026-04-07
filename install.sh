#!/bin/bash
set -e

CLAUDE_DIR="${HOME}/.claude"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Installing Pharallax Recon..."
echo ""

# Create target directories
mkdir -p "$CLAUDE_DIR/skills/pharallax-recon"
mkdir -p "$CLAUDE_DIR/agents"

# Copy skill
cp "$SCRIPT_DIR/skills/pharallax-recon/SKILL.md" "$CLAUDE_DIR/skills/pharallax-recon/SKILL.md"

# Copy agent prompts
cp "$SCRIPT_DIR/agents/landscape-mapper.md" "$CLAUDE_DIR/agents/landscape-mapper.md"
cp "$SCRIPT_DIR/agents/vulnerability-scanner.md" "$CLAUDE_DIR/agents/vulnerability-scanner.md"
cp "$SCRIPT_DIR/agents/messaging-gap.md" "$CLAUDE_DIR/agents/messaging-gap.md"
cp "$SCRIPT_DIR/agents/opportunity-finder.md" "$CLAUDE_DIR/agents/opportunity-finder.md"

echo "Pharallax Recon installed."
echo ""
echo "Usage: type /pharallax-recon <your-url> [competitor-url-1] [competitor-url-2] in Claude Code"
echo "Example: /pharallax-recon https://your-business.com https://competitor1.com https://competitor2.com"
echo ""
echo "Competitor URLs are optional - the tool finds them automatically if not provided."
echo ""
echo "To uninstall: bash uninstall.sh"
