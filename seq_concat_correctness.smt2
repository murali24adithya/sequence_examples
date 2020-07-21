(set-logic ALL)

(declare-const a (Seq Int))
(declare-const b (Seq Int))
(declare-const c (Seq Int))

; c is the concatenation of a and b
(assert (= c (seq.++ a b)))

(declare-const index Int)
; elements of c w.r.t a and b 
(assert (let ((len_a (seq.len a))  (len_b (seq.len b)))
	      (not (ite (and (<= 0 index) (< index len_a)) 
	   	   (= (seq.nth c index) (seq.nth a index))
	   	   (ite (and (<= len_a index) (< index (+ len_a len_b))) 
	   	   	(= (seq.nth c index) (seq.nth b (- index len_a)))
	   	   	true))
	      )
	)
)

(check-sat)
; Expected unsat
