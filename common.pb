﻿Structure square
  x.w
  y.w
  type.b
  id.s
EndStructure

Structure dot
  x.w
  y.w
  type.b
  color.l
EndStructure

#start = 1
#stop = 2
#area = 3
#squareBegin = 4
#squareEnd = 5
#white = 16777215
#red = 255
#green = 65280

Global NewList all.dot(), NewList every.square()

Procedure addDot(x,y,type=#start,color=#white)
  AddElement(all())
  all()\x = x
  all()\y = y
  all()\type = type
  all()\color = color ;Random(#white-100)
EndProcedure

Procedure addSquare(x,y,type,id$="")
  AddElement(every())
  every()\id = id$
  every()\x = x
  every()\y = y
  every()\type = type
EndProcedure

Procedure drawAll()
  StartDrawing(CanvasOutput(#canva))
  Box(0,0,300,300,0)
  For i = 0 To ListSize(all())-1
    SelectElement(all(),i)
    type = all()\type
    x = all()\x
    y = all()\y
    color = all()\color
    Select type
      Case #start
        Circle(x,y,R,color)
        If i > 0 And Not type = #stop
          SelectElement(all(),i-1)
          x2 = all()\x
          y2 = all()\y
          LineXY(x,y,x2,y2,color)
          SelectElement(all(),i)
        EndIf
      Case #stop  
        Circle(x,y,R,color)
      Case #area
        FillArea(x,y,-1,color)
        DrawingMode(#PB_2DDrawing_XOr)
        Circle(x,y,R,color)
        DrawingMode(#PB_2DDrawing_Default)
    EndSelect
  Next
  For i = 0 To ListSize(every())-1
    SelectElement(every(),i)
    type = every()\type
    x = every()\x
    y = every()\y
    Select type
      Case #squareBegin
        Circle(x,y,R,squaresClr)
      Case #squareEnd
        DrawingMode(#PB_2DDrawing_Outlined)
        If i>0
          SelectElement(every(),i-1)
          x2 = every()\x
          y2 = every()\y
          Box(x,y,x2-x,y2-y,squaresClr)
          DrawingMode(#PB_2DDrawing_Default)
          Circle(x,y,R,squaresClr)
        EndIf
        SelectElement(every(),i)
    EndSelect
  Next
  StopDrawing()
EndProcedure

Procedure popalSquare(mX, mY, objX, objY, objW, objH)
  If mX >= objX And mX <= objX+objW And mY >= objY And mY <= objY+objH
    ProcedureReturn #True
  EndIf
  ProcedureReturn #False
EndProcedure
; IDE Options = PureBasic 5.31 (Windows - x86)
; CursorPosition = 23
; Folding = -
; EnableUnicode
; EnableXP