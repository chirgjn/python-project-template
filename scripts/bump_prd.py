# scripts/bump_prd.py
"""Bump the PRD minor version: rename file, update symlink, patch header, insert history row, update CLAUDE.md."""

import os
import re
import sys
from datetime import date
from pathlib import Path


def bump_minor(version: str) -> str:
    major, minor = version.split(".")
    return f"{major}.{int(minor) + 1}"


def _today_str() -> str:
    today = date.today()
    return f"{today.strftime('%B')} {today.day}, {today.year}"


def find_current_prd(project_root: Path) -> Path:
    symlink = project_root / "assets" / "prd.md"
    if not symlink.is_symlink():
        sys.exit(f"Error: {symlink} is not a symlink. Cannot determine current PRD.")
    target = symlink.parent / os.readlink(symlink)
    if not target.exists():
        sys.exit(f"Error: symlink target {target} does not exist.")
    return target


def run(project_root: Path) -> None:
    current = find_current_prd(project_root)

    # Parse version from filename e.g. prd_v1.4.md -> "1.4"
    match = re.match(r"prd_v(\d+\.\d+)\.md", current.name)
    if not match:
        sys.exit(f"Error: cannot parse version from filename '{current.name}'.")
    old_version = match.group(1)
    new_version = bump_minor(old_version)
    new_name = f"prd_v{new_version}.md"
    new_path = current.parent / new_name

    # --- Phase 1: read and transform content (no filesystem mutations yet) ---
    today = _today_str()
    content = current.read_text()
    content = re.sub(r"(?m)^\*\*Version:\*\* \S+", f"**Version:** {new_version}", content)
    content = re.sub(r"(?m)^\*\*Date:\*\* .+", f"**Date:** {today}", content)

    table_header_re = re.compile(r"(\| Version \| Date.*\n\| [-| ]+\|[-| ]+\n)")
    new_row = f"| {new_version}     | {today} | Claude | _TBD_ |\n"
    if not table_header_re.search(content):
        sys.exit("Error: could not find Version History table header in PRD.")
    content = table_header_re.sub(r"\1" + new_row, content)

    # --- Phase 2: apply all mutations atomically ---
    _ = current.rename(new_path)
    print(f"Renamed: {current.name} -> {new_name}")

    symlink = project_root / "assets" / "prd.md"
    symlink.unlink()
    symlink.symlink_to(new_name)
    print(f"Symlink:  prd.md -> {new_name}")

    _ = new_path.write_text(content)
    print(f"Header:   Version -> {new_version}, Date -> {today}")
    print(f"History:  inserted row for {new_version}")

    claude_md = project_root / "CLAUDE.md"
    if claude_md.exists():
        md = claude_md.read_text()
        md = md.replace(f"prd_v{old_version}.md", new_name)
        _ = claude_md.write_text(md)
        print(f"CLAUDE.md: updated reference to {new_name}")


if __name__ == "__main__":
    run(Path(__file__).parent.parent)
