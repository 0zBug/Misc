return {
    new = function()
        local o = {}
        o.__index = o

        function o.new(...)
            local s = setmetatable({}, o)
            s:init(...)
            return s
        end

        return o
    end
}
