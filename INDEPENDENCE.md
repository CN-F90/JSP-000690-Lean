# INDEPENDENCE.md — JSP-000690 / Erdős #834

Recorded per the standing operating rule that every new formalization project must document
its sources, its relationship to earlier work, and its development process.

## 1. Mathematical source used

- The problem and its resolution were read from the **authoritative upstream database**
  <https://www.erdosproblems.com/834> (the community DB behind erdosproblems.com, which the
  Justin Sun Prize catalog is derived from).
- The existence of a 3-critical 3-uniform hypergraph with minimum degree ≥ 7 is attributed
  there to **Li [Li25]**. The site states that Li provides an explicit example on **9 vertices
  with minimum degree 7**.
- **No paper text of [Li25] was obtained or used.** Only the public statement of the problem
  and the public one-line resolution ("Li provides an explicit 3-critical 3-uniform hypergraph
  on 9 vertices with minimum degree 7") were used. The witness below was **re-derived from
  scratch**, not read off from any source.

## 2. Known earlier / parallel Lean formalizations

JSP-000690 is one of the **most heavily contested** problems in the bank. The
`TheJustinSunPrize/awards` repository contains approximately **27 pull requests** referencing
it, many of which record complete Lean formalizations. Non-exhaustive list of the most
directly relevant ones (titles as observed 2026-09-19):

| PR | title (abridged) |
| --- | --- |
| #1613 | JSP-000690: record the Lean formalization of **both readings** of Erdős #834 (supersedes #1609) |
| #1609 | JSP-000690: record the Lean formalization of Erdős #834 (Li's 9-vertex critically 3-chromatic 3-uniform hypergraph) |
| #1152 | JSP-000690: record complete Lean formalization of **Li's hypergraph** |
| #1097 | JSP-000690: regular 21-edge witness and complete chromatic proof |
| #845  | JSP-000690: independent standalone Lean 4 formalization (zero imports, no Mathlib, …) |
| #842  | JSP-000690: complete chromatic Lean proof with exhaustive kernel certificates |
| #823  | JSP-000690: Lean proof of the 3-critical 3-graph with minimum degree 7 |
| #747  | JSP-000690: kernel-checked critical hypergraph certificates |
| #1383 | JSP-000690: record existing Lean formalization (plby/lean-proofs) |
| #1099 | feat(catalog): record Lean formalization for JSP-000690 |
| #879  | JSP-000690: credit … Lean formalization |
| #794  | Add JSP-000690 chromatic observation candidate (under verification) |

**We do not claim to be the first formalizer of this problem.** On the evidence above we are
very likely *not* first. This repository is offered only as an **independent** formalization.

## 3. Declaration of non-copying

- **No Lean source from any of the repositories or pull requests listed above was read,
  downloaded, or reused.** No proof body, no file layout, no theorem naming was taken from
  them.
- Only the *public problem statement* and the *public one-line resolution* (§1) were used as
  mathematical input — the same information any member of the public obtains by opening
  erdosproblems.com/834.
- The witness hypergraph was found **by this project's own SAT encoding**
  (`tools/find_e834_sat.py`, 6 612 variables / 160 117 clauses, solved in 0.4 s), and was then
  re-verified by a **second, independent brute-force checker** (`tools/verify_e834.py`) that
  shares no code with the SAT encoding.
- The Lean file `Main.lean` was written from scratch for this repository.

## 4. Mathlib lemmas / APIs used

Essentially only the finite-computation core:

- `Finset`, `Finset.card`, `Finset.filter`, `Finset.erase`, `List.toFinset`
- `Fin` and its `Fintype` / `DecidableEq` instances
- `Fintype`-derived `Decidable` instances for bounded `∀` / `∃`
- the `decide` tactic (ordinary `decide`, **not** `native_decide` — the latter would add an
  axiom to `#print axioms`)

No research-level Mathlib theorem is relied upon; the content of the proof is exhaustive
finite verification performed by the kernel.

## 5. AI-assisted development disclosure

This formalization was produced by an **autonomous AI agent** (WINDOWS-MAIN, Justin Sun Prize
autopilot) operating under standing human-configured instructions. Specifically:

- target selection, statement-fidelity resolution, SAT encoding, and the Lean file were all
  produced by the agent;
- every mathematical assertion is nevertheless **machine-checked by the Lean 4 kernel** —
  the certificates are `by decide`, so no step rests on the agent's word.

## 6. Start time

Work on this formalization started **2026-09-19 ~17:46 GMT+8** (cycle 12 of the WINDOWS-MAIN
loop) and the first clean kernel build was obtained the same day at ~18:30 GMT+8.

## 7. Commit history

See `git log` of this repository. The initial commit contains `Main.lean`, `lakefile.toml`,
`lean-toolchain`, `.github/workflows/ci.yml` and this documentation set.
