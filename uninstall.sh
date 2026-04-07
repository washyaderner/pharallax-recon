#!/bin/bash
set -e

CLAUDE_DIR="${HOME}/.claude"

echo "Uninstalling Pharallax Recon..."

rm -rf "$CLAUDE_DIR/skills/pharallax-recon"
rm -f "$CLAUDE_DIR/agents/landscape-mapper.md"
rm -f "$CLAUDE_DIR/agents/vulnerability-scanner.md"
rm -f "$CLAUDE_DIR/agents/messaging-gap.md"
rm -f "$CLAUDE_DIR/agents/opportunity-finder.md"

echo "Pharallax Recon uninstalled."
