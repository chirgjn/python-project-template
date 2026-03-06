#!/usr/bin/env bash
# Wrapper so proselint never blocks a commit (warn only).
uv run proselint check "$@" || true
