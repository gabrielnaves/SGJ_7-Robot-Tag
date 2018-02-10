require("scripts.game_scene.robot_bulb")

local game_scene = {}

game_scene.name = 'game'

function game_scene:load()
    self.blue_robot = require('scripts.game_scene.robot')
    self.blue_robot:load('assets/robot_blue.png', measure.screen_width/4, measure.screen_height-4)
    self.blue_robot.input = newInputHandler('w', 's', 'a', 'd', 'space', 'lshift')
    package.loaded['scripts.game_scene.robot'] = nil
    self.red_robot = require('scripts.game_scene.robot')
    self.red_robot:load('assets/robot_red.png', 3*measure.screen_width/4, measure.screen_height-4)
    self.red_robot.flip = true
    self.red_robot.input = newInputHandler('up', 'down', 'left', 'right', 'l', 'k')
end

function game_scene:update(dt)
    self.blue_robot:update(dt)
    self.red_robot:update(dt)
end

function game_scene:draw(dt)
    self.blue_robot:draw()
    self.red_robot:draw()
end

function game_scene:restart()
end


game_scene:load()
return game_scene
