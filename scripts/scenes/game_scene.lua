require("scripts.game_scene.robot_bulb")
require("scripts.game_scene.tag_mark")
require("scripts.game_scene.score")

local game_scene = {}

game_scene.name = 'game'
game_scene.robot_data = {
    {
        img = 'assets/robot_blue.png',
        x = measure.screen_width/4,
        y = measure.screen_height-4,
        input = newInputHandler('w', 's', 'a', 'd', 'space', 'lshift'),
        flip = false
    },
    {
        img = 'assets/robot_red.png',
        x = 3*measure.screen_width/4,
        y = measure.screen_height-4,
        input = newInputHandler('up', 'down', 'left', 'right', 'l', 'k'),
        flip = true
    }
}

function game_scene:load()
    self.robot_count = 0
    self.robots = {}
    for i, data in ipairs(self.robot_data) do
        self.robots[i] = require('scripts.game_scene.robot')
        self.robots[i]:load(data.img, data.x, data.y)
        self.robots[i].input = data.input
        self.robots[i].flip = data.flip
        package.loaded['scripts.game_scene.robot'] = nil
        self.robot_count = self.robot_count + 1
    end
    self.tagged_robot = love.math.random(1, self.robot_count)
    self.robots[self.tagged_robot].tagged = true
end

function game_scene:update(dt)
    score:update(dt)
    for i, robot in ipairs(self.robots) do
        robot:update(dt)
    end
    tag_mark:update(dt)
end

function game_scene:draw(dt)
    for i, robot in ipairs(self.robots) do
        robot:draw(dt)
    end
    score:draw()
end

function game_scene:restart()
end


game_scene:load()
return game_scene
