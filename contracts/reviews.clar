;; Review System Contract

;; Constants
(define-constant err-invalid-rating (err u300))
(define-constant err-duplicate-review (err u302))
(define-constant err-review-not-found (err u303))

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
  (let ((existing-review (map-get? reviews { product-id: product-id, reviewer: tx-sender })))
    (if (is-some existing-review)
      err-duplicate-review
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
        err-invalid-rating)))
)

(define-public (modify-review
  (product-id uint)
  (rating uint)
  (comment (string-utf8 500)))
  (let ((existing-review (map-get? reviews { product-id: product-id, reviewer: tx-sender })))
    (if (is-none existing-review)
      err-review-not-found
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
        err-invalid-rating)))
)

(define-read-only (get-review (product-id uint) (reviewer principal))
  (ok (map-get? reviews { product-id: product-id, reviewer: reviewer }))
)

(define-read-only (get-average-rating (product-id uint))
  (ok (fold get-rating-value 
    (map-get? reviews { product-id: product-id, reviewer: tx-sender })
    { total: u0, count: u0 }))
)

(define-private (get-rating-value (review {rating: uint, comment: (string-utf8 500), timestamp: uint}) 
  (acc {total: uint, count: uint}))
  {
    total: (+ (get total acc) (get rating review)),
    count: (+ (get count acc) u1)
  }
)
