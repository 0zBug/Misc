
local Vector2 = {}

local Object = {}
Object.__index = Object

function Object.new()
end

function Object:Extend()
      local cls = {}
      for k, v in pairs(self) do
            if k:find("__") == 1 then
                  cls[k] = v
            end
      end
      
      cls.__index = cls
      cls.super = self
      setmetatable(cls, self)
      return cls
end

function Object:__call(...)
      local obj = setmetatable({}, self)
      obj:new(...)
      return obj
end

Vector2.new = Object:Extend()

local prot = {}
local metavector = {
    __newindex = function (t,i,v)
        t.Magnitude = math.sqrt(t.x * t.x + t.y * t.y)
        print(t.Magnitude)
    end,
    __add = function(a, b)
        return Vector2.new(a.x + b.x, a.y + b.y)
    end,
    __sub = function(a, b)
        return Vector2.new(a.x - b.x, a.y - b.y)
    end,
    __mul = function(a, b)
        if type(b) == "number" then
            return Vector2.new(a.x * b, a.y * b)
        else
            return Vector2.new(a.x * b.x, a.y * b.y)
        end
    end,
    __div = function(a, b)
        if type(b) == "number" then
            return Vector2.new(a.x / b, a.y / b)
        else
            return Vector2.new(a.x / b.x, a.y / b.y)
        end
    end,
    __eq = function(a, b)
        return a.x == b.x and a.y == b.y
    end
}

function Vector2.new:new(x, y)
    self.x = x or 0
    self.X = x or 0
    self.y = y or 0
    self.Y = y or 0
    self.Magnitude =  math.sqrt(self.x * self.x + self.y * self.y)

    setmetatable(self, metavector)

    return self
end

Vector2.zero = Vector2.new(0, 0)
Vector2.one = Vector2.new(1, 1)
Vector2.xAxis = Vector2.new(1, 0)
Vector2.yAxis = Vector2.new(0, 1)

function Vector2:Lerp(self, b, t)
      return Vector2.new(self.x + (b.x - self.x) * t, self.y + (b.y - self.y) * t)
end

return Vector2
