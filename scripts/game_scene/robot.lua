local robot = {}

-- Image data
robot.img = love.graphics.newImage('assets/robot_blue.png')
robot.num_frames = 4
robot.frame_width = robot.img:getWidth() / robot.num_frames
robot.frame_height = robot.img:getHeight()
robot.frames = {
    love.graphics.newQuad(robot.frame_width*0, 0, robot.frame_width, robot.frame_height, robot.img:getWidth(), robot.img:getHeight()),
    love.graphics.newQuad(robot.frame_width*1, 0, robot.frame_width, robot.frame_height, robot.img:getWidth(), robot.img:getHeight()),
    love.graphics.newQuad(robot.frame_width*2, 0, robot.frame_width, robot.frame_height, robot.img:getWidth(), robot.img:getHeight()),
    love.graphics.newQuad(robot.frame_width*3, 0, robot.frame_width, robot.frame_height, robot.img:getWidth(), robot.img:getHeight()),
}
robot.flip = false

-- Motion data
robot.rect = geometry.makeRect(measure.screen_width/2, measure.screen_height-4, robot.frame_width, robot.frame_height, 0.5, 1)
robot.gravity = 4000
robot.max_speed = 400
robot.offset_bound = 20
robot.velocity = geometry.makePoint(0, 0)
robot.acceleration = geometry.makePoint(1000, 0)
robot.mov_decay = 0.75
robot.double_jump = true
robot.dashDirection = nil
robot.dashSpeed = 1000

-- State data
robot.states = {
    grounded = 'grounded',
    ascending = 'ascending',
    falling = 'falling',
    dashing = 'dashing'
}
robot.state = nil
robot.updateFunction = nil

-- Timers
robot.ascendTime = 0.1
robot.ascendTimer = 0
robot.dashCooldown = 1.5
robot.dashDuration = 0.25
robot.dashTimer = 2

function robot:load()
    self:changeState(self.states.grounded, self.updateGrounded)
end

function robot:changeState(state, updateFunction)
    self.state = state
    self.updateFunction = updateFunction
    self.ascendTimer = 0
end

function robot:update(dt)
    self.input:update()
    self:checkDash(dt)
    self:updateFunction(dt)
    self:updateBasicMotion(dt)
end

function robot:checkDash(dt)
    if self.state ~= self.states.dashing then
        self.dashTimer = self.dashTimer + dt
        if self.input.dashButtonDown and self.dashTimer > self.dashCooldown then
            self.dashTimer = 0
            self.dashDirection = geometry.makePoint(self.input:horizontalAxis(), self.input:verticalAxis())
            self.velocity = geometry.makePoint(0, 0)
            self:changeState(self.states.dashing, self.updateDashing)
        end
    end
end

function robot:updateGrounded(dt)
    if self.input.jumpButtonDown then
        self.velocity.y = -1000
        self:changeState(self.states.ascending, self.updateAscending)
    end
end

function robot:updateAscending(dt)
    self.ascendTimer = self.ascendTimer + dt
    if self.ascendTimer >= self.ascendTime or not self.input.jumpButton then
        self.velocity.y = self.velocity.y / 2
        self:changeState(self.states.falling, self.updateFalling)
    end
end

function robot:updateFalling(dt)
    self.velocity.y = self.velocity.y + self.gravity * dt
    if self.double_jump and self.input.jumpButtonDown then
        self.velocity.y = -1000
        self.double_jump = false
        self:changeState(self.states.ascending, self.updateAscending)
    end
end

function robot:updateDashing(dt)
    self.velocity.x = self.dashSpeed * self.dashDirection.x
    self.velocity.y = self.dashSpeed * self.dashDirection.y
    self.dashTimer = self.dashTimer + dt
    if self.dashTimer >= self.dashDuration then
        self.dashTimer = 0
        self.velocity.y = self.velocity.y / 2
        self:changeState(self.states.falling, self.updateFalling)
    end
end

function robot:updateBasicMotion(dt)
    self:updateHorizontalVelocity(dt)
    self:updatePosition(dt)
    self:updateFlip(dt)
end

function robot:updateHorizontalVelocity(dt)
    if self.state ~= self.states.dashing then
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
    if self.rect.y > measure.screen_height then
        self.rect.y = measure.screen_height - 4
        self.velocity.y = 0
        self.double_jump = true
        self:changeState(self.states.grounded, self.updateGrounded)
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
    local draw_x = math.floor(self.rect.x - self.rect.width*self.rect.pivotX)
    local draw_y = math.floor(self.rect.y - self.rect.height*self.rect.pivotY)
    local frame = 1
    if self.input:horizontalAxis() ~= 0 then frame = 2 end
    if self.flip then frame = frame + self.num_frames/2 end
    love.graphics.draw(self.img, self.frames[frame], draw_x, draw_y)
    self:drawBulb(frame, draw_x, draw_y)
    love.graphics.print({{0, 0, 0},tostring(self.state)}, draw_x, draw_y - 25)
end

function robot:drawBulb(frame, x, y)
    if self.state == self.states.dashing then
        frame = frame + 4
    elseif self.dashTimer >= self.dashCooldown then
        frame = frame + 4
    end
    robot_bulb.draw(frame, x, y)
end


robot:load()
return robot
