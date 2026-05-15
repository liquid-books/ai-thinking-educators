# Chapter 5 Quiz: AI Studio — Behind the Curtain
*Instructor resource — not published in the book.*

---

## Multiple Choice (10 questions)

**1.** Which of the following best describes the difference between Gemini (gemini.google.com) and AI Studio (aistudio.google.com)?

a) Gemini uses more powerful models than AI Studio  
b) AI Studio is for students; Gemini is for teachers  
c) Gemini is a consumer-grade interface; AI Studio exposes model controls like temperature, system instructions, and model selection  
d) AI Studio requires a paid subscription; Gemini is always free  

**Correct answer: C**

---

**2.** A teacher sets temperature to 0.1 in AI Studio before asking for a historical timeline of key events in the American Civil War. What is the likely effect?

a) The model will produce creative, highly varied interpretations of the events  
b) The model will produce a consistent, factually safe, predictable response  
c) The model will refuse to answer without additional context  
d) The response will be longer than usual  

**Correct answer: B**

---

**3.** What is a "context window" in the context of large language models?

a) The visual area of the AI Studio interface where you type prompts  
b) The total amount of text (measured in tokens) that the model can process at once, including all inputs and outputs  
c) A feature that allows the model to remember previous sessions  
d) The maximum number of images that can be uploaded in one session  

**Correct answer: B**

---

**4.** A teacher uploads a full-semester course textbook, a pacing guide, and a list of state standards into AI Studio and asks the model to map each standard to the relevant textbook chapter. This is an example of which AI Studio capability?

a) Multimodal input processing  
b) Stream of thought reasoning  
c) Long context utilization  
d) Model comparison  

**Correct answer: C**

---

**5.** System instructions in AI Studio differ from regular prompts in what important way?

a) System instructions are only visible to administrators, not teachers  
b) System instructions run before every message in the conversation, shaping all subsequent responses  
c) System instructions override the model's training data  
d) System instructions cannot be changed once the session begins  

**Correct answer: B**

---

**6.** According to Kolb's Experiential Learning Cycle (1984), what follows the "Reflective Observation" stage?

a) Concrete Experience  
b) Active Experimentation  
c) Abstract Conceptualization  
d) Productive Failure  

**Correct answer: C**

---

**7.** A teacher enables "thinking" mode in AI Studio and sees a series of reasoning steps appear before the final answer. What is the PRIMARY educational value of this feature for classroom use?

a) It makes the model respond faster  
b) It reduces token consumption  
c) It allows students to see and critique AI reasoning, supporting AI literacy  
d) It forces the model to use a lower temperature setting automatically  

**Correct answer: C**

---

**8.** A teacher wants to provide essay feedback to 30 students using AI Studio. Which model setting would MOST effectively ensure consistent, rubric-aligned feedback across all 30 essays?

a) A high temperature setting (1.8+) for each essay  
b) A detailed system instruction that defines the feedback format, persona, and rubric dimensions  
c) Selecting a different model for each student based on their grade level  
d) Keeping token limits very low to force concise responses  

**Correct answer: B**

---

**9.** Dewey's (1938) foundational claim that "learning emerges from experience, not transmission" is most directly reflected in which AI Studio practice?

a) Using AI Studio only during class time  
b) Iteratively testing and refining prompts and system instructions, reflecting on outputs, and adjusting based on what works  
c) Uploading lecture notes for the AI to summarize  
d) Setting temperature to 0 for all educational tasks  

**Correct answer: B**

---

**10.** A teacher uses AI Studio to generate a diagram of a plant cell for a lesson. Before showing it to students, what is the MOST important step?

a) Increase the temperature setting before generating the image  
b) Review the image for scientific accuracy, since AI-generated visuals can contain errors  
c) Convert the image from PNG to JPEG for classroom use  
d) Compare the image across at least three different Gemini model versions  

**Correct answer: B**

---

## Short Answer (3 questions)

**11.** Explain in your own words the difference between a "prompt" and "system instructions" in AI Studio. Give a concrete example of how a teacher might use each in a feedback workflow. (Suggested response: 150–250 words)

