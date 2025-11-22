# Linux Scripts

A collection of **practical Linux administration scripts** I use in my daily work as a Linux / DevOps engineer.

The goal of this repository is to provide **simple, readable Bash scripts** for:

- backups and snapshots
- monitoring (disk, load, services)
- maintenance and cleanup
- basic security checks

Most scripts are referenced and explained in more detail on my blog:  
👉 https://emr3.me

---

## Structure

- `backup-scripts/` – ZFS snapshots, rsync backups, rotation helpers  
- `monitoring-scripts/` – health checks for disks, load, ZFS, services  
- `maintenance-scripts/` – log cleanup, Docker cleanup, journal cleanup  
- `security-scripts/` – Fail2ban reports, SSH login overviews  

---

## Usage

Clone the repo:

```bash
git clone https://github.com/emrehayta/linux-scripts.git
cd linux-scripts
