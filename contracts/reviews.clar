;; Review System Contract

;; Constants
(define-constant err-invalid-rating (err u300))
(define-constant err-not-purchased (err u301))

;; Maps
(define-map reviews
  { product-id: uint, reviewer: principal }
  {
    rating: uint,
    comment: (string-utf8 500),
    timestamp: uint
  }
)

;; Public functions
(define-public (add-review 
  (product-id uint)
  (rating uint)
  (comment (string-utf8 500)))
  (if (and (>= rating u1) (<= rating u5))
    (begin
      (map-set reviews 
        { product-id: product-id, reviewer: tx-sender }
        {
          rating: rating,
          comment: comment,
          timestamp: block-height
        }
      )
      (ok true))
    err-invalid-rating)
)

(define-read-only (get-review (product-id uint) (reviewer principal))
  (ok (map-get? reviews { product-id: product-id, reviewer: reviewer }))
)
