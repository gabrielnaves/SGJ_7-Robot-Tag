local robot = {}

function robot:load(robot_image, x, y)
    -- Image data
    self.img = love.graphics.newImage(robot_image)
    self.num_frames = 4
    self.frame_width = self.img:getWidth() / self.num_frames
    self.frame_height = self.img:getHeight()
    self.frames = {
        love.graphics.newQuad(self.frame_width*0, 0, self.frame_width, self.frame_height, self.img:getWidth(), self.img:getHeight()),
        love.graphics.newQuad(self.frame_width*1, 0, self.frame_width, self.frame_height, self.img:getWidth(), self.img:getHeight()),
        love.graphics.newQuad(self.frame_width*2, 0, self.frame_width, self.frame_height, self.img:getWidth(), self.img:getHeight()),
        love.graphics.newQuad(self.frame_width*3, 0, self.frame_width, self.frame_height, self.img:getWidth(), self.img:getHeight()),
    }
    self.flip = false

    -- Motion data
    self.rect = geometry.makeRect(x, y, self.frame_width-6, self.frame_height, 0.5, 1)
    self.previousPosition = geometry.makePoint(x, y)
    self.gravity = 4000
    self.max_speed = 400
    self.offset_bound = 20
    self.velocity = geometry.makePoint(0, 0)
    self.acceleration = geometry.makePoint(1000, 0)
    self.mov_decay = 0.75
    self.double_jump = true
    self.dashDirection = nil
    self.dashSpeed = 1000

    -- State data
    self.states = {
        grounded = 'grounded',
        ascending = 'ascending',
        falling = 'falling',
        dashing = 'dashing'
    }
    self.state = nil
    self.updateFunction = nil

    -- Timers
    self.ascendTime = 0.1
    self.ascendTimer = 0
    self.dashCooldown = 1.5
    self.dashDuration = 0.25
    self.dashTimer = 2

    -- Tag
    self.tagged = false
    self.tagTime = 1
    self.tagTimer = 0

    self:changeState(self.states.grounded, self.updateGrounded)
end

function robot:changeState(state, updateFunction)
    if state == self.states.grounded then
        self.double_jump = true
    end
    self.state = state
    self.updateFunction = updateFunction
    self.ascendTimer = 0
end

function robot:update(dt)
    self.input:update()
    self:checkDash(dt)
    self:updateFunction(dt)
    self:updateBasicMotion(dt)
    self:updateTag(dt)
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
        self:changeState(self.states.grounded, self.updateGrounded)
    elseif self.rect.y - self.rect.height < 0 then
        self.rect.y = self.rect.height
        self.velocity.y = 0
        self:changeState(self.states.falling, self.updateFalling)
    end
end

function robot:updateFlip(dt)
    if self.velocity.x > 0 then
        self.flip = false
    elseif self.velocity.x < 0 then
        self.flip = true
    end
end

function robot:updateTag(dt)
    if not self.tagged then return end
    if current_scene == nil then return end
    if current_scene.name ~= 'game' then return end

    self.tagTimer = self.tagTimer + dt
    if self.tagTimer > self.tagTime then
        for i, robot in ipairs(current_scene.robots) do
            if robot ~= self then
                if geometry.overlappingRects(robot.rect, self.rect) then
                    robot.tagged = true
                    self.tagged = false
                    self.tagTimer = 0
                    return
                end
            end
        end
    end
end

function robot:lateUpdate(dt)
    self.previousPosition.x = self.rect.x
    self.previousPosition.y = self.rect.y
end

function robot:draw()
    local draw_x = math.floor(self.rect.x - self.frame_width / 2)
    local draw_y = math.floor(self.rect.y - self.frame_height)
    local frame = 1

    if self.input:horizontalAxis() ~= 0 then frame = 2 end
    if self.flip then frame = frame + self.num_frames/2 end

    self:drawTag()
    self:drawBulb(frame, draw_x, draw_y)
    love.graphics.draw(self.img, self.frames[frame], draw_x, draw_y)
    -- love.graphics.print({{255, 255, 255}, tostring(self.state)}, draw_x, draw_y - 25)
end

function robot:drawBulb(frame, x, y)
    if self.state == self.states.dashing then
        frame = frame + 4
    elseif self.dashTimer >= self.dashCooldown then
        frame = frame + 4
    end
    robot_bulb.draw(frame, x, y)
end

function robot:drawTag()
    if self.tagged then
        tag_mark:setPosition(self.rect.x, self.rect.y - 60)
        tag_mark:draw()
    end
end

return robot
