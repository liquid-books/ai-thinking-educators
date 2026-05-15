---
title: "Addendum H: Quick Reference Cards"
short_title: "Addendum H"
description: "Cheat sheets for Gemini, NotebookLM, AI Studio, and Google Antigravity"
label: addendum-h
---

# Addendum H: Quick Reference Cards

> **How to use these cards:** Print one per page, laminate, and keep at your desk. Each card covers one tool — what it is, when to use it, and how to avoid the most common mistakes.

---

## Card 1 — Gemini

**gemini.google.com · Personal Google account required**

**What it is:** Gemini is Google's conversational AI assistant — a general-purpose thinking partner that reads, writes, analyzes, and reasons across text, images, and documents.

### Best For

| # | Teacher Use Case |
|---|-----------------|
| 1 | Drafting lesson plans, rubrics, and syllabi from a brief description |
| 2 | Differentiating a single activity for multiple reading levels |
| 3 | Generating quiz questions, discussion prompts, or exit tickets |
| 4 | Summarizing research articles or PDFs you upload |
| 5 | Writing parent/guardian communication in plain language |
| 6 | Brainstorming project ideas, analogies, or real-world examples |

### Access

- Go to **gemini.google.com**
- Sign in with your **personal** Google account
- School/institution accounts may have Gemini features restricted by IT policy — use personal account for full access

### Gems — Your Custom AI Personas

**What they are:** Gems are saved Gemini configurations with a custom name, instructions, and persona. Create one for each role you play repeatedly (e.g., "Rubric Writer," "Quiz Generator," "Parent Email Helper").

**How to create a Gem (3 steps):**

1. Click **"Explore Gems"** → **"New Gem"** in the left sidebar
2. Give it a name, describe its role, and paste in your standing instructions (e.g., *"You help me write rubrics aligned to Bloom's Taxonomy for undergraduate business courses"*)
3. Click **Save** — the Gem appears in your sidebar for instant reuse

### Power Tips

```{tip} 5 Prompting Tips for Teachers
1. **Give context first** — Start with: *"I teach [subject] to [grade/level] students at [institution]."* Better context = better output.
2. **Use the constraint trick** — Add *"in under 200 words"* or *"as a bulleted list"* to get scan-friendly output.
3. **Iterate, don't restart** — Say *"Make it shorter," "Add a rubric," or "Now write a version for struggling learners"* to refine in the same chat.
4. **Upload your materials** — Paste a syllabus or upload a PDF and ask Gemini to work *from that document*, not its general knowledge.
5. **Ask for options** — *"Give me three different versions"* lets you pick the best one rather than guessing on the first try.
```

### Watch Out For

```{caution} 3 Common Mistakes
1. **Trusting without verifying** — Gemini can confidently state outdated facts or hallucinate citations. Always verify statistics, dates, and sources before sharing with students.
2. **Vague prompts** — *"Help me with my class"* produces generic output. The more specific your prompt, the more useful the response.
3. **Using your school account and hitting walls** — If features are missing or grayed out, switch to your personal Google account. Institution policies often restrict AI tools.
```

---

## Card 2 — NotebookLM

**notebooklm.google.com · Personal Google account required**

**What it is:** NotebookLM is an AI research assistant that reads only the sources *you* provide — letting you query, summarize, and explore your own documents, articles, and videos without the AI wandering off into the open internet.

### Best For

| # | Teacher Use Case |
|---|-----------------|
| 1 | Building a private Q\&A assistant from your course readings or textbook chapters |
| 2 | Generating a Study Guide or FAQ from your syllabus and lecture notes |
| 3 | Creating an Audio Overview (podcast-style summary) students can listen to |
| 4 | Cross-referencing multiple sources to find connections or contradictions |
| 5 | Letting students explore a curated source set without access to unvetted web content |
| 6 | Reviewing and summarizing student-submitted papers or research packets |

### Access

- Go to **notebooklm.google.com**
- Sign in with your **personal** Google account
- Create a **new notebook** for each project, course, or unit

### Key Features

