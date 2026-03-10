# TOOLS.md - Local Notes

Skills define _how_ tools work. This file is for _your_ specifics — the stuff that's unique to your setup.

## What Goes Here

Things like:

- Camera names and locations
- SSH hosts and aliases
- Preferred voices for TTS
- Speaker/room names
- Device nicknames
- Anything environment-specific

## Examples

```markdown
### Cameras

- living-room → Main area, 180° wide angle
- front-door → Entrance, motion-triggered

### SSH

- home-server → 192.168.1.100, user: admin

### TTS

- Preferred voice: "Nova" (warm, slightly British)
- Default speaker: Kitchen HomePod
```

## Lumen Discovery Guardrail

For any discovery, search, or lead-generation task, run the lumen router first before using browser-based tools.

### Workflow

1. Run the helper script:

scripts/run-lumen-first.ps1

2. The helper attempts to route the request through `lumen-router`.

3. If `lumen-router` returns a valid command, execute that pipeline.

4. Only use browsing or web-search tools if the router returns:
   - `UNSUPPORTED`
   - `NEEDS_CLARIFICATION`

### Why this exists

Browsing is fast but produces one-off answers.  
The lumen pipeline produces **structured, repeatable lead data**.

This guardrail ensures we do not bypass the pipeline out of convenience.

### Reminder

If a search/find/discover task begins and the helper was not run first, stop and run the helper before continuing.

Speed is not a reason to skip the system workflow.

## Why Separate?

Skills are shared. Your setup is yours. Keeping them apart means you can update skills without losing your notes, and share skills without leaking your infrastructure.

---

Add whatever helps you do your job. This is your cheat sheet.
