
local Origin = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2  - (game:GetService("GuiService"):GetGuiInset().Y/2))
local Second = os.date("%S", os.time())
local Minute = os.date("%M", os.time())
local Hour = os.date("%I", os.time())

local Fill = Drawing.new("Circle")
Fill.Color = Color3.new(1, 1, 1)
Fill.Radius = 68
Fill.Thickness = 5
Fill.Position = Origin
Fill.Visible = true
Fill.Filled = true

local Border = Drawing.new("Circle")
Border.Radius = 68
Border.Thickness = 5
Border.Position = Origin
Border.Visible = true

for i = 0, 11 do
    local Tick = Drawing.new("Line")
    if i % 3 == 0 then
        Tick.Thickness = 2
    else
        Tick.Thickness = 1
    end
    Tick.From = Origin + Vector2.new(math.sin(i*30*math.pi/180)*50, math.cos(i*30*math.pi/180)*-50)
    Tick.To = Origin + Vector2.new(math.sin(i*30*math.pi/180)*60, math.cos(i*30*math.pi/180)*-60)
    Tick.Visible = true
end

local SecondLine = Drawing.new("Line")
SecondLine.Color = Color3.new(1, 0, 0)
SecondLine.From = Origin
SecondLine.Visible = true

local MinuteLine = Drawing.new("Line")
MinuteLine.Thickness = 1.5
MinuteLine.From = Origin
MinuteLine.Visible = true

local HourLine = Drawing.new("Line")
HourLine.Thickness = 2
HourLine.From = Origin
HourLine.Visible = true

game:GetService("RunService").RenderStepped:Connect(function()
    Second = os.date("%S", os.time())
    Minute = os.date("%M", os.time())
    Hour = os.date("%I", os.time())

    SecondLine.To = Origin + Vector2.new(math.sin(Second*6*math.pi/180)*60, math.cos(Second*6*math.pi/180)*-60)
    MinuteLine.To = Origin + Vector2.new(math.sin(Minute*6*math.pi/180)*50, math.cos(Minute*6*math.pi/180)*-50)
    HourLine.To = Origin + Vector2.new(math.sin(Hour*30*math.pi/180)*30, math.cos(Hour*30*math.pi/180)*-30)
end)
