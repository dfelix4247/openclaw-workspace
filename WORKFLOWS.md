# WORKFLOWS.md — Lead Discovery Workflow

This file defines how discovery workflows operate when using lumen-scout.

The goal is to move from **search → leads → action** smoothly without the user needing to restate context.

---

# Core Principle

Discovery should not end at results.

After a search, the system should naturally support:

• enrichment  
• ranking / scoring  
• outreach drafting  
• exporting

The assistant should treat discovered leads as a **working set** that subsequent commands can operate on.

---

# Working Set

The **working set** represents the **most recently discovered leads**.

When a discovery command runs, the resulting leads become the **active working set**.

Examples:

discover-web "private lenders in Los Angeles"

discover --city "Downey, CA"

These commands establish a working set.

Subsequent commands can reference this set using natural language such as:

• "enrich these"  
• "rank these"  
• "draft outreach"  
• "export this list"

The assistant should understand that **"these" refers to the most recent working set**.

---

# Working Set Lifecycle

## Creation

A working set is created whenever a discovery command runs.

Commands that create a working set:

lumen-scout discover

lumen-scout discover-web

The discovery results are persisted as leads and become the **active working set**.

## Replacement

Only **one active working set** exists at a time.

If a new discovery runs, the previous working set is replaced with the new results.

Example:

lumen-scout discover-web "charter schools in Pasadena"

This becomes the new active working set.

## Persistence

The working set stores:

• lead_ids  
• discovery query  
• source command  
• lead type (school / generic)  
• creation timestamp

Only lead identifiers are stored in the working set.

Lead data remains in the main lead store.

---

# Workflow Sequence

## Step 1 — Discovery

Use lumen-scout discovery tools to find leads.

Examples:

lumen-scout discover-web "tutoring centers in Los Angeles" --max 10

lumen-scout discover --city "Downey, CA" --max 25

Discovery returns structured results and persists leads in storage.

These leads become the **active working set**.

## Step 2 — Enrichment

Once leads exist, enrichment gathers additional context.

Examples:

• scrape website pages  
• extract contact details  
• identify personalization hooks

Example command:

lumen-scout enrich

If the user says:

"enrich these leads"

the assistant should run enrichment against the **current working set**.

## Step 3 — Ranking

After discovery and/or enrichment, leads can be ranked so the user knows which ones to act on first.

Ranking should be:

• deterministic  
• explainable  
• based on stored lead attributes  
• scoped to the active working set

Examples of scoring signals may include:

• contact email exists  
• contact role exists  
• personalization hook exists  
• website or domain exists  
• phone exists  
• city exists  
• lead type fit

Example command:

lumen-scout rank

If the user says:

"rank these"  
"score these leads"  
"prioritize this list"

the assistant should rank the **current working set**.

Ranking should update lead metadata such as:

• lead_score  
• lead_score_label  
• lead_score_reasons  
• ranking_version  
• ranked_at

Ranking should help downstream actions decide what to work on first.

## Step 4 — Outreach Drafting

After enrichment and/or ranking, outreach drafts can be generated.

Examples:

• email drafts  
• LinkedIn messages  
• contact form submissions

Example command:

lumen-scout draft --limit 10

This should target the most relevant or highest-priority leads in the working set.

If ranking exists, drafting may later use that ranking to prioritize the best leads first.

## Step 5 — Export

Users may want to export the current working set.

Examples:

• CSV export  
• JSON export  
• saved result set

Example:

"export this list"

The assistant should export the **active working set**.

---

# Natural Language Continuations

Users will often issue follow-up commands that refer to the current working set without restating the original search.

Examples:

• "enrich these"  
• "rank these"  
• "score these leads"  
• "prioritize this list"  
• "write outreach for these"  
• "export this list"  
• "learn more about these companies"

These phrases should map to workflow actions.

## Continuation Intent Mapping

### Enrichment intent

User phrases such as:

• "enrich these"  
• "look deeper into these"  
• "get more details"  
• "scrape their sites"  
• "find contact info"  
• "learn more about these companies"

should map to:

run enrichment on the active working set

### Ranking intent

User phrases such as:

• "rank these"  
• "score these leads"  
• "prioritize these"  
• "prioritize this list"  
• "rank this list"

should map to:

run ranking on the active working set

### Outreach drafting intent

User phrases such as:

• "write outreach"  
• "generate cold emails"  
• "draft messages"  
• "prepare emails"  
• "write outreach for these"

should map to:

run draft workflow on the active working set

### Export intent

User phrases such as:

• "save this list"  
• "download this"  
• "give me csv"  
• "export these leads"  
• "export this list"

should map to:

export the active working set

## Referential Language

The assistant should interpret phrases like:

• these  
• this list  
• those  
• these leads  
• these companies  
• the results  
• the last search

as references to the **active working set**.

---

# Assistant Behavior Rules

When the user runs discovery:

1. Execute the search  
2. Summarize results  
3. Store the working set  
4. Suggest next steps

Example:

"I found 10 tutoring centers in Los Angeles.

Next steps you might want:
• enrich these leads
• rank these leads
• generate outreach drafts
• export this list"

The assistant should treat these suggestions as natural continuations of the same workflow, not as unrelated commands.

---

# Ranking Behavior Rules

Ranking should not be treated as a separate disconnected feature.

It is part of the lead workflow and should operate on the active working set unless the user clearly requests something else.

Ranking should:

• score only the intended leads  
• persist the score and explanation  
• make prioritization visible to downstream steps  
• remain explainable and easy to debug

The assistant should not rank all stored leads by default unless the user explicitly asks for that behavior.

---

# No Working Set Behavior

If the user attempts a continuation action and **no working set exists**, the assistant should return a clear instruction.

Example:

No active working set found.

Run a discovery search first, then follow with enrichment, ranking, outreach drafting, or export.

The assistant should **not** guess which leads to use and should **not** run the action across all stored leads by default.

---

# Command Model

The lumen-scout workflow should support two command styles:

## Explicit workflow commands

Examples:

lumen-scout discover-web "private schools in Pasadena"

lumen-scout enrich

lumen-scout rank

lumen-scout draft --limit 10

These remain valid direct commands.

## Natural language continuation

Examples:

"enrich these"

"rank these"

"score these leads"

"write outreach for these"

"export this list"

These should resolve against the active working set.

If a unified continuation entrypoint exists, it should dispatch the appropriate workflow action without requiring the user to restate the original discovery query.

---

# Future Workflow Extensions

Possible additions:

• ranking-aware drafting  
• draft outreach for top 10  
• ranking-aware export  
• saving named lead sets  
• campaign pipelines  
• CRM sync

These future features should operate on the same **working set abstraction**.

They should extend the workflow without changing the core principle that discovery establishes the active context for follow-up actions.

---

# Summary

The lumen-scout workflow is:

Discovery → Working Set → Enrich → Rank → Draft → Export

Discovery creates the working set.

Subsequent actions operate on that set until a new discovery replaces it.

The assistant should guide users through this sequence naturally and interpret follow-up language as continuation of the current working set whenever possible.