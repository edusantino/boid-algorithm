local Boid = require("components.boid")

local Flock = require("components.flock")
local flock

local constants = require("config.constants")
local config = require("config.config")

function love.load()
    love.window.setMode(config.width, config.height)
    love.graphics.setBackgroundColor(0.2, 0.2, 0.2)
    
    flock = Flock:new()
    
    local width, height = love.graphics.getDimensions()
    for i = 1, constants.init_flock_numbers do
        flock:addBoid(Boid:new(width/2, height/2))
    end
end

function love.update(dt)

end

function love.draw()
    love.graphics.clear(love.graphics.getBackgroundColor())
    flock:run()
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        flock:addBoid(Boid:new(x, y))
    end
end