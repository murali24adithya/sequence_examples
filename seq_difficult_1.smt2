; This example can be found in issue #2448 on the Z3 github page

(set-logic ALL)
(declare-const A (Seq Int))

; max index
(declare-const m Int)

; max index constraints
(assert (<= 0 m))
(assert (< m (seq.len A)))
(assert (forall ((i Int)) (<= (seq.nth A i) (seq.nth A m))))

; the projected sequence
(declare-const f_A (Seq Int))
(assert (= f_A
	(let (
		(max (seq.nth A m))
		(n   (seq.len A)))
	(ite
		(or (>= max n) (< max 0))
		(seq.unit 74)
		(seq.++
			(seq.extract A 0 m)
			(seq.extract A (+ m 1) (- (- n 1) m)))))))

; specification
(define-fun spec ((in (Seq Int))) Bool
	(let (
		(n (seq.len in)))
	(and
		(forall ((j Int))
			(=>
				(and
					(<= 0 j)
					(<  j n))
				(and
					(<= 0 (seq.nth in j))
					(<  (seq.nth in j) n))))))
)

; specification property
(assert (and (spec f_A) (not (spec A))))

(check-sat)
; Expected unsat
; Reason: If f_A satisfies spec, there is no way that A could have not. Because A has only one more element than f_A does, and it could not have been greater than len(A).
;Therefore (spec A) must also hold if (spec f_A) holds.
