;; use the SIP-009 NFT interface
(impl-trait 'SP2PABAF9FTAJYNFZH93XENAJ8FVY99RRM50D2JG9.nft-trait.nft-trait)

;; define a new JoeToken NFT. 
(define-non-fungible-token JoeToken uint)

;; Errors
(define-constant nft-not-owned-err (err u401)) ;; unauthorized
(define-constant nft-not-found-err (err u404)) ;; not found
(define-constant sender-equals-recipient-err (err u405)) ;; method not allowed

;; Error Message Handling
(define-private (nft-transfer-err (code uint))
  (if (is-eq u1 code)
    nft-not-owned-err
    (if (is-eq u2 code)
      sender-equals-recipient-err
      (if (is-eq u3 code)
        nft-not-found-err
        (err code)))))

;; Transfers tokens to a specified principal.
(define-public (transfer (token-id uint) (sender principal) (recipient principal))
  (if (and
        (is-eq tx-sender (unwrap! (nft-get-owner? JoeToken token-id) nft-not-found-err))
        (is-eq tx-sender sender)
        (not (is-eq recipient sender)))
       (match (nft-transfer?  JoeToken token-id sender recipient)
        success (ok success)
        error (nft-transfer-err error))
      nft-not-owned-err))

;; Gets the owner of the specified token ID.
(define-read-only (get-owner (token-id uint))
  (ok (nft-get-owner?  JoeToken token-id)))

;; Gets the owner of the specified token ID.
(define-read-only (get-last-token-id)
  (ok u1))

;; Defines external image as NFT metadata
(define-read-only (get-token-uri (token-id uint))
  (ok (some "https://ipfs.io/ipfs/QmauCyd2NggdpiCR4MfwgbsGXPweKsRTB3kwVeHLYkjuW6")))

(define-read-only (get-meta (token-id uint))
  (if (is-eq token-id u1)
    (ok (some {name: "JoeToken", uri: "https://ipfs.globalupload.io/QmauCyd2NggdpiCR4MfwgbsGXPweKsRTB3kwVeHLYkjuW6", mime-type: "image/png"}))
    (ok none)))

(define-read-only (get-nft-meta)
  (ok (some {name: "JoeToken", uri: "https://ipfs.globalupload.io/QmauCyd2NggdpiCR4MfwgbsGXPweKsRTB3kwVeHLYkjuW6", mime-type: "image/png"})))

;; More Error Code Handling
(define-read-only (get-errstr (code uint))
  (ok (if (is-eq u401 code)
    "nft-not-owned"
    (if (is-eq u404 code)
      "nft-not-found"
      (if (is-eq u405 code)
        "sender-equals-recipient"
        "unknown-error")))))

;; Initialize the contract
(try! (nft-mint? JoeToken  u1 tx-sender))
