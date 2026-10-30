# Included by headers/glib2.nim; do not import directly.
type
  TGMarkupParseContext* = pointer
  PGMarkupParseContext* = ptr TGMarkupParseContext
  TGMarkupParser*{.final.} = object
    start_element*: proc (context: PGMarkupParseContext, element_name: cstring,
                          attribute_names: PPgchar, attribute_values: PPgchar,
                          user_data: gpointer, error: pointer){.cdecl.}
    end_element*: proc (context: PGMarkupParseContext, element_name: cstring,
                        user_data: gpointer, error: pointer){.cdecl.}
    text*: proc (context: PGMarkupParseContext, text: cstring, text_len: gsize,
                 user_data: gpointer, error: pointer){.cdecl.}
    passthrough*: proc (context: PGMarkupParseContext,
                        passthrough_text: cstring, text_len: gsize,
                        user_data: gpointer, error: pointer){.cdecl.}
    error*: proc (context: PGMarkupParseContext, error: pointer,
                  user_data: gpointer){.cdecl.}


  PGMarkupParser* = ptr TGMarkupParser
