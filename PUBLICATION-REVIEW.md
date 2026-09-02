# Publication Review Record

publication_status: local-draft
reviewed_at: 2026-09-02
published_at: null
license_scope_reviewed: false
third_party_reviewed: false
privacy_reviewed: false
archive_reviewed: false
owner_approval: false

## Current Decision

This repository is a local publication candidate. Draft structure, authoring files, archive hashes, routing cases, and automated checks may be reviewed locally, but public release is blocked.

## Status Lifecycle

- `local-draft`: authoring or review is still in progress. `published_at` remains `null`; `Draft` validation may pass with unresolved publication warnings.
- `release-ready`: the owner has selected `LICENSE`, documented `LICENSE-SCOPE.md`, completed every review field above, and approved the tracked file list. `published_at` remains `null`; `Release` validation is the final pre-publication gate.
- `published`: publication has actually occurred. Set `published_at` to the real `YYYY-MM-DD` publication date and run `Published` validation as a post-publication audit.

## Outstanding Gates

- The repository owner must choose a `LICENSE`.
- `LICENSE-SCOPE.md` must state how the license applies to code, documentation, Prompt files, and archive material.
- Third-party concepts, character IP, model output, and archived artifacts require scope review.
- Privacy review must confirm that no real chat, credentials, private configuration, or internal recovery notes are included.
- The owner must approve the final tracked file list and publication date.

Do not set a review field to `true` before that review has actually occurred. Do not set `publication_status: release-ready` until every release gate is complete, and do not set it to `published` before the repository is actually published.
