ConfigFile = %A_WorkingDir%\LotteryConfig.ini
RuntimeConfig = %A_WorkingDir%\LotteryRuntime.ini
;LotteryMusic = %A_WorkingDir%\LotteryMusic.wav
;TrigerMusic = %A_WinDir%\Media\ding.wav

LeftNumFile = NumbersLeft.txt

LoadConfig()
{
	global

	IfNotExist, %ConfigFile%
	{
		Msgbox, Cannot found Config file.
		Exit
	}

	LoadGlobalConfig()
	LoadInterfaceConfig()
	
	local level
	level := 0
	
	loop, %PrizeLevelTotal%
	{
		level += 1
		LoadLevelConfig(level)
		;MsgBox % PrizeNumber%level% 
		continue
		;IniRead, PrizeName%level%, %ConfigFile%, Prize%level%, Name
		;IniRead, PrizeNumber%level%, %ConfigFile%, Prize%level%, Number
		;IniRead, TrigerTime%level%, %ConfigFile%, Prize%level%, TrigerTime
		;IniRead, PrizeRow%level%, %ConfigFile%, prize%level%, Row
		;IniRead, PrizeColumn%level%, %ConfigFile%, prize%level%, Column
		;OnceNum%level% := PrizeRow%level% * PrizeColumn%level%
	}
}

