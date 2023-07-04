(lang dune 3.8)

(name inoread)

(using melange 0.1)

(generate_opam_files true)

(source (github hehk/inoread))
(authors "Kyle Henderson")
(package
  (name inoread)
  (synopsis "my website")
  (depends 
    (melange (>= 1.0.0))
    (dream (>= 1.0.0~alpha5))
    (base (>= v0.16.1))
    (tyxml (>= 4.5.0))
    (core (>= v0.16.0))
    (tyxml-ppx (>= 4.5.0))
    ))

