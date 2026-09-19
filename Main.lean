/-
  Erdős Problem #834  ==  Justin Sun Prize JSP-000690
  ------------------------------------------------------------------
  "Does there exist a 3-critical 3-uniform hypergraph in which every
   vertex has degree >= 7?"

  This module gives an explicit 9-vertex witness and verifies, by kernel
  computation (`decide`), that it is

      * 3-uniform,
      * of minimum degree >= 7 (in fact exactly 7),
      * NOT 2-colourable                       -> chromatic number >= 3,
      * 2-colourable after deleting any vertex -> vertex-critical,
      * 2-colourable after deleting any edge   -> edge-critical,

  and therefore 3-critical.  No `sorry`, no `admit`, no new axioms.

  Conventions (stated explicitly because the source problem leaves them
  implicit):
    - "deleting a vertex v"  =  pass to the induced sub-hypergraph on the
      remaining vertices, i.e. keep exactly those edges that do not contain v.
      (This is the standard convention that keeps the hypergraph 3-uniform.)
    - "deleting an edge e"   =  erase e from the edge set, vertices unchanged.
    - "chromatic number 2"   =  there is a 2-colouring of the vertices with no
      monochromatic edge (Property B style).
  -/
import Mathlib

-- Finite exhaustive verification blows past the default recursion budget.
set_option maxRecDepth 200000
set_option maxHeartbeats 0

namespace Erdos834

abbrev Vertex := Fin 9
abbrev Edge := Finset Vertex
abbrev Hypergraph := Finset Edge

/-- The explicit witness: a 3-uniform hypergraph on 9 vertices. -/
def H834 : Hypergraph :=
  [ ({0, 2, 3} : Edge),
      ({0, 2, 5} : Edge),
      ({0, 2, 7} : Edge),
      ({0, 3, 5} : Edge),
      ({0, 3, 7} : Edge),
      ({0, 4, 5} : Edge),
      ({0, 7, 8} : Edge),
      ({1, 3, 5} : Edge),
      ({1, 3, 6} : Edge),
      ({1, 3, 7} : Edge),
      ({1, 4, 5} : Edge),
      ({1, 5, 6} : Edge),
      ({1, 6, 7} : Edge),
      ({1, 7, 8} : Edge),
      ({2, 3, 6} : Edge),
      ({2, 4, 6} : Edge),
      ({2, 4, 8} : Edge),
      ({2, 6, 8} : Edge),
      ({3, 4, 5} : Edge),
      ({3, 4, 8} : Edge),
      ({3, 7, 8} : Edge),
      ({4, 6, 8} : Edge)
  ].toFinset

/-- `TwoColorable H`: some 2-colouring of the vertices leaves no edge
    monochromatic (all-true or all-false). -/
abbrev TwoColorable (H : Hypergraph) : Prop :=
  ∃ c : Vertex → Bool,
    ∀ e ∈ H, ¬ (∀ v ∈ e, c v = true) ∧ ¬ (∀ v ∈ e, c v = false)

/-- `Chi3 H`: chromatic number is (at least) 3, i.e. not 2-colourable.
    (A 3-uniform hypergraph whose edges are all non-empty has chromatic
    number at most 3 only in general; here we only need "not 2" together
    with the criticality statements, which pin the value to 3.) -/
abbrev Chi3 (H : Hypergraph) : Prop := ¬ TwoColorable H

/-- Every edge has exactly three vertices. -/
abbrev ThreeUniform (H : Hypergraph) : Prop :=
  ∀ e ∈ H, e.card = 3

/-- Every vertex lies in at least `d` edges. -/
abbrev MinDegreeGE (H : Hypergraph) (d : Nat) : Prop :=
  ∀ v : Vertex, d ≤ (H.filter (fun e => v ∈ e)).card

/-- Deleting any single vertex makes the hypergraph 2-colourable. -/
abbrev VertexCritical (H : Hypergraph) : Prop :=
  ∀ v : Vertex, TwoColorable (H.filter (fun e => v ∉ e))

/-- Deleting any single edge makes the hypergraph 2-colourable. -/
abbrev EdgeCritical (H : Hypergraph) : Prop :=
  ∀ e ∈ H, TwoColorable (H.erase e)

-- ---------------------------------------------------------------------------
-- Individual certified facts (each is a finite computation, closed by `decide`)
-- ---------------------------------------------------------------------------

theorem H834_uniform : ThreeUniform H834 := by decide

theorem H834_mindeg : MinDegreeGE H834 7 := by decide

theorem H834_chi3 : Chi3 H834 := by decide

theorem H834_vertex_critical : VertexCritical H834 := by decide

theorem H834_edge_critical : EdgeCritical H834 := by decide

-- ---------------------------------------------------------------------------
-- The main theorem: a 3-critical 3-uniform hypergraph of minimum degree >= 7
-- ---------------------------------------------------------------------------

theorem erdos_834_exists :
    ∃ H : Hypergraph,
      ThreeUniform H ∧ MinDegreeGE H 7 ∧ Chi3 H ∧ VertexCritical H ∧ EdgeCritical H := by
  exact ⟨H834, H834_uniform, H834_mindeg, H834_chi3,
          H834_vertex_critical, H834_edge_critical⟩

end Erdos834

#print axioms Erdos834.H834_uniform
#print axioms Erdos834.H834_mindeg
#print axioms Erdos834.H834_chi3
#print axioms Erdos834.H834_vertex_critical
#print axioms Erdos834.H834_edge_critical
#print axioms Erdos834.erdos_834_exists
