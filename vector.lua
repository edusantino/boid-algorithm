local Vector = {}
Vector.__index = Vector

function Vector:new(x, y)
    local self = setmetatable({}, Vector)
    self.x = x
    self.y = y
    return self
end

function Vector:normalized()
    local length = math.sqrt(self.x^2 + self.y^2)
    if length > 0 then
        return Vector:new(self.x / length, self.y / length)
    else
        return Vector:new(0, 0)
    end
end

function Vector:__add(v)
    return Vector:new(self.x + v.x, self.y + v.y)
end

function Vector:__sub(v)
    return Vector:new(self.x - v.x, self.y - v.y)
end

function Vector:__mul(scalar)
    return Vector:new(self.x * scalar, self.y * scalar)
end

function Vector:__div(scalar)
    return Vector:new(self.x / scalar, self.y / scalar)
end

function Vector:length()
    return math.sqrt(self.x^2 + self.y^2)
end

function Vector:distance(v)
    return math.sqrt((self.x - v.x)^2 + (self.y - v.y)^2)
end

return Vector