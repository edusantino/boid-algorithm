Flock = {}
Flock.__index = Flock

function Flock:new()
    local obj = {
        boids = {}
    }
    setmetatable(obj, Flock)
    return obj
end

function Flock:run()
    for _, b in ipairs(self.boids) do
        b:run(self.boids)
    end
end

function Flock:addBoid(b)
    table.insert(self.boids, b)
end

return Flock