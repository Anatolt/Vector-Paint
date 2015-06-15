Enumeration
  #canva
EndEnumeration

OpenWindow(0,#PB_Ignore,#PB_Ignore,300,300,"Result", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
CanvasGadget(#canva,0,0,300,300)
drawAll()
Repeat
Until WaitWindowEvent() = #PB_Event_CloseWindow
; IDE Options = PureBasic 5.31 (Windows - x86)
; CursorPosition = 4
; EnableUnicode
; EnableXP