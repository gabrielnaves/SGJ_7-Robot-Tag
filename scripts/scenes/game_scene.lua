local game_scene = {}

game_scene.name = 'game'

function game_scene:load()
    self.robot = require('scripts.game_scene.robot')
    self.robot.input = newInputHandler('w', 's', 'a', 'd')
end

function game_scene:update(dt)
    self.robot:update(dt)
end

function game_scene:draw(dt)
    self.robot:draw()
end

function game_scene:restart()
end


game_scene:load()
return game_scene
