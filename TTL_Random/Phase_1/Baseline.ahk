#SingleInstance, Force
#NoEnv
#Warn

SendMode Input
SetWorkingDir, %A_ScriptDir%

_FileRoot = C:\WakeTV\
_DataPath = Data\
_TempPath = Temp\
_TTL_DIS_IniFile = TTL_DIS.ini
_TTL_DIS_RemFile = TTL_DIS_Remain.txt
_TempDir := _FileRoot _TempPath
_TempFile = TTL_DIS.tmp
_TTL_DIS_IniFileFull := _FileRoot _DataPath _TTL_DIS_IniFile
_TTL_DIS_RemFileFull := _FileRoot _TempPath _TTL_DIS_RemFile
_TempDir := _FileRoot _TempPath
_TempFileFull := _FileRoot _TempPath _TempFile

_DIS_CNT := 0
_DIS_ARR := []
_RND_DIS := ""
_REFRESH_FILE = "NO"

FileCreateDir, %_TempDir%

if !FileExist(_TTL_DIS_IniFileFull) {
    IniWrite, "NULL", %_TTL_DIS_IniFileFull%, Config, ACTIVE
    IniWrite, "10", %_TTL_DIS_IniFileFull%, Config, CURRENT_TTL_CNT    
    IniWrite, "ON", %_TTL_DIS_IniFileFull%, Disturbances, BlastBoth
    IniWrite, "ON", %_TTL_DIS_IniFileFull%, Disturbances, BlastMax
    IniWrite, "ON", %_TTL_DIS_IniFileFull%, Disturbances, BlastMel
    IniWrite, "ON", %_TTL_DIS_IniFileFull%, Disturbances, Blind
    IniWrite, "ON", %_TTL_DIS_IniFileFull%, Disturbances, Blower
    IniWrite, "ON", %_TTL_DIS_IniFileFull%, Disturbances, Bubbles
    IniWrite, "ON", %_TTL_DIS_IniFileFull%, Disturbances, Shock
    IniWrite, "ON", %_TTL_DIS_IniFileFull%, Disturbances, Spray
    IniWrite, "ON", %_TTL_DIS_IniFileFull%, Disturbances, Strobe
	}

;if (A_Args[1] = "") {
;	goto, ForceExitApp
;	} Else {
	_TTL_INC_CNT := 10
;	_TTL_INC_CNT := A_Args[1]
;	}

;if (A_Args[1] = "RESET") {
;	goto, RESET_STREAM
;	}

RESET_STREAM:

FileDelete, %_TTL_DIS_RemFileFull%
IniWrite, "NULL", %_TTL_DIS_IniFileFull%, Config, ACTIVE
IniWrite, 10, %_TTL_DIS_IniFileFull%, Config, CURRENT_TTL_CNT  
goto, INITIAL_STREAM

INITIAL_STREAM:

IniRead, _CURRENT_DIS, %_TTL_DIS_IniFileFull%, Config, ACTIVE

if instr(_CURRENT_DIS, "NULL") {
    goto, DISTURBANCE_SELECTION
} else {
    goto, ACTIVATION_SELECTION
}

DISTURBANCE_SELECTION:

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

IniRead, _CURRENT_DIS, %_TTL_DIS_IniFileFull%, Config, ACTIVE

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
REMOVE_DIS_ITEM(_DIS_RND_NUM)

if instr(_RND_DIS, "BlastBoth") {
    goto, ACTIVATE_BLASTBOTH
}

if instr(_RND_DIS, "BlastMax") {
    goto, ACTIVATE_BLASTMAX
}

if instr(_RND_DIS, "BlastMel") {
    goto, ACTIVATE_BLASTMEL
}

if instr(_RND_DIS, "Blind") {
    goto, ACTIVATE_BLIND
}

if instr(_RND_DIS, "Blower") {
    goto, ACTIVATE_BLOWER
}

if instr(_RND_DIS, "Bubbles") {
    goto, ACTIVATE_BUBBLES
}

if instr(_RND_DIS, "Shock") {
    goto, ACTIVATE_SHOCK
}

if instr(_RND_DIS, "Spray") {
    goto, ACTIVATE_SPRAY
}

if instr(_RND_DIS, "Strobe") {
    goto, ACTIVATE_STROBE
}

goto ForceExitApp


ACTIVATION_SELECTION:
if instr(_CURRENT_DIS, "BlastBoth") {
    goto, ACTIVATE_BLASTBOTH
}

if instr(_CURRENT_DIS, "BlastMax") {
    goto, ACTIVATE_BLASTMAX
}

if instr(_CURRENT_DIS, "BlastMel") {
    goto, ACTIVATE_BLASTMEL
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
MsgBox, , ACTIVATED, "Shoot Max & Mel", 3
goto, REMOVE_DIS_ITEM

ACTIVATE_BLASTMAX:
MsgBox, , ACTIVATED, "Shoot Max", 3
goto, REMOVE_DIS_ITEM

ACTIVATE_BLASTMEL:
MsgBox, , ACTIVATED, "Shoot Mel", 3
goto, REMOVE_DIS_ITEM

ACTIVATE_BLIND:
MsgBox, , ACTIVATED, "Blind", 3
goto, REMOVE_DIS_ITEM

ACTIVATE_BLOWER:
MsgBox, , ACTIVATED, "Blower", 3
goto, REMOVE_DIS_ITEM

ACTIVATE_BUBBLES:
MsgBox, , ACTIVATED, "Bubbles", 3
goto REMOVE_DIS_ITEM

ACTIVATE_SHOCK:
MsgBox, , ACTIVATED, "Shock", 3
goto, REMOVE_DIS_ITEM

ACTIVATE_SPRAY:
MsgBox, , ACTIVATED, "Spray", 3
goto, REMOVE_DIS_ITEM

ACTIVATE_STROBE:
MsgBox, , ACTIVATED, "Strobe", 3
goto, REMOVE_DIS_ITEM




goto ForceExitApp

ForceExitApp:
ExitApp
Return



REMOVE_DIS_ITEM(_DIS_RND_NUM) {
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
