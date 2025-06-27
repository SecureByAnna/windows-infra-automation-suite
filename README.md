# Windows Infrastructure Automation Suite

This project is a modular PowerShell toolkit designed to automate and standardize key tasks across a Windows-based infrastructure.

## 🚀 Core Features

- Server Inventory (hostname, OS, patch level, uptime, etc.)
- Service Monitoring (stopped/failed services on remote machines)
- GPO Analysis (unlinked/conflicting policies)
- Local Admin Audit (list users with local admin rights)
- Patch Status Reports
- Event Log Collection & Filtering

Each script is built with:
- Modular functions
- Logging and dry-run support
- Clean and readable output (CSV or HTML)

## Project Structure
modules/ # Core PowerShell scripts
scripts/ # Entry points to run modules
reports/ # Auto-generated reports
logs/ # Timestamped logs
notes/ # Design notes, troubleshooting, TODOs


## Why I Built This

I am a Security Administrator with experience in engineering, excited to build this toolkit to solve common infrastructure problems and prove hands-on automation capability using PowerShell.

## Current Progress

| Module               | Description                            | Status     |
|----------------------|----------------------------------------|------------|
| server_inventory.ps1 | Collects system info from remote hosts | Completed |
| service_monitor.ps1  | Detects stopped services               | Completed   |
| gpo_analyzer.ps1     | Lists and analyzes GPO links           | In Progress   |

---

Let’s automate everything. 💻⚙️  
