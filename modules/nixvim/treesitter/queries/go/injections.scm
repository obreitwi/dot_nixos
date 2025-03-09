;; extends

; embed sql in literals
; (
 ; (comment) @_tag (#eq? @_tag "/* sql */")
 ; (raw_string_literal (raw_string_literal_content) @injection.content (#set! injection.language "sql"))
; )

((raw_string_literal_content) @injection.content (#set! injection.language "sql"))
; (
;  (comment) @_tag (#eq? @_tag "/* sql */")
;  (raw_string_literal_content) @injection.content (#set! injection.language "sql")
; )

; (
;  (comment) @_tag (#eq? @_tag "/* sql */")
;  (expression_list (raw_string_literal (raw_string_literal_content) @injection.content (#set! injection.language "sql")))
; )
 
; (const_declaration
;    [
;     ((comment) @_tag (#eq? @_tag "/* sql */"))
;    ((raw_string_literal_content) @injection.content (#set! injection.language "sql"))
;    ]
; )

; TODO: This also matches go literals in the middle but there is no way to
; specifically match all "raw_string_literals" within a possibly complex
; binary_expression tree yet
; (
 ; (comment) @_tag (#eq? @_tag "/* sql */")
 ; (expression_list) @injection.content (#set! injection.language "sql")
; )
