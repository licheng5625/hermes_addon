# Dependency Management with Renovate

This repository uses [Renovate](https://github.com/renovatebot/renovate) to automatically keep dependencies up to date.

## What is Renovate?

Renovate is a bot that automatically creates Pull Requests to update dependencies when new versions are available.

## Configuration

- **Schedule**: Runs every Monday at 2 AM UTC
- **Manual Trigger**: Can be triggered manually via GitHub Actions
- **Files Monitored**: `hermes/requirements.txt`

## How it Works

1. Renovate scans `hermes/requirements.txt` for Python dependencies
2. Checks PyPI for newer versions
3. Creates Pull Requests with updates
4. Groups minor and patch updates together
5. Separates major updates for manual review

## Update Types

- **Major updates** (e.g., 1.x → 2.x): Labeled `major-update`, requires manual review
- **Minor/Patch updates** (e.g., 1.1 → 1.2): Grouped together
- **Security updates**: Labeled `security`, assigned to @licheng5625

## Setup

The workflow uses `GITHUB_TOKEN` by default. For better rate limits, you can optionally create a `RENOVATE_TOKEN`:

1. Go to https://github.com/settings/tokens/new
2. Create a token with `repo` scope
3. Add it as `RENOVATE_TOKEN` in repository secrets

## Customization

Edit `.github/renovate.json` to customize behavior:
- Change update schedules
- Enable/disable automerge
- Adjust grouping rules
- Add package-specific rules
