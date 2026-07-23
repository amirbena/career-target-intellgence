# Career Targeting Intelligence

Career Targeting Intelligence is a research and prioritization workflow that helps a job seeker turn a candidate profile into a focused, evidence-based outreach plan — identifying the right target companies, the right recruiters, and the right hiring managers, without relying on background automation or scraping.

## Problem

Job searching at a senior level is usually either too broad (spraying applications with no prioritization) or too manual (hours of unstructured research per company). There is no lightweight, repeatable method for going from "who am I and what do I want" to "here are the specific companies, people, and outreach actions worth my time this week."

## Intended users

Individual job seekers — particularly experienced professionals — who want a structured, on-demand research assistant for their own job search, and who are willing to review and act on findings manually rather than automate them away.

## Planned product surfaces

- **ChatGPT Custom GPT** — a conversational interface to the same methodology, built for the ChatGPT ecosystem.
- **Claude Project with a Claude Skill** — a conversational interface to the same methodology, built for the Claude ecosystem.

Both surfaces are thin, platform-specific wrappers. The methodology itself lives once, in `core/`.

## Core principle

`core/` is the platform-independent source of truth. Anything that describes *what the product does* — its methodology, outputs, and scope — belongs in `core/`. Platform folders (`claude/`, `chatgpt/`) only adapt that shared definition to a specific product surface; they should not redefine or duplicate business rules.

## Current project status

Foundation stage. This repository currently defines project structure, working rules, and high-level scope only. The Claude Skill, Claude Project instructions, ChatGPT GPT instructions, detailed workflows, schemas, ranking models, and research examples have not been implemented yet.

## Further reading

- [ROADMAP.md](ROADMAP.md)
- [core/product-definition.md](core/product-definition.md)
- [core/scope-and-non-goals.md](core/scope-and-non-goals.md)
