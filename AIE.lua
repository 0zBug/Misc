
if not game:IsLoaded() then
    game.Loaded:Wait()
end

wait(1)

if not isfolder("AlphaOS") then
	makefolder("AlphaOS")
end

if not isfolder("AlphaOS/RemoteSpy") then
	makefolder("AlphaOS/RemoteSpy")
end

if not isfolder("AlphaOS/ScriptSaves") then
	makefolder("AlphaOS/ScriptSaves")
end

if not isfolder("AlphaOS/Scripts") then
	makefolder("AlphaOS/Scripts")
end

if not isfolder("AlphaOS/Assets") then
	makefolder("AlphaOS/Assets")
end

if not isfile("AlphaOS/Assets/Pin.png") then
	writefile("AlphaOS/Assets/Pin.png", game:HttpGet("https://i.ibb.co/Wp9HrZD/Pin-Button.png"))
end

if not isfile("AlphaOS/Assets/Inject.png") then
	writefile("AlphaOS/Assets/Inject.png", game:HttpGet("https://i.ibb.co/jDBH1by/Inject.png"))
end

if not isfolder("AlphaOS/Tabs") then
	makefolder("AlphaOS/Tabs")
end

if not isfile("AlphaOS/Tabs/Script1.lua") then
	writefile("AlphaOS/Tabs/Script1.lua", 'print("Hello, World!")')
end

if not isfile("AlphaOS/Settings.json") then
	local Settings = {
		["RemoteSpy"] = false,
		["Executer Pinned"] = false,
		["Tools Pinned"] = false,
		["Files Pinned"] = false,
		["Console Pinned"] = false
	}
	writefile("AlphaOS/Settings.json", game:GetService('HttpService'):JSONEncode(Settings))
end

if not isfile("AlphaOS/Tools.json") then
	local ToolSaves = {
		["Current Song"] = 5011102700,
		["Song Position"] = 0,
		["Song Volume"] = 3,
		["Song Playing"] = true,
		["Teleport ID"] = 5100950559
	}
	
	writefile("AlphaOS/Tools.json", game:GetService('HttpService'):JSONEncode(ToolSaves))
end

local Settings = game:GetService('HttpService'):JSONDecode(readfile("AlphaOS/Settings.json"))
local ToolSaves = game:GetService('HttpService'):JSONDecode(readfile("AlphaOS/Tools.json"))

local SavedScript = readfile("AlphaOS/Tabs/Script1.lua")

BnM = loadstring(game:HttpGet("https://raw.githubusercontent.com/saxophonebug/rblxtst/main/BnM"))()

if CustomUI then
	function setab(val, name, skipnewlines, depth) 
	   skipnewlines = skipnewlines or false depth = depth or 0 local tmp = string.rep(" ", depth) if name then tmp = tmp .. name .. " = " end if type(val) == "table" then tmp = tmp .. "{" .. (not skipnewlines and "\n" or "") for k, v in pairs(val) do tmp =  tmp .. setab(v, k, skipnewlines, depth + 1) .. "," .. (not skipnewlines and "\n" or "") end tmp = tmp .. string.rep(" ", depth) .. "}" elseif type(val) == "number" then tmp = tmp .. tostring(val) elseif type(val) == "string" then tmp = tmp .. string.format("%q", val) elseif type(val) == "boolean" then tmp = tmp .. (val and "true" or "false") elseif type(val) == "function" then tmp = tmp  .. "func: " .. debug.getinfo(val).name else tmp = tmp .. tostring(val) end return tmp
	end  
	
	queue_on_teleport('getgenv().nl = true getgenv().CustomUI = ' .. setab(CustomUI) .. 'loadstring(game:HttpGet("https://raw.githubusercontent.com/saxophonebug/rblxtst/main/AIE"))()')
else
	queue_on_teleport('getgenv().nl = true loadstring(game:HttpGet("https://raw.githubusercontent.com/saxophonebug/rblxtst/main/AIE"))()')
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local InputService = game:GetService("UserInputService")
local LogService = game:GetService("LogService")

local Player = Players.LocalPlayer
local Character = Player.Character
local RootPart = Character.HumanoidRootPart
local Mouse = Player:GetMouse()
local Humanoid = Character.Humanoid

local ToggleUi = true
local ToggleExecuter = true
local ToggleConsole = true
local ToggleFiles = true
local ToggleTools = true
local MusicVolume = 0

local Fonts = Enum.Font
local BackgroundMusic = Instance.new("Sound", Workspace)

local Main = Instance.new("ScreenGui")

local BlurFX = Instance.new("BlurEffect")

BlurFX.Size = 50
BlurFX.Name = "MenuBlur"
BlurFX.Parent = game.Lighting

game:GetService('StarterGui'):SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)

local BackgroundColor = Color3.fromRGB(9, 11, 16)
local ForegroundColor = Color3.fromRGB(143, 147, 162)
local BackgroundTintColor = Color3.fromRGB(20, 20, 20)
local TextBoxColor = Color3.fromRGB(15, 17, 26)
local LineNumberColor = Color3.fromRGB(17, 32, 47)
local PinPinnedColor = Color3.fromRGB(3, 60, 166)
local PinUnPinnedColor = Color3.fromRGB(88, 88, 88) 

local RoundedCorners = false

if CustomUI then
	if CustomUI.Colors then
		if CustomUI.Colors.BackgroundColor then
			BackgroundColor = CustomUI.Colors.BackgroundColor
		end
		if CustomUI.Colors.ForegroundColor then
			ForegroundColor = CustomUI.Colors.ForegroundColor
		end
		if CustomUI.Colors.BackgroundTintColor then
			BackgroundTintColor = CustomUI.Colors.BackgroundTintColor
		end
		if CustomUI.Colors.TextBoxColor then
			TextBoxColor = CustomUI.Colors.TextBoxColor
		end
		if CustomUI.Colors.LineNumberColor then
			LineNumberColor = CustomUI.Colors.LineNumberColor
		end
		if CustomUI.Colors.PinPinnedColor then
			PinPinnedColor = CustomUI.Colors.PinnedColor
		end
		if CustomUI.Colors.UnpinnedColor then
			PinUnPinnedColor = CustomUI.Colors.UnpinnedColor
		end
	end
	if CustomUI.Rounded then
		RoundedCorners = CustomUI["Rounded"]
	end
end

--[[ FRAMES ]]--

local BlockClick = Instance.new("Frame")

local BackgroundTint = Instance.new("Frame")

local TaskBar = Instance.new("Frame")
local TaskBarExecuterLine = Instance.new("Frame")
local TaskBarConsoleLine = Instance.new("Frame")
local TaskBarFilesLine = Instance.new("Frame")
local TaskBarToolsLine = Instance.new("Frame")

local Loader = Instance.new("Frame")
local LoadBar = Instance.new("Frame")

local Logon = Instance.new("Frame")

local Executer = Instance.new("Frame")
local ExecuterBoxBack = Instance.new("Frame")
local ExecuterScroll = Instance.new("ScrollingFrame")

local ExecuterPinned = false
local ExecuterPin = Instance.new("ImageButton")

local InjectButton = Instance.new("ImageButton")

local ScriptsScroll = Instance.new("ScrollingFrame")
local ScriptsLayout = Instance.new("UIListLayout")

local Console = Instance.new("Frame")
local ConsoleScroll = Instance.new("ScrollingFrame")

local ConsolePinned = false
local ConsolePin = Instance.new("ImageButton")

local Files = Instance.new("Frame")

local FilesPinned = false
local FilesPin = Instance.new("ImageButton")

local Tools = Instance.new("Frame")

local ToolsPinned = false
local ToolsPin = Instance.new("ImageButton")

local ToolsScroll = Instance.new("ScrollingFrame")

if RoundedCorners then
	local ExecuterUICorner = Instance.new("UICorner", Executer)
	local ToolsUICorner = Instance.new("UICorner", Tools)
	local ConsoleUICorner = Instance.new("UICorner", Console)
	local FilesUICorner = Instance.new("UICorner", Files)
end

--[[ TEXTLABELS ]]--

local BackgroundMusicText = Instance.new("TextLabel")
local BackgroundOSText = Instance.new("TextLabel")

local TaskBarLogo = Instance.new("TextLabel")
local TaskBarLine = Instance.new("TextLabel")
local TaskBarTime = Instance.new("TextLabel")

local LoaderTitle = Instance.new("TextLabel")
local LoaderDesc = Instance.new("TextLabel")
local LoaderProc = Instance.new("TextLabel")

local LogonWelcome = Instance.new("TextLabel")
local LogonLogo = Instance.new("TextLabel")
local LogonTitle = Instance.new("TextLabel")
local LogonDesc = Instance.new("TextLabel")

local ExecuterTitle = Instance.new("TextLabel")
local ExecuterLineNumbers = Instance.new("TextLabel")

local ConsoleTitle = Instance.new("TextLabel")
local ConsoleLogs = Instance.new("TextLabel")
local ConsolePrefix = Instance.new("TextLabel")

local FilesTitle = Instance.new("TextLabel")

local ToolsTitle = Instance.new("TextLabel")
local ToolsSyntaxCheck = Instance.new("TextLabel")

local Globals_ = Instance.new("TextLabel")
local Keywords_ = Instance.new("TextLabel")
local Numbers_ = Instance.new("TextLabel")
local RemoteHighlight_ = Instance.new("TextLabel")
local Strings_ = Instance.new("TextLabel")
local Tokens_ = Instance.new("TextLabel")
local Comments_ = Instance.new("TextLabel")

--[[ IMAGELABELS ]]--

--[[ BUTTONS ]]--

local TaskBarExecuter = Instance.new("TextButton")
local TaskBarConsole = Instance.new("TextButton")
local TaskBarFiles = Instance.new("TextButton")
local TaskBarTools = Instance.new("TextButton")

local LogonLogin = Instance.new("TextButton")

local ExecuterBtn = Instance.new("TextButton")
local ExecuterClearBtn = Instance.new("TextButton")
local ExecuterOpenFileBtn = Instance.new("TextButton")
local ExecuterSaveFileBtn = Instance.new("TextButton")
local ExecuterBeautifyBtn = Instance.new("TextButton")
local R6Btn = Instance.new("TextButton")

local ToolsClearBtn = Instance.new("TextButton")
local ToolsToggleRspy = Instance.new("TextButton")
local ToolsRejoin = Instance.new("TextButton")
local ToolsPlayBtn = Instance.new("TextButton")
local ToolsStopBtn = Instance.new("TextButton")
local ToolsChangeBtn = Instance.new("TextButton")
local ToolsSetBtn = Instance.new("TextButton")
local ToolsTeleBtn = Instance.new("TextButton")

--[[ TEXTBOXS ]]--

local ExecuterBox = Instance.new("TextBox")

local ConsoleBox = Instance.new("TextBox")

local ToolsMusicBox = Instance.new("TextBox")
local ToolsVolumeBox = Instance.new("TextBox")

local ToolsTeleBox = Instance.new("TextBox")
--[[ SOME FUNCTIONS ]]--

Chars = {}

for i = ("a"):byte(), ("z"):byte() do
	table.insert(Chars, string.char(i))
end

for i = ("A"):byte(), ("Z"):byte() do
	table.insert(Chars, string.char(i))
end

for i = ("0"):byte(), ("9"):byte() do
	table.insert(Chars, string.char(i))
end

