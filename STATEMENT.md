# STATEMENT.md — JSP-000690 / Erdős #834

## Official problem

**Justin Sun Prize JSP-000690** — *"Is there a three-uniform, three-chromatic-critical
hypergraph with minimum degree at least seven?"*

Authoritative source: <https://www.erdosproblems.com/834> (Erdős problem #834), which states

> "Does there exist a 3-critical 3-uniform hypergraph in which every vertex has degree ≥ 7?"

and records that the answer is **yes**: under the chromatic notion of criticality, **Li [Li25]**
gives an explicit 3-critical 3-uniform hypergraph on **9 vertices with minimum degree 7**.

## Statement formalized here

```
∃ H : Finset (Finset (Fin 9)),
    ThreeUniform H ∧ MinDegreeGE H 7 ∧ Chi3 H ∧ VertexCritical H ∧ EdgeCritical H
```

with

| predicate | meaning |
| --- | --- |
| `ThreeUniform H`     | every edge has exactly 3 vertices |
| `MinDegreeGE H 7`    | every vertex lies in ≥ 7 edges |
| `Chi3 H`             | `¬ TwoColorable H` — no 2-colouring avoids a monochromatic edge |
| `TwoColorable H`     | `∃ c : Vertex → Bool, ∀ e ∈ H, ¬(∀ v∈e, c v = true) ∧ ¬(∀ v∈e, c v = false)` |
| `VertexCritical H`   | `∀ v, TwoColorable (H.filter (fun e => v ∉ e))` |
| `EdgeCritical H`     | `∀ e ∈ H, TwoColorable (H.erase e)` |

### Conventions fixed explicitly

The original problem does not spell out the deletion conventions, so they are stated here:

1. **Vertex deletion** `H − v` — keep exactly those edges that do *not* contain `v`, on the
   remaining 8 vertices. (This is the standard convention that keeps a 3-uniform hypergraph
   3-uniform.)
2. **Edge deletion** `H − e` — erase `e` from the edge set; the vertex set is unchanged.
3. **Chromatic number 2** — existence of a 2-colouring with no monochromatic edge
   (Property-B style).

"3-critical" therefore means: chromatic number is **not** 2, but becomes 2 after deleting
**any single vertex** and after deleting **any single edge**.

## The witness

22 edges on the 9 vertices `{0,…,8}`; degrees `7,7,7,10,7,7,7,7,7` (minimum 7):

- `{0, 2, 3}`
- `{0, 2, 5}`
- `{0, 2, 7}`
- `{0, 3, 5}`
- `{0, 3, 7}`
- `{0, 4, 5}`
- `{0, 7, 8}`
- `{1, 3, 5}`
- `{1, 3, 6}`
- `{1, 3, 7}`
- `{1, 4, 5}`
- `{1, 5, 6}`
- `{1, 6, 7}`
- `{1, 7, 8}`
- `{2, 3, 6}`
- `{2, 4, 6}`
- `{2, 4, 8}`
- `{2, 6, 8}`
- `{3, 4, 5}`
- `{3, 4, 8}`
- `{3, 7, 8}`
- `{4, 6, 8}`
## Attribution

The existence result is due to **Li [Li25]** (see erdosproblems.com/834). This repository
claims **only** an independent Lean formalization of it.
