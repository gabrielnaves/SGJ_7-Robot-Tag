local robot = {}

-- Image data
robot.img = love.graphics.newImage('assets/robot.png')
robot.num_frames = 2
robot.frame_width = robot.img:getWidth() / robot.num_frames
robot.frame_height = robot.img:getHeight()
robot.frames = {
    love.graphics.newQuad(0, 0, robot.frame_width, robot.frame_height, robot.img:getWidth(), robot.img:getHeight()),
    love.graphics.newQuad(robot.frame_width, 0, robot.frame_width, robot.frame_height, robot.img:getWidth(), robot.img:getHeight()),
}
robot.flip = false

-- Motion data
robot.rect = geometry.makeRect(measure.screen_width/2, measure.screen_height-2, robot.frame_width, robot.frame_height, 0.5, 1)
robot.gravity = 100
robot.max_speed = 400
robot.offset_bound = 20
robot.velocity = geometry.makePoint(0, 0)
robot.acceleration = geometry.makePoint(1000, 0)
robot.mov_decay = 0.75

function robot:update(dt)
    self:updateVelocity(dt)
    self:updatePosition(dt)
    self:updateFlip(dt)
end

function robot:updateVelocity(dt)
    local acc = self.input:horizontalAxis() * self.acceleration.x
    if (acc > 0 and self.velocity.x > 0) or (acc < 0 and self.velocity.x < 0) then
        self.velocity.x = self.velocity.x + acc * dt
    elseif acc ~= 0 then
        self.velocity.x = self.velocity.x * self.mov_decay
        self.velocity.x = self.velocity.x + acc * dt
    else
        self.velocity.x = self.velocity.x * self.mov_decay
    end
    self.velocity.x = self.velocity.x + dt * acc
    self.velocity.x = gamemath.clamp(self.velocity.x, self.max_speed, -self.max_speed)
end

function robot:updatePosition(dt)
    self.rect.x = self.rect.x + self.velocity.x * dt
    self.rect.y = self.rect.y + self.velocity.y * dt
    if self.rect.x < self.offset_bound then
        self.rect.x = self.offset_bound
        self.velocity.x = 0
    end
    if self.rect.x > measure.screen_width - self.offset_bound then
        self.rect.x = measure.screen_width - self.offset_bound
        self.velocity.x = 0
    end
end

function robot:updateFlip(dt)
    if self.velocity.x > 0 then
        self.flip = false
    elseif self.velocity.x < 0 then
        self.flip = true
    end
end

function robot:draw()
    local draw_x = self.rect.x - self.rect.width*self.rect.pivotX
    local draw_y = self.rect.y - self.rect.height*self.rect.pivotY
    local frame = 1
    if self.flip then frame = 2 end
    love.graphics.draw(self.img, self.frames[frame], draw_x, draw_y)
end

return robot
