--[[
	Terminal Client by fghdx
	Inspired by GTerm https://github.com/ExtReMLapin/GTerm
	cd, pwd and ls are thanks to him.

	Check out this project on github:
	https://github.com/fghdx/GMod-Terminal/

]]--

Term = {}
Term.Path = ""
Term.Text = ""
Term.DefaultText = [[Gmod Terminal v1
Open source at https://github.com/fghdx/GMod-Terminal/
Credit to ExtReMLapin for some code. Check out his project: https://github.com/ExtReMLapin/GTerm]]

Term.LastCommand = ""

Term.Colors = {
				titlefont = Color(0, 0, 0),
				background = Color(236, 236, 236),
				textarea = Color(0, 0, 0),
				consoletext = Color(200, 200, 200)
			}
 

			
Term.FullSize = false

--Global functions
function Term.space( times )
	return string.rep( " ", times ) --Used to create spacing for messages.
end

function Term.alert(message)
	textarea:SetValue(textarea:GetValue() .. "Error: " .. message .. "\n") 
end

function Term.pathfixmultipleslash()
	Term.Path = string.gsub(Term.Path, "//", "/") --If there are multiple slashes in the path this will remove the,
end

function Term.file_exists(f)
	if file.Exists(f, "BASE_PATH") then return true end --Check if the file exists.
end

if CLIENT then

local function MakeCirclePoly( _x, _y, _r, _points ) -- thx acecool // _if you fucking _dmca me im going to fucking _eat your family
	local _u = ( _x + _r * 1 ) - _x;
	local _v = ( _y + _r * 1 ) - _y;
	local _slices = ( 2 * math.pi ) / _points;
	local _poly = { };
	for i = 0, _points - 1 do local _angle = ( _slices * i ) % _points;
		local x = _x + _r * math.cos( _angle );
		local y = _y + _r * math.sin( _angle );
	table.insert( _poly, { x = x, y = y, u = _u, v = _v } ) end return _poly;
end

local circle1 = MakeCirclePoly(443, 263, 10, 100)
local circle2 = MakeCirclePoly(443, 263, 8.9, 100)



-- i tried
local arrow = 
{
	{ x = 438, y = 264 },
	{ x = 438, y = 259 },
--	{ x = 342, y = 273 }, -- mid up -- fuck gmod poly system
	{ x = 448, y = 259 },
	{ x = 448	, y = 264 },
	{ x = 443, y = 269 }, -- mid down
}

local arrow2 =  -- lets eat a part of the arrow
{
	{ x = 437, y = 258 },
	{ x = 449, y = 258 },
	{ x = 443, y = 263.5 }, -- I FUCKIING HATE VECTORS
}

surface.CreateFont( "WindowsPopUpTitle", {
	font = "Segoe UI",
	size = 24,
} )

surface.CreateFont( "WindowsPopUpTitle2", {
	font = "Segoe UI",
	size = 20,
} )


end

--------------------------------
---- Including the commands ----
--------------------------------
include("cmds/cmds_main.lua")
AddCSLuaFile( "cmds/cmds_main.lua" )
--------------------------------
--------------------------------

if CLIENT then --We do not want to execute this on the server.
	
include( "cmds/cmds_main.lua" )
--fonts
surface.CreateFont("terminaltitle", {font="Myriad Pro", size=18, antialias=true}) --Title
surface.CreateFont("terminalfont", {font="ProFontWindows", size=12, antialias=true}) --Terminal font.

function Term.Menu() --Function for drawing the menu
	--The derma elements here are not local so we can access them outside of this function.

	frame = vgui.Create("DFrame") --Create the frame. This is where we will draw everything.
	frame:SetSize(650, 350) --Size
	frame:SetTitle("") --Title is set to nothing because we draw the title in the paint function.
	frame:ShowCloseButton(false) --We do not need a close button as I made a custom one below. (See frameclose function)
	frame:MakePopup() --Make the frame resease the mouse.
	function frame:Paint(w,h) --This function is so we can draw on the frame.
	
	
		
	--	draw.RoundedBox(0, 0, 0, w, h, Term.Colors['background']) --Changing the background colour.
	--	draw.RoundedBox(0, 2, 25, w - 4, h - 27, Term.Colors['textarea']) --Draw a area for text box.
	--	draw.SimpleText("Terminal", "terminaltitle", 5, 5, Term.Colors['titlefont']) --Draw the title.

	--surface.SetDrawColor(Color(64, 134, 195, 250)) -- Background outline
	--surface.DrawRect(0, 0, 370, 250)
	draw.RoundedBox(0, 0, 0, w, h, Color(64, 134, 195))
	
	--surface.SetDrawColor(Color(84, 175, 255)) -- Background
	--surface.DrawRect(-21, 50, 368, 248)
	draw.RoundedBox(0, 1, 1, w-2, h-2, Color(84, 175, 255))

	draw.SimpleText("C:\\WINDOWS\\system32\\cmd.exe", "WindowsPopUpTitle", textarea:GetSize()/2, 15 , Color(0,0,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)


		
	end

	textarea = vgui.Create("DTextEntry", frame) --Create the text area
	textarea:SetSize(frame:GetWide() - 18, frame:GetTall() - 60) --Set the size
	textarea:SetMultiline(true) --Multiple lines
	textarea:SetPos(9, 33) --Set pos
	textarea:SetMouseInputEnabled( true )
	textarea:SetKeyboardInputEnabled( false )

	if Term.Text == "" then --If the text in the terminal is not already set
		textarea:SetText(Term.DefaultText) --Put the default text in
	else --Otherwise
		textarea:SetValue(Term.Text) --Put in the text that we saved
	end
	textarea:SetVerticalScrollbarEnabled(true) --So we can scroll.
	textarea:SetFont("terminalfont") --Setting the font to our terminal font.
	function textarea:Paint(w, h) --Lets theme the textarea
		draw.RoundedBox(0, 0, 0, w-18, h-15, Color(64, 134, 195))
		draw.RoundedBox(0, w-18, 0, 17, h, Color(240, 240, 240))
		draw.RoundedBox(0, 1, 1, w-20, h-17, Term.Colors['textarea']) --This is the background colour.
		textarea:DrawTextEntryText(Term.Colors['consoletext'], Color(255, 255, 255), Color(200, 200, 200)) --This is the actual textbox.
		-- The parameters are (text color, highlight colour, cursor colour.)
	end

	
	pathtext = LocalPlayer():Nick() .. "@gmod: ~ " .. Term.Path .. " $" --This is the text for the prompt
																		--This will look like "fghdx@gmod ~ garrysmod/lua $"
	drawpath = vgui.Create("DLabel", frame) --Create the label for the prompt
	drawpath:SetText(pathtext) --Set the text for the prompt label
	drawpath:SetFont("terminalfont") --Set the font for the label
	drawpath:SetTextColor(Color(255,255,255)) --Set the text folour for the label
	drawpath:SetPos(10, frame:GetTall() - 20) --Get the position for the label
	drawpath:SizeToContents() --Size the label to match the length of the text

	commandbox = vgui.Create("DTextEntry", frame) --Create the box for the command
	commandbox:SetSize(frame:GetWide() - (4 + drawpath:GetWide()), 20) --Set the size. It is 4 pixels in front of the prompt label
	commandbox:SetPos(drawpath:GetWide() + 2, frame:GetTall() - 22) --Set the position for the command textbox
	commandbox:RequestFocus() --This will make the text box focus upon opening the menu.
	function commandbox:OnKeyCodeTyped(code) -- Here we can sort out what happens on when certain keys are pressed.
		--View a list of the key enums here: http://wiki.garrysmod.com/page/Enums/KEY
		if code == 88 then --This is for the up arrow. We want this to display our last sent command. (We set this lower down)
			commandbox:SetText(Term.LastCommand) --Sets the command box text to the last sent command.
			commandbox:SetCaretPos(#commandbox:GetText()) --Set the caret to the end of the textbox.
		end
	
		if code == 64 then send_command() end --64 is the code for the enter key. This will execute the send_command() function below.
	end
	function commandbox:Paint(w, h) --Lets paint the command box
		draw.RoundedBox(0, 0, 0, w, h, Term.Colors['textarea']) --Set the background to the background colour
		commandbox:DrawTextEntryText(Term.Colors['consoletext'], Color(255, 255, 255), Color(200, 200, 200)) --Set the text colour, highlight
																											 --colour And cursor colour 
	end
	function send_command() --This is the function where the command is proccessed.

		--This prints the command when it is entered. Eg: "fghdx@gmod ~ $ cd garrysmod/lua"
		textarea:SetValue(textarea:GetValue() .. "\n" .. pathtext .. " " .. commandbox:GetValue() .. "\n")

		local command = string.Explode(" ", commandbox:GetValue())  --Create a table from the entered string.
																	--We can use this to identify the command and any parameters needed.
		
		--If you enter something like "cat -A file.lua" it will be exploded into
		--command[1] = cat
		--command[2] = -A
		--command[3] = file.lua

		Term.handleCommands( command )

		Term.LastCommand = commandbox:GetValue() --When the command is sent we save it as the last command so we can get it by pressing up.
		textarea:SetCaretPos(#textarea:GetValue()) --Set the caret pos so the text area is always at the bottom.
		commandbox:SetText("") --Remove the text in teh command box
		commandbox:RequestFocus() --Set the focus to the command box.

	end


	frameclose = vgui.Create("DButton", frame) --This is our custom close button.
	frameclose:SetSize(45, 20) --Set the size to be appropriate.
	frameclose:SetPos(frame:GetWide() - 55, 1) --Set the pos
	frameclose:SetText("") --We don't want the text to be anything because we draw that below.
	frameclose.DoClick = function() --On click
		frame:Remove() --Remove the frame
		timer.Destroy("TimerTransitionY") timer.Destroy("TimerTransitionW")
		Term.FullSize = false
		Term.Text = textarea:GetValue() --Set Term.Text to the textarea
	end

	function frameclose:Paint(w, h) --paint function for the button
				draw.RoundedBox(0, 0, 0, w, h, Color(200, 80, 80))
	end
	
	framebigger = vgui.Create("DButton", frame) --This is our custom close button.
	framebigger:SetSize(10, 8.5) --Set the size to be appropriate.
	framebigger:SetPos(frame:GetWide() -76, 5) --Set the pos
	framebigger:SetText("") --We don't want the text to be anything because we draw that below.
	framebigger.DoClick = function() --On click
	frameposa, frameposb = 	frame:GetSize()
		if Term.FullSize == true then 
					dotransition()
					Term.FullSize = false

		else
				
					dotransition()
					Term.FullSize = true
		end
	end

	function framebigger:Paint(w, h) --paint function for the button
				draw.RoundedBox(0, 0, 0, w, h, Color(62, 107, 147))
				draw.RoundedBox(0, 1, 2, w-2, h-3,Color(84, 175, 225))
				
				
				
				
	end
	
	framereduce = vgui.Create("DButton", frame) --This is our custom close button.
	framereduce:SetSize(8, 2) --Set the size to be appropriate.
	framereduce:SetPos(frame:GetWide() - 103, 9) --Set the pos
	framereduce:SetText("") --We don't want the text to be anything because we draw that below.
	framereduce.DoClick = function() --On click
		dotreduce()
		Term.Text = textarea:GetValue() --Set Term.Text to the textarea
	end

	function framereduce:Paint(w, h) --paint function for the button
				draw.RoundedBox(0, 0, 0, w, h, Color(40, 40, 40))
	end
	
	
	textarea:SetCaretPos(#textarea:GetValue()) --Set the caret to the end of the text area so we get put the the bottom the the textbox.

end
--Console Commands
concommand.Add("terminal", Term.Menu) --Add the console command.






		
function updatesize(posa, posb)
				
				tempposa, tempposb = frame:GetPos()

				 if frameposa then frame:SetSize(frameposa, frameposb) end
				if posa then frame:SetPos(posa or tempposa, posb or tempposa) end
				textarea:SetSize(frame:GetWide() - 18, frame:GetTall() - 60) --Set the size
				commandbox:SetSize(frame:GetWide() - (4 + drawpath:GetWide()), 20)
				commandbox:SetPos(drawpath:GetWide() + 2, frame:GetTall() - 22)
				frameclose:SetPos(frame:GetWide() - 55, 1)
				framereduce:SetPos(frame:GetWide() - 103, 9)
				drawpath:SetPos(10, frame:GetTall() - 20)
				framebigger:SetPos(frame:GetWide() -76, 5)
			if frameposa == ScrW() or frameposb == ScrH() then
				timer.Destroy("TimerTransitionY")
				timer.Destroy("TimerTransitionW")
			end
end
		
function bigmamatransition()
		if not IsValid(frame) then 	timer.Destroy("TimerTransitionY") timer.Destroy("TimerTransitionW")  return end
		if Term.FullSize then
			frameposa = math.Approach(frameposa, ScrW(), 40)
			frameposb = math.Approach(frameposb, ScrH(), 20)
		else
			frameposa = math.Approach(frameposa, 650, 40)
			frameposb =	math.Approach(frameposb, 350, 20)
		end
		updatesize()
	
end
		
function reducemove()
	posa, posb = frame:GetPos()
	posa = math.Approach(posa, ScrW()/2, 40)
	posb = math.Approach(posb, ScrH()+500, 40)
	updatesize(posa, posb)
end
		
		
		
function dotransition()
	if not frameposa then frameposa, frameposb = 	frame:GetSize() end
	timer.Create( "TimerTransitionX", 1/(ScrW()/40), ScrW()/40, bigmamatransition ) 
	timer.Create( "TimerTransitionY",1/(ScrH()/20), ScrH()/20, bigmamatransition )
end
		
function dotreduce()
	if not frameposa then frameposa, frameposb = 	frame:GetSize() end
	timer.Create( "TimerReduceterm", 1/(ScrW()/40), ScrW()/40, reducemove )
	timer.Simple(1, function () timer.Destroy("TimerReduceterm")  frame:Remove() end)
end
		
	
		
	
end




