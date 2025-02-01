;; Impact DAO Main Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant proposal-duration u7200) ;; ~30 days in blocks

;; Error codes
(define-constant err-unauthorized (err u100))
(define-constant err-proposal-exists (err u101))
(define-constant err-proposal-expired (err u102))

;; Proposal types
(define-data-var next-proposal-id uint u0)

(define-map proposals
  { proposal-id: uint }
  {
    creator: principal,
    title: (string-ascii 64),
    description: (string-utf8 256),
    project-id: uint,
    amount: uint,
    start-block: uint,
    end-block: uint,
    yes-votes: uint,
    no-votes: uint,
    status: (string-ascii 10)
  }
)

;; Create proposal
(define-public (create-proposal
  (title (string-ascii 64))
  (description (string-utf8 256))
  (project-id uint)
  (amount uint)
)
  (let
    (
      (proposal-id (var-get next-proposal-id))
      (start-block block-height)
    )
    (map-set proposals
      { proposal-id: proposal-id }
      {
        creator: tx-sender,
        title: title,
        description: description,
        project-id: project-id,
        amount: amount,
        start-block: start-block,
        end-block: (+ start-block proposal-duration),
        yes-votes: u0,
        no-votes: u0,
        status: "ACTIVE"
      }
    )
    (var-set next-proposal-id (+ proposal-id u1))
    (ok proposal-id)
  )
)

;; Vote on proposal
(define-public (vote (proposal-id uint) (vote-for bool))
  (let
    (
      (proposal (unwrap! (map-get? proposals {proposal-id: proposal-id}) err-unauthorized))
    )
    (asserts! (< block-height (get end-block proposal)) err-proposal-expired)
    (if vote-for
      (map-set proposals 
        {proposal-id: proposal-id}
        (merge proposal {yes-votes: (+ (get yes-votes proposal) u1)})
      )
      (map-set proposals
        {proposal-id: proposal-id} 
        (merge proposal {no-votes: (+ (get no-votes proposal) u1)})
      )
    )
    (ok true)
  )
)
