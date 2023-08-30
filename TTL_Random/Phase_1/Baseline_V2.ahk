#SingleInstance, Force
#NoEnv
;#Warn

;SetBatchLines, -1
;SetControlDelay, -1
SendMode Input
SetWorkingDir, %A_ScriptDir%

_FileRoot = C:\WakeTV\
_DataPath = Data\
_TempPath = Temp\
_OverlayPath = Overlays\
_TTL_DIS_IniFile = TTL_DIS.ini
_TTL_DIS_RemFile = TTL_DIS_Remain.txt
_OverlayDir := _FileRoot _OverlayPath
_DataDir := _FileRoot _DataPath
_TempDir := _FileRoot _TempPath
_TempFile = TTL_DIS.tmp
_OverlayFile = TTL_Overlay.txt
_TTL_DIS_IniFileFull := _FileRoot _DataPath _TTL_DIS_IniFile
_TTL_DIS_RemFileFull := _FileRoot _TempPath _TTL_DIS_RemFile
_TTL_OverlayFileFull := _FileRoot _OverlayPath _OverlayFile
_TempDir := _FileRoot _TempPath
_TempFileFull := _FileRoot _TempPath _TempFile

_DIS_CNT := ""
_DIS_ARR := []
_RND_DIS := ""
_TTL_INC_CNT := ""
_REFRESH_FILE = "NO"

FileCreateDir, %_DataDir%
FileCreateDir, %_OverlayDir%
FileCreateDir, %_TempDir%

if !FileExist(_TTL_DIS_IniFileFull) {
    IniWrite, "NULL", %_TTL_DIS_IniFileFull%, Config, ACTIVE
    IniWrite, 10, %_TTL_DIS_IniFileFull%, Config, TTL_GOAL
    IniWrite, "MAX", %_TTL_DIS_IniFileFull%, Config, HOT_SEAT       
    IniWrite, "ON", %_TTL_DIS_IniFileFull%, Disturbances, BlastBoth
    IniWrite, "ON", %_TTL_DIS_IniFileFull%, Disturbances, Blind
    IniWrite, "ON", %_TTL_DIS_IniFileFull%, Disturbances, Blower
    IniWrite, "ON", %_TTL_DIS_IniFileFull%, Disturbances, Bubbles
    IniWrite, "ON", %_TTL_DIS_IniFileFull%, Disturbances, Shock
    IniWrite, "ON", %_TTL_DIS_IniFileFull%, Disturbances, Spray
    IniWrite, "ON", %_TTL_DIS_IniFileFull%, Disturbances, Strobe
	}

if (A_Args[1] = "") {
	goto, ForceExitApp
} Else {
	_TTL_INC_CNT := A_Args[1]
}

if (A_Args[1] = "RESET") {
	goto, RESET_STREAM
}

if (A_Args[1] = "MAX" or A_Args[1] = "MEL") {
    _HOT_SEAT := A_Args[1]
	goto, HOT_SEAT_SWAP
}

INITIAL_STREAM_CONFIG:
IniRead, _HOT_SEAT, %_TTL_DIS_IniFileFull%, Config, HOT_SEAT
IniRead, _CURRENT_DIS, %_TTL_DIS_IniFileFull%, Config, ACTIVE

if instr(_CURRENT_DIS, "NULL") {
    _CURRENT_DIS := DISTURBANCE_SELECTION()
    REMOVE_DIS_ITEM(_DIS_RND_NUM)
    goto, OVERLAY_GENERATION
} else {
    goto, ACTIVATION_SELECTION
}

ACTIVATION_SELECTION:
if instr(_CURRENT_DIS, "BlastBoth") {
    goto, ACTIVATE_BLASTBOTH
}

if instr(_CURRENT_DIS, "Blind") {
    goto, ACTIVATE_BLIND
}

if instr(_CURRENT_DIS, "Blower") {
    goto, ACTIVATE_BLOWER
}

if instr(_CURRENT_DIS, "Bubbles") {
    goto, ACTIVATE_BUBBLES
}

if instr(_CURRENT_DIS, "Shock") {
    goto, ACTIVATE_SHOCK
}

if instr(_CURRENT_DIS, "Spray") {
    goto, ACTIVATE_SPRAY
}

if instr(_CURRENT_DIS, "Strobe") {
    goto, ACTIVATE_STROBE
}

ACTIVATE_BLASTBOTH:
R_HTTP := ComObjCreate("WinHTTP.WinHttpRequest.5.1")
L_HTTP := ComObjCreate("WinHTTP.WinHttpRequest.5.1")
R_HTTP.SetTimeouts(0,10000,10000,10000)
L_HTTP.SetTimeouts(0,10000,10000,10000)
R_HTTP.Open("GET", "http://Max_Blaster_Gun/TRIGGER", 0)
L_HTTP.Open("GET", "http://Mel_Blaster_Gun/TRIGGER", 0)
R_HTTP.Send()
L_HTTP.Send()

_CURRENT_DIS := DISTURBANCE_SELECTION()
REMOVE_DIS_ITEM(_DIS_RND_NUM)
goto, OVERLAY_GENERATION

