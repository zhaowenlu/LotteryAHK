;#NoTrayIcon

#include LuckyDraw_FileOperation.ahk

;读取配置文件
LoadConfig()
LoadRuntimeConfig()
;CurrentLevel := PrizeLevelTotal
;Msgbox %CurrentLevel%
Color =  ABCDEF
#include LuckyDraw_GUI.ahk
CreateBackground(Background)
CreateRightMenu()
Gui, 2:Show, x0 y0 w%A_ScreenWidth% h%A_ScreenHeight%
SetTimer, UpdateNumber, 10
SetTimer, UpdateNumber, off
SetTimer, ShowResult, %ShowTime%
SetTimer,  ShowResult, off

ResetLottery:
CreateWelcomeGui()
SoundPlay, %EndMusic% 
start := 1
Gui, Show, W%InitWidth% H%InitHeight% X%InitPosX% Y%InitPosY%
WinSet, TransColor, %Color% 255
Return

BeginOneLevel:
If (CurrentLevel <= 0)
{
	CurrentLevel := 0
	return
}
TrigerAllowed := 1
state := 0
display_index := 0
totalnum :=PrizeNumber%CurrentLevel%
oncenum := OnceNum%CurrentLevel%
prizename := PrizeName%CurrentLevel%
startnum := 1
endnum := OnceNum%CurrentLevel%
row := PrizeRow%CurrentLevel%
column := PrizeColumn%CurrentLevel%
rrow := ResultRow%CurrentLevel%
rcolumn := ResultColumn%CurrentLevel%
array_num := 0
loopcount := totalnum / oncenum
PrizeNumFile = Prize%CurrentLevel%.txt 
bResultstate := 0
Gui, destroy
CreateGui(row, column, Color)
ReadLeftNumFromFile()
;loop %oncenum%   ; 显示控件
;{
;	GuiControl, Show, KeyPromt%A_Index%
;}
;GuiControl, Hide, HintText

SoundPlay, %LotteryMusic% 
SetTimer, UpdateNumber, on

UpdateGuiTitle(prizename, totalnum, startnum, endnum)
Gui, Show, W%InitWidth% H%InitHeight% X%InitPosX% Y%InitPosY%
WinSet, TransColor, %Color% 255
Return

UpdateNumber:
UpdateCount := 0
;MsgBox %totalnum%
loop 
{
	Random, rand, 1, %oriarray_num%
	luckynum := OriArray%rand%
	if ( luckynum > 0) 
	{
	    UpdateCount += 1
		;TrayTip, UpdateCount, %UpdateCount%
		;sleep 1000
		GuiControl,, KeyPromt%UpdateCount%, %luckynum%
	}
	if ( UpdateCount >= oncenum )
	{
	    break
	}
}
return

ContinueLottery:
if (array_num >= totalnum && CurrentLevel > 0)
{
	;loop %oncenum%
	;{
	;	GuiControl, Hide, KeyPromt%A_Index%
	;}
	;ResultTextW := InitWidth / 2 - 100
	;ResultTextH := InitHeight /2
	;GuiControl, Show, HintText
	if (EnterCount = 0)
	{
	    EnterCount := 1
		SoundPlay, %EndMusic%
		RangePrizeResult()
		PrizeResultTitle = %prizename%结果
		UpdateGuiTitle(PrizeResultTitle, totalnum, 0, 0)
		if (totalnum < 25)
		{
			Gosub, ShowResult
		}
		else
		{
			SetTimer, ShowResult, on
		}
	}
}
if (array_num < totalnum)
{ 
	UpdateGuiTitle(prizename, totalnum, startnum, endnum)
	if (TrigerAllowed = 0)
	{
		SoundPlay, %LotteryMusic% 
	}
	SetTimer, UpdateNumber, on
	TrigerAllowed := 1
}
Return

ShowResult:
bResultstate := 1
if (totalnum > 25)
{
	loop %loopcount%
	{
		i := (A_index - 1)*oncenum
		loop %oncenum%
		{
			i += 1
			element := Array%i% 
			GuiControl,, KeyPromt%A_index%, %element%
		}
		sleep %showtime%
	}
}
else 
{
	Gui, Destroy
	CreateGui(rrow, rcolumn, Color)
	UpdateGuiTitle(PrizeResultTitle, totalnum, 0, 0)
	Gui, Show, W%InitWidth% H%InitHeight% X%InitPosX% Y%InitPosY%
    WinSet, TransColor, %Color% 255
    loop %totalnum%
	{
		element := Array%A_index% 
		GuiControl,, KeyPromt%A_index%, %element%
	}
}
Return

ShowResultPreviousPage:
SetTimer, UpdateNumber, off
loop %oncenum%   ; 显示控件
{
	GuiControl, Show, KeyPromt%A_Index%
}
GuiControl, Hide, HintText

if (state = 0)
{
	display := display_index * oncenum 
	i := display
	loop %oncenum%
	{
		i += 1
		element := Array%i% 
		GuiControl,, KeyPromt%A_index%, %element%
	}
	state = 1
}
else
{
	k := display_index + drawnum - 1
	display_index := mod( k, drawnum) 
	display := display_index * oncenum
	display := Round(display)
	i := display
	loop %oncenum%
	{
		i := i + 1
		element := Array%i% 
		GuiControl,, KeyPromt%A_index%, %element%
	}
}
return

ShowResultNextPage:
SetTimer, UpdateNumber, off
if (state = 0)
{
	display := display_index * oncenum 
	i := display
	loop %oncenum%
	{
		i += 1
		element := Array%i% 
		GuiControl,, KeyPromt%A_index%, %element%
	}
	state = 1
}
else
{
    k := display_index + 1
	display_index := mod( k, drawnum) 
	display := display_index * oncenum 
	display := Round(display)
	i := display
	loop %oncenum%
	{
		i += 1
		element := Array%i% 
		GuiControl,, KeyPromt%A_index%, %element%
	}
}
return

