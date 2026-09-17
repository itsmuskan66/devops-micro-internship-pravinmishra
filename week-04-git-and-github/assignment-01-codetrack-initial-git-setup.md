# Assignment 1 — CodeTrack: Initial Git Setup (Local Only)

Part of the DevOps Micro Internship (DMI) with Agentic AI

---

## Purpose

In this assignment, you will set up Git correctly on your local machine before starting the CodeTrack project. You will create a local repository and configure your Git identity at both the repository level (local) and the machine level (global). This assignment is local only — you will not push anything to GitHub yet.

---

# Task 1 — Create the CodeTrack Project and Initialize Git

## Goal

Create a `CodeTrack` project folder and initialize it as a Git repository.

### Evidence

#### Screenshot 1 — Output of `git init` inside `CodeTrack` showing "Initialized empty Git repository"

![Screenshot 1](screenshots/a1-ss1.png)

---

#### Screenshot 2 — Output of `ls -a` showing the `.git` folder

![Screenshot 2](screenshots/a1-ss2.png)

---

### Notes

**1. What is the `.git` folder, and why does it matter?**

The `.git` folder is a hidden directory that Git creates automatically when you run `git init`. It is the repository itself — it stores everything Git needs to track the project: the full commit history, branch references, configuration settings, the staging area (index), remote URLs, and the object database that holds file content as compressed blobs. Without the `.git` folder, Git has no record of the project and none of the version control commands — such as `git status`, `git commit`, `git log`, or `git branch` — will work. Deleting it would permanently destroy all commit history and revert the folder to a plain directory with no version control. This is why the `.git` folder is considered the heart of a Git repository.

---

# Task 2 — Configure Git Identity Locally (Repository-Only)

## Goal

Set your Git username and email for the `CodeTrack` repository only, using `git config --local`.

### Evidence

#### Screenshot 3 — Output of `git config --local --list` showing your `user.name` and `user.email`

![Screenshot 3](screenshots/a1-ss3.png)

---

# Task 3 — Configure Git Identity Globally

## Goal

Set a global Git username and email for this machine using `git config --global`. Note that CodeTrack's local settings still take priority over these.

### Evidence

#### Screenshot 4 — Output of `git config --global --list` showing your `user.name` and `user.email`

![Screenshot 4](screenshots/a1-ss4.png)

---

# Task 4 — Share Your Git Setup Progress on WhatsApp Status

## Goal

Share that you have started your Git and version control journey on WhatsApp Status with your leaderboard progress link.

### Evidence

#### Screenshot 5 — Published WhatsApp Status showing your Git setup message and leaderboard progress link

![Screenshot 5](screenshots/a1-ss5.png)

---

# Submission Instructions

- Add all required screenshots in your submission
- Full Name must be visible in required screenshots
- Do not expose passwords, access tokens, or private keys

---

# Completion Checklist

- [x] `CodeTrack` folder created and initialized as a Git repository (Screenshots 1–2)
- [x] Explanation of the `.git` folder written in your own words
- [x] Local `user.name` and `user.email` configured and verified (Screenshot 3)
- [x] Global `user.name` and `user.email` configured and verified (Screenshot 4)
- [x] WhatsApp Status published with leaderboard progress link (Screenshot 5)
- [x] No sensitive data exposed

---

## 📌 About DMI & CloudAdvisory

DevOps Micro Internship (DMI) is a project-based DevOps program run by Pravin Mishra (The CloudAdvisory) focused on real-world execution, systems thinking, and career readiness.

It helps learners build strong DevOps foundations with hands-on experience.

---

## 📌 Resources

- 🌐 DMI Official Website: https://dmi.pravinmishra.com?utm_source=github&utm_medium=readme  
- 🎓 University: https://university.pravinmishra.com?utm_source=github&utm_medium=readme  
- 💬 Discord Community: https://discord.pravinmishra.com?utm_source=github&utm_medium=readme  
- 📝 Blog: https://dmi.pravinmishra.com/blog?utm_source=github&utm_medium=readme  
- ▶️ YouTube Playlist: https://www.youtube.com/playlist?list=PLFeSNDtI4Cho  
- 🔗 Pravin Mishra (LinkedIn): https://www.linkedin.com/in/pravin-mishra-aws-trainer/  
- 🏢 CloudAdvisory (LinkedIn): https://www.linkedin.com/company/thecloudadvisory/

---

*This submission is part of DevOps Micro Internship (DMI) — Agentic AI Track.*