ACTIVATE_BLIND:

WinHTTP := ComObjCreate("WinHTTP.WinHttpRequest.5.1")
WinHTTP.SetTimeouts(0,10000,10000,10000)
WinHTTP.Open("PUT", "http://192.168.1.10/api/9mt-Y7y6rwoeSaeaHyojMej3RVV4ZVVujiXW9mdw/lights/12/state", 0)
lighton = {"on" : true}
lightoff = {"on" : false}

Loop, 10
{
    WinHTTP.Send(lighton)
    RandSleep(1000,5000)
    WinHTTP.Send(lightoff)
    RandSleep(1000,5000)
}

_CURRENT_DIS := DISTURBANCE_SELECTION()
REMOVE_DIS_ITEM(_DIS_RND_NUM)
goto, OVERLAY_GENERATION

ACTIVATE_BLOWER:
WinHTTP := ComObjCreate("WinHTTP.WinHttpRequest.5.1")
WinHTTP.SetTimeouts(0,10000,10000,10000)
WinHTTP.Open("PUT", "http://192.168.1.10/api/9mt-Y7y6rwoeSaeaHyojMej3RVV4ZVVujiXW9mdw/lights/19/state", 0)
Blowon = {"on" : true}
Blowoff = {"on" : false}
WinHTTP.Send(Blowon)
Sleep, 7000
WinHTTP.Send(Blowoff)

_CURRENT_DIS := DISTURBANCE_SELECTION()
REMOVE_DIS_ITEM(_DIS_RND_NUM)
goto, OVERLAY_GENERATION

ACTIVATE_BUBBLES:
WinHTTP := ComObjCreate("WinHTTP.WinHttpRequest.5.1")
WinHTTP.SetTimeouts(0,10000,10000,10000)
WinHTTP.Open("PUT", "http://192.168.1.10/api/9mt-Y7y6rwoeSaeaHyojMej3RVV4ZVVujiXW9mdw/lights/24/state", 0)
Blowon = {"on" : true}
Blowoff = {"on" : false}
WinHTTP.Send(Blowon)
Sleep, 10000
WinHTTP.Send(Blowoff)

_CURRENT_DIS := DISTURBANCE_SELECTION()
REMOVE_DIS_ITEM(_DIS_RND_NUM)
goto, OVERLAY_GENERATION

ACTIVATE_SHOCK:
WinHTTP := ComObjCreate("WinHTTP.WinHttpRequest.5.1")
WinHTTP.SetTimeouts(0,10000,10000,10000)
WinHTTP.Open("GET", "http://Max_Shocker/TRIGGER", 0)
WinHTTP.Send()

_CURRENT_DIS := DISTURBANCE_SELECTION()
REMOVE_DIS_ITEM(_DIS_RND_NUM)
goto, OVERLAY_GENERATION

ACTIVATE_SPRAY:
WinHTTP := ComObjCreate("WinHTTP.WinHttpRequest.5.1")
WinHTTP.SetTimeouts(0,10000,10000,10000)
WinHTTP.Open("GET", "http://Max_Sprayer/TRIGGER", 0)
WinHTTP.Send()

_CURRENT_DIS := DISTURBANCE_SELECTION()
REMOVE_DIS_ITEM(_DIS_RND_NUM)
goto, OVERLAY_GENERATION

ACTIVATE_STROBE:
LeftKeyLight := ComObjCreate("WinHTTP.WinHttpRequest.5.1")
RightKeyLight := ComObjCreate("WinHTTP.WinHttpRequest.5.1")
RightKeyLight.SetTimeouts(0,10000,10000,10000)
LeftKeyLight.SetTimeouts(0,10000,10000,10000)
lightsoff = {"Lights": [{"on":0}]}
lightson = {"Lights": [{"on":1}]}
leftlightsdefault = {"Lights": [{"on":1,"brightness":40,"temperature":213}]}
rightlightsdefault = {"Lights": [{"on":1,"brightness":40,"temperature":203}]}
LeftKeyLight.Open("PUT", "http://192.168.1.15:9123/elgato/lights", 0)
RightKeyLight.Open("PUT", "http://192.168.1.21:9123/elgato/lights", 0)

Loop, 50 {
    LeftKeyLight.Send(lightson)
    RightKeyLight.Send(lightson)
    sleep, 150
    LeftKeyLight.Send(lightsoff)
    RightKeyLight.Send(lightsoff)
    sleep, 150
}
sleep, 850
LeftKeyLight.Send(leftlightsdefault)
RightKeyLight.Send(rightlightsdefault)

_CURRENT_DIS := DISTURBANCE_SELECTION()
REMOVE_DIS_ITEM(_DIS_RND_NUM)
goto, OVERLAY_GENERATION

OVERLAY_GENERATION:
goto, OVERLAY_CNT_GENERATION