| Feature | What It Does |
|---------|-------------|
| **Sources panel** | Left sidebar — add, view, and manage all your loaded documents |
| **Chat** | Ask questions; answers cite the exact source and page number |
| **Study Guide** | Auto-generates key themes, glossary, practice questions, and timeline |
| **Audio Overview** | Produces a ~10-minute AI-hosted "podcast" summarizing your sources |
| **Mind Map** | Visual concept map showing how ideas connect across your sources |

### 5 Ways to Load Sources

1. **URL** — Paste any public webpage link (article, blog, news story)
2. **PDF upload** — Upload from your computer (research papers, handouts, textbooks)
3. **Google Drive** — Connect directly to Docs, Slides, or PDFs in your Drive
4. **Paste text** — Copy-paste any raw text directly into the source panel
5. **YouTube link** — Paste a YouTube URL; NotebookLM reads the transcript

### Power Tips

```{tip} 5 Tips for NotebookLM
1. **Start every notebook with a "Notebook Guide"** — Ask the chat: *"Summarize all my sources and identify the three most important themes."* Great orientation for any new project.
2. **Use it as a student study tool** — Share the notebook link (view-only) so students can ask questions of your curated readings at their own pace.
3. **Create one notebook per unit** — Keeps sources focused; the AI answers better with targeted rather than sprawling source sets.
4. **Cite-check everything** — Hover over any AI answer to see the yellow citation highlights in the source. Teach students to do the same.
5. **Use the Study Guide for test prep** — Hit "Study Guide" for an instant set of practice questions drawn from your exact materials — no manual question-writing needed.
```

### Watch Out For

```{caution} 3 Limitations to Know
1. **Only your sources — not the web** — NotebookLM cannot search the internet. If you ask about something not in your sources, it will say so (or may decline to answer). This is a feature, not a bug — but students expecting web search will be surprised.
2. **No editing sources after upload** — Once a source is loaded, you cannot edit its content inside NotebookLM. To update a document, delete the source and re-upload the revised version.
3. **Audio Overview is read-only** — You cannot edit the script or re-record the Audio Overview. If your source set changes, regenerate it from scratch.
```

---

## Card 3 — AI Studio

**aistudio.google.com · Free tier available**

**What it is:** AI Studio is Google's developer-facing playground for Gemini models — giving educators direct access to raw model settings, system instructions, and API keys to build custom AI-powered tools and workflows.

### Best For

| # | Teacher Use Case |
|---|-----------------|
| 1 | Building a reusable AI tool with a fixed persona (e.g., a Socratic tutor that never gives direct answers) |
| 2 | Stress-testing prompts before deploying them in a class activity |
| 3 | Experimenting with multimodal input — upload images, audio, or video for analysis |
| 4 | Generating structured output (JSON, tables, formatted lists) for gradebook or LMS import |
| 5 | Getting an API key to connect Gemini to Google Sheets, Docs, or a course app |
| 6 | Comparing how different Gemini models respond to the same prompt |

### Access

- Go to **aistudio.google.com**
- Sign in with a Google account — **free tier available** (rate limits apply)
- Paid tiers unlock higher quotas and access to the latest models

### Key Controls

| Control | What It Does |
|---------|-------------|
| **Model selector** | Switch between Gemini Flash (fast/cheap), Gemini Pro (balanced), and Gemini Ultra (most capable) |
| **Temperature** | 0 = precise and deterministic → 1 = creative and varied. Use 0–0.3 for factual tasks; 0.7–1.0 for creative tasks |
| **Token limit** | Sets the maximum length of the AI's response. Increase for long documents; decrease to force brevity |
| **System Instructions panel** | The hidden "rulebook" — write standing instructions the model follows for every message in the session |

### Power Tips

```{tip} 5 Tips for AI Studio
1. **Write your System Instructions like an employee handbook** — Be explicit: *"You are a writing coach for college freshmen. Never write the essay for the student. Ask guiding questions only. Keep responses under 150 words."*
2. **Use the Compare feature** — Run the same prompt across two models side-by-side to choose the best one for your use case.
3. **Save prompts as presets** — Name and save your best prompts. Reuse them next semester instead of rebuilding from memory.
4. **Grab the API key** — Even if you're not a developer, your API key lets Google Apps Script (in Sheets or Docs) call Gemini directly — no third-party tools needed.
5. **Lower the temperature for rubrics and grading** — Set temperature to 0.2 for consistent, repeatable output when scoring or evaluating student work.
```