TrigerLottery:
if ( TrigerAllowed = 1)
{
	TrigerAllowed := 0
	RestartAllowed := 1
	EnterCount := 0
	count = 0
	SetTimer, UpdateNumber, off
	if (array_num < totalnum)
	{
		SoundPlay, %TrigerMusic%
	}
	if (array_num >= totalnum)
	{
		loop %oncenum%
		{
			GuiControl, Hide, KeyPromt%A_Index%
		}
		GuiControl, show, HintText
		return
	}
	loop 
	{
		Random, rand, 1, %oriarray_num%
		luckynum := OriArray%rand%
		if (luckynum > 0 )
		{
			count += 1
			OriArray%rand% = 
			GuiControl,, KeyPromt%count%, %luckynum%
			array_num += 1
			Array%array_num% := luckynum
			FileAppend, %luckynum%`n , %A_WorkingDir%\%PrizeNumFile%
		}
		if (array_num = totalnum)
		{
			;Value := array_num + 1
			;order -= 1
			;IniWrite, %Value%, %A_WorkingDir%\LuckDraw.ini, prize%order%, start
			;IniWrite, %order%, %A_WorkingDir%\LuckDraw.ini, options, RunningRound
		}
		if (count >= oncenum)
		{
			break
		}
	}
	startnum := endnum + 1
	endnum := startnum + oncenum - 1
	if (array_num = totalnum)
	{
		WriteLeftNumToFile(oriarray_num)
	}
}
Return

RestartCurrentRound:  ;重新上次抽奖
if (RestartAllowed = 1 && TrigerAllowed = 0)
{
	SetTimer, UpdateNumber, off
	SoundPlay, %LotteryMusic%
	ShowControl()
	startline := array_num - oncenum + 1          ;从第startline行开始删除
	if (startline >= 1)
	{

		WriteLeftNumToFile(oriarray_num)
		RevertFile(PrizeNumFile, startline, oncenum)
		ReadLeftNumFromFile()

		array_num := array_num - oncenum
		endnum := startnum - 1
		startnum := endnum - oncenum + 1
		UpdateGuiTitle(prizename, totalnum, startnum, endnum)
	}
	SetTimer, UpdateNumber, on
	TrigerAllowed := 1 ;抽奖键有效
	ReStartAllowed := 0 ;重新抽奖键无效
}
return

StartNextPrizeOrder:
SetTimer, ShowResult, off
CurrentLevel --
if (CurrentLevel <= 0)
{
	CurrentLevel := 0
	IniWrite, %CurrentLevel%, %RuntimeConfig%, options, CurrentLevel
	return
	;;;;;;;;;;;;;
	CurrentLevel := 5
	IniWrite, %CurrentLevel%, %RuntimeConfig%, options, CurrentLevel
	Msgbox 抽奖结束
	ExitApp
	return
}
Gosub, BeginOneLevel
return

SaveAllPrizeNumber:
SaveResult()
Return

^s::
Gosub, SaveAllPrizeNumber
return

;^d::
;Loop
;{
;   FileReadLine, line, %A_WorkingDir%\%ResultFile%, %A_Index%
;    if ErrorLevel
;        break
;    array_num += 1
;    Array%array_num% := line
;}
;SetTimer, UpdateNumber, off
;SetTimer, ShowResult, on
;return

GuiClose:
GuiEscape:
2GuiClose:
2GuiEscape:
#x::
Gosub, QuitApp
Return

QuitApp:
SaveResult()
if (array_num < totalnum)
{
    IniWrite, %CurrentLevel%, %RuntimeConfig%, options, CurrentLevel
}
if (array_num = totalnum)
{
	CurrentLevel -= 1
	if (CurrentLevel <= 0)
	{
		CurrentLevel := 0
		;CurrentLevel := PrizeLevelTotal
	}
	IniWrite, %CurrentLevel%, %RuntimeConfig%, options, CurrentLevel
	;WriteLeftNumToFile(oriarray_num)
	;Value := array_num + 1
	;IniWrite, %Value%, %A_WorkingDir%\LuckDraw.ini, prize%order%, start
	;IniWrite, %order%, %A_WorkingDir%\LuckDraw.ini, options, RunningRound
}
ExitApp
Return


GuiContextMenu:
2GuiContextMenu:
menu, RightMenu, show, %A_GuiX%, %A_GuiY%
Return

Reset()
{
	global
	local time
	local timestr
	SaveResult()
	FileGetTime, time, %ResultFile%
	FormatTime, timestr, time, yyyyMMddHHmm
	IfExist,  %ResultFile%
	{
	    FileMove, %ResultFile%, %ResultFile%-%timestr%.txt
	}
	CurrentLevel := PrizeLevelTotal
	Gui, Destroy
	Gosub, ResetLottery
}

RangePrizeResult()
{
	global
	RangeFile(PrizeNumFile)
	loop %totalnum%
	{
		FileReadLine, line, %PrizeNumFile%, %A_index% 
		;TrayTip, line, %line%
		Array%A_index% := line
	}
}

ResetPrize:
Reset()
Return


PgDn::
;SoundPlay, %A_WinDir%\Media\ding.wav
Gosub, TrigerLottery
Return

PgUp::
if (start = 1)
{
	GoSub, BeginOneLevel
	start = 0
}
else
{
	Gosub, ContinueLottery
}
Return

 ^!n::   ;进行下一轮
Gosub, StartNextPrizeOrder
Return

^p::
Gosub, RestartCurrentRound
Return

