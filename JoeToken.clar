;; use the SIP-009 interface
(impl-trait 'SP1JSH2FPE8BWNTP228YZ1AZZ0HE0064PS6RXRAY4.nft-trait.nft-trait)

;; define a new NFT. 
(define-non-fungible-token JoeToken uint)

;; Store the last issues token ID
(define-data-var last-id uint u0)

;; Claim a new NFT
(define-public (claim)
  (ok (mint tx-sender)))

;; SIP-009: Transfer token to a specified principal
(define-public (transfer (token-id uint) (sender principal) (recipient principal))
  (if (and
        (is-eq tx-sender sender))
      (match (nft-transfer? JoeToken token-id sender recipient)
        success (ok success)
        error (err {code: error}))
      (err {code: error})))

;; SIP-009: Get the owner of the specified token ID
(define-read-only (get-owner (token-id uint))
  (ok (nft-get-owner? JoeToken token-id)))

;; SIP-009: Get the last token ID
(define-read-only (get-last-token-id)
  (ok (var-get last-id)))

;; SIP-009: Get the token URI. 
(define-read-only (get-token-uri (token-id uint))
  (ok (some "https://ipfs.io/ipfs/QmauCyd2NggdpiCR4MfwgbsGXPweKsRTB3kwVeHLYkjuW6")))

(define-read-only (get-meta (token-id uint))
  (if (is-eq token-id u1)
    (ok (some {name: "JoeToken", uri: "https://ipfs.globalupload.io/QmauCyd2NggdpiCR4MfwgbsGXPweKsRTB3kwVeHLYkjuW6", mime-type: "image/png"}))
    (ok none)))

(define-read-only (get-nft-meta)
  (ok (some {name: "JoeToken", uri: "https://ipfs.globalupload.io/QmauCyd2NggdpiCR4MfwgbsGXPweKsRTB3kwVeHLYkjuW6", mime-type: "image/png"})))

;; Internal - Mint new NFT
(define-private (mint (new-owner principal))
    (let ((next-id (+ u1 (var-get last-id))))
      (match (nft-mint? JoeToken next-id new-owner)
        success
          (begin
            (var-set last-id next-id)
            (ok success))
        error (err {code: error}))))
