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
    (base (>= v0.16.1))
    (tyxml (>= 4.5.0))
    dream
    dream-livereload
    core
    core_unix
    cohttp-lwt-unix
    cohttp-lwt-unix
    atdgen 
    xml-light
    http
    ))

