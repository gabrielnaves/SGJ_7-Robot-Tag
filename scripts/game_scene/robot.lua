local robot = {}

robot.img = love.graphics.newImage('assets/robot.png')
robot.num_frames = 3
robot.frame_width = robot.img:getWidth() / robot.num_frames
robot.frame_height = robot.img:getHeight()
robot.body_quad = love.graphics.newQuad(0, 0, robot.frame_width, robot.frame_height, robot.img:getWidth(), robot.img:getHeight())
robot.arm_quad = love.graphics.newQuad(robot.frame_width, 0, robot.frame_width, robot.frame_height, robot.img:getWidth(), robot.img:getHeight())
robot.head_quad = love.graphics.newQuad(robot.frame_width*2, 0, robot.frame_width, robot.frame_height, robot.img:getWidth(), robot.img:getHeight())

robot.rect = geometry.makeRect(measure.screen_width/2, measure.screen_height-2, robot.frame_width, robot.frame_height, 0.5, 1)

function robot:load()

end

function robot:update(dt)
end

function robot:draw()
    local draw_x = self.rect.x - self.rect.width*self.rect.pivotX
    local draw_y = self.rect.y - self.rect.height*self.rect.pivotY
    love.graphics.draw(self.img, self.body_quad, draw_x, draw_y)
    love.graphics.draw(self.img, self.arm_quad, draw_x, draw_y)
    love.graphics.draw(self.img, self.head_quad, draw_x, draw_y)
end

return robot
