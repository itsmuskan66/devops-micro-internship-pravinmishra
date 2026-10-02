# Assignment 4 — Building Your AI Team

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will build and configure a set of specialized AI subagents inside your project. You will learn how different models and tool permissions define agent behavior, and you will trigger two real agent delegations to analyze security and cost aspects of your Terraform infrastructure.

---

# Task 1 — Create the Agents Folder and Add Files

## Goal

Create the `.claude/agents/` directory and add all required agent files.

### Evidence

#### Screenshot 1 — VS Code sidebar showing `.claude/agents/` with all 3 files

Add your screenshot here.
![aSIGNMENT4](./screenshots/A4_s1.jpg)




# Task 2 — Compare the Agent Configurations

## Goal

Analyze the configuration differences between the three agents and demonstrate understanding of model and tool selection.

### Written Answers

#### 1. Why does the cost optimizer use Haiku instead of Sonnet?
Cost optimization is a relatively straightforward, pattern-matching task — it mainly involves reading Terraform resource definitions and comparing them against known pricing/sizing rules, rather than deep reasoning or complex problem-solving. Haiku is faster and cheaper to run than Sonnet, so using it for a lighter-weight, repetitive task like this keeps the agent efficient without sacrificing the quality needed for the job.

#### 2. Why does the security auditor NOT have Write in its tools list?
A security auditor's job is to review and report issues, not to modify infrastructure code. By excluding Write from its allowed tools, the agent is restricted to a read-only role — it can inspect files, run checks, and flag vulnerabilities, but it cannot accidentally (or maliciously) alter the actual Terraform configuration. This enforces a safe separation between "auditing" and "changing" the infrastructure.

#### 3. Why does the tf-writer use `inherit` instead of a specific model?
The tf-writer agent is responsible for generating and modifying Terraform code, which can require more complex reasoning depending on the task's difficulty — from simple resource additions to complicated multi-resource configurations. Using inherit means it automatically uses whatever model the main session is running (instead of being locked to one fixed model), giving it flexibility to match the capability level of the parent conversation rather than being over- or under-powered for the task.

### Evidence

#### Screenshot 2 — `security-auditor.md` frontmatter showing model and tools configuration

Add your screenshot here.
![aSIGNMENT4](./screenshots/A4_s2.jpg)

---

#### Screenshot 3 — `cost-optimizer.md` frontmatter showing the model and tools configuration


![aSIGNMENT4](./screenshots/A4_s3.jpg)


# Task 3 — Run the Security Auditor

## Goal

Trigger the security auditor agent and analyze the generated security report for your Terraform infrastructure.

### Evidence

#### Screenshot 4 — The delegation message showing Claude launched the security-auditor

Add your screenshot here.
![aSIGNMENT4](./screenshots/A4_S4.jpg)



#### Screenshot 5 — Security audit report output

Add your screenshot here.
![aSIGNMENT4](./screenshots/A4_S5.jpg)



# Task 4 — Run the Cost Optimizer

## Goal

Trigger the cost optimizer agent and review the generated cost optimization report.

### Evidence

#### Screenshot 6 — The full cost optimization report

Add your screenshot here.
![aSIGNMENT4](./screenshots/A4_S6.jpg)
![aSIGNMENT4](./screenshots/A4_S7.jpg)



# Submission Instructions

- Ensure all agent files are committed in `.claude/agents/`
- Complete all written answers in your GitHub Repo
- Push final changes to your forked GitHub repository

---

## GitHub Repository URL

Paste your forked repository URL here:


https://github.com/itsmuskan66/Ultimate-Agentic-DevOps-with-Claude-Code.git


# Completion Checklist

 [✅ ] `.claude/agents/` folder contains all 3 agent files
 [✅ ] Screenshot 2 shows correct `security-auditor.md` configuration
 [✅ ] Screenshot 3 shows correct `cost-optimizer.md` configuration
 [✅ ] All 3 written answers completed 
 [✅ ] Security auditor executed successfully
 [✅ ] Cost optimizer executed successfully
 [✅ ] Security report is visible with findings
 [✅ ] Cost report is visible with recommendations
 [✅ ] All required screenshots added
 [✅ ] GitHub repo updated with agents

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

*This submission is part of DevOps Micro Internship (DMI) Cohort 3 — Agentic AI Track.*
