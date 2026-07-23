# Builder Setup Guide

How to configure the Career Targeting Intelligence Custom GPT from this
package.

## Steps

1. Open the GPT creation/editor interface.
2. Set the name and description from
   [`builder-config.md`](builder-config.md).
3. Paste the entire content of [`instructions.md`](instructions.md) into
   the GPT's Instructions field.
4. Add the Conversation Starters from
   [`conversation-starters.md`](conversation-starters.md).
5. Upload the eight generated Knowledge bundles under `knowledge/`.
6. Configure the recommended Capabilities from
   [`builder-config.md`](builder-config.md) — enable what your account and
   workspace expose; leave the rest at their defaults.
7. Leave Actions and Apps unconfigured — this package defines neither.
8. Test the GPT in Preview using [`testing-guide.md`](testing-guide.md).
9. Save privately first.
10. Share or publish only after validation — see
    [`sharing-and-publishing.md`](sharing-and-publishing.md).

## What goes where

- **Instructions** contain workflow behavior — routing, trust boundaries,
  clarification policy, output policy, and non-actions. This is what
  makes the GPT act like Career Targeting Intelligence rather than a
  generic assistant.
- **Knowledge** contains reference material — schemas, scoring weights,
  evidence-state definitions, and output contracts. It supplies the
  detail Instructions deliberately doesn't restate.
- Uploading Knowledge alone does not configure the GPT's behavior — a GPT
  with only Knowledge attached and no Instructions pasted in will not
  follow the routing, trust, or output rules this package defines. Both
  steps are required.

## Privacy note

The source repository and this generated distribution package contain no
personal candidate files. Everything under `knowledge/` and everything in
`instructions.md` is methodology and reference material only — see
[`knowledge-manifest.md`](knowledge-manifest.md) for the explicit list of
what Knowledge must never contain.

## A note on builder controls

Exact field names, toggle placement, and available Capability controls
may vary by account, workspace, and platform version. Follow the
platform's own current builder UI; this guide describes what to configure,
not the exact click path.
