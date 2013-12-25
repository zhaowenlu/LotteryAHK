InitPosX := 0
InitPosY := 0
InitWidth := A_ScreenWidth 
InitHeight := A_ScreenHeight

ShowControl()
{
	global 
	loop %oncenum%
	{
		GuiControl, Show, KeyPromt%A_index%
	}
	GuiControl, Hide, HintText
}

CreateBackground(picture)
{
	global
	;Gui, 2:+LastFound -AlwaysOnTop -Caption +ToolWindow +MaximizeBox
	Gui, 2:-Caption +ToolWindow
	Gui, 2:Add, Picture, x%InitPosX% y%InitPosY% w%InitWidth% h%InitHeight%, %picture%
}

CreateWelcomeGui()
{
	global
	Gui, +LastFound +AlwaysOnTop -Caption +ToolWindow
	Gui, Color, %Color%
	Gui, Font, s80
	Gui, Font, c%FontColor%
	Gui, Font, bold
	Gui, Font,,Arial Bold
	ResultTextW1 := InitWidth / 2 - 200
	ResultTextH1:= InitHeight /2 - 80
	HintTextW := InitWidth - A_ScreenWidth * 1 / 2 + HintTextOffSetW
	HintTextH := InitHeight - 50 + HintTextOffSetH
	Gui, Add, Text, x%ResultTextW1% y%ResultTextH1%, 抽奖环节
    Gui, Font, s15, Courier New
	Gui, Add, Text, x%HintTextW% y%HintTextH%, Powered by @xuyangela && @wenlu from @DianGroup
}
;界面部分
CreateGui(row, column, color)
{
	global

	NumAreaHeight := InitHeight * 5 / 6
	NumAreaWidth := InitWidth * 5 / 6
	;TextHeightInterval := NumAreaHeight / row - yIntervalOffset   ;y间隔距离   40
	TextHeightInterval := NumAreaHeight / (row + 1) + yIntervalOffset
	;TextWidthInterval := NumAreaWidth / column - xIntervalOffset     ;x间隔距离   10
	TextWidthInterval := NumAreaWidth / (column + 1) + xIntervalOffset
	;OriTextWidth := NumAreaWidth / (column + 1) - xNumStartOffset ;开始起点x    100
	;OriTextHeight := (NumAreaHeight - yNumStartOffset) / (row + 1)     ;开始起点y   70
	OriTextWidth := TextWidthInterval + xNumStartOffset 
	OriTextHeight := TextHeightInterval + yNumStartOffset

	TextWidth := InitWidth / 2 - xTitleOffset ;奖项名称x坐标  200

	display_index := 0 ; 用于结果显示
	state = 0
	Gui, +LastFound +AlwaysOnTop -Caption +ToolWindow
	Gui, Color, %Color%
	;Gui, Add, Picture, x%InitPosX% y%InitPosY% w%InitWidth% h%InitHeight%, %Background%

	;显示标题和抽奖区间
	Gui, Font, s%TitleSize% ;设置字体
	Gui, Font, c%FontColor%
	Gui, Font, bold
	Gui, Font,,%FontType%
	Gui, Add, Text, vGuiTitle x%TextWidth% y0, xxxxxxxxxxxxxxxxxxx
	Gui, Font, s%AttachedTitleSize%
	TextWidthk := TextWidth + xAttachedTitleOffset    ;125
	Gui, Add, Text, vAttachedTitle x%TextWidthk% y70, xxxxxxxxxxxx

	Gui, Font, s50
	ResultTextW2 := InitWidth / 2 - 200
	ResultTextH2 := InitHeight /2
	Gui, Add, Text, vHintText x%ResultTextW2% y%ResultTextH2%, 本轮抽奖结束！
	GuiControl, Hide, HintText
	if (bResultstate = 0)
	{
		local numsize := Numbersize%CurrentLevel%
		Gui, Font, s%numsize%
	}
	else
	{
		local ssize := ShowSize%CurrentLevel%
		Gui, Font, s%ssize%
	}
	DrawArrayText(row, column) 
}


UpdateGuiTitle(title, prizenum, start, end)
{
	global oncenum
	global totalnum
	global bResultstate
	global array_num
	if(start = end && bResultstate = 0 && totalnum > array_num)
	{
		TitleWords = %title%(%prizenum%人)第%start%名
	}
	else
	{
		TitleWords = %title%(%prizenum%人)
	}
	GuiControl,, GuiTitle, %TitleWords%
	
	if (end > start && oncenum < totalnum)
	{
		AttachedTitle = %start% - %end%
		GuiControl,, AttachedTitle, %AttachedTitle%
	}
	else
	{
		GuiControl, Hide, AttachedTitle
	}
}


DrawArrayText(row, column)
{
	global
	height := OriTextHeight
	loop %row% ;行
	{
		i := (A_index - 1)* column
		width := OriTextWidth
		loop %column% ;列
		{
			i += 1
			Gui, Add, Text, vKeyPromt%i% x%width% y%height%, xxx
			width += %TextWidthInterval%
		}
		height += %TextHeightInterval%
	}
}
; 右键菜单
CreateRightMenu()
{
	;menu, RightMenu, add, Triger, TrigerLottery
	;menu, RightMenu, add, Continue, ContinueLottery
	;menu, RightMenu, add, Restart, RestartCurrentRound
	menu, RightMenu, add
	menu, RightMenu, add, NextLevel (Ctrl+Alt+N), StartNextPrizeOrder
	menu, RightMenu, add, SaveFile, SaveAllPrizeNumber
	;menu, RightMenu, add, NextResult, ShowResultNextPage
	;menu, RightMenu, add, PreviousResult, ShowResultPreviousPage
	menu, RightMenu, add
	menu, RightMenu, add, Reset All Levels, ResetPrize
	menu, RightMenu, add
	menu, RightMenu, add, Exit, QuitApp
}
