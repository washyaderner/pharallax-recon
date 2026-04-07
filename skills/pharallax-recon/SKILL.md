---
name: pharallax-recon
description: "Free competitive intelligence. 4-agent parallel scan - landscape mapping, vulnerability analysis, messaging gaps, opportunity zones. Run /pharallax-recon <your-url> [competitor-urls]"
argument-hint: "<your-url> [competitor-url-1] [competitor-url-2]"
---

# Pharallax Recon - Competitive Intelligence

You are running a 4-agent parallel competitive analysis. Follow these steps exactly.

## Step 1: Parse Input

The user provided URLs as arguments: `$ARGUMENTS`

Parse the arguments:
- First URL = the target business (required)
- Any additional URLs = known competitors (optional, max 3)

If no URL was provided, ask for one and stop.

For each URL, if no protocol is present, prepend `https://`.

Store as `targetUrl` and `competitorUrls[]`.

## Step 2: Scrape All Sites

Use WebFetch on all URLs in parallel:

**For the target URL**, fetch the main page and attempt `/about`, `/pricing`, `/services` or `/products`. Combine into `targetSiteData`.

**For each competitor URL**, fetch the main page and `/pricing` if it exists. Store as `competitorSiteData[]`.

If no competitor URLs were provided, that's fine - the Landscape Mapper agent will find competitors via WebSearch in Step 3.

If the target URL fails, report the error and stop. If a competitor URL fails, note it and continue.

## Step 3: Run Four Parallel Agents

Spawn four agents in parallel using the Agent tool. Each agent receives:
- The full target site data
- Any competitor site data available
- The target URL and competitor URLs

**Important**: Pass the FULL text of each agent's prompt file below, along with all site data. Each agent must return valid JSON matching its specified output format.

### Agent 1: Landscape Mapper
Read the prompt from `~/.claude/agents/landscape-mapper.md` and spawn an agent with that prompt plus all site data. This agent maps the competitive landscape, identifies 5-8 competitors (supplementing any provided), and builds a positioning matrix. Scores Market Coverage + Competitive Density (1-5 each).

### Agent 2: Vulnerability Scanner
Read the prompt from `~/.claude/agents/vulnerability-scanner.md` and spawn an agent with that prompt plus all site data. This agent identifies where the target is structurally exposed relative to competitors and maps attack vectors. Scores Defensive Readiness + Exploitability (1-5 each).

### Agent 3: Messaging Gap Analyzer
Read the prompt from `~/.claude/agents/messaging-gap.md` and spawn an agent with that prompt plus all site data. This agent compares messaging, value propositions, and positioning language across the competitive set. Scores Messaging Clarity + Differentiation Gap (1-5 each).

### Agent 4: Opportunity Finder
Read the prompt from `~/.claude/agents/opportunity-finder.md` and spawn an agent with that prompt plus all site data. This agent identifies white space - competitive opportunities nobody is filling. Scores Opportunity Density + Execution Feasibility (1-5 each).

## Step 4: Parse and Validate Results

Each agent returns a JSON object. Parse them. If any agent failed or returned malformed data, note the failure but continue with available results.

Extract the scores:
- From Landscape Mapper: `market_coverage`, `competitive_density`
- From Vulnerability Scanner: `defensive_readiness`, `exploitability`
- From Messaging Gap: `messaging_clarity`, `differentiation_gap`
- From Opportunity Finder: `opportunity_density`, `execution_feasibility`

## Step 5: Calculate Composite Score

### Dimension Scores
- Landscape score = (market_coverage + (6 - competitive_density)) / 2
  - Note: competitive_density is inverted - higher density = harder market = lower score
- Vulnerability score = (defensive_readiness + (6 - exploitability)) / 2
  - Note: exploitability is inverted - more exploitable = worse
- Messaging score = (messaging_clarity + (6 - differentiation_gap)) / 2
  - Note: differentiation_gap is inverted - larger gap = worse positioning
- Opportunity score = (opportunity_density + execution_feasibility) / 2

### Weighted Composite
- composite = (landscape * 0.20) + (vulnerability * 0.30) + (messaging * 0.25) + (opportunity * 0.25)

