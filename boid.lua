Boid = {}
Boid.__index = Boid

local Vector = require("vector")

function Boid:new(x, y)
    self = setmetatable({}, Boid)
    
    self.acceleration = Vector:new(0, 0)
    local angle = math.random(0, 2 * math.pi)
    self.velocity = Vector:new(math.cos(angle), math.sin(angle))
    self.position = Vector:new(x, y)
    self.r = 2.0
    self.maxSpeed = 2
    self.maxForce = 0.03
    return self
end

function Boid:run(boids)
    self:flock(boids)
    self:update()
    self:borders()
    self:render()
end

function Boid:applyForce(force)
    self.acceleration = self.acceleration + force
end

function Boid:flock(boids)
    local sep = self:separate(boids)
    local ali = self:align(boids)
    local coh = self:cohesion(boids)

    sep = sep * 1.5
    ali = ali * 1.0
    coh = coh * 1.0

    self:applyForce(sep)
    self:applyForce(ali)
    self:applyForce(coh)
end

function Boid:update()
    self.velocity = self.velocity + self.acceleration
    -- Speed limit
    if self.velocity:length() > self.maxSpeed then
        self.velocity = self.velocity:normalized() * self.maxSpeed
    end
    self.position = self.position + self.velocity
    self.acceleration = self.acceleration * 0
end

function Boid:seek(target)
    local desired = target - self.position
    desired = desired:normalized() * self.maxSpeed
    local steer = desired - self.velocity
    if steer:length() > self.maxForce then
        steer = steer:normalized() * self.maxForce
    end
    return steer
end

function Boid:render()
    local theta = math.atan2(self.velocity.y, self.velocity.x) + math.pi/2
    
    love.graphics.push()
    love.graphics.translate(self.position.x, self.position.y)
    love.graphics.rotate(theta)
    
    love.graphics.setColor(0.8, 0.8, 0.8, 1)
    love.graphics.polygon("fill", 
        0, -self.r*2,
        -self.r, self.r*2,
        self.r, self.r*2
    )
    
    love.graphics.pop()
end

function Boid:borders()
    local width, height = love.graphics.getDimensions()
    
    if self.position.x < -self.r then self.position.x = width + self.r end
    if self.position.y < -self.r then self.position.y = height + self.r end
    if self.position.x > width + self.r then self.position.x = -self.r end
    if self.position.y > height + self.r then self.position.y = -self.r end
end

function Boid:separate(boids)
    local desiredseparation = 25.0
    local steer = Vector:new(0, 0)
    local count = 0
    
    for _, other in ipairs(boids) do
        local d = self.position:distance(other.position)
        if (d > 0) and (d < desiredseparation) then
            local diff = self.position - other.position
            diff = diff:normalized()
            diff = diff / d
            steer = steer + diff
            count = count + 1
        end
    end
    
    if count > 0 then
        steer = steer / count
    end
    
    if steer:length() > 0 then
        steer = steer:normalized() * self.maxSpeed
        steer = steer - self.velocity
        if steer:length() > self.maxForce then
            steer = steer:normalized() * self.maxForce
        end
    end
    
    return steer
end

function Boid:align(boids)
    local neighbordist = 50
    local sum = Vector:new(0, 0)
    local count = 0
    
    for _, other in ipairs(boids) do
        local d = self.position:distance(other.position)
        if (d > 0) and (d < neighbordist) then
            sum = sum + other.velocity
            count = count + 1
        end
    end
    
    if count > 0 then
        sum = sum / count
        sum = sum:normalized() * self.maxSpeed
        local steer = sum - self.velocity
        if steer:length() > self.maxForce then
            steer = steer:normalized() * self.maxForce
        end
        return steer
    else
        return Vector:new(0, 0)
    end
end

function Boid:cohesion(boids)
    local neighbordist = 50
    local sum = Vector:new(0, 0)
    local count = 0
    
    for _, other in ipairs(boids) do
        local d = self.position:distance(other.position)
        if (d > 0) and (d < neighbordist) then
            sum = sum + other.position
            count = count + 1
        end
    end
    
    if count > 0 then
        sum = sum / count
        return self:seek(sum)
    else
        return Vector:new(0, 0)
    end
end

return Boid