**Model Answer:** A prompt is the specific instruction a teacher types in the conversation each time — for example, "Please provide feedback on this student essay: [paste essay]." It changes with every interaction. System instructions, by contrast, are persistent text that runs before every message in the session, shaping the model's persona, tone, format, and constraints for the entire conversation. A teacher might write system instructions like: "You are a writing feedback assistant for 8th-grade students. Always begin with one specific strength. Frame all growth areas as suggestions. Keep feedback under 150 words. Reference rubric dimensions: thesis, evidence, organization, voice, and mechanics." Once these are set, every essay the teacher pastes into the session receives feedback in that consistent format — without the teacher having to re-explain the feedback style each time. The system instructions make the workflow consistent and reusable, while the prompts carry the specific content (each student's essay) that changes with every use.

---

**12.** John Dewey (1938) wrote that education must be grounded in experience and reflection, not passive transmission. How does AI Studio — specifically the cycle of running prompts, observing outputs, and refining system instructions — reflect Dewey's principle? Use Kolb's four-stage cycle in your response. (Suggested response: 150–250 words)

**Model Answer:** Dewey's core insight is that genuine learning requires active engagement with experience followed by reflective processing — not simply receiving information from an authoritative source. Kolb (1984) operationalized this into four stages: Concrete Experience (doing or encountering something), Reflective Observation (stepping back to examine what happened), Abstract Conceptualization (forming a theory or principle), and Active Experimentation (testing that theory). Using AI Studio mirrors this cycle precisely. When a teacher uploads essays and runs a feedback prompt (Concrete Experience), then reads the output and notices that the feedback lacks specificity about the rubric's evidence dimension (Reflective Observation), then forms the hypothesis that adding clearer rubric language to the system instructions will improve the output (Abstract Conceptualization), then revises the instructions and runs the prompt again to test the improvement (Active Experimentation), they have completed a full Kolb cycle — in approximately ten minutes. AI Studio's iterative interface makes this cycle fast enough to complete multiple times in a single session, which accelerates the teacher's professional learning about what these models can do, what they can't, and how to configure them effectively for specific educational tasks. This is experiential learning, in the Dewey tradition, applied to professional development.

---

**13.** A student argues: "Using AI Studio to generate essay feedback saves time, so teachers should automate the grading process as much as possible." Evaluate this argument. What does the chapter's discussion of teacher professional judgment and Bjork's desirable difficulties suggest about the limits of this position? (Suggested response: 150–250 words)

**Model Answer:** The student's argument captures something real — AI Studio does dramatically compress the time required for first-pass feedback generation, and that time savings has genuine value. However, "as much as possible" sets up a problematic conclusion. The chapter identifies several irreducible limits on automation. First, AI feedback is consistently described as a "first pass" — 75–80% of what a skilled teacher might write. The remaining 20–25% includes feedback that requires contextual knowledge of the individual student: their growth trajectory, their emotional state, their particular learning needs. A model cannot notice that a student's voice has gone flat because something is happening at home. Second, Bjork's research on desirable difficulties makes clear that the struggle of engaging with feedback and revising work is part of what produces learning. If the feedback process is so automated that it becomes frictionless for both teacher and student, the productive difficulty that drives improvement may be lost. The teacher's professional judgment — in reviewing, personalizing, and deciding which AI-generated comments to use, revise, or discard — is not administrative overhead; it is the mechanism that keeps the human expert in the loop and ensures feedback actually serves student learning rather than simply producing the appearance of it.

---

## Answer Key Summary

| Question | Answer |
|----------|--------|
| 1 | C |
| 2 | B |
| 3 | B |
| 4 | C |
| 5 | B |
| 6 | C |
| 7 | C |
| 8 | B |
| 9 | B |
| 10 | B |
| 11 | See model answer above |
| 12 | See model answer above |
| 13 | See model answer above |

*Key themes to look for in short answers: distinction between prompts and system instructions, Kolb's four-stage cycle applied to AI Studio iteration, and the limits of automation (teacher judgment, desirable difficulties, contextual knowledge of students).*
