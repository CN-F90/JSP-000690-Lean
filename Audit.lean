/-
  Independent audit bridge — Erdős Problem #834  ==  Justin Sun Prize JSP-000690
  ===============================================================================

  Original problem (Erdős #834, as recorded in the Justin Sun Prize catalog
  entry JSP-000690):

      "Is there a three-uniform, three-chromatic-critical hypergraph with
       minimum degree at least seven?"

  Purpose of this file
  --------------------
  It performs the official `lean-verify` step "write a minimal target statement
  and `example : IntendedStatement := ...` in a separate audit file, connecting
  it to the submitted theorem."

  Two things are done, and they are kept strictly separate:

  (A) INDEPENDENT RESTATEMENT AND RE-VERIFICATION.
      The intended statement is re-written from the original source, in a
      formulation deliberately *different* from the one used in `Main.lean`:
      proper 2-colourability is stated here in EXISTENTIAL form ("every edge
      contains a vertex of each colour"), whereas `Main.lean` states it in
      NEGATED-UNIVERSAL form ("no edge is monochromatic"). The witness is then
      re-verified from scratch under these definitions by kernel computation
      (`by decide`). None of the theorems of `Main.lean` are used for this.

  (B) BRIDGE TO THE SUBMITTED THEOREM.
      The two colourability formulations are proved equivalent
      (`twoColorable_iff_twoCol`), and the submitted main theorem
      `Erdos834.erdos_834_exists` is then mechanically transported to the
      audit's `IntendedStatement` (`submitted_theorem_yields_intended`).
      This is what licenses reading the submitted theorem as a solution of
      the original problem.

  Honest scope note
  -----------------
  `Uniform3` and `MinDeg` below happen to have the same bodies as
  `Erdos834.ThreeUniform` / `Erdos834.MinDegreeGE`; they are re-stated here so
  that the target statement is self-contained, and the bridge transports them
  componentwise. The colourability predicate is *not* merely renamed — the
  equivalence is genuinely proved.

  No `sorry`, no `admit`, no new axioms.
-/
import Mathlib
import Main

set_option maxRecDepth 200000
set_option maxHeartbeats 0

namespace Audit834

open Erdos834

/-! ## A. Independent restatement of the intended target -/

/-- Every edge has exactly three vertices. -/
abbrev Uniform3 {V : Type} [DecidableEq V] (H : Finset (Finset V)) : Prop :=
  ∀ e ∈ H, e.card = 3

/-- Every vertex lies in at least `d` edges. -/
abbrev MinDeg {V : Type} [DecidableEq V] (H : Finset (Finset V)) (d : ℕ) : Prop :=
  ∀ v : V, d ≤ (H.filter (fun e => v ∈ e)).card

/-- Proper 2-colouring, EXISTENTIAL form: every edge contains a vertex coloured
    `true` and a vertex coloured `false`. -/
abbrev TwoCol {V : Type} [DecidableEq V] (H : Finset (Finset V)) : Prop :=
  ∃ c : V → Bool, ∀ e ∈ H, (∃ v ∈ e, c v = true) ∧ (∃ v ∈ e, c v = false)

/-- Deleting any single vertex (i.e. keeping exactly the edges avoiding it)
    leaves a 2-colourable hypergraph. -/
abbrev VertexCrit {V : Type} [DecidableEq V] (H : Finset (Finset V)) : Prop :=
  ∀ v : V, TwoCol (H.filter (fun e => v ∉ e))

/-- Deleting any single edge leaves a 2-colourable hypergraph. -/
abbrev EdgeCrit {V : Type} [DecidableEq V] (H : Finset (Finset V)) : Prop :=
  ∀ e ∈ H, TwoCol (H.erase e)

/-- The intended statement: there exists a finite 3-uniform hypergraph of
    minimum degree at least 7 that is not 2-colourable (chromatic number ≥ 3)
    and is both vertex- and edge-critical. -/
def IntendedStatement : Prop :=
  ∃ (n : ℕ) (H : Finset (Finset (Fin n))),
    Uniform3 H ∧ MinDeg H 7 ∧ ¬ TwoCol H ∧ VertexCrit H ∧ EdgeCrit H

/-! ### A.1 Independent re-verification of the witness -/

theorem audit_uniform : Uniform3 H834 := by decide

theorem audit_mindeg : MinDeg H834 7 := by decide

theorem audit_not_twoCol : ¬ TwoCol H834 := by decide

theorem audit_vertex_critical : VertexCrit H834 := by decide

theorem audit_edge_critical : EdgeCrit H834 := by decide

/-- The intended statement, established by INDEPENDENT re-computation: this
    proof does not cite any theorem of `Main.lean`. -/
example : IntendedStatement := by
  exact ⟨9, H834, audit_uniform, audit_mindeg, audit_not_twoCol,
          audit_vertex_critical, audit_edge_critical⟩

/-! ## B. Bridge to the submitted theorem -/

/-- The submitted (negated-universal) colourability predicate is equivalent to
    the audit's (existential) one. -/
theorem twoColorable_iff_twoCol (H : Hypergraph) :
    TwoColorable H ↔ TwoCol H := by
  classical
  constructor
  · rintro ⟨c, hc⟩
    refine ⟨c, ?_⟩
    intro e he
    constructor
    · by_contra hno
      push Not at hno
      have allFalse : ∀ v ∈ e, c v = false := by
        intro v hv
        by_cases h : c v = false
        · exact h
        · exfalso
          apply hno v hv
          cases hv' : c v <;> simp [hv'] at h ⊢
      exact (hc e he).2 allFalse
    · by_contra hno
      push Not at hno
      have allTrue : ∀ v ∈ e, c v = true := by
        intro v hv
        by_cases h : c v = true
        · exact h
        · exfalso
          apply hno v hv
          cases hv' : c v <;> simp [hv'] at h ⊢
      exact (hc e he).1 allTrue
  · rintro ⟨c, hc⟩
    refine ⟨c, ?_⟩
    intro e he
    constructor
    · intro allTrue
      rcases (hc e he).2 with ⟨v, hv, hvFalse⟩
      have : (false : Bool) = true := hvFalse.symm.trans (allTrue v hv)
      cases this
    · intro allFalse
      rcases (hc e he).1 with ⟨v, hv, hvTrue⟩
      have : (true : Bool) = false := hvTrue.symm.trans (allFalse v hv)
      cases this

/-- Transporting the submitted theorem to the audit's target statement. -/
theorem submitted_theorem_yields_intended : IntendedStatement := by
  rcases erdos_834_exists with ⟨H, hU, hD, hChi, hVC, hEC⟩
  refine ⟨9, H, ?_, ?_, ?_, ?_, ?_⟩
  · intro e he; exact hU e he
  · intro v;    exact hD v
  · intro hTwoCol
    exact hChi ((twoColorable_iff_twoCol H).mpr hTwoCol)
  · intro v
    exact (twoColorable_iff_twoCol (H.filter (fun e => v ∉ e))).mp (hVC v)
  · intro e he
    exact (twoColorable_iff_twoCol (H.erase e)).mp (hEC e he)

end Audit834

#print axioms Audit834.audit_uniform
#print axioms Audit834.audit_mindeg
#print axioms Audit834.audit_not_twoCol
#print axioms Audit834.audit_vertex_critical
#print axioms Audit834.audit_edge_critical
#print axioms Audit834.twoColorable_iff_twoCol
#print axioms Audit834.submitted_theorem_yields_intended
