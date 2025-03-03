;; Product Management Contract

;; Constants
(define-constant err-invalid-price (err u200))
(define-constant err-not-seller (err u201))
(define-constant err-invalid-quantity (err u202))

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
    (if (and (> price u0) (> quantity u0))
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
      (if (<= price u0)
        err-invalid-price
        err-invalid-quantity)))
)

(define-public (update-product
  (product-id uint)
  (price uint)
  (quantity uint))
  (let ((product (unwrap! (map-get? products product-id) err-not-seller)))
    (if (is-eq (get seller product) tx-sender)
      (begin
        (map-set products product-id
          (merge product {
            price: price,
            quantity: quantity
          }))
        (ok true))
      err-not-seller))
)

(define-public (deactivate-product (product-id uint))
  (let ((product (unwrap! (map-get? products product-id) err-not-seller)))
    (if (is-eq (get seller product) tx-sender)
      (begin
        (map-set products product-id
          (merge product { active: false }))
        (ok true))
      err-not-seller))
)

(define-read-only (get-product (product-id uint))
  (ok (map-get? products product-id))
)
