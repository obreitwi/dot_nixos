;; extends

(
 (unordered_list1
   state: (detached_modifier_extension [(todo_item_undone) (todo_item_done) (todo_item_pending)])
   content: (paragraph (paragraph_segment (inline_comment ("_open") ("_word" @task-id-tag) ("_word") ("_close")) @conceal (#set! conceal "")))
 )
 (#match? @task-id-tag "#taskid")
)

; (
 ; (unordered_list1
   ; state: (detached_modifier_extension [(todo_item_undone) (todo_item_done) (todo_item_pending)])
   ; content: (paragraph (paragraph_segment (("_word" @todo-id-tag) ("_word" @todo-content) @conceal (#set! conceal ""))))
 ; )
 ; (#match? @todo-id-tag "#taskid")
 ; (#match? @todo-content "^[a-zA-Z].*$")
; )