OVERLAY_CNT_GENERATION:
IniRead, _CURRENT_TTL_GOAL, %_TTL_DIS_IniFileFull%, Config, TTL_GOAL
EnvAdd, _CURRENT_TTL_GOAL, _TTL_INC_CNT
IniWrite, %_CURRENT_TTL_GOAL%, %_TTL_DIS_IniFileFull%, Config, TTL_GOAL

if (_CURRENT_TTL_GOAL < 1000) {
    _TTL_CNT_OVLY := _CURRENT_TTL_GOAL "K "
} else {
    _TTL_CNT_OVLY := Format("{:.2f}", (_CURRENT_TTL_GOAL / 1000)) "M "
}

goto, OVERLAY_GOAL_GENERATION

OVERLAY_GOAL_GENERATION:

_FUTURE_DIS := _RND_DIS

if instr(_FUTURE_DIS, "BlastBoth") {
    _FULL_OVERLAY := _TTL_CNT_OVLY "LIKES = ORBEEZ BLAST"
}

if instr(_FUTURE_DIS, "Blind") {
    _FULL_OVERLAY := _TTL_CNT_OVLY "LIKES = BLIND US"
}

if instr(_FUTURE_DIS, "Blower") {
    _FULL_OVERLAY := _TTL_CNT_OVLY "LIKES = BLOW " _HOT_SEAT
}

if instr(_FUTURE_DIS, "Bubbles") {
    _FULL_OVERLAY := _TTL_CNT_OVLY "LIKES = BUBBLIFY US"
}

if instr(_FUTURE_DIS, "Shock") {
    _FULL_OVERLAY := _TTL_CNT_OVLY "LIKES = SHOCK " _HOT_SEAT
}

if instr(_FUTURE_DIS, "Spray") {
    _FULL_OVERLAY := _TTL_CNT_OVLY "LIKES = SPRAY " _HOT_SEAT
}

if instr(_FUTURE_DIS, "Strobe") {
    _FULL_OVERLAY := _TTL_CNT_OVLY "LIKES = STROBE LIGHTS"
}

FileDelete, %_TTL_OverlayFileFull%
FileAppend, %_FULL_OVERLAY%, %_TTL_OverlayFileFull%

goto, ForceExitApp

RESET_STREAM:
FileDelete, %_TTL_DIS_RemFileFull%
IniWrite, "NULL", %_TTL_DIS_IniFileFull%, Config, ACTIVE
IniWrite, "MAX", %_TTL_DIS_IniFileFull%, Config, HOT_SEAT
IniWrite, 10, %_TTL_DIS_IniFileFull%, Config, TTL_GOAL

IniRead, _HOT_SEAT, %_TTL_DIS_IniFileFull%, Config, HOT_SEAT


_CURRENT_DIS := DISTURBANCE_SELECTION()
REMOVE_DIS_ITEM(_DIS_RND_NUM)
goto, OVERLAY_GENERATION


HOT_SEAT_SWAP:
IniWrite, %_HOT_SEAT%, %_TTL_DIS_IniFileFull%, Config, HOT_SEAT
goto, ForceExitApp

ForceExitApp:
ExitApp
Return

REMOVE_DIS_ITEM(_DIS_RND_NUM) {
    global
    Loop, Read, %_TTL_DIS_RemFileFull%
    {
        If (A_Index = _DIS_RND_NUM or A_LoopReadLine = "") {
            Continue
        } else {
            FileAppend %A_LoopReadLine%`n, %_TempFileFull%
        }
    }

    if instr(_REFRESH_FILE, "YES") {
        FileDelete, %_TTL_DIS_RemFileFull%
    } else {
        FileMove, %_TempFileFull%, %_TTL_DIS_RemFileFull%, 1
    }

Return
}

DISTURBANCE_SELECTION() {
    global
    IniRead, _DIS_INI_LIST, %_TTL_DIS_IniFileFull%, Disturbances

    if !FileExist(_TTL_DIS_RemFileFull) {

        Loop, parse, _DIS_INI_LIST, `n
        {
            if (InStr(A_LoopField, "ON") > 0) {
                _StrArray := StrSplit(A_LoopField, "=")
                _Disturbance := _StrArray[1]
                FileAppend, %_Disturbance%`n, %_TTL_DIS_RemFileFull%
            }
        }
    }

    FileRead, _DIS_RAW_LIST, %_TTL_DIS_RemFileFull%

    Loop, parse, _DIS_RAW_LIST, `n
    {
        if (A_LoopField <> "") {
            _DIS_ARR.push(A_LoopField)
            _DIS_CNT := _DIS_CNT + 1
        }
    }

    if (_DIS_CNT > 1) {
        Random, _DIS_RND_NUM, 1, %_DIS_CNT%
    } Else {
        _DIS_RND_NUM := 1
        _REFRESH_FILE = "YES"
    }

    FileReadLine, _RND_DIS, %_TTL_DIS_RemFileFull%, %_DIS_RND_NUM%
    IniWrite, %_RND_DIS%, %_TTL_DIS_IniFileFull%, Config, ACTIVE

    return 
}

RandSleep(x,y) {
    Global
    Random, rand, %x%, %y%
    Sleep %rand%
}