function genstring(length)
   local Str = ""

   for i = 1, length do
      local Random = math.random(1, #Chars)
      Str = Str .. Chars[Random]
   end
   return Str
end

local Rspy = Settings["RemoteSpy"]

ignorelist = {}

local SpecialCharacters = {['\a'] = '\\a', ['\b'] = '\\b', ['\f'] = '\\f', ['\n'] = '\\n', ['\r'] = '\\r', ['\t'] = '\\t', ['\v'] = '\\v', ['\0'] = '\\0'}
local Keywords = {['and'] = true, ['break'] = true, ['do'] = true, ['else'] = true, ['elseif'] = true, ['end'] = true, ['false'] = true, ['for'] = true, ['function'] = true, ['if'] = true, ['in'] = true, ['local'] = true, ['nil'] = true, ['not'] = true, ['or'] = true, ['repeat'] = true, ['return'] = true, ['then'] = true, ['true'] = true, ['until'] = true, ['while'] = true, ['continue'] = true}

function GetFullName(Object) 
	local Hierarchy = {} local ChainLength = 1 local Parent = Object while Parent do Parent = Parent.Parent ChainLength = ChainLength + 1 end Parent = Object local Num = 0 while Parent do Num = Num + 1 local ObjName = string.gsub(Parent.Name, '[%c%z]', SpecialCharacters) ObjName = Parent == game and 'game' or ObjName if Keywords[ObjName] or not string.match(ObjName, '^[_%a][_%w]*$') then ObjName = '["' .. ObjName .. '"]' elseif Num ~= ChainLength - 1 then ObjName = '.' .. ObjName end Hierarchy[ChainLength - Num] = ObjName Parent = Parent.Parent end return table.concat(Hierarchy)
end
		
local function SerializeType(Value, Class)
	if Class == 'string' then return string.format('"%s"', string.gsub(Value, '[%c%z]', SpecialCharacters)) elseif Class == 'Instance' then return GetFullName(Value) elseif type(Value) ~= Class then return Class .. '.new(' .. tostring(Value) .. ')' elseif Class == 'function' then return Functions[Value] or '\'[Unknown ' .. (pcall(setfenv, Value, getfenv(Value)) and 'Lua' or 'C')  .. ' ' .. tostring(Value) .. ']\'' elseif Class == 'userdata' then return 'newproxy(' .. tostring(not not getmetatable(Value)) .. ')' elseif Class == 'thread' then return '\'' .. tostring(Value) ..  ', status: ' .. coroutine.status(Value) .. '\'' else return tostring(Value) end 
end

local function TableToString(Table, IgnoredTables, DepthData, Path)
	IgnoredTables = IgnoredTables or {} local CyclicData = IgnoredTables[Table] if CyclicData then return ((CyclicData[1] == DepthData[1] - 1 and '\'[Cyclic Parent ' or '\'[Cyclic ') .. tostring(Table) .. ', path: ' .. CyclicData[2] .. ']\'') end Path = Path or 'ROOT' DepthData = DepthData or {0, Path} local Depth = DepthData[1] + 1 DepthData[1] = Depth DepthData[2] = Path IgnoredTables[Table] = DepthData local Tab = string.rep('    ', Depth) local TrailingTab = string.rep('    ', Depth - 1) local Result = '{' local LineTab = '\n' .. Tab local HasOrder = true local Index = 1 local IsEmpty = true for Key, Value in next, Table do IsEmpty = false if Index ~= Key then HasOrder = false else Index = Index + 1 end local KeyClass, ValueClass = typeof(Key), typeof(Value) local HasBrackets = false if KeyClass == 'string' then Key = string.gsub(Key, '[%c%z]', SpecialCharacters) if Keywords[Key] or not string.match(Key, '^[_%a][_%w]*$') then HasBrackets = true Key = string.format('["%s"]', Key) end else HasBrackets = true Key = '[' .. (KeyClass == 'table' and string.gsub(TableToString(Key, IgnoredTables, {Depth + 1, Path}), '^%s*(.-)%s*$', '%1') or SerializeType(Key, KeyClass)) .. ']' end Value = ValueClass == 'table' and TableToString(Value, IgnoredTables, {Depth + 1, Path}, Path .. (HasBrackets and '' or '.') .. Key) or SerializeType(Value, ValueClass) Result = Result .. LineTab .. (HasOrder and Value or Key .. ' = ' .. Value) .. ',' end return IsEmpty and Result .. '}' or string.sub(Result,  1, -2) .. '\n' .. TrailingTab .. '}'
end        

function genscript(args, t, ty)
	if args[1] == nil then if ty == "InvokeServer" then return GetFullName(t) .. ":InvokeServer()" elseif ty == "FireServer" then return GetFullName(t) .. ":FireServer()" end else if ty == "InvokeServer" then return "\nargs = " .. TableToString(args) .. "\n\n" .. GetFullName(t) .. ":InvokeServer(table.unpack(args))" elseif ty == "FireServer" then return "\nargs = " .. TableToString(args) .. "\n\n" .. GetFullName(t) .. ":FireServer(table.unpack(args))" end end
end

local met = getrawmetatable(game)
setreadonly(met,false)
local old = met.__namecall

met.__namecall = function(t, ...)
    local args = {...}
    
    if Rspy == true and not table.find(ignorelist, tostring(t)) then
		if(getnamecallmethod()=="InvokeServer") then 
			print(genscript(args, t, "InvokeServer"))
			writefile("AlphaOS/RemoteSpy/"..tostring(t).."-"..genstring(math.random(8, 15))..".lua", genscript(args, t, "InvokeServer"))
		elseif(getnamecallmethod()=="FireServer") then
			print(genscript(args, t, "FireServer"))
			writefile("AlphaOS/RemoteSpy/"..tostring(t).."-"..genstring(math.random(8, 15))..".lua", genscript(args, t, "FireServer"))
		end
	end

    return old(t, ...)
end

--[[
local scroller = function(obj)
	obj.ClipsDescendants = true
	local Scroller = Instance.new("Frame")
	local UIListLayout = Instance.new("UIListLayout")
	local Execute = Instance.new("TextButton")
	local LoadIntoEditor = Instance.new("TextButton")
	local Delete = Instance.new("TextButton")

	Scroller.Name = "Scroller"
	Scroller.Parent = obj
	Scroller.AnchorPoint = Vector2.new(0.5, 1)
	Scroller.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Scroller.BackgroundTransparency = 1.000
	Scroller.Position = UDim2.new(0, #obj.Text * 14, 6.5, 0)
	Scroller.Size = UDim2.new(0, 206, 0, 99)

	UIListLayout.Parent = Scroller
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 2)

	Execute.Name = "Execute"
	Execute.Parent = Scroller
	Execute.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	Execute.BackgroundTransparency = 0.500
	Execute.BorderColor3 = Color3.fromRGB(27, 42, 53)
	Execute.BorderSizePixel = 0
	Execute.Position = UDim2.new(0, 49, 0, 50)
	Execute.Size = UDim2.new(0, 200, 0, 15)
	Execute.Font = Enum.Font.SourceSansBold
	Execute.Text = "Execute"
	Execute.TextColor3 = Color3.fromRGB(255, 255, 255)
	Execute.TextSize = 14.000
	Execute.TextStrokeTransparency = 0.750
	Execute.TextWrapped = true

	LoadIntoEditor.Name = "LoadIntoEditor"
	LoadIntoEditor.Parent = Scroller
	LoadIntoEditor.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	LoadIntoEditor.BackgroundTransparency = 0.500
	LoadIntoEditor.BorderColor3 = Color3.fromRGB(27, 42, 53)
	LoadIntoEditor.BorderSizePixel = 0
	LoadIntoEditor.Position = UDim2.new(0, 49, 0, 50)
	LoadIntoEditor.Size = UDim2.new(0, 200, 0, 15)
	LoadIntoEditor.Font = Enum.Font.SourceSansBold
	LoadIntoEditor.Text = "Load Into Editor"
	LoadIntoEditor.TextColor3 = Color3.fromRGB(255, 255, 255)
	LoadIntoEditor.TextSize = 14.000
	LoadIntoEditor.TextStrokeTransparency = 0.750
	LoadIntoEditor.TextWrapped = true

	Delete.Name = "Delete"
	Delete.Parent = Scroller
	Delete.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	Delete.BackgroundTransparency = 0.500
	Delete.BorderColor3 = Color3.fromRGB(27, 42, 53)
	Delete.BorderSizePixel = 0
	Delete.Position = UDim2.new(0, 49, 0, 50)
	Delete.Size = UDim2.new(0, 200, 0, 15)
	Delete.Font = Enum.Font.SourceSansBold
	Delete.Text = "Delete Script"
	Delete.TextColor3 = Color3.fromRGB(255, 255, 255)
	Delete.TextSize = 14.000
	Delete.TextStrokeTransparency = 0.750
	Delete.TextWrapped = true
	return Scroller
end]]--

local scrollers = {}

local ScriptNumber = 0

local function addscript(name)
	ScriptNumber = ScriptNumber + 1
	local Script = Instance.new("TextButton")
	Script.ZIndex = 14
	Script.Name = "Script"..ScriptNumber
	Script.Text = string.split(name, "\\")[3]
	Script.Parent = ScriptsScroll
	Script.BackgroundColor3 = LineNumberColor
	Script.BorderColor3 = LineNumberColor
	Script.Position = UDim2.new(0, 0, 0, 0)
	Script.Size = UDim2.new(0.9, 0, 0.01, 0)
	Script.TextSize = 18
	Script.Font = Enum.Font.SourceSans
	Script.TextColor3 = ForegroundColor
	Script.MouseButton1Down:connect(function()
		ExecuterBox.Text = readfile(name)
	end)
	--[[
	Script.MouseButton2Down:connect(function()
		if Script:FindFirstChild("Scroller") then
		   return
		end
		local s = scroller(Script)

		for i, v in pairs(s:GetChildren()) do
		   if v:IsA("TextButton") then
			  v.ZIndex = 20
		   end
		end

		table.insert(scrollers, s)
		if #scrollers >= 2 then
		   scrollers[1]:Destroy()
		   scrollers = {s}
		end

		s.Parent.ClipsDescendants = false

		s.MouseLeave:Connect(function()
		s:Destroy()
		end)

		s.Execute.MouseButton1Click:Connect(function()
		v:Destroy()
		end)

		s.Delete.MouseButton1Click:Connect(function()

		end)

		s.LoadIntoEditor.MouseButton1Click:Connect(function()
		--v.TextButton.Text
		end)
	end)]]--
end

for i,v in pairs(listfiles("AlphaOS/Scripts")) do
	addscript(v)
end

ExecuterBoxBack.Position = UDim2.new(0.07, 0, 0, 0)
ExecuterBoxBack.Size = UDim2.new(0.4, 0, 0.45, 0)
ExecuterBoxBack.Active = true
ExecuterBoxBack.Draggable = false
--[[ UI SETUPS ]]--

Main.Name = "Alpha Inside Executer"
Main.Parent = game.CoreGui

BlockClick.Name = "BlockClick"
BlockClick.Parent = Main
BlockClick.Visible = true
BlockClick.ZIndex = 0
BlockClick.BackgroundTransparency = 1
BlockClick.BackgroundColor3 = BackgroundTintColor
BlockClick.BorderColor3 = BackgroundTintColor
BlockClick.Position = UDim2.new(0, 0, -.1, 0)
BlockClick.Size = UDim2.new(1, 0, 1.2, 0)
BlockClick.Active = true
BlockClick.Draggable = false

--[[ TINT ]]--

BackgroundTint.Name = "Tint"
BackgroundTint.Parent = Main
BackgroundTint.Visible = false
BackgroundTint.ZIndex = 0
BackgroundTint.BackgroundTransparency = 0.15
BackgroundTint.BackgroundColor3 = BackgroundTintColor
BackgroundTint.BorderColor3 = BackgroundTintColor
BackgroundTint.Position = UDim2.new(0, 0, -.1, 0)
BackgroundTint.Size = UDim2.new(1, 0, 1.2, 0)
BackgroundTint.Active = true
BackgroundTint.Draggable = false

--[[ OTHER STUFFS ]]--

BackgroundMusicText.Name = "BackgroundMusicText"
BackgroundMusicText.Parent = Main
BackgroundMusicText.ZIndex = 3
BackgroundMusicText.Visible = false
BackgroundMusicText.BackgroundTransparency = 1
BackgroundMusicText.BorderSizePixel = 0
BackgroundMusicText.BackgroundColor3 = BackgroundColor
BackgroundMusicText.BorderColor3 = BackgroundColor
BackgroundMusicText.Position = UDim2.new(0.795, 0, 0.955, 0)
BackgroundMusicText.Size = UDim2.new(0, 381, 0, 50)
BackgroundMusicText.Font = Enum.Font.SourceSansLight
BackgroundMusicText.Text = "Author - Music Name"
BackgroundMusicText.TextColor3 = ForegroundColor
BackgroundMusicText.TextSize = 27
BackgroundMusicText.TextXAlignment = "Right"

BackgroundOSText.Name = "BackgroundOSText"
BackgroundOSText.Parent = Main
BackgroundOSText.ZIndex = 3
BackgroundOSText.Visible = false
BackgroundOSText.BackgroundTransparency = 1
BackgroundOSText.BorderSizePixel = 0
BackgroundOSText.BackgroundColor3 = BackgroundColor
BackgroundOSText.BorderColor3 = BackgroundColor
BackgroundOSText.Position = UDim2.new(0.005, 0, 0.955, 0)
BackgroundOSText.Size = UDim2.new(0.1, 0, 0, 50)
BackgroundOSText.Font = Enum.Font.SourceSansLight
BackgroundOSText.Text = "Alpha OS 0.2 Beta"
BackgroundOSText.TextColor3 = ForegroundColor
BackgroundOSText.TextSize = 27
BackgroundOSText.TextXAlignment = "Left"

--[[ TASKBAR ]]--

TaskBar.Name = "TaskBar"
TaskBar.Parent = Main
TaskBar.Visible = false
TaskBar.ZIndex = 2
TaskBar.BackgroundColor3 = BackgroundColor
TaskBar.BorderColor3 = BackgroundColor
TaskBar.Position = UDim2.new(0.0585, 0, -0.035, 0)
TaskBar.Size = UDim2.new(0.91, 0, 0.04, 0)
TaskBar.Active = true
TaskBar.Draggable = false

TaskBarLogo.Name = "TaskBarLogo"
TaskBarLogo.Parent = TaskBar
TaskBarLogo.ZIndex = 3
-- TaskBarLogo.Image = "rbxassetid://6215071424" -- rbxassetid://6214770328
-- TaskBarLogo.ImageTransparency = 0
-- TaskBarLogo.ImageColor3 = ForegroundColor
TaskBarLogo.Font = Enum.Font.Roboto
TaskBarLogo.Text = "V"
TaskBarLogo.TextSize = 40
TaskBarLogo.TextColor3 = ForegroundColor
TaskBarLogo.BackgroundColor3 = TextBoxColor
TaskBarLogo.BorderSizePixel = 0
TaskBarLogo.Position = UDim2.new(0, 0, 0, 0)
TaskBarLogo.Rotation = 180
TaskBarLogo.Size = UDim2.new(0.025, 0, 1, 0)

TaskBarLine.Name = "TaskBarLine"
TaskBarLine.Parent = TaskBar
TaskBarLine.ZIndex = 3
TaskBarLine.BackgroundColor3 = TextBoxColor
TaskBarLine.BackgroundTransparency = 1
TaskBarLine.BorderColor3 = TextBoxColor
TaskBarLine.BorderSizePixel = 0
TaskBarLine.Position = UDim2.new(0.025, 0, -0.003, 0)
TaskBarLine.Size = UDim2.new(0.001, 0, 1, 0)
TaskBarLine.Font = Enum.Font.SourceSansLight
TaskBarLine.Text = " |"
TaskBarLine.TextColor3 = ForegroundColor
TaskBarLine.TextSize = 35
TaskBarLine.TextXAlignment = "Left"

TaskBarExecuter.Name = "TaskBarExecuter"
TaskBarExecuter.Parent = TaskBar
TaskBarExecuter.ZIndex = 3
TaskBarExecuter.BackgroundColor3 = TextBoxColor
TaskBarExecuter.BorderColor3 = TextBoxColor
TaskBarExecuter.BorderSizePixel = 0
TaskBarExecuter.Position = UDim2.new(0.035, 0, 0, 0)
TaskBarExecuter.Size = UDim2.new(0.125, 0, 1, 0)
TaskBarExecuter.Font = Enum.Font.SourceSansLight
TaskBarExecuter.Text = "   Executer"
TaskBarExecuter.TextColor3 = ForegroundColor
TaskBarExecuter.TextSize = 25
TaskBarExecuter.TextXAlignment = "Left"

TaskBarExecuterLine.Name = "TaskBarExecuterLine"
TaskBarExecuterLine.Parent = TaskBar
TaskBarExecuterLine.ZIndex = 4
TaskBarExecuterLine.BackgroundColor3 = ForegroundColor
TaskBarExecuterLine.BorderColor3 = ForegroundColor
TaskBarExecuterLine.BorderSizePixel = 0
TaskBarExecuterLine.Position = UDim2.new(0.035, 0, 0, 0)
TaskBarExecuterLine.Size = UDim2.new(0.125, 0, 0.1, 0)

TaskBarExecuter.MouseButton1Down:connect(function() 
	
	if not ToggleExecuter then
		
		Executer.Visible = true
		
		ToggleExecuter = true
		
		TaskBarExecuter.BackgroundColor3 = TextBoxColor
		
	elseif ToggleExecuter then
		
		Executer.Visible = false
		
		ToggleExecuter = false
		
		TaskBarExecuter.BackgroundColor3 = BackgroundColor
	end
end)

TaskBarConsole.Name = "TaskBarConsole"
TaskBarConsole.Parent = TaskBar
TaskBarConsole.ZIndex = 3
TaskBarConsole.BackgroundColor3 = TextBoxColor
TaskBarConsole.BorderColor3 = TextBoxColor
TaskBarConsole.BorderSizePixel = 0
TaskBarConsole.Position = UDim2.new(0.164, 0, 0, 0)
TaskBarConsole.Size = UDim2.new(0.125, 0, 1, 0)
TaskBarConsole.Font = Enum.Font.SourceSansLight
TaskBarConsole.Text = "   Console"
TaskBarConsole.TextColor3 = ForegroundColor
TaskBarConsole.TextSize = 25
TaskBarConsole.TextXAlignment = "Left"

TaskBarConsoleLine.Name = "TaskBarConsoleLine"
TaskBarConsoleLine.Parent = TaskBar
TaskBarConsoleLine.ZIndex = 4
TaskBarConsoleLine.BackgroundColor3 = ForegroundColor
TaskBarConsoleLine.BorderColor3 = ForegroundColor
TaskBarConsoleLine.BorderSizePixel = 0
TaskBarConsoleLine.Position = UDim2.new(0.164, 0, 0, 0)
TaskBarConsoleLine.Size = UDim2.new(0.125, 0, 0.1, 0)

TaskBarConsole.MouseButton1Down:connect(function() 
	
	if not ToggleConsole then
		
		Console.Visible = true
		
		ToggleConsole = true
		
		TaskBarConsole.BackgroundColor3 = TextBoxColor
		
	elseif ToggleConsole then
		
		Console.Visible = false
		
		ToggleConsole = false
		
		TaskBarConsole.BackgroundColor3 = BackgroundColor
	end
end)

TaskBarFiles.Name = "TaskBarFiles"
TaskBarFiles.Parent = TaskBar
TaskBarFiles.ZIndex = 3
TaskBarFiles.BackgroundColor3 = TextBoxColor
TaskBarFiles.BorderColor3 = TextBoxColor
TaskBarFiles.BorderSizePixel = 0
TaskBarFiles.Position = UDim2.new(0.293, 0, 0, 0)
TaskBarFiles.Size = UDim2.new(0.125, 0, 1, 0)
TaskBarFiles.Font = Enum.Font.SourceSansLight
TaskBarFiles.Text = "   Files"
TaskBarFiles.TextColor3 = ForegroundColor
TaskBarFiles.TextSize = 25
TaskBarFiles.TextXAlignment = "Left"

TaskBarFilesLine.Name = "TaskBarFilesLine"
TaskBarFilesLine.Parent = TaskBar
TaskBarFilesLine.ZIndex = 4
TaskBarFilesLine.BackgroundColor3 = ForegroundColor
TaskBarFilesLine.BorderColor3 = ForegroundColor
TaskBarFilesLine.BorderSizePixel = 0
TaskBarFilesLine.Position = UDim2.new(0.293, 0, 0, 0)
TaskBarFilesLine.Size = UDim2.new(0.125, 0, 0.1, 0)

TaskBarFiles.MouseButton1Down:connect(function() 
	
	if not ToggleFiles then
		
		Files.Visible = true
		
		ToggleFiles = true
		
		TaskBarFiles.BackgroundColor3 = TextBoxColor
		
	elseif ToggleFiles then
		
		Files.Visible = false
		
		ToggleFiles = false
		
		TaskBarFiles.BackgroundColor3 = BackgroundColor
	end
end)

TaskBarTools.Name = "TaskBarTools"
TaskBarTools.Parent = TaskBar
TaskBarTools.ZIndex = 3
TaskBarTools.BackgroundColor3 = TextBoxColor
TaskBarTools.BorderColor3 = TextBoxColor
TaskBarTools.BorderSizePixel = 0
TaskBarTools.Position = UDim2.new(0.422, 0, 0, 0)
TaskBarTools.Size = UDim2.new(0.125, 0, 1, 0)
TaskBarTools.Font = Enum.Font.SourceSansLight
TaskBarTools.Text = "   Tools"
TaskBarTools.TextColor3 = ForegroundColor
TaskBarTools.TextSize = 25
TaskBarTools.TextXAlignment = "Left"

TaskBarToolsLine.Name = "TaskBarToolsLine"
TaskBarToolsLine.Parent = TaskBar
TaskBarToolsLine.ZIndex = 4
TaskBarToolsLine.BackgroundColor3 = ForegroundColor
TaskBarToolsLine.BorderColor3 = ForegroundColor
TaskBarToolsLine.BorderSizePixel = 0
TaskBarToolsLine.Position = UDim2.new(0.422, 0, 0, 0)
TaskBarToolsLine.Size = UDim2.new(0.125, 0, 0.1, 0)

TaskBarTools.MouseButton1Down:connect(function() 
	
	if not ToggleTools then
		
		Tools.Visible = true
		
		ToggleTools = true
		
		TaskBarTools.BackgroundColor3 = TextBoxColor
		
	elseif ToggleTools then
		
		Tools.Visible = false
		
		ToggleTools = false
		
		TaskBarTools.BackgroundColor3 = BackgroundColor
	end
end)

TaskBarTime.Name = "TaskBarTime"
TaskBarTime.Parent = TaskBar
TaskBarTime.ZIndex = 3
TaskBarTime.BackgroundColor3 = TextBoxColor
TaskBarTime.BorderColor3 = TextBoxColor
TaskBarTime.BorderSizePixel = 0
TaskBarTime.Position = UDim2.new(0.96, 0, 0, 0)
TaskBarTime.Size = UDim2.new(0.04, 0, 1, 0)
TaskBarTime.Font = Enum.Font.SourceSansLight
TaskBarTime.Text = "   00:00"
TaskBarTime.TextColor3 = ForegroundColor
TaskBarTime.TextSize = 28
TaskBarTime.TextXAlignment = "Left"

coroutine.resume(coroutine.create(function() 
	
	while wait() do
		
		local function numberWithZero(num) 
			
			return (num < 10 and "0" or "") .. num
		end
		
		local localTime = os.time() - os.time() + math.floor(tick())
		local dayTime = localTime % 86400
		
		local hour = math.floor(dayTime/3600)
		
		dayTime = dayTime - (hour * 3600)
		local minute = math.floor(dayTime/60)
		
		dayTime = dayTime - (minute * 60)
		local second = dayTime
		
		local h = numberWithZero(hour)
		local m = numberWithZero(minute)
		local s = numberWithZero(dayTime)
		
		TaskBarTime.Text = "  " .. h .. ":" .. m
	end
end))

--[[ ALPHA INSIDE EXECUTER LOADER ]]--

Loader.Name = "Loader"
Loader.Parent = Main
Loader.Visible = false
Loader.ZIndex = 2
Loader.BackgroundColor3 = Color3.new(0, 0, 0)
Loader.BorderColor3 = Color3.new(0, 0, 0)
Loader.Position = UDim2.new(0, 0, -0.1, 0)
Loader.Size = UDim2.new(1, 0, 1.2, 0)
Loader.Active = true
Loader.Draggable = false

LoaderTitle.Name = "LoaderTitle"
LoaderTitle.Parent = Loader
LoaderTitle.ZIndex = 3
LoaderTitle.BackgroundColor3 = BackgroundColor
LoaderTitle.BorderColor3 = BackgroundColor
LoaderTitle.BackgroundTransparency = 1
LoaderTitle.Position = UDim2.new(0.315, 0, 0.43, 0)
LoaderTitle.Rotation = 180
LoaderTitle.Size = UDim2.new(0, 381, 0, 50)
LoaderTitle.Font = Enum.Font.Roboto
LoaderTitle.Text = "V"
LoaderTitle.TextColor3 = ForegroundColor
LoaderTitle.TextSize = 5000
LoaderTitle.TextXAlignment = "Left"

--[[ LoaderDesc.Name = "LoaderDesc"
LoaderDesc.Parent = Loader
LoaderDesc.ZIndex = 3
LoaderDesc.BackgroundColor3 = BackgroundColor
LoaderDesc.BorderColor3 = Color3.new(0.1,0.1,0.1)
LoaderDesc.BackgroundTransparency = 1
LoaderDesc.Position = UDim2.new(0.45, 0, 0.08, 0)
LoaderDesc.Size = UDim2.new(0, 381, 0, 50)
LoaderDesc.Font = Enum.Font.SourceSansLight
LoaderDesc.Text = "The new level of executor."
LoaderDesc.TextColor3 = ForegroundColor
LoaderDesc.TextSize = 25
LoaderDesc.TextXAlignment = "Left" --]]

LoaderProc.Name = "LoaderProc"
LoaderProc.Parent = Loader
LoaderProc.ZIndex = 3
LoaderProc.BackgroundColor3 = BackgroundColor
LoaderProc.BorderColor3 = Color3.new(0.1,0.1,0.1)
LoaderProc.BackgroundTransparency = 1
LoaderProc.Position = UDim2.new(0.4, 0, 0.85, 0)
LoaderProc.Size = UDim2.new(0, 381, 0, 50)
LoaderProc.Font = Enum.Font.SourceSansLight
LoaderProc.Text = "Loading.."
LoaderProc.TextColor3 = ForegroundColor
LoaderProc.TextSize = 25
LoaderProc.TextXAlignment = "Center"

LoadBar.Name = "LoadBar"
LoadBar.Parent = Loader
LoadBar.ZIndex = 2
LoadBar.BackgroundColor3 = ForegroundColor
LoadBar.BorderColor3 = ForegroundColor
LoadBar.Position = UDim2.new(0.45, 0, 0.53, 0)
LoadBar.Size = UDim2.new(0.25, 0, 0.005, 0)
LoadBar.Active = true
LoadBar.Draggable = false

--[[ ALPHA INSIDE LOGON ]]--

Logon.Name = "Logon"
Logon.Parent = Main
Logon.Visible = false
Logon.BackgroundColor3 = Color3.new(0, 0, 0)
Logon.BackgroundTransparency = 1
Logon.BorderColor3 = Color3.new(0, 0, 0)
Logon.Position = UDim2.new(0, 0, -.1, 0)
Logon.Size = UDim2.new(1, 0, 1.2, 0)
Logon.Active = true
Logon.Draggable = false

LogonWelcome.Name = "LogonWelcome"
LogonWelcome.Parent = Logon
LogonWelcome.ZIndex = 3
LogonWelcome.BackgroundColor3 = BackgroundColor
LogonWelcome.BorderColor3 = BackgroundColor
LogonWelcome.BackgroundTransparency = 1
LogonWelcome.TextTransparency = 1
LogonWelcome.Position = UDim2.new(0.42, 0, 0.56, 0)
LogonWelcome.Size = UDim2.new(0, 381, 0, 50)
LogonWelcome.Font = Enum.Font.SourceSansLight
LogonWelcome.Text = "Welcome to Alpha OS"
LogonWelcome.TextColor3 = ForegroundColor
LogonWelcome.TextSize = 45
LogonWelcome.TextXAlignment = "Left"

LogonLogin.Name = "LogonLogin"
LogonLogin.Parent = Logon
LogonLogin.ZIndex = 3
LogonLogin.Visible = false
LogonLogin.BackgroundColor3 = Color3.new(1, 1, 1)
LogonLogin.BackgroundTransparency = 1
LogonLogin.BorderColor3 = Color3.new(1, 1, 1)
LogonLogin.Position = UDim2.new(0.38, 0, 0.44, 0)
LogonLogin.Size = UDim2.new(0.3, 0, 0.1, 0)
LogonLogin.Font = Enum.Font.SourceSans
LogonLogin.Text = ""
LogonLogin.TextColor3 =  ForegroundColor
LogonLogin.TextSize = 25

LogonLogin.MouseButton1Down:Connect(function() 
	
	ToggleUi = true
end)

LogonLogo.Name = "LogonLogo"
LogonLogo.Parent = LogonLogin
LogonLogo.ZIndex = 3
LogonLogo.BackgroundColor3 = BackgroundColor
LogonLogo.BorderColor3 = BackgroundColor
LogonLogo.BackgroundTransparency = 1
LogonLogo.TextTransparency = 1
LogonLogo.Position = UDim2.new(0, 0, 0, 0) -- UDim2.new(0.25, 0, 0.45, 0)
LogonLogo.Rotation = 180
LogonLogo.Size = UDim2.new(0.2, 0, 1, 0)
LogonLogo.Font = Enum.Font.Roboto
LogonLogo.Text = "V"
LogonLogo.TextColor3 = ForegroundColor
LogonLogo.TextSize = 500
LogonLogo.TextXAlignment = "Left"

LogonTitle.Name = "LogonTitle"
LogonTitle.Parent = LogonLogin
LogonTitle.ZIndex = 3
LogonTitle.BackgroundColor3 = BackgroundColor
LogonTitle.BorderColor3 = BackgroundColor
LogonTitle.BackgroundTransparency = 1
LogonTitle.TextTransparency = 1
LogonTitle.Position = UDim2.new(0.28, 0, 0.15, 0)
LogonTitle.Size = UDim2.new(0, 381, 0, 50)
LogonTitle.Font = Enum.Font.Roboto
LogonTitle.Text = game.Players.LocalPlayer.Name
LogonTitle.TextColor3 = ForegroundColor
LogonTitle.TextSize = 40
LogonTitle.TextXAlignment = "Left"

LogonDesc.Name = "LogonDesc"
LogonDesc.Parent = LogonLogin
LogonDesc.ZIndex = 3
LogonDesc.BackgroundColor3 = BackgroundColor
LogonDesc.BorderColor3 = Color3.new(0.1,0.1,0.1)
LogonDesc.BackgroundTransparency = 1
LogonDesc.TextTransparency = 1
LogonDesc.Position = UDim2.new(0.28, 0, 0.45, 0)
LogonDesc.Size = UDim2.new(0, 381, 0, 50)
LogonDesc.Font = Enum.Font.SourceSansLight
LogonDesc.Text = "Login to this account"
LogonDesc.TextColor3 = ForegroundColor
LogonDesc.TextSize = 30
LogonDesc.TextXAlignment = "Left"

--[[ ALPHA INSIDE EXECUTER ]]--

Executer.Name = "Executer"
Executer.Parent = Main
Executer.Visible = false
Executer.BackgroundColor3 = BackgroundColor
Executer.BorderColor3 = BackgroundColor
Executer.Position = UDim2.new(0.51, 0, 0.025, 0)
Executer.Size = UDim2.new(0.4, 0, 0.45, 0)
Executer.Active = true
Executer.Draggable = true
Executer.ZIndex = 11

ExecuterPin.Parent = Executer
ExecuterPin.Active = true
ExecuterPin.Position = UDim2.new(0.95, 0, 0.025, 0)
ExecuterPin.Size = UDim2.new(0, 20, 0, 20)
ExecuterPin.Image = getcustomasset("AlphaOS/Assets/Pin.png")
ExecuterPin.BackgroundTransparency = 1
ExecuterPin.ZIndex = 14

if Settings["Executer Pinned"] == false then
	ExecuterPin.ImageColor3 = PinUnPinnedColor
	ExecuterPinned = false
elseif Settings["Executer Pinned"] == true then 
	ExecuterPin.ImageColor3 = PinPinnedColor
	ExecuterPinned = true
end

ExecuterPin.MouseButton1Down:connect(function() 
	if ExecuterPinned then
		ExecuterPin.ImageColor3 = PinUnPinnedColor
		Settings["Executer Pinned"] = false
		writefile("AlphaOS/Settings.json", game:GetService('HttpService'):JSONEncode(Settings))
		ExecuterPinned = false
		if not ToggleUi then
			Executer.Visible = false
		end
	else
		ExecuterPin.ImageColor3 = PinPinnedColor
		Settings["Executer Pinned"] = true
		writefile("AlphaOS/Settings.json", game:GetService('HttpService'):JSONEncode(Settings))
		ExecuterPinned = true
	end
end)

--credits to backdoor.exe for backdoor with remotes.

InjectButton.Parent = Executer
InjectButton.Active = true
InjectButton.Position = UDim2.new(0.9, 0, 0.025, 0)
InjectButton.Size = UDim2.new(0, 20, 0, 20)
InjectButton.Image = getcustomasset("AlphaOS/Assets/Inject.png")
InjectButton.BackgroundTransparency = 1
InjectButton.ZIndex = 14
InjectButton.ImageColor3 = PinUnPinnedColor

function Notify(title, text)
	game:GetService("StarterGui"):SetCore("SendNotification", {Title = title, Text = text})
end

checkDebounce = true
function Attached()
	if workspace:FindFirstChild(valueName) then
		game.workspace:WaitForChild(valueName):Destroy()
	end
	Notify('Server Side','Attached')
	R6Btn.Visible = true
	InjectButton.ImageColor3 = PinPinnedColor
	found = true
end

cachEnabled = false
found = false

valueName = "apples" ..game.Players.LocalPlayer.Name..string.char(math.random(65, 90))..string.char(math.random(65, 90))..math.random(100000, 999999)

function check()
	if workspace:FindFirstChild(valueName) then
		remote = sti(workspace:FindFirstChild(valueName).Value)
		return true
	end
end

function sti(str)
	local dir = str
	local segments = dir:split(".")
	local current = game
	for i, v in pairs(segments) do
		current = current[v]
	end
	return current
end

function scan()
	found = false
	scanDebounce = false
	for _, rm in pairs(game:GetDescendants()) do
		if rm.ClassName == "RemoteEvent" and not found then
			rm:FireServer("a = Instance.new('StringValue',workspace) a.Name = '" ..valueName .. "' a.Value = '" .. rm:GetFullName() .. "'")
			game:GetService("RunService").Stepped:Wait()
			if check() then
				Attached()
				backdoor = remote:GetFullName()
				break
			end
		end
	end
	if not found then
		wait(1.5)
		if check() then
			Attached()
			backdoor = remote:GetFullName()
		end
	end
	if not found then
		Notify("Server Side","Status: failed to find a backdoor")
	end
	wait(0.01)
	scanDebounce = true
end

Adebounce = true
InjectButton.MouseButton1Click:Connect(
	function()
		if not found then
			if Adebounce then
				Adebounce = false
				for _, cach in pairs(game:GetDescendants()) do
					if cach.ClassName == "StringValue" and cach.Name == "cached remote" then
						local backdoor = cach.Parent:GetFullName()
						remote = cach.Parent
						Attached()
						cached = true
						Adebounce = true
						break
					end
				end
				if game.ReplicatedStorage:FindFirstChild("Chat") then
					qrm = game.ReplicatedStorage:FindFirstChild("Chat")
					qrm:FireServer(Script)
					wait(0.15)
					if check(qrm) then
						Attached()
					end
					rsc = true
				end
				if not cached and not rsc then
					scan()
					Adebounce = true
				end
			end
		end
	end
)

ExecuterTitle.Name = "ExecuterTitle"
ExecuterTitle.Parent = Executer
ExecuterTitle.ZIndex = 13
ExecuterTitle.BackgroundColor3 = BackgroundColor
ExecuterTitle.BorderColor3 = BackgroundColor
ExecuterTitle.Position = UDim2.new(0, 0, 0.01, 0)
ExecuterTitle.Size = UDim2.new(1, 0, 0.07, 0)
ExecuterTitle.Font = Enum.Font.SourceSans
ExecuterTitle.Text = " Executor"
ExecuterTitle.TextColor3 = ForegroundColor
ExecuterTitle.TextSize = 25
ExecuterTitle.TextXAlignment = "Left"
ExecuterTitle.BackgroundTransparency = 1

ExecuterScroll.Name = "ExecuterScroll"
ExecuterScroll.Parent = Executer
ExecuterScroll.ZIndex = 13
ExecuterScroll.Active = true
ExecuterScroll.CanvasSize = UDim2.new(0, 0, 250, 0)
ExecuterScroll.ScrollBarImageColor3 = ForegroundColor
ExecuterScroll.ScrollBarImageTransparency = 0
ExecuterScroll.ScrollBarThickness = 7
ExecuterScroll.BackgroundColor3 = LineNumberColor
ExecuterScroll.Position = UDim2.new(0.006, 0, 0.09, 0)
ExecuterScroll.Size = UDim2.new(0.8, 0, 0.8, 0)

ScriptsScroll.Name = "ExecuterScroll"
ScriptsScroll.Parent = Executer
ScriptsScroll.ZIndex = 13
ScriptsScroll.Active = true
ScriptsScroll.CanvasSize = UDim2.new(0, 0, 5, 0)
ScriptsScroll.ScrollBarImageColor3 = ForegroundColor
ScriptsScroll.ScrollBarImageTransparency = 0
ScriptsScroll.ScrollBarThickness = 7
ScriptsScroll.BackgroundColor3 = LineNumberColor
ScriptsScroll.Position = UDim2.new(0.82, 0, 0.09, 0)
ScriptsScroll.Size = UDim2.new(0.16, 0, 0.8, 0)
ScriptsLayout.Parent = ScriptsScroll

ExecuterBoxBack.Name = "ExecuterBoxBack"
ExecuterBoxBack.Parent = ExecuterScroll
ExecuterBoxBack.Visible = true
ExecuterBoxBack.BackgroundColor3 = BackgroundColor
ExecuterBoxBack.BorderColor3 = BackgroundColor
ExecuterBoxBack.Position = UDim2.new(0.07, 0, 0, 0)
ExecuterBoxBack.Size = UDim2.new(0.4, 0, 0.45, 0)
ExecuterBoxBack.Active = true
ExecuterBoxBack.Draggable = false

ExecuterBox.Name = "ExecuterBox"
ExecuterBox.Parent = ExecuterScroll
ExecuterBox.ZIndex = 13
ExecuterBox.MultiLine = true
ExecuterBox.ClearTextOnFocus = false
ExecuterBox.TextXAlignment = "Left"
ExecuterBox.TextYAlignment = "Top"
ExecuterBox.BackgroundColor3 = TextBoxColor
ExecuterBox.BorderColor3 = TextBoxColor
ExecuterBox.Position = UDim2.new(0.02, 0, 0, 0)
ExecuterBox.Size = UDim2.new(1, 0, 1, 0)
ExecuterBox.Font = Enum.Font.Code
ExecuterBox.Text = SavedScript
ExecuterBox.TextColor3 = Color3.fromRGB(255, 255, 255)
ExecuterBox.TextSize = 14

Globals_.Name = "Globals_"
Globals_.Parent = ExecuterBox
Globals_.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Globals_.BackgroundTransparency = 1.000
Globals_.ClipsDescendants = true
Globals_.Size = UDim2.new(0, 561, 0, 1744)
Globals_.ZIndex = 15
Globals_.Font = Enum.Font.Code
Globals_.Text = ""
Globals_.TextColor3 = Color3.fromRGB(132, 214, 247)
Globals_.TextSize = 14
Globals_.TextXAlignment = Enum.TextXAlignment.Left
Globals_.TextYAlignment = Enum.TextYAlignment.Top

Keywords_.Name = "Keywords_"
Keywords_.Parent = ExecuterBox
Keywords_.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Keywords_.BackgroundTransparency = 1.000
Keywords_.ClipsDescendants = true
Keywords_.Size = UDim2.new(0, 561, 0, 1744)
Keywords_.ZIndex = 15
Keywords_.Font = Enum.Font.Code
Keywords_.Text = ""
Keywords_.TextColor3 = Color3.fromRGB(248, 109, 124)
Keywords_.TextSize = 14
Keywords_.TextXAlignment = Enum.TextXAlignment.Left
Keywords_.TextYAlignment = Enum.TextYAlignment.Top

Numbers_.Name = "Numbers_"
Numbers_.Parent = ExecuterBox
Numbers_.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Numbers_.BackgroundTransparency = 1.000
Numbers_.ClipsDescendants = true
Numbers_.Size = UDim2.new(0, 561, 0, 1744)
Numbers_.ZIndex = 14
Numbers_.Font = Enum.Font.Code
Numbers_.Text = ""
Numbers_.TextColor3 = Color3.fromRGB(255, 194, 89)
Numbers_.TextSize = 14
Numbers_.TextXAlignment = Enum.TextXAlignment.Left
Numbers_.TextYAlignment = Enum.TextYAlignment.Top

RemoteHighlight_.Name = "RemoteHighlight_"
RemoteHighlight_.Parent = ExecuterBox
RemoteHighlight_.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
RemoteHighlight_.BackgroundTransparency = 1.000
RemoteHighlight_.ClipsDescendants = true
RemoteHighlight_.Size = UDim2.new(0, 561, 0, 1744)
RemoteHighlight_.ZIndex = 15
RemoteHighlight_.Font = Enum.Font.Code
RemoteHighlight_.Text = ""
RemoteHighlight_.TextColor3 = Color3.fromRGB(11, 255, 203)
RemoteHighlight_.TextSize = 14
RemoteHighlight_.TextXAlignment = Enum.TextXAlignment.Left
RemoteHighlight_.TextYAlignment = Enum.TextYAlignment.Top

Strings_.Name = "Strings_"
Strings_.Parent = ExecuterBox
Strings_.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Strings_.BackgroundTransparency = 1.000
Strings_.ClipsDescendants = true
Strings_.Size = UDim2.new(0, 561, 0, 1744)
Strings_.ZIndex = 15
Strings_.Font = Enum.Font.Code
Strings_.Text = ""
Strings_.TextColor3 = Color3.fromRGB(172, 122, 104)
Strings_.TextSize = 14
Strings_.TextXAlignment = Enum.TextXAlignment.Left
Strings_.TextYAlignment = Enum.TextYAlignment.Top

Tokens_.Name = "Tokens_"
Tokens_.Parent = ExecuterBox
Tokens_.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Tokens_.BackgroundTransparency = 1.000
Tokens_.ClipsDescendants = true
Tokens_.Size = UDim2.new(0, 561, 0, 1744)
Tokens_.ZIndex = 15
Tokens_.Font = Enum.Font.Code
Tokens_.Text = ""
Tokens_.TextColor3 = Color3.fromRGB(255, 255, 255)
Tokens_.TextSize = 14
Tokens_.TextXAlignment = Enum.TextXAlignment.Left
Tokens_.TextYAlignment = Enum.TextYAlignment.Top

Comments_.Name = "Comments_"
Comments_.Parent = ExecuterBox
Comments_.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Comments_.BackgroundTransparency = 1.000
Comments_.ClipsDescendants = true
Comments_.Size = UDim2.new(0, 561, 0, 1744)
Comments_.Visible = false
Comments_.ZIndex = 15
Comments_.Font = Enum.Font.Code
Comments_.Text = ""
Comments_.TextColor3 = Color3.fromRGB(86, 86, 86)
Comments_.TextSize = 14
Comments_.TextTransparency = 1.000
Comments_.TextXAlignment = Enum.TextXAlignment.Left
Comments_.TextYAlignment = Enum.TextYAlignment.Top

local lua_keywords = {
    "and",
    "break",
    "do",
    "else",
    "elseif",
    "end",
    "false",
    "for",
    "function",
    "goto",
    "if",
    "in",
    "local",
    "nil",
    "not",
    "or",
    "repeat",
    "return",
    "then",
    "true",
    "until",
    "while"
}
local global_env = {
    "getrawmetatable",
    "game",
    "workspace",
    "script",
    "math",
    "string",
    "table",
    "print",
    "wait",
    "BrickColor",
    "Color3",
    "next",
    "pairs",
    "ipairs",
    "select",
    "unpack",
    "Instance",
    "Vector2",
    "Vector3",
    "CFrame",
    "Ray",
    "UDim2",
    "Enum",
    "assert",
    "error",
    "warn",
    "tick",
    "loadstring",
    "_G",
    "shared",
    "getfenv",
    "setfenv",
    "newproxy",
    "setmetatable",
    "getmetatable",
    "os",
    "debug",
    "pcall",
    "ypcall",
    "xpcall",
    "rawequal",
    "rawset",
    "rawget",
    "tonumber",
    "tostring",
    "type",
    "typeof",
    "_VERSION",
    "coroutine",
    "delay",
    "require",
    "spawn",
    "LoadLibrary",
    "settings",
    "stats",
    "time",
    "UserSettings",
    "version",
    "Axes",
    "ColorSequence",
    "Faces",
    "ColorSequenceKeypoint",
    "NumberRange",
    "NumberSequence",
    "NumberSequenceKeypoint",
    "gcinfo",
    "elapsedTime",
    "collectgarbage",
    "PhysicalProperties",
    "Rect",
    "Region3",
    "Region3int16",
    "UDim",
    "Vector2int16",
    "Vector3int16"
}
local Highlight = function(string, keywords)
    local K = {}
    local S = string
    local Token = {
        ["="] = true,
        ["."] = true,
        [","] = true,
        ["("] = true,
        [")"] = true,
        ["["] = true,
        ["]"] = true,
        ["{"] = true,
        ["}"] = true,
        [":"] = true,
        ["*"] = true,
        ["/"] = true,
        ["+"] = true,
        ["-"] = true,
        ["%"] = true,
        [";"] = true,
        ["~"] = true
    }
    for i, v in pairs(keywords) do
        K[v] = true
    end
    S =
        S:gsub(
        ".",
        function(c)
            if Token[c] ~= nil then
                return "\32"
            else
                return c
            end
        end
    )
    S =
        S:gsub(
        "%S+",
        function(c)
            if K[c] ~= nil then
                return c
            else
                return (" "):rep(#c)
            end
        end
    )
    return S
end
local hTokens = function(string)
    local Token = {
        ["="] = true,
        ["."] = true,
        [","] = true,
        ["("] = true,
        [")"] = true,
        ["["] = true,
        ["]"] = true,
        ["{"] = true,
        ["}"] = true,
        [":"] = true,
        ["*"] = true,
        ["/"] = true,
        ["+"] = true,
        ["-"] = true,
        ["%"] = true,
        [";"] = true,
        ["~"] = true
    }
    local A = ""
    string:gsub(
        ".",
        function(c)
            if Token[c] ~= nil then
                A = A .. c
            elseif c == "\n" then
                A = A .. "\n"
            elseif c == "\t" then
                A = A .. "\t"
            else
                A = A .. "\32"
            end
        end
    )
    return A
end
local strings = function(string)
    local highlight = ""
    local quote = false
    string:gsub(
        ".",
        function(c)
            if quote == false and c == '"' then
                quote = true
            elseif quote == false and c == "'" then
                quote = true
            elseif quote == true and c == '"' then
                quote = false
            elseif quote == true and c == "'" then
                quote = false
            end
            if quote == false and c == '"' then
                highlight = highlight .. '"'
            elseif quote == false and c == "'" then
                highlight = highlight .. "'"
            elseif c == "\n" then
                highlight = highlight .. "\n"
            elseif c == "\t" then
                highlight = highlight .. "\t"
            elseif quote == true then
                highlight = highlight .. c
            elseif quote == false then
                highlight = highlight .. "\32"
            end
        end
    )
    return highlight
end
local comments = function(string)
    local ret = ""
    string:gsub(
        "[^\r\n]+",
        function(c)
            local comm = false
            local i = 0
            c:gsub(
                ".",
                function(n)
                    i = i + 1
                    if c:sub(i, i + 1) == "--" then
                        comm = true
                    end
                    if comm == true then
                        ret = ret .. n
                    else
                        ret = ret .. "\32"
                    end
                end
            )
            ret = ret
        end
    )
    return ret
end
local numbers = function(string)
    local A = ""
    string:gsub(
        ".",
        function(c)
            if tonumber(c) ~= nil then
                A = A .. c
            elseif c == "\n" then
                A = A .. "\n"
            elseif c == "\t" then
                A = A .. "\t"
            else
                A = A .. "\32"
            end
        end
    )
    return A
end
local highlight_source = function(type)
    if type == "Text" then
        ExecuterBox.Text = ExecuterBox.Text:gsub("\13", "")
        ExecuterBox.Text = ExecuterBox.Text:gsub("\t", "      ")
        local s = ExecuterBox.Text
        ExecuterBox.Keywords_.Text = Highlight(s, lua_keywords)
        ExecuterBox.Globals_.Text = Highlight(s, global_env)
        ExecuterBox.RemoteHighlight_.Text =
            Highlight(
            s,
            {
                "FireServer",
                "fireServer",
                "InvokeServer",
                "invokeServer"
            }
        )
        ExecuterBox.Tokens_.Text = hTokens(s)
        ExecuterBox.Numbers_.Text = numbers(s)
        ExecuterBox.Strings_.Text = strings(s)
        ExecuterBox.Comments_.Text = comments(s)
        local lin = 1
        s:gsub(
            "\n",
            function()
                lin = lin + 1
            end
        )
        ExecuterLineNumbers.Text = ""
        for i = 1, lin do
            ExecuterLineNumbers.Text = ExecuterLineNumbers.Text .. i .. "\n"
        end
    end
end
highlight_source("Text")
ExecuterBox.Changed:Connect(highlight_source)

ExecuterBox.Changed:Connect(function()
	SavedScript = ExecuterBox.Text
	writefile("AlphaOS/Tabs/Script1.lua", SavedScript)
end)

ExecuterLineNumbers.Name = "ExecuterLineNumbers"
ExecuterLineNumbers.Parent = ExecuterScroll
ExecuterLineNumbers.ZIndex = 13
ExecuterLineNumbers.TextXAlignment = "Left"
ExecuterLineNumbers.TextYAlignment = "Top"
ExecuterLineNumbers.BackgroundColor3 = LineNumberColor
ExecuterLineNumbers.BorderColor3 = LineNumberColor
ExecuterLineNumbers.Position = UDim2.new(0, 0, 0, 0)
ExecuterLineNumbers.Size = UDim2.new(0.01, 0, 1, 0)
ExecuterLineNumbers.Font = Enum.Font.SourceSansLight
ExecuterLineNumbers.Text = " 1"
ExecuterLineNumbers.TextColor3 = ForegroundColor
ExecuterLineNumbers.TextSize = 14
ExecuterLineNumbers.TextXAlignment = "Left"

ExecuterBox:GetPropertyChangedSignal("Text"):Connect(function() 
	
	local _, count = ExecuterBox.Text:gsub("\n", "")
	
	ExecuterLineNumbers.Text = " 1"
	
	coroutine.resume(coroutine.create(function() 
		
		for i = 2, count + 1, 1 do
			
			ExecuterLineNumbers.Text = ExecuterLineNumbers.Text .. "\n " .. i
		end
	end))
end)

local _, count = ExecuterBox.Text:gsub("\n", "")
      
ExecuterLineNumbers.Text = " 1"
      
coroutine.resume(coroutine.create(function() 
            
      for i = 2, count + 1, 1 do
                  
            ExecuterLineNumbers.Text = ExecuterLineNumbers.Text .. "\n " .. i
      end
end))

ExecuterBtn.Name = "ExecuterBtn"
ExecuterBtn.Parent = Executer
ExecuterBtn.ZIndex = 13
ExecuterBtn.BackgroundColor3 = BackgroundColor
ExecuterBtn.BorderColor3 = BackgroundColor
ExecuterBtn.Position = UDim2.new(0.007, 0, 0.91, 0)
ExecuterBtn.Size = UDim2.new(0, 111, 0, 32)
ExecuterBtn.Font = Enum.Font.SourceSans
ExecuterBtn.Text = "Execute"
ExecuterBtn.TextColor3 =  ForegroundColor
ExecuterBtn.TextSize = 25

ExecuterBtn.MouseButton1Down:connect(function() 
	if not found then
		local result, err = loadstring(ExecuterBox.Text)
		
		if type(result) ~= "function" then
			
			print(err)
			
		else
			
			result()
		end
	elseif found then
		remote:FireServer(ExecuterBox.Text)
	end
end)

ExecuterClearBtn.Name = "ExecuterClearBtn"
ExecuterClearBtn.Parent = Executer
ExecuterClearBtn.ZIndex = 13
ExecuterClearBtn.BackgroundColor3 = BackgroundColor
ExecuterClearBtn.BorderColor3 = BackgroundColor
ExecuterClearBtn.Position = UDim2.new(0.165, 0, 0.91, 0)
ExecuterClearBtn.Size = UDim2.new(0, 111, 0, 32)
ExecuterClearBtn.Font = Enum.Font.SourceSans
ExecuterClearBtn.Text = "Clear"
ExecuterClearBtn.TextColor3 = ForegroundColor
ExecuterClearBtn.TextSize = 25

ExecuterClearBtn.MouseButton1Down:connect(function() 
	
	ExecuterBox.Text = ""
end)

ExecuterOpenFileBtn.Name = "ExecuterOpenFileBtn"
ExecuterOpenFileBtn.Parent = Executer
ExecuterOpenFileBtn.ZIndex = 13
ExecuterOpenFileBtn.BackgroundColor3 = BackgroundColor
ExecuterOpenFileBtn.BorderColor3 = BackgroundColor
ExecuterOpenFileBtn.Position = UDim2.new(0.322, 0, 0.91, 0)
ExecuterOpenFileBtn.Size = UDim2.new(0, 111, 0, 32)
ExecuterOpenFileBtn.Font = Enum.Font.SourceSans
ExecuterOpenFileBtn.Text = "Open file"
ExecuterOpenFileBtn.TextColor3 = ForegroundColor
ExecuterOpenFileBtn.TextSize = 25

ExecuterSaveFileBtn.Name = "ExecuterSaveFileBtn"
ExecuterSaveFileBtn.Parent = Executer
ExecuterSaveFileBtn.ZIndex = 13
ExecuterSaveFileBtn.BackgroundColor3 = BackgroundColor
ExecuterSaveFileBtn.BorderColor3 = BackgroundColor
ExecuterSaveFileBtn.Position = UDim2.new(0.48, 0, 0.91, 0)
ExecuterSaveFileBtn.Size = UDim2.new(0, 111, 0, 32)
ExecuterSaveFileBtn.Font = Enum.Font.SourceSans
ExecuterSaveFileBtn.Text = "Save file"
ExecuterSaveFileBtn.TextColor3 = ForegroundColor
ExecuterSaveFileBtn.TextSize = 25

ExecuterSaveFileBtn.MouseButton1Down:connect(function() 
	writefile("AlphaOS/ScriptSaves/ScriptSave-"..genstring(math.random(8, 15))..".lua", ExecuterBox.Text)
end)

ExecuterBeautifyBtn.Name = "ExecuterBeautifyBtn"
ExecuterBeautifyBtn.Parent = Executer
ExecuterBeautifyBtn.ZIndex = 13
ExecuterBeautifyBtn.BackgroundColor3 = BackgroundColor
ExecuterBeautifyBtn.BorderColor3 = BackgroundColor
ExecuterBeautifyBtn.Position = UDim2.new(0.638, 0, 0.91, 0)
ExecuterBeautifyBtn.Size = UDim2.new(0, 111, 0, 32)
ExecuterBeautifyBtn.Font = Enum.Font.SourceSans
ExecuterBeautifyBtn.Text = "Beautify"
ExecuterBeautifyBtn.TextColor3 = ForegroundColor
ExecuterBeautifyBtn.TextSize = 25

ExecuterBeautifyBtn.MouseButton1Down:connect(function() 
	ExecuterBox.Text = BnM.Beautify(ExecuterBox.Text)
end)

R6Btn.Name = "R6Btn"
R6Btn.Parent = Executer
R6Btn.ZIndex = 13
R6Btn.BackgroundColor3 = BackgroundColor
R6Btn.BorderColor3 = BackgroundColor
R6Btn.Position = UDim2.new(0.85, 0, 0.91, 0)
R6Btn.Size = UDim2.new(0, 111, 0, 32)
R6Btn.Font = Enum.Font.SourceSans
R6Btn.Text = "R6"
R6Btn.TextColor3 = ForegroundColor
R6Btn.TextSize = 22
R6Btn.Visible = false

R6Btn.MouseButton1Click:Connect(function()
	if found then
		remote:FireServer('require(3041175937):r6("' .. game.Players.LocalPlayer.Name .. '")')
	end
end)

--[[ ALPHA INSIDE EXECUTER CONSOLE ]]--

Console.Name = "  Console"
Console.Parent = Main
Console.Visible = false
Console.BackgroundColor3 = BackgroundColor
Console.BorderColor3 = BackgroundColor
Console.Position = UDim2.new(0.51, 0, 0.51, 0)
Console.Size = UDim2.new(0.4, 0, 0.45, 0)
Console.Active = true
Console.Draggable = true

ConsolePin.Parent = Console
ConsolePin.Active = true
ConsolePin.Position = UDim2.new(0.95, 0, 0.025, 0)
ConsolePin.Size = UDim2.new(0, 20, 0, 20)
ConsolePin.Image = getcustomasset("AlphaOS/Assets/Pin.png")
ConsolePin.BackgroundTransparency = 1
ConsolePin.ZIndex = 4

if Settings["Console Pinned"] == false then
	ConsolePin.ImageColor3 = PinUnPinnedColor
	ConsolePinned = false
elseif Settings["Console Pinned"] == true then 
	ConsolePin.ImageColor3 = PinPinnedColor
	ConsolePinned = true
end

ConsolePin.MouseButton1Down:connect(function() 
	if ConsolePinned then
		ConsolePin.ImageColor3 = PinUnPinnedColor
		Settings["Console Pinned"] = false
		writefile("AlphaOS/Settings.json", game:GetService('HttpService'):JSONEncode(Settings))
		ConsolePinned = false
		if not ToggleUi then
			Console.Visible = false
		end
	else
		ConsolePin.ImageColor3 = PinPinnedColor
		Settings["Console Pinned"] = true
		writefile("AlphaOS/Settings.json", game:GetService('HttpService'):JSONEncode(Settings))
		ConsolePinned = true
	end
end)

ConsoleTitle.Name = "ConsoleTitle"
ConsoleTitle.Parent = Console
ConsoleTitle.ZIndex = 3
ConsoleTitle.BackgroundColor3 = BackgroundColor
ConsoleTitle.BorderColor3 = BackgroundColor
ConsoleTitle.Position = UDim2.new(0, 0, 0.01, 0)
ConsoleTitle.Size = UDim2.new(1, 0, 0.07, 0)
ConsoleTitle.Font = Enum.Font.SourceSans
ConsoleTitle.Text = " Console" -- "        Console" for icon
ConsoleTitle.TextColor3 = ForegroundColor
ConsoleTitle.TextSize = 25
ConsoleTitle.TextXAlignment = "Left"
ConsoleTitle.BackgroundTransparency = 1

ConsoleScroll.Name = "ConsoleScroll"
ConsoleScroll.Parent = Console
ConsoleScroll.ZIndex = 3
ConsoleScroll.Active = true
ConsoleScroll.CanvasSize = UDim2.new(0, 0, 250, 0)
ConsoleScroll.ScrollBarImageColor3 = ForegroundColor
ConsoleScroll.ScrollBarImageTransparency = 0
ConsoleScroll.ScrollBarThickness = 7
ConsoleScroll.BackgroundColor3 = LineNumberColor
ConsoleScroll.BorderColor3 = LineNumberColor
ConsoleScroll.Position = UDim2.new(0.01, 0, 0.1, 0)
ConsoleScroll.Size = UDim2.new(0.98, 0, 0.8, 0)

ConsoleLogs.Name = "ConsoleLogs"
ConsoleLogs.Parent = ConsoleScroll
ConsoleLogs.ZIndex = 3
ConsoleLogs.TextXAlignment = "Left"
ConsoleLogs.TextYAlignment = "Top"
ConsoleLogs.BackgroundColor3 = TextBoxColor
ConsoleLogs.BorderColor3 = TextBoxColor
ConsoleLogs.Position = UDim2.new(0, 0, 0, 0)
ConsoleLogs.Size = UDim2.new(1, 0, 1, 0)
ConsoleLogs.Font = Enum.Font.SourceSansLight
ConsoleLogs.Text = ""
ConsoleLogs.TextColor3 = ForegroundColor
ConsoleLogs.TextSize = 20
ConsoleLogs.TextWrap = true

coroutine.resume(coroutine.create(function() 
	
	do -- This do block keeps history from sticking around in memory
		
		local history = game:GetService("LogService"):GetLogHistory()
		
		for i = 1, #history do
			
			local msg = history[i]
			
			local function numberWithZero(num) 
				
				return (num < 10 and "0" or "") .. num
			end
	
			local localTime = msg.timestamp - os.time() + math.floor(tick())
			local dayTime = localTime % 86400
	
			local hour = math.floor(dayTime/3600)
	
			dayTime = dayTime - (hour * 3600)
			local minute = math.floor(dayTime/60)
	
			dayTime = dayTime - (minute * 60)
			local second = dayTime
	
			local h = numberWithZero(hour)
			local m = numberWithZero(minute)
			local s = numberWithZero(dayTime)
			
			local MessageTypeFilter = "Output"
			
			if msg.messageType == Enum.MessageType.MessageOutput then
				
				MessageTypeFilter = "Output"
				
			elseif msg.messageType == Enum.MessageType.MessageInfo then
				
				MessageTypeFilter = "Info"
				
			elseif msg.messageType == Enum.MessageType.MessageWarning then
				
				MessageTypeFilter = "Warning"
				
			elseif msg.messageType == Enum.MessageType.MessageError then
				
				MessageTypeFilter = "Error"
			end
			
			ConsoleLogs.Text = ConsoleLogs.Text .. "[" .. h .. ":" .. m .. ":" .. s .. "] FROM: History | TYPE: " .. MessageTypeFilter .. " | MESSAGE: " .. (msg.message or "[DevConsole Error: 2") .. "\n"
		end
	end
end))

game:GetService("LogService").MessageOut:Connect(function(msg, messageType) 
	
	local function numberWithZero(num) 
		
		return (num < 10 and "0" or "") .. num
	end
	
	local localTime = os.time() - os.time() + math.floor(tick())
	local dayTime = localTime % 86400
	
	local hour = math.floor(dayTime/3600)
	
	dayTime = dayTime - (hour * 3600)
	local minute = math.floor(dayTime/60)
	
	dayTime = dayTime - (minute * 60)
	local second = dayTime
	
	local h = numberWithZero(hour)
	local m = numberWithZero(minute)
	local s = numberWithZero(dayTime)
	
	local MessageTypeFilter = "Output"
	
	if messageType == Enum.MessageType.MessageOutput then
		
		MessageTypeFilter = "Output"
				
	elseif messageType == Enum.MessageType.MessageInfo then
		
		MessageTypeFilter = "Info"
				
	elseif messageType == Enum.MessageType.MessageWarning then
		
		MessageTypeFilter = "Warning"
				
	elseif messageType == Enum.MessageType.MessageError then
		
		MessageTypeFilter = "Error"
	end
	
	ConsoleLogs.Text = ConsoleLogs.Text .. "[" .. h .. ":" .. m .. ":" .. s .. "] FROM: Client | TYPE: " .. MessageTypeFilter .. " | MESSAGE: " .. (msg or "[DevConsole Error: 2") .. "\n"
end)

LogService.ServerMessageOut:connect(function(text, messageType, timestamp) 
	
	local function numberWithZero(num) 
		
		return (num < 10 and "0" or "") .. num
	end
	
	local localTime = os.time() - os.time() + math.floor(tick())
	local dayTime = localTime % 86400
	
	local hour = math.floor(dayTime/3600)
	
	dayTime = dayTime - (hour * 3600)
	local minute = math.floor(dayTime/60)
	
	dayTime = dayTime - (minute * 60)
	local second = dayTime
	
	local h = numberWithZero(hour)
	local m = numberWithZero(minute)
	local s = numberWithZero(dayTime)
	
	local MessageTypeFilter = "Output"
	
	if messageType == Enum.MessageType.MessageOutput then
		
		MessageTypeFilter = "Output"
				
	elseif messageType == Enum.MessageType.MessageInfo then
		
		MessageTypeFilter = "Info"
				
	elseif messageType == Enum.MessageType.MessageWarning then
		
		MessageTypeFilter = "Warning"
				
	elseif messageType == Enum.MessageType.MessageError then
		
		MessageTypeFilter = "Error"
	end
	
	ConsoleLogs.Text = ConsoleLogs.Text .. "[" .. h .. ":" .. m .. ":" .. s .. "] FROM: Server | TYPE: " .. MessageTypeFilter .. " | MESSAGE: " .. (msg or "[DevConsole Error: 2") .. "\n"
end)

ConsolePrefix.Name = "ConsolePrefix"
ConsolePrefix.Parent = Console
ConsolePrefix.ZIndex = 3
ConsolePrefix.BackgroundColor3 = TextBoxColor
ConsolePrefix.BorderColor3 = TextBoxColor
ConsolePrefix.Position = UDim2.new(0.0115, 0, 0.925, 0)
ConsolePrefix.Size = UDim2.new(0.036, 0, 0.05, 0)
ConsolePrefix.Font = Enum.Font.SourceSansLight
ConsolePrefix.Text = " >"
ConsolePrefix.TextColor3 = ForegroundColor
ConsolePrefix.TextSize = 22
ConsolePrefix.TextXAlignment = "Left"

ConsoleBox.Name = "ConsoleBox"
ConsoleBox.Parent = Console
ConsoleBox.ZIndex = 3
ConsoleBox.MultiLine = false
ConsoleBox.ClearTextOnFocus = false
ConsoleBox.TextXAlignment = "Left"
ConsoleBox.TextYAlignment = "Top"
ConsoleBox.BackgroundColor3 = TextBoxColor
ConsoleBox.BorderColor3 = TextBoxColor
ConsoleBox.Position = UDim2.new(0.0505, 0, 0.925, 0)
ConsoleBox.Size = UDim2.new(0.93, 0, 0.05, 0)
ConsoleBox.Font = Enum.Font.SourceSansLight
ConsoleBox.Text = ""
ConsoleBox.TextColor3 = ForegroundColor
ConsoleBox.TextSize = 23
ConsoleBox.TextXAlignment = "Left"

ConsoleBox.FocusLost:Connect(function(pressed) 
	
	if pressed then
		
		local result = loadstring(ConsoleBox.Text)
		
		if type(result) ~= "function" then
			
			print(loadstring(ConsoleBox.Text))
			
		else
			
			result()
		end
	end
end)

--[[ ALPHA INSIDE EXECUTER FILES ]]--

Files.Name = "Files"
Files.Parent = Main
Files.Visible = false
Files.BackgroundColor3 = BackgroundColor
Files.BorderColor3 = BackgroundColor
Files.Position = UDim2.new(0.09, 0, 0.025, 0)
Files.Size = UDim2.new(0.4, 0, 0.45, 0)
Files.Active = true
Files.Draggable = true

FilesPin.Parent = Files
FilesPin.Active = true
FilesPin.Position = UDim2.new(0.95, 0, 0.025, 0)
FilesPin.Size = UDim2.new(0, 20, 0, 20)
FilesPin.Image = getcustomasset("AlphaOS/Assets/Pin.png")
FilesPin.BackgroundTransparency = 1
FilesPin.ZIndex = 3

if Settings["Files Pinned"] == false then
	FilesPin.ImageColor3 = PinUnPinnedColor
	FilesPinned = false
elseif Settings["Files Pinned"] == true then 
	FilesPin.ImageColor3 = PinPinnedColor
	FilesPinned = true
end

FilesPin.MouseButton1Down:connect(function() 
	if FilesPinned then
		FilesPin.ImageColor3 = PinUnPinnedColor
		Settings["Files Pinned"] = false
		writefile("AlphaOS/Settings.json", game:GetService('HttpService'):JSONEncode(Settings))
		FilesPinned = false
		if not ToggleUi then
			Files.Visible = false
		end
	else
		FilesPin.ImageColor3 = PinPinnedColor
		Settings["Files Pinned"] = true
		writefile("AlphaOS/Settings.json", game:GetService('HttpService'):JSONEncode(Settings))
		FilesPinned = true
	end
end)

FilesTitle.Name = "FilesTitle"
FilesTitle.Parent = Files
FilesTitle.ZIndex = 2
FilesTitle.BackgroundColor3 = BackgroundColor
FilesTitle.BorderColor3 = BackgroundColor
FilesTitle.Position = UDim2.new(0, 0, 0.01, 0)
FilesTitle.Size = UDim2.new(1, 0, 0.07, 0)
FilesTitle.Font = Enum.Font.SourceSans
FilesTitle.Text = " Files" -- "        Executor" for icon
FilesTitle.TextColor3 = ForegroundColor
FilesTitle.TextSize = 25
FilesTitle.TextXAlignment = "Left"
FilesTitle.BackgroundTransparency = 1

--[[ ALPHA INSIDE EXECUTER TOOLS ]]--

Tools.Name = "Tools"
Tools.Parent = Main
Tools.Visible = false
Tools.BackgroundColor3 = BackgroundColor
Tools.BorderColor3 = BackgroundColor
Tools.Position = UDim2.new(0.09, 0, 0.51, 0)
Tools.Size = UDim2.new(0.4, 0, 0.45, 0)
Tools.Active = true
Tools.Draggable = true
Tools.ZIndex = 6

ToolsPin.Parent = Tools
ToolsPin.Active = true
ToolsPin.Position = UDim2.new(0.95, 0, 0.025, 0)
ToolsPin.Size = UDim2.new(0, 20, 0, 20)
ToolsPin.Image = getcustomasset("AlphaOS/Assets/Pin.png")
ToolsPin.BackgroundTransparency = 1
ToolsPin.ZIndex = 9

if Settings["Tools Pinned"] == false then
	ToolsPin.ImageColor3 = PinUnPinnedColor
	ToolsPinned = false
elseif Settings["Tools Pinned"] == true then 
	ToolsPin.ImageColor3 = PinPinnedColor
	ToolsPinned = true
end

ToolsPin.MouseButton1Down:connect(function() 
	if ToolsPinned then
		ToolsPin.ImageColor3 = PinUnPinnedColor
		Settings["Tools Pinned"] = false
		writefile("AlphaOS/Settings.json", game:GetService('HttpService'):JSONEncode(Settings))
		ToolsPinned = false
		if not ToggleUi then
			Tools.Visible = false
		end
	else
		ToolsPin.ImageColor3 = PinPinnedColor
		Settings["Tools Pinned"] = true
		writefile("AlphaOS/Settings.json", game:GetService('HttpService'):JSONEncode(Settings))
		ToolsPinned = true
	end
end)

ToolsTitle.Name = "ToolsTitle"
ToolsTitle.Parent = Tools
ToolsTitle.ZIndex = 8
ToolsTitle.BackgroundColor3 = BackgroundColor
ToolsTitle.BorderColor3 = BackgroundColor
ToolsTitle.Position = UDim2.new(0, 0, 0.01, 0)
ToolsTitle.Size = UDim2.new(1, 0, 0.07, 0)
ToolsTitle.Font = Enum.Font.SourceSans
ToolsTitle.Text = " Tools" -- "        Executor" for icon
ToolsTitle.TextColor3 = ForegroundColor
ToolsTitle.TextSize = 25
ToolsTitle.TextXAlignment = "Left"
ToolsTitle.BackgroundTransparency = 1

ToolsScroll.Name = "ToolsScroll"
ToolsScroll.Parent = Tools
ToolsScroll.ZIndex = 8
ToolsScroll.Active = true
ToolsScroll.CanvasSize = UDim2.new(0, 0, 250, 0)
ToolsScroll.ScrollBarImageColor3 = ForegroundColor
ToolsScroll.ScrollBarImageTransparency = 0
ToolsScroll.ScrollBarThickness = 7
ToolsScroll.BackgroundColor3 = LineNumberColor
ToolsScroll.BorderColor3 = LineNumberColor
ToolsScroll.Position = UDim2.new(0.01, 0, 0.1, 0)
ToolsScroll.Size = UDim2.new(0.825, 0, 0.4, 0)

ToolsSyntaxCheck.Name = "ToolsSyntaxCheck"
ToolsSyntaxCheck.Parent = ToolsScroll
ToolsSyntaxCheck.ZIndex = 8
ToolsSyntaxCheck.TextXAlignment = "Left"
ToolsSyntaxCheck.TextYAlignment = "Top"
ToolsSyntaxCheck.BackgroundColor3 = TextBoxColor
ToolsSyntaxCheck.BorderColor3 = TextBoxColor
ToolsSyntaxCheck.Position = UDim2.new(0, 0, 0, 0)
ToolsSyntaxCheck.Size = UDim2.new(1, 0, 1, 0)
ToolsSyntaxCheck.Font = Enum.Font.SourceSansLight
ToolsSyntaxCheck.Text = "No error"
ToolsSyntaxCheck.TextColor3 = ForegroundColor
ToolsSyntaxCheck.TextSize = 20
ToolsSyntaxCheck.TextWrap = true

ExecuterBox:GetPropertyChangedSignal("Text"):Connect(function() 
	
	local result, err = loadstring(ExecuterBox.Text)
	
	if type(result) ~= "function" then
		
		ToolsSyntaxCheck.Text = err
	else
		
		ToolsSyntaxCheck.Text = "No error"
	end
end)

ToolsClearBtn.Name = "ToolsClearBtn"
ToolsClearBtn.Parent = Tools
ToolsClearBtn.ZIndex = 8
ToolsClearBtn.BackgroundColor3 = BackgroundColor
ToolsClearBtn.BorderColor3 = BackgroundColor
ToolsClearBtn.Position = UDim2.new(0.845, 0, 0.1, 0)
ToolsClearBtn.Size = UDim2.new(0, 111, 0, 32)
ToolsClearBtn.Font = Enum.Font.SourceSans
ToolsClearBtn.Text = "Clear Console"
ToolsClearBtn.TextColor3 = ForegroundColor
ToolsClearBtn.TextSize = 22

ToolsClearBtn.MouseButton1Down:connect(function() 
	ConsoleLogs.Text = ""
end)

ToolsRejoin.Name = "ToolsRejoin"
ToolsRejoin.Parent = Tools
ToolsRejoin.ZIndex = 8
ToolsRejoin.BackgroundColor3 = BackgroundColor
ToolsRejoin.BorderColor3 = BackgroundColor
ToolsRejoin.Position = UDim2.new(0.845, 0, 0.25, 0)
ToolsRejoin.Size = UDim2.new(0, 111, 0, 32)
ToolsRejoin.Font = Enum.Font.SourceSans
ToolsRejoin.Text = "Rejoin"
ToolsRejoin.TextColor3 = ForegroundColor
ToolsRejoin.TextSize = 22

ToolsRejoin.MouseButton1Down:connect(function() 
	game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId)
end)

ToolsToggleRspy.Name = "ToolsToggleRspyBtn"
ToolsToggleRspy.Parent = Tools
ToolsToggleRspy.ZIndex = 8
ToolsToggleRspy.BackgroundColor3 = BackgroundColor
ToolsToggleRspy.BorderColor3 = BackgroundColor
ToolsToggleRspy.Position = UDim2.new(0.845, 0, 0.175, 0)
ToolsToggleRspy.Size = UDim2.new(0, 111, 0, 32)
ToolsToggleRspy.Font = Enum.Font.SourceSans
ToolsToggleRspy.Text = "Toggle R-Spy"
ToolsToggleRspy.TextColor3 = ForegroundColor
ToolsToggleRspy.TextSize = 22

ToolsToggleRspy.MouseButton1Down:connect(function()
	if Rspy == true then 
		Rspy = false
		Settings["RemoteSpy"] = false
		writefile("AlphaOS/Settings.json", game:GetService('HttpService'):JSONEncode(Settings))
	elseif Rspy == false then
		Rspy = true
		Settings["RemoteSpy"] = true
		writefile("AlphaOS/Settings.json", game:GetService('HttpService'):JSONEncode(Settings))
	end
end)

ToolsMusicBox.Name = "ToolsMusicBox"
ToolsMusicBox.Parent = Tools
ToolsMusicBox.ZIndex = 8
ToolsMusicBox.MultiLine = false
ToolsMusicBox.ClearTextOnFocus = false
ToolsMusicBox.TextXAlignment = "Left"
ToolsMusicBox.TextYAlignment = "Top"
ToolsMusicBox.BackgroundColor3 = TextBoxColor
ToolsMusicBox.BorderColor3 = LineNumberColor
ToolsMusicBox.Position = UDim2.new(0.01, 0, 0.55, 0)
ToolsMusicBox.Size = UDim2.new(0.4, 0, 0.08, 0)
ToolsMusicBox.Font = Enum.Font.SourceSansLight
ToolsMusicBox.Text = ToolSaves["Current Song"]
ToolsMusicBox.TextColor3 = ForegroundColor
ToolsMusicBox.TextSize = 25
ToolsMusicBox.TextXAlignment = "Left"

ToolsMusicBox.Changed:Connect(function()
	ToolSaves["Current Song"] = ToolsMusicBox.Text
	writefile("AlphaOS/Tools.json", game:GetService('HttpService'):JSONEncode(ToolSaves))
end)

ToolsTeleBox.Name = "ToolsTeleBox"
ToolsTeleBox.Parent = Tools
ToolsTeleBox.ZIndex = 8
ToolsTeleBox.MultiLine = false
ToolsTeleBox.ClearTextOnFocus = false
ToolsTeleBox.TextXAlignment = "Left"
ToolsTeleBox.TextYAlignment = "Top"
ToolsTeleBox.BackgroundColor3 = TextBoxColor
ToolsTeleBox.BorderColor3 = LineNumberColor
ToolsTeleBox.Position = UDim2.new(0.428, 0, 0.55, 0)
ToolsTeleBox.Size = UDim2.new(0.4, 0, 0.08, 0)
ToolsTeleBox.Font = Enum.Font.SourceSansLight
ToolsTeleBox.Text = ToolSaves["Teleport ID"]
ToolsTeleBox.TextColor3 = ForegroundColor
ToolsTeleBox.TextSize = 25
ToolsTeleBox.TextXAlignment = "Left"

ToolsTeleBox.Changed:Connect(function()
	ToolSaves["Teleport ID"] = ToolsTeleBox.Text
	writefile("AlphaOS/Tools.json", game:GetService('HttpService'):JSONEncode(ToolSaves))
end)

ToolsTeleBtn.Name = "ToolsTeleBtn"
ToolsTeleBtn.Parent = Tools
ToolsTeleBtn.ZIndex = 8
ToolsTeleBtn.BackgroundColor3 = BackgroundColor
ToolsTeleBtn.BorderColor3 = BackgroundColor
ToolsTeleBtn.Position = UDim2.new(0.428, 0, 0.66, 0)
ToolsTeleBtn.Size = UDim2.new(0.195, 0, 0.08, 0)
ToolsTeleBtn.Font = Enum.Font.SourceSans
ToolsTeleBtn.Text = "Teleport"
ToolsTeleBtn.TextColor3 = ForegroundColor
ToolsTeleBtn.TextSize = 25

ToolsTeleBtn.MouseButton1Down:Connect(function() 
	game:GetService("TeleportService"):Teleport(tonumber(ToolsTeleBox.Text), game.Players.LocalPlayer)
end)

ToolsPlayBtn.Name = "ToolsPlayBtn"
ToolsPlayBtn.Parent = Tools
ToolsPlayBtn.ZIndex = 8
ToolsPlayBtn.BackgroundColor3 = BackgroundColor
ToolsPlayBtn.BorderColor3 = BackgroundColor
ToolsPlayBtn.Position = UDim2.new(0.01, 0, 0.66, 0)
ToolsPlayBtn.Size = UDim2.new(0.195, 0, 0.08, 0)
ToolsPlayBtn.Font = Enum.Font.SourceSans
ToolsPlayBtn.Text = "Play"
ToolsPlayBtn.TextColor3 = ForegroundColor
ToolsPlayBtn.TextSize = 25

ToolsPlayBtn.MouseButton1Down:Connect(function() 
	ToolSaves["Song Playing"] = true
	writefile("AlphaOS/Tools.json", game:GetService('HttpService'):JSONEncode(ToolSaves))
	
	BackgroundMusic:Resume()
end)

ToolsStopBtn.Name = "ToolsStopBtn"
ToolsStopBtn.Parent = Tools
ToolsStopBtn.ZIndex = 8
ToolsStopBtn.BackgroundColor3 = BackgroundColor
ToolsStopBtn.BorderColor3 = BackgroundColor
ToolsStopBtn.Position = UDim2.new(0.215, 0, 0.66, 0)
ToolsStopBtn.Size = UDim2.new(0.195, 0, 0.08, 0)
ToolsStopBtn.Font = Enum.Font.SourceSans
ToolsStopBtn.Text = "Stop"
ToolsStopBtn.TextColor3 = ForegroundColor
ToolsStopBtn.TextSize = 25

ToolsStopBtn.MouseButton1Down:Connect(function() 
	ToolSaves["Song Playing"] = false
	writefile("AlphaOS/Tools.json", game:GetService('HttpService'):JSONEncode(ToolSaves))
	
	BackgroundMusic:Pause()
end)

ToolsVolumeBox.Name = "ToolsVolumeBox"
ToolsVolumeBox.Parent = Tools
ToolsVolumeBox.ZIndex = 8
ToolsVolumeBox.MultiLine = false
ToolsVolumeBox.ClearTextOnFocus = false
ToolsVolumeBox.TextXAlignment = "Left"
ToolsVolumeBox.TextYAlignment = "Top"
ToolsVolumeBox.BackgroundColor3 = TextBoxColor
ToolsVolumeBox.BorderColor3 = LineNumberColor
ToolsVolumeBox.Position = UDim2.new(0.01, 0, 0.77, 0)
ToolsVolumeBox.Size = UDim2.new(0.4, 0, 0.08, 0)
ToolsVolumeBox.Font = Enum.Font.SourceSansLight
ToolsVolumeBox.Text = tostring(ToolSaves["Song Volume"])
ToolsVolumeBox.TextColor3 = ForegroundColor
ToolsVolumeBox.TextSize = 25
ToolsVolumeBox.TextXAlignment = "Left"

ToolsChangeBtn.Name = "ToolsChangeBtn"
ToolsChangeBtn.Parent = Tools
ToolsChangeBtn.ZIndex = 8
ToolsChangeBtn.BackgroundColor3 = BackgroundColor
ToolsChangeBtn.BorderColor3 = BackgroundColor
ToolsChangeBtn.Position = UDim2.new(0.01, 0, 0.89, 0)
ToolsChangeBtn.Size = UDim2.new(0.195, 0, 0.08, 0)
ToolsChangeBtn.Font = Enum.Font.SourceSans
ToolsChangeBtn.Text = "Change"
ToolsChangeBtn.TextColor3 = ForegroundColor
ToolsChangeBtn.TextSize = 25

ToolsChangeBtn.MouseButton1Down:Connect(function() 
	
	local SoundAsset = game:GetService("MarketplaceService"):GetProductInfo(tonumber(ToolsMusicBox.Text))

	BackgroundMusicText.Text = "Now Playing : " .. SoundAsset.Name
	
	BackgroundMusic:Stop()
	
	BackgroundMusic.Volume = ToolSaves["Song Volume"]
	BackgroundMusic.TimePosition = 0
	BackgroundMusic.PlaybackSpeed = 1
	BackgroundMusic.Pitch = 1
	BackgroundMusic.SoundId = "rbxassetid://" .. ToolsMusicBox.Text
	
	ToolSaves["Current Song"] = ToolsMusicBox.Text
	ToolSaves["Song Position"] = 0
	writefile("AlphaOS/Tools.json", game:GetService('HttpService'):JSONEncode(ToolSaves))
	
	BackgroundMusic:Play()
end)

ToolsSetBtn.Name = "ToolsSetBtn"
ToolsSetBtn.Parent = Tools
ToolsSetBtn.ZIndex = 8
ToolsSetBtn.BackgroundColor3 = BackgroundColor
ToolsSetBtn.BorderColor3 = BackgroundColor
ToolsSetBtn.Position = UDim2.new(0.215, 0, 0.89, 0)
ToolsSetBtn.Size = UDim2.new(0.195, 0, 0.08, 0)
ToolsSetBtn.Font = Enum.Font.SourceSans
ToolsSetBtn.Text = "Set to Volume"
ToolsSetBtn.TextColor3 = ForegroundColor
ToolsSetBtn.TextSize = 25

ToolsSetBtn.MouseButton1Down:Connect(function() 
	MusicVolume = tonumber(ToolsVolumeBox.Text)
	ToolSaves["Song Volume"] = tonumber(ToolsVolumeBox.Text)
	writefile("AlphaOS/Tools.json", game:GetService('HttpService'):JSONEncode(ToolSaves))
	
	BackgroundMusic.Volume = tonumber(ToolsVolumeBox.Text)
end)

if nl then
	local SoundAsset = game:GetService("MarketplaceService"):GetProductInfo(ToolSaves["Current Song"])
	BackgroundMusicText.Text = "Now Playing : " .. SoundAsset.Name

	BackgroundMusic:Stop()

	BackgroundMusic.Volume = ToolSaves["Song Volume"]
	BackgroundMusic.TimePosition = ToolSaves["Song Position"]
	BackgroundMusic.PlaybackSpeed = 1
	BackgroundMusic.Pitch = 1
	BackgroundMusic.SoundId = "rbxassetid://" .. ToolSaves["Current Song"]

	coroutine.resume(coroutine.create(function() 
		while wait(1) do
			ToolSaves["Song Position"] = BackgroundMusic.TimePosition
			
			writefile("AlphaOS/Tools.json", game:GetService('HttpService'):JSONEncode(ToolSaves))
		end
	end))

	if ToolSaves["Song Playing"] == true then
		BackgroundMusic:Play()
	end

	BackgroundMusicText.Visible = true
	BackgroundOSText.Visible = true

	game.Lighting:SetMinutesAfterMidnight(22 * 60)

	BackgroundMusicText.Visible = true
	BackgroundOSText.Visible = true
	BackgroundTint.Visible = true
	TaskBar.Visible = true
	Executer.Visible = true
	Console.Visible = true
	Files.Visible = true
	Tools.Visible = true

	MusicVolume = 3
else
	function PixelBlock(bonuspeed, FastSpeed, type, pos ,x1, y1 ,z1, value, color, outerpos) 
		local type = type
		
		local rng = Instance.new("Part", Character)
		rng.Anchored = true
		rng.BrickColor = color
		rng.CanCollide = false
		rng.FormFactor = 3
		rng.Name = "Ring"
		rng.Material = "Neon"
		rng.Size = Vector3.new(1, 1, 1)
		rng.Transparency = 0
		rng.TopSurface = 0
		rng.BottomSurface = 0
		rng.CFrame = pos
		rng.CFrame = rng.CFrame + rng.CFrame.lookVector*outerpos

		local rngm = Instance.new("SpecialMesh", rng)
		rngm.MeshType = "Brick"
		rngm.Scale = Vector3.new(x1,y1,z1)
		
		local scaler2 = 1
		local speeder = FastSpeed/10
		
		if type == "Add" then
			
			scaler2 = 1*value
			
		elseif type == "Divide" then
			
			scaler2 = 1/value
		end
		
		coroutine.resume(coroutine.create(function() 
			
			for i = 0,10 / bonuspeed,0.1 do
				
				RunService.Stepped:wait(0)
				
				if type == "Add" then
					
					scaler2 = scaler2 - 0.01*value/bonuspeed
					
				elseif type == "Divide" then
					
					scaler2 = scaler2 - 0.01/value*bonuspeed
				end
				
				speeder = speeder - 0.01*FastSpeed*bonuspeed/10
				
				rng.CFrame = rng.CFrame + rng.CFrame.lookVector*speeder*bonuspeed
				rngm.Scale = rngm.Scale - Vector3.new(scaler2*bonuspeed, scaler2*bonuspeed, scaler2*bonuspeed)
				
				-- rng.Transparency = rng.Transparency + 0.01*bonuspeed
			end
			
			rng:Destroy()
		end))
	end

	wait(1)

	local originalBarSize = LoadBar.Size
	local processList = {"Loading scripts..", "Loading datas..", "Loading guis..", "Loading console..", "Loading tools.."}

	LoadBar.Size = UDim2.new(0, 0, 0.005, 0)
	Loader.Transparency = 1
	Loader.Visible = true

	coroutine.resume(coroutine.create(function() 
		
		for i = 20,0,-1 do
			
			Loader.Transparency = i / 20
			
			wait()
		end
	end))

	BlockClick.Visible = false

	for i = 1, 5, 1 do
		
		LoaderProc.Text = processList[i]
		
		for j = 5, 50, 2 do
				
			LoadBar.Size = UDim2.new((j / 500), 0, 0.005, 0)
			
			wait()
		end
	end

	coroutine.resume(coroutine.create(function() 
		
		for i = 0,20,1 do
			
			Loader.Transparency = i / 20
			
			wait()
		end
		
		Loader.Visible = false
	end))

	wait(.5)

	Logon.Transparency = 1
	Logon.Visible = true

	coroutine.resume(coroutine.create(function() 
		
		for i = 20,0,-1 do
			
			Logon.Transparency = i / 40 + 0.5
			
			wait()
		end
	end))

	wait(1)

	local SoundAsset = game:GetService("MarketplaceService"):GetProductInfo(ToolSaves["Current Song"])

	BackgroundMusicText.Text = "Now Playing : " .. SoundAsset.Name

	BackgroundMusic:Stop()

	BackgroundMusic.Volume = ToolSaves["Song Volume"]
	BackgroundMusic.TimePosition = ToolSaves["Song Position"]
	BackgroundMusic.PlaybackSpeed = 1
	BackgroundMusic.Pitch = 1
	BackgroundMusic.SoundId = "rbxassetid://" .. ToolSaves["Current Song"]

	coroutine.resume(coroutine.create(function() 
		while wait(1) do
			ToolSaves["Song Position"] = BackgroundMusic.TimePosition
			
			writefile("AlphaOS/Tools.json", game:GetService('HttpService'):JSONEncode(ToolSaves))
		end
	end))

	if ToolSaves["Song Playing"] == true then
		BackgroundMusic:Play()
	end

	coroutine.resume(coroutine.create(function() 
		
		for i = 100,0,-1 do
			
			LogonWelcome.TextTransparency = i / 100
			
			wait()
		end
	end))

	LogonWelcome:TweenPosition(UDim2.new(0.42, 0, 0.46, 0), "Out", "Sine", .5, false)

	wait(3)

	LogonWelcome:TweenPosition(UDim2.new(0.42, 0, 0.35, 0), "Out", "Sine", .5, false)

	wait(.1)

	BackgroundMusicText.Visible = true
	BackgroundOSText.Visible = true
	LogonLogin.Visible = true

	game.Lighting:SetMinutesAfterMidnight(22 * 60)

	for i = 0, 49 do
		
		PixelBlock(1,math.random(1,20),"Add",RootPart.CFrame*CFrame.Angles(math.rad(math.random(-360,360)),math.rad(math.random(-360,360)),math.rad(math.random(-360,360))),2,2,2,0.04,BrickColor.new("White"),0)
	end

	coroutine.resume(coroutine.create(function() 
		
		for i = 20,0,-1 do
			
			LogonLogo.TextTransparency = i / 20
			LogonTitle.TextTransparency = i / 20
			LogonDesc.TextTransparency = i / 20
			
			wait()
		end
	end))

	repeat wait() until ToggleUi

	coroutine.resume(coroutine.create(function() 
		
		for i = 0,20,1 do
			
			LogonWelcome.TextTransparency = i / 20
			LogonLogo.TextTransparency = i / 20
			LogonTitle.TextTransparency = i / 20
			LogonDesc.TextTransparency = i / 20
			
			wait()
		end
		
		LogonLogin.Visible = false
	end))

	coroutine.resume(coroutine.create(function() 
		
		for i = 0,20,1 do
			
			Logon.Transparency = i / 40 + 0.5
			
			wait()
		end
		
		Logon.Visible = false
	end))

	wait(2)

	BackgroundMusicText.Visible = true

	wait(0.05)

	BackgroundOSText.Visible = true

	wait(0.05)

	BackgroundTint.Visible = true

	wait(0.05)

	TaskBar.Visible = true

	wait(0.05)

	Executer.Visible = true

	wait(0.05)

	Console.Visible = true

	wait(0.05)

	Files.Visible = true

	wait(0.05)

	Tools.Visible = true

	wait(0.05)

	MusicVolume = 3
end

Mouse.KeyDown:Connect(function(key) 
	
	if key == "=" and not ToggleUi then
		
		ToggleUi = true
		
		BlurFX.Size = 50
		
		BackgroundTint.Visible = true
		BackgroundTint.Size = UDim2.new(1, 0, 1.2, 0)
		BlockClick.Size = UDim2.new(1, 0, 1.2, 0)
		TaskBar.Visible = true
		BackgroundMusicText.Visible = true
		BackgroundOSText.Visible = true
		
		if ToggleExecuter then
			Executer.Visible = true
		end
		if ToggleConsole then
			Console.Visible = true
		end
		if ToggleFiles then
			Files.Visible = true
		end
		if ToggleTools then
			Tools.Visible = true
		end
		ExecuterPin.Visible = true
		ToolsPin.Visible = true
		ConsolePin.Visible = true
		FilesPin.Visible = true
		InjectButton.Visible = true
		
		BackgroundMusic.Volume = MusicVolume
		
		game.Lighting:SetMinutesAfterMidnight(22 * 60)
		
		game:GetService('StarterGui'):SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
		game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
		
	elseif key == "=" and ToggleUi then
		
		ToggleUi = false
		
		BlurFX.Size = 0
		
		BackgroundTint.Visible = false
		BackgroundTint.Size = UDim2.new(0, 0, 0, 0)
		BlockClick.Size = UDim2.new(0, 0, 0, 0)
		TaskBar.Visible = false
		BackgroundMusicText.Visible = false
		BackgroundOSText.Visible = false
		if not ExecuterPinned then
			Executer.Visible = false
		end
		if not ConsolePinned then
			Console.Visible = false
		end
		if not FilesPinned then
			Files.Visible = false
		end
		if not ToolsPinned then
			Tools.Visible = false
		end
		ExecuterPin.Visible = false
		ToolsPin.Visible = false
		ConsolePin.Visible = false
		FilesPin.Visible = false
		InjectButton.Visible = false
		
		BackgroundMusic.Volume = 1
		
		game.Lighting:SetMinutesAfterMidnight(14 * 60)
		
		game:GetService('StarterGui'):SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)
		game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
	end
end)