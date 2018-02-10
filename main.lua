require("scripts.utility.debug")
require("scripts.utility.measure")
require("scripts.utility.geometry")
require("scripts.utility.still_image")

local background = nil

function love.load(arg)
    background = still_image.new('background.png')

    current_scene = require("scripts.scenes.game_scene")
end

function love.update(dt)
    if current_scene ~= nil then
        current_scene:update()
    end
end

function love.draw(dt)
    background:draw()
    if current_scene ~= nil then
        current_scene:draw()
    end
end
