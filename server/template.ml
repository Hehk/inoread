open Tyxml.Html
open Base

let header () =
  header
    ~a:
      [
        a_class
          [
            "container mx-auto max-w-3xl sm:grid sm:grid-cols-6 gap-4 pt-16 \
             pb-14 px-4";
          ];
      ]
    [
      div
        ~a:
          [
            a_class
              [ "flex flex-row justify-between col-span-4 col-start-2 -bl-2" ];
          ]
        [
          h1
            [
              a
                ~a:
                  [
                    a_href "/";
                    a_class
                      [
                        "text-black hover:text-black hover:underline \
                         underline-offset-2";
                      ];
                  ]
                [ txt "I No Read" ];
            ];
          ul
            ~a:[ a_class [ "flex flex-row space-x-4" ] ]
            [
              li
                [
                  a
                    ~a:
                      [
                        a_href "/writing";
                        a_class
                          [
                            "text-black hover:text-black hover:underline \
                             underline-offset-2";
                          ];
                      ]
                    [ txt "Ideas" ];
                ];
              li
                [
                  a
                    ~a:
                      [
                        a_href "/projects";
                        a_class
                          [
                            "text-black hover:text-black hover:underline \
                             underline-offset-2";
                          ];
                      ]
                    [ txt "Projects" ];
                ];
            ];
        ];
    ]

let grid =
  let column_class = "border-l border-r border-black/20" in
  let container_class =
    "absolute max-w-3xl px-4 sm:grid sm:grid-cols-6 gap-4 inset-0 mx-auto \
     pointer-events-none opacity-0 sub-grid"
  in
  div
    ~a:[ a_class [ container_class ] ]
    (List.init 6 ~f:(fun _ -> div ~a:[ a_class [ column_class ] ] []))


let main_layout children =
  html ~a:[ a_lang "en" ]
    (head
       (title (txt "I No Read"))
       [
         meta ~a:[ a_charset "utf-8" ] ();
         meta
           ~a:
             [
               a_name "viewport";
               a_content "width=device-width, initial-scale=1";
             ]
           ();
  link ~rel:[`Stylesheet] ~href:"https://fonts.googleapis.com/css2?family=EB+Garamond:wght@400;700&display=swap" ();
         link ~rel:[ `Stylesheet ] ~href:"/dist/styles.css" ();
         script ~a:[ a_src "/dist/grid.js"; a_async () ] (txt "");
       ])
    (body
       [
         header ();
         grid;
         main
           ~a:
             [
               a_class
                 [
                   "container";
                   "mx-auto";
                   "max-w-3xl";
                   "px-4";
                   "pb-16";
                   "text-justify";
                   "md";
                   "sm:grid";
                   "sm:grid-cols-6";
                   "gap-4";
                 ];
             ]
           children;
       ])

let centered children = div ~a:[ a_class [ "col-span-4 col-start-2" ] ] children

module Tag = struct
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
