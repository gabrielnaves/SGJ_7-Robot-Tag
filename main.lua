require("scripts.utility.debug")
require("scripts.utility.measure")
require("scripts.utility.gamemath")
require("scripts.utility.geometry")
require("scripts.utility.still_image")
require("scripts.utility.still_animation")
require("scripts.utility.input")

local background = nil

function love.load(arg)
    background = still_image.new('background.png')

    current_scene = require("scripts.scenes.game_scene")
end

function love.update(dt)
    mouse:update()
    if current_scene ~= nil then
        current_scene:update(dt)
    end
end

function love.draw()
    background:draw()
    if current_scene ~= nil then
        current_scene:draw()
    end
end
