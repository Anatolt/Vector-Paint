;result.pb
OpenWindow(0,#PB_Ignore,#PB_Ignore,300,300,"Result", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
CanvasGadget(#canva,0,0,300,300)
drawAll()
Repeat
  event = WaitWindowEvent()
  If event = #PB_Event_Gadget And EventGadget() = #canva
    mX = GetGadgetAttribute(#canva, #PB_Canvas_MouseX)
    mY = GetGadgetAttribute(#canva, #PB_Canvas_MouseY)
    Select EventType()
      Case #PB_EventType_LeftButtonDown
        squares2btns
    EndSelect
  EndIf
Until event = #PB_Event_CloseWindow
; IDE Options = PureBasic 5.31 (Windows - x64)
; CursorPosition = 10
; EnableUnicode
; EnableXP