LoadGlobalConfig()
{
	global
	IniRead, NumberFile, %ConfigFile%, options, NumberFile, Numbers.txt
	IniRead, PrizeLevelTotal, %ConfigFile%, options, PrizeLevelTotal, 5
	IniRead, ShowTime,  %ConfigFile%, options, ShowTime, 3000
	IniRead, revertDelNum, %ConfigFile%, options, RevertDelNum, 1
	IniRead, ResultFile, %ConfigFile%, options, ResultFile, Result.txt
	IniRead, LotteryMusic, %ConfigFile%, options, LotteryMusic, LotteryMusic.wav
	IniRead, TrigerMusic, %ConfigFile%, options, TrigerMusic, %A_WinDir%\Media\ding.wav
	IniRead, EndMusic,  %ConfigFile%, options, EndMusic, EndMusic.wav
	
	IniRead, ReadFromFile,  %ConfigFile%, options, ReadFromFile, 0
	IniRead, StartNum,  %ConfigFile%, options, StartNum, 1
	IniRead, EndNum,  %ConfigFile%, options, EndNum, 1
	
	IniRead, HintTextOffSetW, %ConfigFile%, options, HintTextOffSetW, 0
	IniRead, HintTextOffSetH, %ConfigFile%, options, HintTextOffSetH, 0
	
	if (StartNum = EndNum)
	{
		msgBox Please Set the Starting Number and the Ending Number!
	}
	else
	{
		if (ReadFromFile = 0)
		{
			IfExist, %NumberFile% 
			FileDelete, %NumberFile%
			local temp := startnum
			local tempToFile
			while (temp <= endnum)
			{
				if (temp >= 1 && temp < 10)
				{
				    tempToFile = 00%temp%
				}
				else if( temp >= 10 && temp < 100)
				{
					tempToFile = 0%temp%
				}
				else 
				{
					tempToFile = %temp%
				}
				FileAppend, %tempToFile%`n, %NumberFile% 
				temp += 1
			}
		}
	}
}

LoadInterfaceConfig()
{
	global
	IniRead, Background, %ConfigFile%, interface, Background, Fireworks.jpg
	IniRead, FontColor, %ConfigFile%, interface, FontColor, FF0000
	IniRead, FontType, %ConfigFile%, interface, FontType, Arial Bold
	IniRead, TitleSize, %ConfigFile%, interface, TitleSize, 50
	IniRead, AttachedTitleSize, %ConfigFile%, interface, AttachedTitleSize, 40
	IniRead, NumberSize, %ConfigFile%, interface, NumberSize, 50
	IniRead, xIntervalOffset, %ConfigFile%,interface, xIntervalOffset, 10
	IniRead, yIntervalOffset, %ConfigFile%, interface, yIntervalOffset, 40 
	IniRead, xNumStartOffset, %ConfigFile%, interface, xNumStartOffset, 100
	IniRead, yNumStartOffset, %ConfigFile%, interface, yNumStartOffset, 70
	IniRead, xTitleOffset, %ConfigFile%, interface, xTitleOffset, 200
	IniRead, xAttachedTitleOffset, %ConfigFile%, interface, xAttachedTitleOffset, 125
}

LoadLevelConfig(level)
{
	global
	IniRead, PrizeName%level%, %ConfigFile%, Prize%level%, Name
	IniRead, PrizeNumber%level%, %ConfigFile%, Prize%level%, Number
	IniRead, TrigerTime%level%, %ConfigFile%, Prize%level%, TrigerTime
	IniRead, PrizeRow%level%, %ConfigFile%, prize%level%, Row
	IniRead, PrizeColumn%level%, %ConfigFile%, prize%level%, Column
	IniRead, ResultRow%level%,  %ConfigFile%, prize%level%, ResultRow
	IniRead, ResultColumn%level%, %ConfigFile%, prize%level%, ResultColumn
	IniRead, Numbersize%level%, %ConfigFile%, prize%level%, NumberSize
	IniRead, ShowSize%level%, %ConfigFile%, prize%level%, ShowSize
	OnceNum%level% := PrizeRow%level% * PrizeColumn%level% 
}

LoadRuntimeConfig()
{
    global
    IniRead, CurrentLevel, %RuntimeConfig%, options, CurrentLevel, %PrizeLevelTotal%
}

WriteLeftNumToFile(oriarraynum)
{
	global LeftNumFile
    FileDelete %LeftNumFile%
    global OriArray
   	loop %oriarraynum%
	{
		element := OriArray%A_index%
		if ( element > 0 )
        {
	        FileAppend, %element%`n , %LeftNumFile%
		}
	}
}
ReadLeftNumFromFile()
{
    global
	if (CurrentLevel = PrizeLevelTotal && array_num = 0)
	{
	    ;MsgBox Delete
	    FileDelete, %LeftNumFile%
		loop %PrizeLevelTotal%
		{
		    PrizeFile = Prize%A_index%.txt 
			FileDelete, %A_WorkingDir%\%PrizeFile%
		}
	}
	IfNotExist, %LeftNumFile% 
	{
		FileCopy, %NumberFile%, %LeftNumFile%
	}
	
	oriarray_num := 0
	; Loop
	; {
		; FileReadLine, line, %A_WorkingDir%\%numfile%, %A_Index%
		; if ErrorLevel
		; {
			; break
		; }
		; oriarray_num += 1
		; OriArray%oriarray_num% := line
	; }
	Loop, Read, %LeftNumFile%
	{
		oriarray_num += 1
		OriArray%oriarray_num% := A_LoopReadLine
	}
}

RevertFile(filename, startline, num)
{
    global array_num
	global totalnum
	global LeftNumFile
	temp := startline
	if (revertDelNum = 0)
	{
		IfExist, %filename%
		{ 
			loop %num%
			{
				FileReadLine, line, %filename%, %temp% 
				;TrayTip, line, %line%		
				;sleep 1000	
				FileAppend, %line%`n, %LeftNumFile%	
				temp += 1
			}
		}
	}
	startline -= 1
	UpdateFile(filename, startline)
}

UpdateFile(filename, num)   ;保留Filename中前num行数据
{
	IfExist, %filename%
	{
		loop %num%
		{
			FileReadLine, line, %filename%, A_index
			Record%A_index% := line
		}
		FileDelete, %filename%
		loop %num%
		{
		    line := Record%A_index%
			FileAppend, %line%`n, %filename%
		}
	}
}

RangeFile(filename)
{
	ifExist %filename%
	{
		FileRead, Content, %filename%
		FileDelete,  %filename%
	}
	If not ErrorLevel
	{
		Sort, Content, N
		FileAppend, %Content%, %filename%
	}
}

SaveResult()
{
    global 
	;ifExist %ResultFile%
	;FileDelete, %ResultFile%
	FileGetTime, time, %ResultFile%
	FormatTime, timestr, time, yyyyMMddHHmm
	IfExist,  %ResultFile%
	{
	    FileMove, %ResultFile%, %ResultFile%-%timestr%.txt
	}
	fileResultAll = Result-0-所有奖项.txt
	FileDelete, %fileResultAll%
	loop %PrizeLevelTotal%
	{
	    ;file = Prize%A_index%.txt
		file := SaveResultOneLevel(A_index)
	    
		FileRead, fileContent, %file%
		FileAppend, %fileContent%`n, %fileResultAll%
		
		continue
		
		ifExist %file%
		{
	        FileRead, Content, %file%
			;MsgBox %Content%
	    }
		If not ErrorLevel
		{
			Sort, Content, N
			text := PrizeName%A_index%
			FileAppend, %text%`n, %ResultFile%
			FileAppend, %Content%`n, %ResultFile%
			Content =
		}
		FileAppend, `n, %ResultFile%
	}
}

SaveResultOneLevel(level)
{
	global PrizeLevelTotal
	if (level > PrizeLevelTotal)
		return
	
	srcfile = Prize%level%.txt
	dstfile := "Result-" . level . "-" . PrizeName%level% . ".txt"
	FileDelete, %dstfile%
	
	; 写入奖项名称
	line := PrizeName%level%
	FileAppend, %line%`n, %dstfile%
	line =
	
	; 写入获奖号码，每行N个
	N := 15
	i := 1
	Loop, read, %srcfile%
	{
		i++
		line = %line% %A_LoopReadLine%
		if ( i > N)
		{
			i := 1
			FileAppend, %line%`n, %dstfile%
			line =
		}
	}
	FileAppend, %line%`n, %dstfile%
	return dstfile
}
