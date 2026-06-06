---
title: 'Scanners-Box: 200+ Cybersecurity Tools Collection for Security Professionals'
description: Discover Scanners-Box - a comprehensive collection of 200+ open-source
  cybersecurity tools for penetration testing, vulnerability scanning, and security
  research.
date: 2026-05-15 04:20:25+09:00
lastmod: 2026-05-15 04:20:25+09:00
tech_stack:
- Docker
- Go
- JavaScript
- Python
- Rust
application_domain: Dev Utils
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: "236 KB"
file_md5: ''
download_url: https://github.com/luckybbjason1/Scanners-Box
backup_url: ''
github_repo: https://github.com/luckybbjason1/Scanners-Box
stars: 0
maintainer: "luckybbjason1"
last_maintained: "2023-09-21"
featureImage: ''
draft: false
aliases:
- /en/posts/scanners-box-cybersecurity-tools-collection/
- /posts/scanners-box-cybersecurity-tools-collection/
faqs:
  - q: 'What is Scanners-Box?'
    a: 'Scanners-Box is a curated collection of 200+ open-source cybersecurity tools across 15+ categories, covering subdomain enumeration, SQL injection, fuzzing, port scanning, social engineering, and more. It was originally created for the Chinese security community (t00ls) and is aimed at penetration testers and security researchers.'
  - q: 'Which tools does Scanners-Box recommend for SQL injection testing?'
    a: 'Its main recommendation is sqlmap, which automatically detects and exploits SQL injection, supports 6 database types, and includes tamper scripts for WAF bypass. The collection also lists jsql-injection, SQLiScanner, and NoSQLAttack.'
  - q: 'What is the difference between Nmap and masscan for port scanning?'
    a: 'Nmap is the standard network scanner offering service/version detection and scripting (e.g. vulnerability scripts via --script=vuln), while masscan is the fastest Internet port scanner, capable of scanning the entire Internet in about 6 minutes using asynchronous transmission. masscan is Nmap-compatible, so the two are often used together.'
  - q: 'What fuzzing tools are included in Scanners-Box?'
    a: 'It lists 20+ fuzzers including AFL (American Fuzzy Lop), honggfuzz, syzkaller, and libFuzzer. AFL is coverage-guided and has found thousands of bugs in real software, while syzkaller is a Linux kernel fuzzer that has found over 3000 kernel bugs and is used by Google and Microsoft.'
  - q: 'Are penetration testing tools like those in Scanners-Box legal to use?'
    a: 'These tools are legal only for authorized security testing; using them against systems without explicit written permission is illegal and unethical. Relevant laws include the US Computer Fraud and Abuse Act (CFAA), the UK Computer Misuse Act, China''s Cybersecurity Law, and the EU GDPR, so always obtain written authorization and define scope before testing.'
---
{</* resource-info */>}

## What is Scanners-Box?

**Scanners-Box** is a curated collection of **200+ open-source cybersecurity tools** for security professionals, penetration testers, and ethical hackers. Originally created for the Chinese security community (t00ls), it covers every aspect of cybersecurity from reconnaissance to exploitation.

**GitHub**: https://github.com/luckybbjason1/Scanners-Box  
**License**: Open Source Collection  
**Tools Count**: 200+  
**Categories**: 15+

---

## Tool Categories Overview