### Watch Out For

```{caution} 3 Mistakes in AI Studio
1. **Forgetting System Instructions reset per session** — System Instructions don't persist automatically. Save them in a text file and paste them at the start of each new session.
2. **Ignoring token costs on paid tiers** — Long documents + large models = rapid token burn. Monitor your usage dashboard, especially during batch tasks.
3. **Treating it like a chat interface** — AI Studio is a *lab*, not a conversational assistant. It's optimized for prompt engineering and testing, not back-and-forth dialogue. Use Gemini.google.com for day-to-day conversation.
```

---

## Card 4 — Google Antigravity

**antigravity.google**

**What it is:** Google Antigravity is an agentic AI platform that lets you build and run autonomous AI agents — programs that can plan multi-step tasks, use tools (search, email, calendar, code), and remember context across long workflows without you manually directing every step.

### Best For

| # | Teacher Use Case |
|---|-----------------|
| 1 | Automating repetitive administrative workflows (e.g., weekly grade summary emails) |
| 2 | Building a research agent that searches, reads, and synthesizes sources on a topic |
| 3 | Creating a student-facing tutoring agent with guardrails and a fixed persona |
| 4 | Running multi-step course design: outline → lessons → assessments → rubrics in one run |
| 5 | Connecting your course tools (calendar, Drive, Sheets) into a single orchestrated workflow |
| 6 | Prototyping AI-integrated classroom activities without writing code |

### Access

- Go to **antigravity.google**
- Sign in with your Google account
- Some features may require joining a waitlist or early-access program — check the site for current availability

### Key Concepts

| Concept | Plain-English Explanation |
|---------|--------------------------|
| **Agent** | The AI entity that executes your task — thinks, plans, and acts on your behalf |
| **Goal** | The high-level objective you give the agent (e.g., *"Research three studies on active learning and write a summary"*) |
| **Tools** | Capabilities the agent can use — web search, Google Drive, Gmail, code execution, etc. |
| **Memory** | Information the agent retains across steps or sessions — facts, prior outputs, user preferences |
| **Guardrails** | Rules and restrictions that keep the agent within safe, intended boundaries (e.g., *"Only read files in this folder; never send emails without my approval"*) |

### Power Tips

```{tip} 5 Tips for Teachers Using Antigravity
1. **Start with a tightly scoped goal** — Vague goals produce wandering agents. *"Summarize the five uploaded PDFs into a 1-page brief"* beats *"Help me with my research."*
2. **Define guardrails before you launch** — Specify what the agent should NOT do. *"Do not access any files outside the /Course-Materials folder"* prevents surprises.
3. **Use memory to build cumulative workflows** — An agent that remembers your course structure can build on prior outputs each week rather than starting from scratch.
4. **Review tool permissions carefully** — Only grant the tools your agent actually needs. An agent that can send email + access your calendar + browse the web has a large footprint — minimize it.
5. **Treat the first run as a draft** — Run the agent on a small test case first. Review its output and reasoning before unleashing it on your full course dataset.
```

### Watch Out For

```{caution} 3 Cautions with Agentic AI
1. **Agents act — they don't just answer** — Unlike a chatbot, an agent can take real actions (send emails, edit files, make API calls). Review permissions carefully and always run a test before a full deployment.
2. **Goal drift on long tasks** — The longer and more complex the goal, the more the agent may wander from your original intent. Break large goals into sequential smaller tasks and review output between steps.
3. **Memory is not always private** — Understand what data your agent retains and where it is stored. Avoid loading sensitive student data (grades, personal info) into agent memory unless you have confirmed it is handled per your institution's data policy.
```

---

## A Note on Tool Velocity

```{note} These tools change frequently.
When in doubt, check the tool's official help documentation — and ask Gemini: *"What's new in [tool name]?"* for the latest features.
```