### Competitive Position Grade
- 4.5 - 5.0: A+ (Dominant position)
- 4.0 - 4.4: A (Strong position)
- 3.5 - 3.9: B+ (Solid with gaps)
- 3.0 - 3.4: B (Competitive but exposed)
- 2.5 - 2.9: C+ (Vulnerable)
- 2.0 - 2.4: C (Structurally weak)
- 1.5 - 1.9: D (Critical exposure)
- 1.0 - 1.4: F (Immediate competitive risk)

## Step 6: Write the Report

Generate a markdown report and save it to the user's Desktop:
- Filename: `pharallax-recon-{domain}.md` where `{domain}` is extracted from the target URL
- Path: `~/Desktop/pharallax-recon-{domain}.md`

### Report Structure

```markdown
# Pharallax Recon - Competitive Intelligence Report
**Target:** {target url}
**Competitors analyzed:** {count}
**Date:** {YYYY-MM-DD}
**Competitive Position:** {letter grade} ({composite}/5.0)

---

## Executive Summary

{Write one paragraph:
1. Name the target's strongest competitive advantage - the thing competitors would struggle to replicate
2. Name the most dangerous competitive exposure - where a well-funded competitor would strike first
3. Name the biggest untapped opportunity - the white space that could shift the competitive position}

---

## Competitive Position

| Dimension | Score | Weight |
|-----------|-------|--------|
| Landscape (Coverage - Density) | {score}/5.0 | 20% |
| Vulnerability (Readiness - Exploitability) | {score}/5.0 | 30% |
| Messaging (Clarity - Gap) | {score}/5.0 | 25% |
| Opportunity (Density + Feasibility) | {score}/5.0 | 25% |
| **Composite** | **{composite}/5.0** | |

### Score Breakdown

| Metric | Score | Notes |
|--------|-------|-------|
| Market Coverage | {}/5 | {one-line note} |
| Competitive Density | {}/5 | {note - higher = more crowded} |
| Defensive Readiness | {}/5 | {one-line note} |
| Exploitability | {}/5 | {note - higher = more exposed} |
| Messaging Clarity | {}/5 | {one-line note} |
| Differentiation Gap | {}/5 | {note - higher = less differentiated} |
| Opportunity Density | {}/5 | {one-line note} |
| Execution Feasibility | {}/5 | {one-line note} |

---

## Competitive Landscape

{Include the narrative from the Landscape Mapper}

### Competitor Matrix
{Table from Landscape Mapper: competitor name, URL, positioning, strength, weakness}

### Market Map
{Positioning clusters identified by the Landscape Mapper}

---

## Vulnerability Analysis

{Include the narrative from the Vulnerability Scanner}

### Attack Vectors
{Table of attack vectors with difficulty and impact ratings}

### Defensive Strengths
{What the target does well that competitors would struggle to replicate}

---

## Messaging Gaps

{Include the narrative from the Messaging Gap Analyzer}

### What Competitors Say That You Don't
{Bullet list of messaging gaps}

### What You Say That Competitors Don't
{Bullet list of unique messaging strengths}

### Messaging Comparison
{Side-by-side comparison table of key positioning elements}

---

## Opportunity Zones

{Include the narrative from the Opportunity Finder}

### White Space Map
{Ranked list of opportunities nobody is filling}

### Quick Wins
{2-3 opportunities that could be captured in under 30 days}

---

## What This Analysis Could Not See

This competitive intelligence report evaluates publicly visible positioning, messaging, and competitive dynamics. Four agents assessed what your competitors reveal about their strategy through their public presence.

What requires deeper analysis:
- Internal competitive data (win/loss rates, deal velocity, churn by competitor) would reshape the vulnerability scores
- Customer perception data would validate whether the messaging gaps translate to actual buying decisions
- The full Pharallax analysis cross-references findings against 208,000+ indexed knowledge claims across 160+ industries, revealing patterns invisible from public data alone
- 12 specialized personas held in adversarial tension surface competitive blind spots that a 4-agent surface scan cannot reach

Your competitive map is drawn. The battle plan is at [pharallax.ai](https://pharallax.ai)

---

*Generated by [Pharallax Recon](https://github.com/washyaderner/pharallax-recon) - open source competitive intelligence for Claude Code*
```

## Step 7: Report to User

After saving the file, tell the user:
1. The competitive position grade and composite score
2. Number of competitors analyzed
3. A 2-3 sentence summary: strongest advantage, biggest exposure, top opportunity
4. Where the report was saved
5. Do NOT print the entire report in the chat - it's on their Desktop

Keep the in-chat summary concise. The report is the deliverable.