| Category | Tool Count | Examples |
|----------|-----------|----------|
| **Subdomain Enumeration** | 15+ | subDomainsBrute, amass, subfinder, OneForAll |
| **Database & SQL Injection** | 10+ | sqlmap, jsql-injection, SQLiScanner, NoSQLAttack |
| **Fuzzing Tools** | 20+ | AFL, honggfuzz, syzkaller, libFuzzer |
| **Port Scanning & Fingerprinting** | 25+ | Nmap, masscan, whatweb, wafw00f |
| **Weak Password & Info Leak** | 15+ | htpwdScan, BBScan, GitHack, truffleHog |
| **IoT Device Scanning** | 5+ | IoTSeeker, RouterSploit, routersploit |
| **XSS Exploitation** | 10+ | BruteXSS, XSS-Radar, XSSTracer, easyXssPayload |
| **Social Engineering** | 15+ | SET, gophish, evilginx2, blackeye |
| **WebShell Detection** | 10+ | findWebshell, HaboMalHunter, PHP-Shell-Detector |
| **Enterprise Network Audit** | 5+ | theHarvester, xunfeng, LNScan |
| **Vulnerability Scanners** | 15+ | vulfocus, vulhub, VulApps, upload-labs |
| **Wireless Security** | 5+ | fern-wifi-cracker, aircrack-ng |
| **Asset Discovery** | 5+ | linglong, H, nemo_go, NextScan |
| **Threat Intelligence** | 3+ | threat-intelligence, VirusTotal, ThreatBook |
| **Learning Resources** | 20+ | sec-wiki, FreeBuf, Web Hacking 101 |

---

## Featured Tools Deep Dive

### 1. Subdomain Enumeration

**OneForAll** — The most comprehensive subdomain collection tool
- Integrates 20+ data sources
- Supports API keys for better results
- Export to various formats

**amass** — Go-based subdomain enumeration
- Fast and efficient
- DNS, scraping, and certificate transparency
- Graph visualization output

### 2. SQL Injection

**sqlmap** — The king of SQL injection tools
- Automatic detection and exploitation
- Support for 6 database types
- Tamper scripts for WAF bypass

```bash
# Basic usage
sqlmap -u "http://target.com/page.php?id=1" --dbs

# Dump specific table
sqlmap -u "http://target.com/page.php?id=1" -D database -T users --dump
```

### 3. Fuzzing Frameworks

**AFL (American Fuzzy Lop)** — Coverage-guided fuzzing
- Discovers vulnerabilities automatically
- Generates test cases
- Found 1000s of bugs in real software

**syzkaller** — Linux kernel fuzzer
- Found 3000+ Linux kernel bugs
- Used by Google, Microsoft
- Supports multiple operating systems

### 4. Port Scanning

**Nmap** — The network scanner king
```bash
# Basic scan
nmap -sV -sC target.com

# Full port scan with scripts
nmap -p- -sV --script=vuln target.com

# Aggressive scan
nmap -A target.com
```

**masscan** — Fastest Internet port scanner
- Scan entire Internet in 6 minutes
- Compatible with Nmap
- Asynchronous transmission

### 5. Social Engineering Toolkit

**SET (Social-Engineer Toolkit)** — Complete phishing framework
- Website cloning
- Email spear-phishing
- Credential harvesting
- Multi-attack vectors

**evilginx2** — Bypass 2FA phishing framework
- Man-in-the-middle attack
- Session cookie capture
- Bypass two-factor authentication

---

## Security Learning Resources

### For Beginners
- **sec-wiki** — Security Wikipedia
- **FreeBuf** — Hacker and geek news
- **Web Hacking 101** — Web security basics
- **Kali Linux Web Pentest Cookbook**

### For Intermediate
- **Burpsuite实战指南** — Web penetration testing
- **API-Security-Checklist** — API security best practices
- **Web-Security-Learning** — Comprehensive web security
- **应急响应实战笔记** — Emergency response

### Advanced Topics
- **Linux exploit development tutorial**
- **Android penetration testing**
- **Node.js Web security issues**
- **Python security series**

---

## Vulnerable Targets for Practice

| Platform | Description | Link |
|----------|-------------|------|
| **vulfocus** | Docker-based vulnerability platform | GitHub |
| **vulhub** | Pre-built vulnerable environments | GitHub |
| **VulApps** | Vulnerable application collection | GitHub |
| **upload-labs** | File upload vulnerability practice | GitHub |
| **bWAPP** | Buggy Web Application | SourceForge |
| **DVWA** | Damn Vulnerable Web Application | GitHub |
| **WebGoat** | OWASP Web security practice | GitHub |

