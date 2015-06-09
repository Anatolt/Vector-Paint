Enumeration
  #up
  #down
  #left
  #right
  #return
  #undo
  #redo
  #hideDots
EndEnumeration


AddKeyboardShortcut(#wnd,#PB_Shortcut_W,#up)
AddKeyboardShortcut(#wnd,#PB_Shortcut_S,#down)
AddKeyboardShortcut(#wnd,#PB_Shortcut_A,#left)
AddKeyboardShortcut(#wnd,#PB_Shortcut_D,#right)
AddKeyboardShortcut(#wnd,#PB_Shortcut_Space,#stopLine)
AddKeyboardShortcut(#wnd,#PB_Shortcut_Control|#PB_Shortcut_Z,#undo)
AddKeyboardShortcut(#wnd,#PB_Shortcut_Control|#PB_Shortcut_Y,#redo)
AddKeyboardShortcut(#wnd,#PB_Shortcut_Control|#PB_Shortcut_Shift|#PB_Shortcut_Z,#redo)
AddKeyboardShortcut(#wnd,#PB_Shortcut_H,#hideDots)
; IDE Options = PureBasic 5.31 (Windows - x86)
; CursorPosition = 8
; EnableUnicode
; EnableXP