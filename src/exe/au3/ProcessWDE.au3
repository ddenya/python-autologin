#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=..\ProcessWDE.exe
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>
#include <File.au3>
#include <Array.au3>
#include <WinAPI.au3>

; Getting arguments from command line and protecting against empty args

If $CmdLine[0] = 0 Then

	ConsoleWrite(@CRLF & "No function was supplied in arguments!" & @CRLF)
    Exit

EndIf

If $CmdLine[1] Then

	ConsoleWrite("GOT: " & $CmdLine[1] & @CRLF)

	$UserPass = ReadCredentials()
	$WDEUserName = $UserPass[0]
	$WDEPassword = $UserPass[1]

	;ConsoleWrite("User: " & "'" & $WDEUserName & "'" & " Pass: "  & "'" & $WDEPassword & "'" & @CRLF)

	If $CmdLine[1] == "LogInToSkype" Then
		ConsoleWrite("Got LogInToSkype" & @CRLF)
		LogInToSkype()
		Exit(0)
	EndIf
	If $CmdLine[1] == "LogInToWDE" Then
		ConsoleWrite("Got LogInToWDE" & @CRLF)
		LogInToWDE()
		Exit(0)
	EndIf
	If $CmdLine[1] == "SetAtDeskWDE" Then
		ConsoleWrite("Got SetAtDeskWDE" & @CRLF)
		SetAtDeskWDE()
		Exit(0)
	EndIf
EndIf

Func ReadCredentials()

   ; Reads credentials
   ; Returns array[2]
   Local $FullPath  = _PathFull("..\tmp", @ScriptDir)
   Local $sFileName = $FullPath & "\config.txt"
   Local $sRes[2]

   Local $UserName = IniRead($sFileName, "Credentials", "User", "nologin")
   Local $Pasword  = IniRead($sFileName, "Credentials", "Pass", "nopass")

   $sRes[0] = $UserName
   $sRes[1] = $Pasword

   return $sRes

EndFunc

