
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local MailBox = "Mail/" .. LocalPlayer.Name

getgenv().BotController = {
    Connections = {},
    Connect = function(self, f)
        table.insert(self.Connections, f)
    end,
    Disconnect = function(self)
        table.clear(self.Connections)
    end,
    Fire = function(self, ...)
        for _,f in pairs(self.Connections) do
            f(...)
        end
    end
}

if not isfolder("Mail") then makefolder("Mail") end
if not isfolder(MailBox) then makefolder(MailBox) end

BotController:Connect(function(Code, Bots)
    if Bots and #Bots > 0 then    
        for _, Bot in next, Bots do
            if not isfolder("Mail/" .. Bot) then
                warn(string.format("%s not found on network.", Bot))
            end

            writefile("Mail/" .. Bot .. "/" .. HttpService:GenerateGUID(false) .. ".mail", Code)
        end
    else
        for _, Bot in pairs(listfiles("Mail")) do
            writefile("Mail/" .. string.sub(Bot, 5, #Bot) .. "/" .. HttpService:GenerateGUID(false) .. ".mail", Code)
        end
    end
end)

RunService.RenderStepped:Connect(function()
    for _, Mail in pairs(listfiles(MailBox)) do
        loadfile(Mail)()
        delfile(Mail)
    end
end)
