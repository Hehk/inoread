open Base

let default_header () =
  let open Tyxml.Html in
  let link_class =
    [ "text-black hover:text-black hover:underline underline-offset-2" ]
  in
  let header_class = [ "container mx-auto max-w-2xl sm:grid sm:grid-cols-6 gap-4 pt-8 pb-6 sm:pt-16 sm:pb-14 px-4" ] in
  let container_class =
    [ "flex flex-row justify-between col-span-4 col-start-2 -bl-2" ]
  in
  let link href name = a ~a:[ a_href href; a_class link_class ] [ txt name ] in
  header
    ~a:[ a_class header_class ]
    [
      div
        ~a:[ a_class container_class ]
        [
          h1 [ link "/" "I No Read" ];
          ul
            ~a:[ a_class [ "flex flex-row space-x-4" ] ]
            [
              li [ link "/writing" "Writing" ]; li [ link "/projects" "Projects" ];
            ];
        ];
    ]

let grid =
  let open Tyxml.Html in
  let column_class = "border-l border-r border-black/20" in
  let container_class =
    "absolute max-w-2xl px-4 sm:grid sm:grid-cols-6 gap-4 inset-0 mx-auto \
     pointer-events-none opacity-0 sub-grid"
  in
  let column = div ~a:[ a_class [ column_class ] ] [] in
  let columns = List.init 6 ~f:(fun _ -> column) in
  div ~a:[ a_class [ container_class ] ] columns

let main_layout children =
  let open Tyxml.Html in
  let head =
    head
      (title (txt "I No Read"))
      [
        meta ~a:[ a_charset "utf-8" ] ();
        meta
          ~a:
            [
              a_name "viewport"; a_content "width=device-width, initial-scale=1";
            ]
          ();
        script ~a:[ a_async (); a_src "/dist/grid.js" ] (txt "");
        link ~rel:[ `Stylesheet ] ~href:"/dist/styles.css" ();
        link
          ~rel:[ `Other "preconnect" ]
          ~href:"https://fonts.googleapis.com" ();
        link
          ~rel:[ `Other "preconnect" ]
          ~href:"https://fonts.gstatic.com"
          ~a:[ a_crossorigin `Anonymous ]
          ();
        link ~rel:[ `Stylesheet ]
          ~href:
            "https://fonts.googleapis.com/css2?family=EB+Garamond:wght@400;700&display=swap"
          ();
      ]
  in
  let body =
    body
      [
        default_header ();
        grid;
        main
          ~a:
            [
              a_class [ "container mx-auto max-w-2xl px-4 pb-16 text-justify sm:grid sm:grid-cols-6 gap-4" ];
            ]
          children;
      ]
  in
  html ~a:[ a_lang "en" ] head body

let centered children =
  let open Tyxml.Html in
  div ~a:[ a_class [ "col-span-4 col-start-2" ] ] children

module Tag = struct
  open Tyxml.Html

  let link ~href children =
    a
      ~a:
        [
          a_href href;
          a_class [ "-bl-2"; "mb-4"; "underline"; "underline-offset-2" ];
        ]
      children

  let p children = p ~a:[ a_class [ "text-black"; "-bl-2"; "mb-4" ] ] children

  let h2 children =
    h2
      ~a:[ a_class [ "text-2xl"; "mb-6"; "mt-6"; "first:mt-0"; "-bl-1" ] ]
      children
end
