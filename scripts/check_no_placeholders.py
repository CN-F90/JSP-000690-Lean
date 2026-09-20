#!/usr/bin/env python3
"""Reject forbidden placeholders in the Main formalization.

Fails if any of the following occurs in *code* (comments are stripped first):

  * `sorry` or `admit` used as a tactic/term
  * a top-level `axiom` declaration
  * an `unsafe` declaration

Documentation in this repository legitimately says e.g. "No `sorry`, no `admit`,
no new axioms.", so comments must be removed before scanning -- a naive text
search produces false positives (that mistake broke the previous CI config).

The authoritative check remains the axiom audit: a `sorry` would surface as
`sorryAx` in the `#print axioms` output, which the workflow asserts against.
This script is the supplementary, human-readable guard.
"""

from __future__ import annotations

import pathlib
import re
import sys

ROOT = pathlib.Path(__file__).resolve().parents[1]
TARGETS = sorted(ROOT.glob("*.lean")) + sorted((ROOT / "Main").glob("*.lean"))
KEYWORDS = ("sorry", "admit")
DECLS = re.compile(r"(?m)^\s*(axiom|unsafe)\b")


def strip_comments(src: str) -> str:
    """Remove Lean block comments (which nest) and line comments."""
    out: list[str] = []
    depth = 0
    i = 0
    n = len(src)
    while i < n:
        if src.startswith("/-", i):
            depth += 1
            i += 2
            continue
        if depth > 0 and src.startswith("-/", i):
            depth -= 1
            i += 2
            continue
        ch = src[i]
        if depth > 0:
            out.append("\n" if ch == "\n" else " ")
        elif src.startswith("--", i):
            while i < n and src[i] != "\n":
                i += 1
            continue
        else:
            out.append(ch)
        i += 1
    return "".join(out)


def main() -> int:
    problems: list[str] = []
    for path in TARGETS:
        rel = path.relative_to(ROOT).as_posix()
        code = strip_comments(path.read_text(encoding="utf-8"))
        for m in DECLS.finditer(code):
            line = code.count("\n", 0, m.start()) + 1
            problems.append(f"{rel}:{line}: '{m.group(1)}' declaration")
        for kw in KEYWORDS:
            for m in re.finditer(r"(?<![A-Za-z0-9_'])" + kw + r"(?![A-Za-z0-9_'])", code):
                line = code.count("\n", 0, m.start()) + 1
                problems.append(f"{rel}:{line}: '{kw}' used in code")

    if problems:
        print("FORBIDDEN PLACEHOLDERS FOUND:")
        for p in problems:
            print("  " + p)
        return 1

    print(
        f"OK: no sorry / admit / axiom / unsafe in {len(TARGETS)} files "
        "(comments excluded)."
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
