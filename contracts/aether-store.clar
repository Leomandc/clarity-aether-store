;; AetherStore Main Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-not-owner (err u100))
(define-constant err-already-initialized (err u101))

;; Data vars
(define-data-var platform-fee uint u25) ;; 2.5% fee
(define-data-var total-sales uint u0)

;; Data maps
(define-map sellers
  principal
  {
    active: bool,
    reputation: uint,
    total-sales: uint
  }
)

;; Public functions
(define-public (register-seller)
  (begin
    (map-set sellers tx-sender {
      active: true,
      reputation: u100,
      total-sales: u0
    })
    (ok true))
)

(define-public (update-platform-fee (new-fee uint))
  (if (is-eq tx-sender contract-owner)
    (begin
      (var-set platform-fee new-fee)
      (ok true))
    err-not-owner)
)

;; Read only functions
(define-read-only (get-platform-fee)
  (ok (var-get platform-fee))
)

(define-read-only (get-seller-info (seller principal))
  (ok (map-get? sellers seller))
)