---

## Responsible Disclosure

> **⚠️ Warning**: All tools listed here are for authorized security testing only. Using these tools against systems without explicit permission is illegal and unethical.

### Legal Framework
- **CFAA** (Computer Fraud and Abuse Act) — US
- **Computer Misuse Act** — UK
- **Cybersecurity Law** — China
- **GDPR** — EU data protection

### Best Practices
1. Always obtain written authorization
2. Define scope clearly
3. Respect business hours
4. Report findings promptly
5. Destroy data after testing

---

## Tool Selection Guide

### Web Application Testing
```
Reconnaissance: amass, subfinder, theHarvester
Scanning: Nmap, masscan, whatweb
Vulnerability: sqlmap, XSS scanners, dirsearch
Exploitation: Burp Suite, custom scripts
Reporting: Dradis, Faraday
```

### Network Penetration Testing
```
Discovery: Nmap, masscan, nbtscan
Enumeration: enum4linux, snmp-check
Vulnerability: OpenVAS, Nessus
Exploitation: Metasploit, Cobalt Strike
Post-exploitation: PowerShell Empire, Mimikatz
```

### Red Team Operations
```
Initial Access: SET, gophish, evilginx2
Persistence: Custom implants, scheduled tasks
Privilege Escalation: PowerUp, BeRoot
Lateral Movement: Pass-the-hash, Kerberoasting
Exfiltration: DNS tunneling, HTTPS C2
```

---

## Related Articles

- [Agent Reach: AI Agent Internet Access](/resources/llm-frameworks/agent-reach-ai-agent-internet-access/) — AI-powered security automation
- [Free Claude Code: Open Source AI Coding](/resources/ai-tools/free-claude-code-open-source-proxy/) — Secure coding practices

---

*Disclaimer: This article is for educational purposes only. All tools should be used responsibly and only on systems you own or have explicit permission to test. The author and dibi8.com are not responsible for any misuse of the information provided.*

---

## Recommended Tools

For developers building or deploying open-source AI tools, we recommend:

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — $200 free credit for new users, 14+ global regions, one-click GPU/CPU droplets ideal for AI workloads.
- **{{< aff "htstack" "category-footer" "HTStack" >}}** — Hong Kong VPS, same IDC that hosts dibi8.com. Self-host security scanners on dedicated VPS for low-latency Asia coverage and no shared-tenant noise.

*Affiliate link — supports dibi8.com at no cost to you.*

<!--auto-references-->
## References & Sources

- [sqlmap](https://github.com/sqlmapproject/sqlmap)
- [Nmap](https://github.com/nmap/nmap)
- [masscan](https://github.com/robertdavidgraham/masscan)
- [amass](https://github.com/owasp-amass/amass)
- [OneForAll](https://github.com/shmilylty/OneForAll)
- [AFL (American Fuzzy Lop)](https://github.com/google/AFL)
- [honggfuzz](https://github.com/google/honggfuzz)
- [syzkaller](https://github.com/google/syzkaller)
- [SET (Social-Engineer Toolkit)](https://github.com/trustedsec/social-engineer-toolkit)
- [gophish](https://github.com/gophish/gophish)
- [evilginx2](https://github.com/kgretzky/evilginx2)
- [RouterSploit](https://github.com/threat9/routersploit)
- [theHarvester](https://github.com/laramies/theHarvester)
- [vulhub](https://github.com/vulhub/vulhub)
- [upload-labs](https://github.com/c0ny1/upload-labs)
- [DVWA](https://github.com/digininja/DVWA)
- [WebGoat](https://github.com/WebGoat/WebGoat)
- [aircrack-ng](https://github.com/aircrack-ng/aircrack-ng)
- [fern-wifi-cracker](https://github.com/savio-code/fern-wifi-cracker)
- [subfinder](https://github.com/projectdiscovery/subfinder)
- [API-Security-Checklist](https://github.com/shieldfy/API-Security-Checklist)
