#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen

; Define the .ini file path to store settings
iniFile := A_ScriptDir "\Settings.ini"

; Load settings from the .ini file
IniRead, grindingOption1, %iniFile%, Settings, grindingOption1, false
IniRead, grindingOption2, %iniFile%, Settings, grindingOption2, false
IniRead, vip, %iniFile%, Settings, vip, false
IniRead, vippls, %iniFile%, Settings, vippls, false
IniRead, obbymain, %iniFile%, Settings, obbymain, false
IniRead, halfobby, %iniFile%, Settings, halfobby, false
IniRead, for, %iniFile%, Settings, for, false
IniRead, item1, %iniFile%, Settings, item1, false
IniRead, item2, %iniFile%, Settings, item2, false
IniRead, item3, %iniFile%, Settings, item3, false
IniRead, dailyquest, %iniFile%, Settings, dailyquest, false

; Create GUI Window
Gui, Add, Text,, REQUIREMENTS: 1920 1080 RESOLUTION AND ROBLOX FULLSCREEN 
Gui, Add, Text,, Seed Detection
Gui, Add, Checkbox, vgrindingOption1, Buy Grape
Gui, Add, Checkbox, vgrindingOption2, Buy Mushroom
Gui, Add, Checkbox, vobbymain, Buy Pepper
Gui, Add, Checkbox, vhalfobby, Buy Cacao
Gui, Add, Checkbox, vvip, Buy Beanstalk

Gui, Add, Text,, F1: Start, F2: Stop
Gui, Add, Text,, For Webhook support go in the Settings.ini file and put your link there
Gui, Add, Text,, IMPORTANT: Before starting the macro, face the seed shop. this is for blood moon detection

; Set default states for checkboxes based on values loaded from the .ini file
GuiControl, , grindingOption1, %grindingOption1%
GuiControl, , grindingOption2, %grindingOption2%
GuiControl, , vip, %vip%
GuiControl, , vippls, %vippls%
GuiControl, , obbymain, %obbymain%
GuiControl, , halfobby, %halfobby%

; Show the GUI window
Gui, Show,, Grow-A-Garden Macro V1 (Patch 1 - )
Return

; Save settings whenever the GUI is closed
GuiClose:
Gui, Submit, NoHide  ; Save current state of GUI controls to variables

; Write the values to the .ini file
SaveSettings()
ExitApp  ; Close the script

; Save settings function
SaveSettings() {
    global grindingOption1, grindingOption2, vip, vippls, obbymain, halfobby, iniFile
    IniWrite, %grindingOption1%, %iniFile%, Settings, grindingOption1
    IniWrite, %grindingOption2%, %iniFile%, Settings, grindingOption2
    IniWrite, %vip%, %iniFile%, Settings, vip
    IniWrite, %vippls%, %iniFile%, Settings, vippls
    IniWrite, %obbymain%, %iniFile%, Settings, obbymain
    IniWrite, %halfobby%, %iniFile%, Settings, halfobby
}



; Main loop starts with F1
lastGrindTick := 0

F1::
    SendDiscordEmbed("Macro Started", "The macro was started")
    Gui, Submit, NoHide
    SaveSettings()

    stopLoop := false
    lastGrindTick := A_TickCount - 300000

    Loop {
        if (stopLoop)
            Break

        Gui, Submit, NoHide

        if (grindingOption1) {
            elapsed := A_TickCount - lastGrindTick
            if (elapsed >= 300000) {
                lastGrindTick := A_TickCount
                SendDiscordEmbed("Seed Detection", "Starting Seed Check / Gear Check")
                Sleep 200
                Seedteleport()
                Sleep 300
               
            } else {
              
                
            }
        }
        Sleep 10000
    }
Return


F2::
stopLoop := true
AHKPanic(Kill=1, Pause=0, Suspend=0, SelfToo=1) { ;AHKPanic
DetectHiddenWindows, On
WinGet, IDList ,List, ahk_class AutoHotkey
Loop %IDList%
  {
  ID:=IDList%A_Index%
  WinGetTitle, ATitle, ahk_id %ID%
  IfNotInString, ATitle, %A_ScriptFullPath%
    {
    If Suspend
      PostMessage, 0x111, 65305,,, ahk_id %ID%  ; Suspend. 
    If Pause
      PostMessage, 0x111, 65306,,, ahk_id %ID%  ; Pause.
    If Kill
      WinClose, ahk_id %ID% ;kill
    }
  }
If SelfToo
  {
  If Suspend
    Suspend, Toggle  ; Suspend. 
  If Pause
    Pause, Toggle, 1  ; Pause.
  If Kill
    ExitApp
  }
}


Seedteleport() {
  Sleep 300
  MouseMove, 664, 116
  Sleep 300
  Click
  Sleep 500
  Send {e}
  Sleep 3000
  SeedPerformance()
}

SeedPerformance() {
  global grindingOption2
  global obbymain
  global halfobby
  global vip
  global grindingOption1
  Gui, Submit, NoHide  
  carrotreset()
  if (grindingOption1) {
    Loop 26 {
    Sleep 140
    Send {WheelDown}
  }
  MouseMove, 912, 856
  Sleep 80
  Click
  Sleep 80 
  MouseMove, 725, 824
  Sleep 80
  Click
  carrotreset()
  }

  if (grindingOption2) {
    Loop 27 {
    Sleep 240
    Send {WheelDown}
  }
  Sleep 70
  MouseMove, 705, 830
  Sleep 80
  Click 
  Sleep 80
  Loop 30 {
    Click 
    Sleep 110
  }
  carrotreset()
  }

  if (obbymain) {
    Loop 29 {
    Sleep 240
    Send {WheelDown}
  }
  }



}

carrotreset() {
  MouseMove, 1334, 552
  Sleep 100
  Loop 70 {
    Sleep 50
    Send {WheelUp}
  }
  MouseMove, 934, 455
  Sleep 100
  Click
  Sleep 100
  Click
}

SendDiscordEmbed(customTitle, customDescription) {
    iniFile := A_ScriptDir "\Settings.ini"

    IniRead, webhookURL, %iniFile%, Webhook, discordWebhook, ERROR

    if (webhookURL = "ERROR") {
        return
    }

    FormatTime, currentTime, , HH:mm:ss
    json := "{""embeds"": [{""title"": ""[" currentTime "] " customTitle """,""description"": """ customDescription """,""footer"": {""text"": ""Sent from Grow-A-Garden""}}]}"

    http := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    http.Open("POST", webhookURL, false)
    http.SetRequestHeader("Content-Type", "application/json")
    http.Send(json)

    return http.ResponseText
}

