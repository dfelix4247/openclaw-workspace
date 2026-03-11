# OpenClaw Lead Discovery Workspace

This repository contains the runtime workspace used to operate the OpenClaw agent system for lead discovery and outreach automation.

The system combines:

- **OpenClaw** agent orchestration
- **lumen-router** for natural language routing
- **lumen-scout** for lead discovery, enrichment, ranking, and outreach drafting
- **buyer-scout** for BBB-based business discovery
- **scout-core** for lead persistence and shared models

The workflow enables natural language lead discovery such as:

find tutoring centers in Glendale

followed by continuation commands:

enrich these  
rank these  
write outreach for these  
export this list

---

# Workflow

Discovery → Working Set → Enrich → Rank → Draft → Export

The assistant maintains a working set so follow-up actions do not require repeating the search query.

---

# Running the System

See:

README_RUN.md

for full setup and execution instructions.

---

# Repository Structure

openclaw-workspace  
│  
├── lumen-scout  
├── buyer-scout  
├── lumen-router  
├── requirements.txt  
├── README_RUN.md  
├── .env.example  
└── run.ps1