Func LogInToSkype()

	ConsoleWrite("LogInToSkype() start" & @CRLF)

	ClickButtonAtMainWindow("Skype")
	MySleep(5)

	; Handling Skype update window here
	$SkypeUpdateWindowTitle   = 'First things first. - \\Remote'
	; "5" overrides Calling Attempt in FindAWindow so we start with 5
	$SkypeUpdateWindowHandle  = FindAWindow($SkypeUpdateWindowTitle, 0, 5)
	ConsoleWrite("HANDLE AFTER : " & $SkypeUpdateWindowHandle & @CRLF)

	; If Window is found - handle is NOT 555
	; If Window is not found - handle == 555

	If $SkypeUpdateWindowHandle <> 555 Then

		ConsoleWrite("Skype update window present")
		$SkypeUpdateWindowPos = GetWindowPos($SkypeUpdateWindowHandle, 1)

		ClickMouse( ($SkypeUpdateWindowPos[0] * 1.1), ($SkypeUpdateWindowPos[1] * 1.1) )
		MySleep(1.2)

		ClickMouse( ($SkypeUpdateWindowPos[0] + 38), ($SkypeUpdateWindowPos[1] + 178))
		MySleep(1.2)

		ClickMouse( ($SkypeUpdateWindowPos[0] + 430), ($SkypeUpdateWindowPos[1] + 328))
		MySleep(2)

	EndIf

	; Working with Skype window here
	$SkypeWindowTitle = 'Skype for Business  - \\Remote'
	$SkypeWindowHandle = FindAWindow($SkypeWindowTitle, 0)

	; X: 208 Y: 34
	$SkypeWindowPos = GetWindowPos($SkypeWindowHandle, 1)

	WinActivate($SkypeWindowHandle)
	MySleep(0.8)

	;_ArrayDisplay($SkypeWindowPos,"$SkypeWindowPos"
	; Click on Skype window area to "activate" window
	ClickMouse(($SkypeWindowPos[0] * 1.1), ($SkypeWindowPos[1] * 1.1))
	MySleep(0.8)

	;Options button
	; X = 999 Y = 210
	ClickMouse( ($SkypeWindowPos[0] + 370), ($SkypeWindowPos[1] + 146))
	MySleep(0.8)

	$SkypeOptionsWindowTitle = "Skype for Business - Options - \\Remote"
	$SkypeOptionsWindowHandle = FindAWindow($SkypeOptionsWindowTitle, 0)
	$SkypeOptionsWindowPos = GetWindowPos($SkypeOptionsWindowHandle, 1)
	WinActivate($SkypeOptionsWindowPos)
	MySleep(0.8)

	ClickMouse(($SkypeOptionsWindowPos[0] * 1.1), ($SkypeOptionsWindowPos[1] * 1.1))
	MySleep(0.8)

	;Status in options
	ClickMouse(($SkypeOptionsWindowPos[0] + 37),($SkypeOptionsWindowPos[1] + 115))
	MySleep(0.8)

	;First Time Field
	ClickMouse( ($SkypeOptionsWindowPos[0] + 657),($SkypeOptionsWindowPos[1] + 89))
	MySleep(0.8)

	;1 Key press = 61 milliseconds 300 * 61 = 18300
	; now it is 80 ms but anyway..
	HoldAKey( "{UP}", 18300)

	;Second Time Field
	ClickMouse( ($SkypeOptionsWindowPos[0] + 657),($SkypeOptionsWindowPos[1] + 118))
	MySleep(0.8)
	HoldAKey( "{UP}", 18300)

	; OK button
	ClickMouse( ($SkypeOptionsWindowPos[0] + 512),($SkypeOptionsWindowPos[1] + 568))
	MySleep(0.8)

	;WinSetState($SkypeWindowHandle, "",  @SW_MINIMIZE)
	;MySleep()

	ConsoleWrite("LogInToSkype() end" & @CRLF)

EndFunc

Func SetAtDeskWDE()

	;  Call once WDE Logged in
	;  Title: "Workspace - \\Remote"
	;  Set "At Desk" and Turn off Chat

	$WDELoggedInWindowTitle = 'Workspace - \\Remote'
	MySleep(1.5)

	$WDELoggedInHandle = FindAWindow($WDELoggedInWindowTitle, 0)
	MySleep(1.5)

	$WDELoggedInPos = GetWindowPos($WDELoggedInHandle, 1)
	MySleep(1.5)
	WinActivate($WDELoggedInHandle)

	; Click at the name
	ClickMouse( ($WDELoggedInPos[0] + 768),($WDELoggedInPos[1] + 22))
	MySleep(1.5)

	; Change status to "At Desk"
	ClickMouse( ($WDELoggedInPos[0] + 787),($WDELoggedInPos[1] + 105))
	MySleep(1.5)

	; Right click at Chat
	ClickMouse( ($WDELoggedInPos[0] + 82),($WDELoggedInPos[1] + 245), "right")
	MySleep(1.5)

	; Left click at Log Off
	ClickMouse( ($WDELoggedInPos[0] + 90),($WDELoggedInPos[1] + 464) )
	MySleep(1.5)

	;WinSetState($WDELoggedInHandle, "",  @SW_MINIMIZE)
	;Sleep($StandardSleep)

EndFunc

Func LogInToWDE()

	; Clicking WDE button
	ClickButtonAtMainWindow("WDE")
	MySleep(4)

	$WDELoginWindowTitle = 'Workspace - Log In - \\Remote'
	$WDELoginWindowHandle = FindAWindow($WDELoginWindowTitle, 0)
	$WDELoginWindowPos = GetWindowPos($WDELoginWindowHandle, 1)
	WinActivate($WDELoginWindowHandle)
	MySleep(2)

	; WDE Login field
	ClickMouse( ($WDELoginWindowPos[0] + 180),($WDELoginWindowPos[1] + 137))
	MySleep(2)

	; Cleanup
	HoldAKey( "{BACKSPACE}", 600)
	MySleep(1.5)

	; Enter login
	Send($WDEUserName)
	MySleep(1.5)

	; WDE Password field
	ClickMouse(($WDELoginWindowPos[0] + 180),($WDELoginWindowPos[1] + 177))
	MySleep(1.5)

	; Cleanup
	HoldAKey("{BACKSPACE}", 600)
	MySleep(1.5)

	; Enter password
	ConsoleWrite("Pass: " & "'" & $WDEPassword & "'" & @CRLF)
	; 1 means RAW
	; https://www.autoitscript.com/autoit3/docs/functions/Send.htm
	Send($WDEPassword, 1)
	MySleep(1.5)

	; WDE Log in button
	ClickMouse( ($WDELoginWindowPos[0] + 100),($WDELoginWindowPos[1] + 269))
	; It may take a while
	MySleep(10)


	; "Workspace - Channel Information - \\Remote"
	; No "login using recent data" checkbox present:
	; Pos: 657, 241
	; Size: 360, 384
	;
	; "+19097932853;ext=1020_Place" - OK button
	ClickMouse( ($WDELoginWindowPos[0] + 95),($WDELoginWindowPos[1] + 286))
	; I think it is a case when checkbox is present: Y has 14px of difference
	; How to check if box is present? - Use Window Size!
	;ClickMouse( ($WDELoginWindowPos[0] + 100),($WDELoginWindowPos[1] + 300))
	; It may take a while
	MySleep(10)

EndFunc

Func ClickButtonAtMainWindow($ButtonName)

	; Click button
	; Button can be: "WDE", "Chrome", "Skype"
	; Working with Support Services window

	ConsoleWrite("ClickButtonAtMainWindow() start " & @CRLF)

	$MainWindowTitle = "Support Services - \\Remote"
	$MainWindowHandle = FindAWindow($MainWindowTitle, 1)
	MySleep(0.2)

	WinActivate($MainWindowHandle)
	MySleep(0.5)

	ConsoleWrite("ClickButtonAtMainWindow() Title: " & $MainWindowTitle & @CRLF & "HANDLE: " & $MainWindowHandle & @CRLF)
	$MainWindowPos = GetWindowPos($MainWindowHandle,1)
	MySleep(0.3)

   If $ButtonName == "WDE" Then
	   ClickMouse( ($MainWindowPos[0] + 71), ($MainWindowPos[1] + 91))
	   MySleep(0.3)
   EndIf

   If $ButtonName == "Chrome" Then
	   ClickMouse( ($MainWindowPos[0] + 71), ($MainWindowPos[1] + 117) )
	   MySleep(0.3)
   EndIf

   If $ButtonName == "Skype" Then
	   ClickMouse( ($MainWindowPos[0] + 71), ($MainWindowPos[1] + 147) )
	   MySleep(0.3)
   EndIf

   ConsoleWrite("ClickButtonAtMainWindow() end " & @CRLF)

   EndFunc

Func MySleep($SleepMultiplier=1,$MessageNeeded=1)

	$StandardSleep = 1500

	If $MessageNeeded == 1 Then
		ConsoleWrite("Sleeping " & ($StandardSleep/1000 * $SleepMultiplier) & " s" &@CRLF)
	EndIf

	Sleep($StandardSleep * $SleepMultiplier)

EndFunc

Func FindAWindow($WindowTitle, $MessageNeeded, $CallingAttempt=1)

	; Retrieve a list of window handles

	Local $aList = WinList()
	Local $aWindowHandle = 555
	Local $WindowFound = 0
	Local $MaxAttempts = 6

	ConsoleWrite(@CRLF & "FindAWindow() start" & @CRLF)
	ConsoleWrite("Attempt " & $CallingAttempt & " of " & $MaxAttempts & @CRLF)
	ConsoleWrite("Target: " & $WindowTitle & @CRLF)
	MySleep(0.3, 0)

	If $CallingAttempt <= $MaxAttempts Then
		; Loop through the array displaying only visible windows with a title.
		For $i = 1 To $aList[0][0]
			If $aList[$i][0] <> "" And BitAND(WinGetState($aList[$i][1]), 2) And $aList[$i][0] == $WindowTitle Then

				If $MessageNeeded == 1 Then
					ConsoleWrite("Title: " & $aList[$i][0] & @CRLF & "Handle: " & $aList[$i][1] & @CRLF)
				EndIf

				$aWindowHandle = $aList[$i][1]
				ConsoleWrite("Found a window: " & $aWindowHandle & @CRLF)
				$WindowFound = 1

				ExitLoop
			EndIf
			MySleep(0.1, 0)
		Next
	EndIf

	If ($WindowFound == 0 and $CallingAttempt < $MaxAttempts) Then

		ConsoleWrite("Could not find a window: " & $WindowTitle & @CRLF)
		ConsoleWrite("Current handle: " & $aWindowHandle & @CRLF)
		ConsoleWrite("Retrying ..." & @CRLF)
		MySleep(5)
		$aWindowHandle = FindAWindow($WindowTitle, 1, $CallingAttempt + 1)

	EndIf

	If ($WindowFound == 0 and $CallingAttempt >= $MaxAttempts) Then
		ConsoleWrite("FindAWindow(): reached MaxAttemps: " & $MaxAttempts & " not found " & @CRLF)
		$aWindowHandle = 555
		ConsoleWrite("Current handle: " & $aWindowHandle & @CRLF)
		Return $aWindowHandle
	EndIf

	If $WindowFound == 1 Then
		ConsoleWrite("FindAWindow(): found " & @CRLF)
		ConsoleWrite("Current handle: " & $aWindowHandle & @CRLF)
		Return $aWindowHandle
	EndIf

	ConsoleWrite("FindAWindow(): Recursive return" & @CRLF)
	ConsoleWrite("Handle: " & $aWindowHandle & @CRLF)

	; Do not remove
	; I think it is because of recursion I use here
	Return $aWindowHandle

 EndFunc   ;==>Example

Func GetWindowPos($WindowHandle, $MessageNeeded)

   ; Retrieve the position as well as height and width of the active window.
   ConsoleWrite(@CRLF & "GetWindowPos start" & @CRLF)
   ConsoleWrite("Target: " & $WindowHandle & @CRLF)

   Local $aPos = WinGetPos($WindowHandle)

   For $RetryCount = 0 TO 5

   If $aPos[0] = -32000 Or $aPos[1] = -32000 Then
	   ConsoleWrite("Pos failed: " & @CRLF & "X: " & $aPos[0] & @CRLF & "Y: " & $aPos[1] & @CRLF )
	   ConsoleWrite("Retrying..." & @CRLF)
	   MySleep(1.5)

	   If Not WinActive($WindowHandle) Then
		   WinActivate($WindowHandle)
		   MySleep()
		   WinWaitActive($WindowHandle)
		EndIf

	   ;WinActivate($WindowHandle)
	   $aPos = WinGetPos($WindowHandle)
	   ConsoleWrite("NewPos: " & @CRLF & "X: " & $aPos[0] & @CRLF & "Y: " & $aPos[1] & @CRLF)
   EndIf
   Next

   If $MessageNeeded == 1 Then
		ConsoleWrite( "X-Pos: " & $aPos[0] & @CRLF & _
         "Y-Pos: " & $aPos[1] & @CRLF & _
         "Width: " & $aPos[2] & @CRLF & _
         "Height: " & $aPos[3] & @CRLF)
   EndIf
   Return $aPos

   ConsoleWrite("GetWindowPos end" & @CRLF)

EndFunc

Func ClickMouse($X, $Y, $type="left")
	;$type = "left" or "right"

	ConsoleWrite(@CRLF & "Click " & $type & @CRLF & "X: " & $X & @CRLF & "Y: " & $Y & @CRLF)
	MouseClick($type, $X, $Y, 1, 4)
	MySleep()
EndFunc

Func HoldAKey($Key, $Time)

   Local $begin = TimerInit()
   Local $i = 0
   Local $TimeToHold = $Time

   Local $CurrentDiff = Round(TimerDiff($begin),2)
   Local $PreviousDiff = 0

   ConsoleWrite("Holding " & $Key & " for " & $TimeToHold & " ms " & @CRLF)

   While $CurrentDiff <= $TimeToHold
	  ; 1 Iteration is done in ~ 80 milliseconds
	  $PreviousDiff = $CurrentDiff
	  Send($Key)
	  MySleep(0.046)
	  $i = $i +1
	  $CurrentDiff = Round(TimerDiff($begin),2)

	  ConsoleWrite("Press: " & $Key & " " & "(" & $i & ")" & " time: " & Round(($CurrentDiff - $PreviousDiff), 0) & " ms" & @CRLF )
   WEnd

EndFunc

Func WinGetControls($Title, $Text="")

	; Does not work with Citrix (Transparent Windows Client)
	; TWC windows have no control handles...

	Local $WndControls, $aControls, $sLast="", $n=1
	$WndControls = WinGetClassList($Title, $Text)
	$aControls = StringSplit($WndControls, @CRLF)
	Dim $aResult[$aControls[0]+1][2]
	For $i = 1 To $aControls[0]
		If $aControls[$i] <> "" Then
			If $sLast = $aControls[$i] Then
				$n+=1
			Else
			$n=1
			EndIf
			$aControls[$i] &= $n
			$sLast = StringTrimRight($aControls[$i],1)
		EndIf

		If $i < $aControls[0] Then
			$aResult[$i][0] = $aControls[$i]
		Else ; last item in array
			$aResult[$i][0] = WinGetTitle($Title) ; return WinTitle
		EndIf
		$aResult[$i][1] = ControlGetHandle($Title, $Text, $aControls[$i])
	Next
	$aResult[0][0] = "ClassnameNN"
	$aResult[0][1] = "Handle"
	Return $aResult

EndFunc