#SingleInstance force
#NoEnv
;#Warn
SendMode Input
SetWorkingDir %A_ScriptDir%

SetTimer, ForceExitApp, 30000

Gui, +E0x20 -Caption +LastFound +ToolWindow +AlwaysOnTop +Border
Gui Color, 0xC0C0C0
Gui, Font, s14, w700, Verdana
Gui, Add, Text, vWinText c000000 +center, THE ENTITY HAS ATTACKED!!!`r`Silly Urban Evading`r`like a rando...
WinSet, Transparent, 200
GuiControl, +Center, WinText
Gui, Show, NoActivate
sleep, 2000
Gui, Destroy



if (SUCCEEDED(SpGetCategoryFromId(SPCAT_VOICES := "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Speech_OneCore\Voices", cpSpObjectTokenCategory)))
{
	hr := DllCall(NumGet(NumGet(cpSpObjectTokenCategory+0)+18*A_PtrSize), "Ptr", cpSpObjectTokenCategory, "Ptr", 0, "Ptr", 0, "Ptr*", cpSpEnumTokens)

	if (SUCCEEDED(hr))
	{
		hr := DllCall(NumGet(NumGet(cpSpEnumTokens+0)+8*A_PtrSize), "Ptr", cpSpEnumTokens, "UInt*", tokenCount)
		if (SUCCEEDED(hr))
		{
			voices := Object()
			Loop %tokenCount% {
				hr := DllCall(NumGet(NumGet(cpSpEnumTokens+0)+7*A_PtrSize), "Ptr", cpSpEnumTokens, "UInt", A_Index - 1, "Ptr*", pToken)
				if (FAILED(hr)) {
					MsgBox Bailing out
					ExitApp 1
				}
				hr := DllCall(NumGet(NumGet(pToken+0)+6*A_PtrSize), "Ptr", pToken, "Ptr", 0, "Ptr*", pszValue)
				if (FAILED(hr)) {
					MsgBox Bailing out
					ExitApp 2
				}
				hr := DllCall(NumGet(NumGet(pToken+0)+16*A_PtrSize), "Ptr", pToken, "Ptr*", pszCoMemTokenId)
				if (FAILED(hr)) {
					MsgBox Bailing out
					ExitApp 3
				}
				voices[StrGet(pszCoMemTokenId, "UTF-16")] := StrGet(pszValue, "UTF-16")
				DllCall("ole32\CoTaskMemFree", "Ptr", pszValue)
				DllCall("ole32\CoTaskMemFree", "Ptr", pszCoMemTokenId)
				ObjRelease(pToken)
			}
			prompt := "Pick a voice by its number:"
			for k, v in voices
				prompt .= "`r`n" . A_Index . ": " v
			InputBox, TheChosenOne,, %prompt%
			if (ErrorLevel == 0) {
				for k, v in voices {
					if (A_Index == TheChosenOne) {
						hr := DllCall(NumGet(NumGet(cpSpObjectTokenCategory+0)+19*A_PtrSize), "Ptr", cpSpObjectTokenCategory, "WStr", k)
						break
					}
				}
			}
		}
		ObjRelease(cpSpEnumTokens)
	}

	ObjRelease(cpSpObjectTokenCategory)
}

SpGetCategoryFromId(pszCategoryId, ByRef ppCategory, fCreateIfNotExist := False)
{
    static CLSID_SpObjectTokenCategory := "{A910187F-0C7A-45AC-92CC-59EDAFB77B53}"
		  ,ISpObjectTokenCategory      := "{2D3D3845-39AF-4850-BBF9-40B49780011D}"

	hr := 0
	try {
		cpTokenCategory := ComObjCreate(CLSID_SpObjectTokenCategory, ISpObjectTokenCategory)
    } catch e {
		; No, A_LastError or ErrorLevel doesn't contain the error code on its own and I CBA to use CoCreateInstance directly
		if (RegExMatch(e.Message, "0[xX][0-9a-fA-F]+", errCode)) { ; https://stackoverflow.com/a/9221391
			hr := errCode + 0
		} else {
			hr := 0x80004005
		}
	}

    if (SUCCEEDED(hr))
    {
		hr := DllCall(NumGet(NumGet(cpTokenCategory+0)+15*A_PtrSize), "Ptr", cpTokenCategory, "WStr", pszCategoryId, "Int", fCreateIfNotExist)
    }
    
    if (SUCCEEDED(hr))
    {
        ppCategory := cpTokenCategory
    } 
	else
	{
		if (cpTokenCategory)
			ObjRelease(cpTokenCategory)
	}

	return hr
}

; https://github.com/maul-esel/AHK-Util-Funcs/blob/master/FAILED.ahk
SUCCEEDED(hr)
{
	return hr != "" && hr >= 0x00
}

FAILED(hr)
{
	return hr == "" || hr < 0
}

ComObjCreate("SAPI.SpVoice").Speak("sup AHK how we doin today")

GOTO, ForceExitApp


sleep 28000
GOTO, ForceExitApp


ForceExitApp:

SetTimer, ForceExitApp, Off
ExitApp
Return

!F2::

Gui, +E0x20 -Caption +LastFound +ToolWindow +AlwaysOnTop +Border
Gui Color, 0xC0C0C0
Gui, Font, s24, w700, Verdana
Gui, Add, Text, vWinText c000000 +center, CHEATER`r`ENTITY DISABLED`r`Urban Evading Gone!
WinSet, Transparent, 200
GuiControl, +Center, WinText
Gui, Show, NoActivate
sleep, 2000
Gui, Destroy
ExitApp
Return

