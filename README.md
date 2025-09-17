# Dell R730xd Fan Control Script

This repository contains a **Linux shell script** to manually control the fans of a Dell R730xd server via **iDRAC IPMI**.  
It allows setting fan speed from 10% to 100% and automatically handles safety checks based on temperature readings.

---

## ⚡ Features

- Read server fan speeds and temperatures via iDRAC.
- Switch between **automatic** and **manual fan control**.
- Set fan speed as a percentage (10–100%).
- Safety checks to avoid overheating.
- Simple shell script – just run and provide the fan speed.

---

## 🖥️ Prerequisites

- Dell R730xd server with **iDRAC** configured.  
- Linux system with network access to iDRAC.  
- `ipmitool` installed on your Linux machine.

> **Example:** On Proxmox/Debian-based systems:
> ```bash
> apt update
> apt install ipmitool
> ```

---
