# VERIFICATION.md — JSP-000690 / Erdős #834

## Environment

| | |
| --- | --- |
| Machine | WINDOWS-MAIN (Windows, D:\AI\WorkBuddy_Projects\JustinSunPrize) |
| Lean | 4.34.0 (`leanprover/lean4:v4.34.0`, commit `293d5d0c…`) |
| Mathlib | v4.34.0 |
| Build command | `lake build Main` (after `lake exe cache get`) |

## Build result (local, 2026-09-19)

```
cd <mathlib-v4.34.0>
lake env lean <this repo>/Main.lean
→ exit 0, no errors, no warnings
```

## Axiom audit

```
'Erdos834.H834_uniform'        depends on axioms: [propext, Classical.choice, Quot.sound]
'Erdos834.H834_mindeg'         depends on axioms: [propext, Classical.choice, Quot.sound]
'Erdos834.H834_chi3'           depends on axioms: [propext, Classical.choice, Quot.sound]
'Erdos834.H834_vertex_critical' depends on axioms: [propext, Classical.choice, Quot.sound]
'Erdos834.H834_edge_critical'  depends on axioms: [propext, Classical.choice, Quot.sound]
'Erdos834.erdos_834_exists'    depends on axioms: [propext, Classical.choice, Quot.sound]
```

Only the three standard axioms appear. **No `sorryAx`** — i.e. no `sorry` and no `admit`
anywhere in the file. No custom axioms, no `axiom` declarations, no `unsafe`.

## How the proof works

All six theorems are closed by `by decide`: the statement is a finite proposition over
`Fin 9`, so the Lean kernel itself performs the exhaustive check. Specifically

- `H834_uniform`, `H834_mindeg` — finite counting;
- `H834_chi3` — the kernel enumerates all 2⁹ colourings and finds none proper;
- `H834_vertex_critical` — for each of the 9 vertices the kernel finds a proper 2-colouring
  of the remaining 8-vertex hypergraph;
- `H834_edge_critical` — for each of the 22 edges the kernel finds a proper 2-colouring after
  erasing it.

Because these are exhaustive searches, the elaborator needs

```lean
set_option maxRecDepth 200000
set_option maxHeartbeats 0
```

## Independent (non-Lean) cross-check

Before being written into Lean, the witness was cross-checked by a standalone Python
brute-force verifier (`tools/verify_e834.py`) that shares no code with the SAT encoding used
to find it:

```
n_edges 22 · n_vertices 9 · uniform true
degrees [7, 7, 7, 10, 7, 7, 7, 7, 7] · min_degree 7
chi_at_least_3 true · vertex_critical true · edge_critical true
ALL_PROPERTIES true
```

## Reproducing from scratch

```bash
# 1. build (needs the mathlib v4.34.0 cache)
lake exe cache get
lake build Main

# 2. axiom audit
lake env lean Main.lean

# 3. reject sorry/admit
! grep -rn --include=*.lean -E '\b(sorry|admit)\b' .
```

The same three steps run in GitHub Actions on every push (`.github/workflows/ci.yml`).

## Independent audit bridge (`Audit.lean`)

The official `lean-verify` self-check asks for "a minimal target statement and
`example : IntendedStatement := ...` in a separate audit file, connecting it to
the submitted theorem". `Audit.lean` supplies this. It does two separate things:

1. **Independent restatement and re-verification.** The target is re-written from
   the original source in a deliberately *different* formulation: proper
   2-colourability is stated in existential form ("every edge contains a vertex
   of each colour"), whereas `Main.lean` states it in negated-universal form
   ("no edge is monochromatic"). The witness `H834` is then re-verified from
   scratch under these definitions by kernel computation. No theorem of
   `Main.lean` is used for this.
2. **Bridge to the submitted theorem.** `twoColorable_iff_twoCol` proves the two
   colourability formulations equivalent, and `submitted_theorem_yields_intended`
   transports `Erdos834.erdos_834_exists` to the audit's `IntendedStatement`.
   This is what licenses reading the submitted theorem as a solution of the
   original problem.

Axioms for every bridge theorem: `[propext, Classical.choice, Quot.sound]`.
No `sorry`, no `admit`, no custom axiom, no `native_decide`.

Reproduce with:

```bash
lake build Main Audit
lake env lean Audit.lean
```
