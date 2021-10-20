--[[
    RawSignal by csqrl (ClockworkSquirrel)
    Version: 0.0.2
    License: MIT
    Originally uploaded to Dcoder.
    Documentation:
        Signal:
            Methods:
                Signal.new(): RawSignal
        RawSignal:
            Methods:
                RawSignal:Connect(Callback: function): DisconnectionTable
                RawSignal:Fire(...): void
                RawSignal:Destroy(): void
        DisconnectionTable:
            Methods:
                DisconnectionTable:Disconnect(): void
--]]

local Signal = {}

Signal.__index = Signal

function Signal.new()
    local self = setmetatable({}, Signal)
    
    self.__callbackInt = 0
    self.__callbacks = {}

    return self
end

function Signal:Connect(Callback)
    if self._destroyed then
       error("Signal has been destroyed", 2) 
    end
    
    local this = self

    this.__callbackInt = this.__callbackInt + 1
    
    local CallbackId = tostring(this.__callbackInt)
    this.__callbacks[CallbackId] = Callback

    return {
        Disconnect = function()
            this.__callbacks[CallbackId] = nil
        end
    }
end

function Signal:Fire(...)
    if self._destroyed then
        error("Signal has been destroyed", 2)
    end
    
    for _, callback in next, self.__callbacks do
        coroutine.wrap(callback)(...)
    end
end

function Signal:Destroy()
    self._destroyed = true
    
    for key, _ in next, self.__callbacks do
        self.__callbacks[key] = nil
    end

    for key, _ in pairs(self) do
        self[key] = nil
    end
end

return Signal
