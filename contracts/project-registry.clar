;; Project Registry Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-invalid-project (err u101))

;; Project data structure
(define-map projects
  { project-id: uint }
  {
    owner: principal,
    name: (string-ascii 64),
    description: (string-utf8 256),
    funding-target: uint,
    current-funding: uint,
    status: (string-ascii 12)
  }
)

(define-data-var next-project-id uint u0)

;; Register new project
(define-public (register-project 
  (name (string-ascii 64))
  (description (string-utf8 256))
  (funding-target uint)
)
  (let
    (
      (project-id (var-get next-project-id))
    )
    (map-set projects
      { project-id: project-id }
      {
        owner: tx-sender,
        name: name,
        description: description,
        funding-target: funding-target,
        current-funding: u0,
        status: "ACTIVE"
      }
    )
    (var-set next-project-id (+ project-id u1))
    (ok project-id)
  )
)

;; Get project details
(define-read-only (get-project (project-id uint))
  (ok (map-get? projects { project-id: project-id }))
)
