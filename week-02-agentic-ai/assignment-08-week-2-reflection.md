# Assignment 8 — Week 2 Reflection Blog

Part of the DevOps Micro Internship (DMI) with Agentic AI

---

# Purpose

In this assignment, you will reflect on your Week 2 learning journey and write a short blog capturing your experience working with Agentic AI tools such as Claude Code, Skills, Subagents, MCP, Hooks, Permissions, and Memory.

You will also publish a LinkedIn post summarizing your learning and share both links for evaluation.

---

# Task 1 — Write Your Reflection Blog

## Goal

Write a reflection blog covering your Week 2 learning experience.

### Blog Requirements

Your blog must include:

* Title: **Reflection – Week 2**
* Minimum 300 words
* At least 2–3 topics from Week 2 (Claude Code, Skills, Subagents, MCP, Hooks, Permissions, Memory)
* Honest personal reflection (learning, challenges, mindset)
* One habit/system you plan to implement
* Your full name clearly visible

### Allowed Platforms

You can publish your blog on:

* Hashnode
* Medium
* Dev.to
* LinkedIn Article
* GitHub Markdown file
* Substack

---

## Blog Content — Javeson Francois Liu

### Reflection – Week 2: How I Gave an AI a Memory, Safety Rails, and a Team

**By Javeson Francois Liu**

Week 2 of the DevOps Micro Internship with Agentic AI was not what I expected. I thought it would be about learning Claude Code features. What I actually learned was how to think about AI as infrastructure — something you configure, constrain, and connect to external systems, not just something you prompt.

**CLAUDE.md: Context as Configuration**

The most mind-shifting moment came early with `CLAUDE.md`. Before I added it, asking Claude about my project gave me a generic answer. After I defined the project rules — S3, CloudFront, Terraform, no JavaScript — Claude stopped suggesting React and started referencing my actual stack. That is when I realized the real skill in agentic AI is not crafting clever prompts. It is defining the context clearly enough that the AI stays in bounds without being micromanaged every session.

**Skills: Reusable Automation**

Skills changed how I think about repetition. Running `/scaffold-terraform` and watching Claude read the template specification and generate five Terraform files — that is not just convenient. That is the same principle behind infrastructure as code. Instead of writing Terraform by hand every project, I write the spec once and the skill handles the rest. The fact that `tf-plan` uses `allowed-tools: Bash, Read, Grep` and blocks Write access is exactly the principle of least privilege applied to AI agents.

**Subagents: Specialization Over Generalization**

Building the security auditor, cost optimizer, and Terraform writer as separate agents taught me something I have seen in every well-functioning engineering team: specialization reduces errors. The security auditor does not have Write access because an auditor should never touch what it is reviewing. The cost optimizer runs on Haiku because cost pattern matching does not need the same reasoning depth as security analysis. These are engineering decisions, not configuration details.

**Hooks and Permissions: AI Safety by Design**

This was the hardest part to appreciate at first, but the most important. The `UserPromptSubmit` hook that blocks destructive intent before Claude even processes the request — that is not a workaround for a bad AI. That is defense in depth. You do not trust any system with your infrastructure unconditionally. You add guardrails at every layer.

**Memory: Persistence Across Sessions**

Memory was the feature that made everything feel coherent. Closing a session and reopening it to find Claude still knows the CSS hero colors and the JavaScript restriction — that is what turns a chatbot into a persistent collaborator.

**One System I Will Implement**

Starting every new project with a `CLAUDE.md` before writing a single line of code. Define the stack, the constraints, the conventions. That single habit will save more time than any prompt optimization.

Week 2 taught me that working with agentic AI well is a form of systems thinking. You are not just using a tool — you are designing the conditions under which the tool operates safely and effectively.

---

### Evidence

#### Screenshot 1 — Blog published and visible

Add your screenshot here.

---

### Submission Field

Blog Link:

`Add your URL here`

---

# Task 2 — Create LinkedIn Post

## Goal

Share your Week 2 learning publicly on LinkedIn.

---

### Evidence

#### Screenshot 2 — LinkedIn post published

Add your screenshot here.

---

### Submission Field

LinkedIn Post Content (copy-paste here):

```
Week 2 of DMI done — and this one changed how I think about AI.

This week I went beyond prompting. I configured Claude Code with:

- CLAUDE.md to define project context and rules
- Skills (/scaffold-terraform, /tf-plan) for reusable automation
- Specialized subagents for security, cost, and Terraform writing
- MCP to connect Claude to live GitHub data
- Hooks and permissions to block destructive commands before they execute
- Memory so Claude remembers project facts across sessions

The biggest insight: agentic AI is infrastructure, not just tooling. You configure it, constrain it, and connect it — the same way you think about cloud architecture.

Read my full reflection: [BLOG LINK]

View my DMI progress: https://dmi.pravinmishra.com/s/javesonfrancoisliu.html

#DMIByPravinMishra #AgenticAI #ClaudeCode #DevOps
```

---

### LinkedIn Post Link:

`Add your URL here`

---

# Submission Instructions

* Blog must be publicly accessible
* LinkedIn post must be visible (public or unlisted where applicable)
* All required fields must be filled
* Screenshot proofs must be added to GitHub repository
* Do not include sensitive information in blog or post

---

# Completion Checklist

* [ ] Blog written with required structure
* [ ] Blog includes at least 2–3 Week 2 topics
* [ ] Blog is publicly accessible
* [ ] LinkedIn post created
* [ ] Required P.S. line included
* [ ] LinkedIn post content copied in submission field
* [ ] Blog link added
* [ ] LinkedIn post link added
* [ ] Screenshots added to GitHub repo

---

# About DMI & CloudAdvisory

DevOps Micro Internship (DMI) is a project-based DevOps program run by Pravin Mishra (The CloudAdvisory), focused on real-world execution, systems thinking, and agentic AI workflows.

It helps learners build strong DevOps foundations through hands-on experience.

---

# Resources

* 🌐 DMI Official Website: [https://dmi.pravinmishra.com?utm_source=github&utm_medium=readme](https://dmi.pravinmishra.com?utm_source=github&utm_medium=readme)
* 🎓 University: [https://university.pravinmishra.com?utm_source=github&utm_medium=readme](https://university.pravinmishra.com?utm_source=github&utm_medium=readme)
* 💬 Discord Community: [https://discord.pravinmishra.com?utm_source=github&utm_medium=readme](https://discord.pravinmishra.com?utm_source=github&utm_medium=readme)
* 📝 Blog: [https://dmi.pravinmishra.com/blog?utm_source=github&utm_medium=readme](https://dmi.pravinmishra.com/blog?utm_source=github&utm_medium=readme)
* ▶️ YouTube Playlist: [https://www.youtube.com/playlist?list=PLFeSNDtI4Cho](https://www.youtube.com/playlist?list=PLFeSNDtI4Cho)
* 🔗 Pravin Mishra (LinkedIn): [https://www.linkedin.com/in/pravin-mishra-aws-trainer/](https://www.linkedin.com/in/pravin-mishra-aws-trainer/)
* 🏢 CloudAdvisory (LinkedIn): [https://www.linkedin.com/company/thecloudadvisory/](https://www.linkedin.com/company/thecloudadvisory/)
---

*This submission is part of DevOps Micro Internship (DMI) — Agentic AI Track.*
