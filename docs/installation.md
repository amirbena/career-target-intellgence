# Installation

Detailed installation steps for every supported platform. The
[README](../README.md#quick-start) has the short version.

Release artifacts are attached to each
[GitHub Release](https://github.com/amirbena/career-target-intellgence/releases/latest).

| Method | Status |
| --- | --- |
| [Claude Code marketplace](#claude-code-marketplace) | Verified locally with `claude plugin validate` and `marketplace add` / `install`; the GitHub form works once this change is on `main` |
| [Codex CLI marketplace](#codex-cli-marketplace) | **Verified** from GitHub (marketplace add, plugin add, plugin list) |
| [Claude Plugin ZIP](#claude-plugin-zip) | Available |
| [ChatGPT Plugin (local marketplace)](#chatgpt-plugin) | Plugin invocation in ChatGPT verified; the Desktop local-marketplace steps below are per OpenAI docs and **not verified end-to-end** |
| [npx skills (skills.sh)](#npx-skills-skillssh) | Verified |
| [Cursor](#cursor) | Install verified; in-app steps follow Cursor's docs |
| [Claude Skill ZIP](#claude-skill-zip) | Available |
| [Claude Project (external kit)](#claude-project-external-kit) | Available |

## Claude Code marketplace

This repository is a Claude Code marketplace
([`.claude-plugin/marketplace.json`](../.claude-plugin/marketplace.json)). Inside Claude Code:

```text
/plugin marketplace add amirbena/career-target-intellgence
/plugin install career-targeting-intelligence@career-targeting-intelligence
```

Or from a shell:

```bash
claude plugin marketplace add amirbena/career-target-intellgence
claude plugin install career-targeting-intelligence@career-targeting-intelligence
```

Activate: run `/reload-plugins` (or start a new session), then ask *"Here is my resume. Build my Candidate Profile."* The Skill also triggers automatically on matching requests, and `/career-targeting-intelligence:career-targeting-intelligence` invokes it explicitly.

Update with `claude plugin marketplace update career-targeting-intelligence`; the plugin tracks the repository's default branch.

Local test from a checkout: `claude plugin validate .` then `claude plugin marketplace add .`.

Docs: [Create and distribute a plugin marketplace](https://code.claude.com/docs/en/plugin-marketplaces).

## Codex CLI marketplace

Codex CLI reads the same marketplace file as Claude Code
([`.claude-plugin/marketplace.json`](../.claude-plugin/marketplace.json)), so no separate
packaging is needed. From a shell:

```bash
codex plugin marketplace add amirbena/career-target-intellgence
codex plugin add career-targeting-intelligence@career-targeting-intelligence
```

Claude Code uses the same marketplace; see [Claude Code marketplace](#claude-code-marketplace).

### Verification status

| Item | Status |
| --- | --- |
| Codex CLI: `marketplace add` from GitHub, `marketplace list`, `plugin add`, `plugin list` | **Verified.** The plugin was installed and enabled; Codex CLI `codex-cli 0.160.0`; the plugin's reported version was `local`. A remote catalog lookup printed a network warning, but local plugin verification succeeded. |
| ChatGPT: plugin invocation | **Verified.** The plugin appeared as installed in ChatGPT, its instructions loaded, its nine Knowledge reference files were accessible, and the Candidate Profile intake workflow ran in conversation. |
| Codex CLI install propagating to ChatGPT Desktop | **Not verified.** That integration path was not tested; do not assume a Codex CLI install makes the plugin available in ChatGPT Desktop. |

For ChatGPT Desktop, use the separate [ChatGPT Plugin](#chatgpt-plugin) steps. A
ChatGPT-specific marketplace is only warranted if a concrete compatibility or behavior gap is shown.

## Claude Plugin ZIP

Download `career-targeting-intelligence-claude-plugin.zip` from Releases.

- **Claude Code:** `claude --plugin-dir ./career-targeting-intelligence-claude-plugin.zip` (accepts a directory or a `.zip`).
- **claude.ai / Cowork:** use **Upload plugin** and choose the ZIP.

Details: [claude/packaging.md](../claude/packaging.md#packaging-the-claude-plugin).

## ChatGPT Plugin

Not verified end-to-end. OpenAI documents plugins in ChatGPT on web and desktop (not the IDE extension), and local plugins are installed through the **desktop app**. OpenAI's docs do not list plan requirements for local installs, and workspace admins can restrict plugins, so availability may vary by account.

OpenAI marketplaces need an assembled plugin folder (root `plugin.json` plus `skills/`). This repository does not commit one, because it would duplicate generated content, so the install uses the release ZIP with a personal local marketplace:

1. Download `career-targeting-intelligence-chatgpt-plugin.zip` from Releases, then unzip it and register it (macOS/Linux; on Windows use `%USERPROFILE%`):
   ```bash
   mkdir -p ~/.codex/plugins/career-targeting-intelligence ~/.agents/plugins
   unzip -o career-targeting-intelligence-chatgpt-plugin.zip -d ~/.codex/plugins/career-targeting-intelligence
   cat > ~/.agents/plugins/marketplace.json <<'JSON'
   {
     "name": "local",
     "plugins": [
       {
         "name": "career-targeting-intelligence",
         "source": { "source": "local", "path": "./.codex/plugins/career-targeting-intelligence" },
         "policy": { "installation": "AVAILABLE", "authentication": "ON_INSTALL" },
         "category": "Productivity"
       }
     ]
   }
   JSON
   ```
   If you already have a `marketplace.json`, add the plugin entry to it instead of overwriting the file. `path` is relative to the marketplace root (`~`) and must start with `./`.
2. Restart the ChatGPT desktop app, open the **Plugins** directory, choose your `local` marketplace, and install `Career Targeting`.
3. Activate: start a new chat, type `@`, choose the plugin, and send *"Here is my resume. Build my Candidate Profile."* A working install answers with the Candidate Profile workflow and asks for your resume details.

Public directory: listing in the universal ChatGPT/Codex plugin directory requires submission through OpenAI's plugin submission portal and OpenAI review. It is optional and has not been done; see [chatgpt/sharing-and-publishing.md](../chatgpt/sharing-and-publishing.md). Publishing to a workspace is a separate action that needs a workspace admin.

More: [chatgpt/testing-guide.md](../chatgpt/testing-guide.md); OpenAI: [Package your plugin](https://developers.openai.com/plugins/build/plugins), [Build plugins](https://developers.openai.com/codex/plugins/build).

## npx skills (skills.sh)

Prerequisite: Node.js 18+ (includes `npx`). Run in your project, or add `-g` for a user-level install:

```bash
npx skills add amirbena/career-target-intellgence
```

The command prompts you to pick the target agent(s); skip the prompt with `-a <agent>` (for example `-a claude-code`, `-a cursor`) and `-y`. It installs the Skill from [`skills/career-targeting-intelligence/`](../skills/career-targeting-intelligence/) with its `references/` and `templates/`, from the current `main` rather than a pinned release.

Verify: `npx skills list` shows `career-targeting-intelligence`. Then ask your agent: *"Here is my resume. Build my Candidate Profile."*

## Cursor

Prerequisites: a Cursor version with Agent Skills (the docs reference 2.4) and Node.js 18+.

1. In your project folder, run:
   ```bash
   npx skills add amirbena/career-target-intellgence -a cursor -y
   ```
   This writes `.agents/skills/career-targeting-intelligence/` (`SKILL.md`, `references/`, `templates/`), which Cursor discovers automatically. Add `-g` to install for all projects.
2. Restart Cursor or reopen the project.
3. Verify: in the sidebar open **Customize → Skills** and look for `career-targeting-intelligence`.
4. Use it: in Agent chat type `/career-targeting-intelligence` and send *"Here is my resume. Build my Candidate Profile."* Cursor also applies it automatically when a request matches its description.

Details: [Cursor Agent Skills docs](https://cursor.com/docs/skills).

## Claude Skill ZIP

Download `career-targeting-intelligence.skill.zip` from Releases and install it as a Skill in Claude. Details: [claude/skill-manifest.md](../claude/skill-manifest.md), [claude/project-setup.md](../claude/project-setup.md).

## Claude Project (external kit)

Download `career-targeting-intelligence-claude-kit.zip` from Releases and follow [claude/external-install/README.md](../claude/external-install/README.md) (checklist: [installation-checklist.md](../claude/external-install/installation-checklist.md)).
