Global name$ = "Vector Paint v0.31", squareCounter, id$, squaresClr, R = 5

Enumeration
  #canvas2editor
  #DebugBtns
  #IMAGE_Color
EndEnumeration

IncludeFile "vector-paint-form.pbf"
IncludeFile "common.pb"
squaresClr = #green

Procedure Modulo(num)
  If num < 0
    ProcedureReturn -num
  EndIf
  ProcedureReturn num
EndProcedure

Procedure popalDot(mX, mY, objX, objY, objW = 5, objH = 5)
  If mX >= objX-R And mX <= objX+R And mY >= objY-R And mY <= objY+R
    ProcedureReturn #True
  EndIf
  ProcedureReturn #False
EndProcedure

Procedure editor2canvas()
  ClearList(all())
  For i=0 To CountGadgetItems(#editor)-1
    string$ = GetGadgetItemText(#editor,i)
    pos_type = FindString(string$, ",")+1
    startType = FindString(string$, ",", pos_type+1)+1
    x = Val(StringField(string$, 1, ","))
    y = Val(Mid(string$,pos_type))
    startColor = FindString(string$, ",", startType)+1
    Debug "startColor="+Str(startColor)
    Debug "startType="+Str(startType)
    Debug "startColor-startType="+Str(startColor-startType)
    type$ = Mid(string$,startType, startColor-startType-1)
    Debug type$
    Select type$
      Case "#start"
        type = #start
      Case "#stop"
        type = #stop
      Case "#area"
        type = #area
    EndSelect
    color = Val(Mid(string$,startColor))
    Debug "addDot("+Str(x)+","+Str(y)+","+Str(type)+","+Str(color)+")"
    addDot(x,y,type,color)
  Next
EndProcedure

Procedure editorSquares2canvas()
  ClearList(every())
  For i=0 To CountGadgetItems(#editorSquares)-1
    string$ = GetGadgetItemText(#editorSquares,i)
    pos_type = FindString(string$, ",")+1
    startType = FindString(string$, ",", pos_type+1)+1
    startID = FindString(string$, ",", startType)+1
    x = Val(StringField(string$, 1, ","))
    y = Val(Mid(string$,pos_type))
    type$ = Mid(string$,startType,startID-startType-1)
    id$ = Mid(string$,startID)
    Select type$
      Case "#squareBegin"
        type = #squareBegin
      Case "#squareEnd"
        type = #squareEnd
    EndSelect
    Debug "addSquare("+Str(x)+","+Str(y)+","+type$+","+id$+")"
    addSquare(x,y,type,id$)
  Next
EndProcedure

Procedure files2proc(name$)
  file = 0
  If name$
    Debug "file "+name$+" opened ok"
    If ReadFile(file,name$)
      Debug "read "+name$+" file ok"
      While Eof(file) = 0
        string$=ReadString(file)
        AddGadgetItem(#editor2proc,-1,string$)
      Wend
      CloseFile(file)
    Else
      MessageRequester("Ooops", "Cannot load "+name$)
    EndIf
  EndIf
EndProcedure

Procedure list2txt(param = 0)
  ClearGadgetItems(#editor)
  ForEach all()
    Select all()\type
      Case #start
        type$ = "#start"
      Case #stop
        type$ = "#stop"
      Case #area
        type$ = "#area"
    EndSelect
    txt$ = Str(all()\x)+","+Str(all()\y)+","+type$+","+Str(all()\color)
    AddGadgetItem(#editor,-1,txt$)
    If param
      AddGadgetItem(#editor2proc,-1,"addDot("+txt$+")")
    EndIf
  Next
  ClearGadgetItems(#editorSquares)
  ForEach every()
    Select every()\type
      Case #squareBegin
        type$ = "#squareBegin"
      Case #squareEnd
        type$ = "#squareEnd"
    EndSelect
    txt$ = Str(every()\x)+","+Str(every()\y)+","+type$+","+every()\id
    AddGadgetItem(#editorSquares,-1,txt$)
    If param
      AddGadgetItem(#editor2proc,-1,"addSquare("+txt$+")")
    EndIf
  Next
EndProcedure

Procedure canvas2resultProc()
  ClearGadgetItems(#editor2proc)
  files2proc("common.pb")
  list2txt(1)
  files2proc("result.pb")
EndProcedure

Procedure addFewDots(num)
  For i = 0 To num
    addDot(Random(300),Random(300),#start,Random(#white))
  Next
  list2txt()
EndProcedure

CurrentColor = Red(255)
CreateImage(#IMAGE_Color, 100, 30)
Macro clrBtn
  If StartDrawing(ImageOutput(#IMAGE_Color))
    Box(0, 0, 100, 30, CurrentColor)
    StopDrawing()
    SetGadgetAttribute(#GADGET_Color, #PB_Button_Image, ImageID(#IMAGE_Color))
  EndIf
EndMacro

Procedure squares4()
  addSquare(50,50,#squareBegin,"Tolik")
  addSquare(100,100,#squareEnd,"2")
  addSquare(200,50,#squareBegin,"Masha")
  addSquare(150,100,#squareEnd,"4")
  addSquare(50,200,#squareBegin,"Ivan")
  addSquare(100,150,#squareEnd,"6")
  addSquare(200,200,#squareBegin,"Max")
  addSquare(150,150,#squareEnd,"8")
EndProcedure

Openwnd()
squares4()
clrBtn
list2txt()

; IncludeFile "vector-paint-keyb.pb"
CurrentMode = #Squares2btns
DisableGadget(#Squares2btns,1)


Repeat
  event = WaitWindowEvent()
  If event = #PB_Event_Gadget
    Select EventGadget() 
      Case #canva
        mX = GetGadgetAttribute(#canva, #PB_Canvas_MouseX)
        mY = GetGadgetAttribute(#canva, #PB_Canvas_MouseY)
        StatusBarText(0, 0, Str(mX)+","+Str(mY)+color$)
        Select EventType() 
          Case #PB_EventType_LeftButtonDown
            StartX = mX
            StartY = mY
            If Not buttonPressed
              buttonPressed = #True
              Select CurrentMode 
                Case #Add
                  addDot(mX, mY,#start,CurrentColor)
                  SelectElement(all(),ListSize(all())-1)
                  all()\x = mX - R/2
                  all()\y = mY - R/2
                  Debug "added element ["+Str(all()\x) + "," + Str(all()\y) +"]"
                  
                Case #Fill
                  addDot(mX,mY,#area,CurrentColor) ;areaFill
                  
                Case #AddClickArea
                  If trigger
                    addSquare(mX,mY,#squareEnd,Str(squareCounter))
                    trigger = 0
                  Else
                    addSquare(mX,mY,#squareBegin,Str(squareCounter))
                    trigger = 1
                  EndIf
                  
                Case #Squares2btns
                  squares2btns
                  
                Case #Move, #Delete 
                  For i = ListSize(all())-1 To 0 Step -1
                    SelectElement(all(),i)
                    If popalDot(mX,mY,all()\x,all()\y)
                      Debug "touched element [" + Str(all()\x) + "," + Str(all()\y) + ","+i+"]"
                      offsetX = mX - all()\x
                      offsetY = mY - all()\y
                      selectedObject = i
                      If CurrentMode = #Delete
                        Debug "deleted element [" + Str(all()\x) + "," + Str(all()\y) + ","+i+"]"
                        DeleteElement(all())
                      EndIf
                      Break
                    EndIf
                  Next
              EndSelect
              drawAll()
            EndIf
            
          Case #PB_EventType_MouseMove
            If (buttonPressed And selectedObject > -1 And CurrentMode = #Move)
              SelectElement(all(),selectedObject)
              all()\x = mX - offsetX
              all()\y = mY - offsetY
              ;drawAll()
            EndIf
            
          Case #PB_EventType_LeftButtonUp
            If buttonPressed
              buttonPressed = #False
              selectedObject = -1
              ;drawAll()
            EndIf
            list2txt()
        EndSelect
        
      Case #Add, #Delete, #Move, #Fill, #AddClickArea, #Squares2btns
        EventGadget = EventGadget()
        For Gadget = #Add To #Delete
          If Gadget = EventGadget
            DisableGadget(Gadget, 1) 
          Else
            DisableGadget(Gadget, 0)
          EndIf
        Next Gadget          
        CurrentMode = EventGadget 
        
      Case #Random
        ClearList(all())
        addFewDots(13)
        
      Case #Hide
        If GetGadgetState(#Hide)
          R = 0
          squaresClr = 0
        Else
          R = 5
          squaresClr = #green
        EndIf
        
      Case #Clear
        ClearList(all())
        ClearList(every())
        ClearGadgetItems(#editor)
        
      Case #Open
        file = 0
        File$ = OpenFileRequester("Load Text...", "", "TXT Files|*.txt|All Files|*.*", 0)
        If File$
          If ReadFile(file,File$)
            ClearGadgetItems(#editor)
            ClearList(all())
            While Eof(file) = 0
              string$=ReadString(file)
              AddGadgetItem(#editor,-1,string$)
            Wend
            CloseFile(file)
            editor2canvas()
          Else
            MessageRequester("Ooops", "Cannot load file: " + File$)
          EndIf
        EndIf
        
      Case #Save
        list2txt()
        File$ = SaveFileRequester("Save Text...", File$, "TXT Files|*.txt|All Files|*.*", 0)
        If File$; And (FileSize(File$) = -1)
          If GetGadgetItemText(#editor,0) And CreateFile(file,File$)
            counter = CountGadgetItems(#editor) - 1
            For position = 0 To counter 
              WriteStringN(file,GetGadgetItemText(#editor,position))
            Next
            CloseFile(file)
          Else
            MessageRequester("Ой","Почему-то не могу создать файл")
          EndIf       
        EndIf
        
      Case #editor2canvas
        editor2canvas()
        
      Case #squares2canvas
        editorSquares2canvas()
        
      Case #GADGET_Color
        CurrentColor = ColorRequester(CurrentColor)
        clrBtn
        
      Case #stopLine
        SelectElement(all(),ListSize(all())-1)
        all()\type = #stop
        
      Case #squares
        squares4()
        
      Case #Procedure2copy
        canvas2resultProc()
        
    EndSelect
    drawAll()
  EndIf
  
;   If event = #PB_Event_Menu And #PB_EventType_Focus ; только если мышь на канве
;     Select EventMenu()
;       Case #down
;         SelectElement(all(),0)
;         all()\y + 10
;         selectedObject = -1
;         drawAll()
;       Case #up
;         SelectElement(all(),0)
;         all()\y - 10
;         selectedObject = -1
;         drawAll()
;       Case #left
;         SelectElement(all(),0)
;         all()\x - 10
;         selectedObject = -1
;         drawAll()
;       Case #right
;         SelectElement(all(),0)
;         all()\x + 10
;         selectedObject = -1
;         drawAll()
;       Case #stopLine
;         SelectElement(all(),ListSize(all())-1)
;         all()\type = #stop
;         drawAll()
;       Case #undo
;         Debug "Undo"
;       Case #redo
;         Debug "Redo"
;     EndSelect
;   EndIf
Until event = #PB_Event_CloseWindow
; IDE Options = PureBasic 5.31 (Windows - x86)
; CursorPosition = 324
; Folding = -8
; Markers = 77,206
; EnableUnicode
; EnableXP
; UseIcon = favicon.ico
; Executable = ..\..\..\Desktop\123.exe