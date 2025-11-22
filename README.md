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

## 📦 Categories

### 🔐 **backup-scripts/**
Scripts to simplify automated backup processes.

- `zfs-snapshot.sh` — automated ZFS snapshots  
- `rsync-backup.sh` — rsync-based directory backup

---

### 📊 **monitoring-scripts/**
Lightweight monitoring utilities for Linux systems.

- `check-disk-usage.sh`
- `check-load-average.sh`
- `check-zpool-status.sh`
- `check-services.sh` — checks if required systemd services are running

---

### 🧹 **maintenance-scripts/**
Housekeeping & performance-improving cleanup scripts.

- `cleanup-logs.sh`
- `cleanup-docker.sh`
- `rotate-journal.sh`

---

### 🛡️ **security-scripts/**
Security helpers to keep your system clean and safe.

- `fail2ban-report.sh` — list offenders & ban statistics  
- `ssh-login-report.sh` — shows recent SSH login attempts

---

### 🌐 **network-scripts/**
Small but powerful tools for network diagnostics.

- `ping-test.sh` — quick connectivity test with summary  
- `dns-lookup.sh` — DNS resolution checks via multiple resolvers  
- `check-ports.sh` — test TCP ports via netcat  

---

## 🚀 Usage

Make a script executable:

```bash
chmod +x script.sh