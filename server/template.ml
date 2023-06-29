open Tyxml.Html

let header () =
  header ~a:[a_class ["container mx-auto max-w-3xl sm:grid sm:grid-cols-6 gap-4 font-mono pt-16 pb-14 px-4"]] [
    (div ~a:[a_class ["flex flex-row justify-between col-span-4 col-start-2"]] [
      h1 [a ~a:[a_href "/"; a_class ["text-black hover:text-black hover:underline underline-offset-2"]] [txt "I No Read"]];
      ul ~a:[a_class ["flex flex-row space-x-4"]] [
        li [a ~a:[a_href "/writing"; a_class ["text-black hover:text-black hover:underline underline-offset-2"]] [txt "Ideas"]];
        li [a ~a:[a_href "/projects"; a_class ["text-black hover:text-black hover:underline underline-offset-2"]] [txt "Projects"]];
      ]
    ])
  ]
 
let main_layout children =
  html
    (head (title (txt "I No Read")) [
        meta ~a:[a_charset "utf-8"] ();
        meta ~a:[a_name "viewport"; a_content "width=device-width, initial-scale=1"] ();
        link ~rel:[`Stylesheet] ~href:"/dist/styles.css" ();
    ])
    (body [
      header ();
      main ~a:[a_class ["container"; "mx-auto"; "max-w-3xl"; "px-4"; "font-mono"; "pb-16"; "text-justify"; "md"; "sm:grid"; "sm:grid-cols-6"; "gap-4"]] [txt children]
    ])
