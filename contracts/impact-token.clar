;; Impact DAO Governance Token
(define-fungible-token impact-token)

;; Constants
(define-constant contract-owner tx-sender)
(define-constant token-name "ImpactDAO Token")
(define-constant token-symbol "IMPACT")
(define-constant token-decimals u6)
(define-constant initial-supply u1000000000000)

;; Error codes
(define-constant err-owner-only (err u100))
(define-constant err-not-authorized (err u101))
(define-constant err-insufficient-balance (err u102))

;; Token transfer
(define-public (transfer (amount uint) (sender principal) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender sender) err-not-authorized)
    (ft-transfer? impact-token amount sender recipient)
  )
)

;; Mint tokens - owner only
(define-public (mint (amount uint) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (ft-mint? impact-token amount recipient)
  )
)

;; Read-only functions
(define-read-only (get-balance (account principal))
  (ok (ft-get-balance impact-token account))
)
