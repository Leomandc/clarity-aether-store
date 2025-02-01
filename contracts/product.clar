;; Product Management Contract

;; Constants
(define-constant err-invalid-price (err u200))
(define-constant err-not-seller (err u201))

;; Types
(define-data-var next-product-id uint u0)

;; Maps
(define-map products
  uint
  {
    seller: principal,
    name: (string-utf8 100),
    description: (string-utf8 500),
    price: uint,
    quantity: uint,
    active: bool
  }
)

;; Public functions
(define-public (list-product 
  (name (string-utf8 100))
  (description (string-utf8 500))
  (price uint)
  (quantity uint))
  (let ((product-id (var-get next-product-id)))
    (if (> price u0)
      (begin
        (map-set products product-id {
          seller: tx-sender,
          name: name,
          description: description,
          price: price,
          quantity: quantity,
          active: true
        })
        (var-set next-product-id (+ product-id u1))
        (ok product-id))
      err-invalid-price))
)

(define-read-only (get-product (product-id uint))
  (ok (map-get? products product-id))
)
