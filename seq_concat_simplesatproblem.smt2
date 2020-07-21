(set-logic ALL)

(declare-const a (Seq Int))
(declare-const b (Seq Int))
(declare-const c (Seq Int))

; c is the concatenation of a and b
(assert (let ((len_a (seq.len a))  (len_b (seq.len b)))
	      (forall ((index Int)) 
	      	      (ite (and (<= 0 index) (< index len_a)) 
	   	           (= (seq.nth c index) (seq.nth a index))
	   	           (ite (and (<= len_a index) (< index (+ len_a len_b))) 
	   	   	        (= (seq.nth c index) (seq.nth b (- index len_a)))
	   	   	        true))
	      )
	)
)

(assert (= (seq.nth a 2) 0))
(assert (= (seq.nth c 2) 1))

(check-sat)
; Expected sat
; This is because it is possible for the legal length of a to be smaller than 2, and therefore a and c can differ on seq.nth at index 2.
