platforms = {}

platforms.data = {
    {
        img = love.graphics.newImage('assets/platform.png'),
        pos = geometry.makePoint(359, 434)
    },
    {
        img = love.graphics.newImage('assets/platform2.png'),
        pos = geometry.makePoint(644, 147)
    },
    {
        img = love.graphics.newImage('assets/platform3.png'),
        pos = geometry.makePoint(0, 219)
    },
}

function platforms:load()
    self.platforms = {}
    for i, data in ipairs(self.data) do
        self.platforms[i] = {
            img = data.img,
            rect = geometry.makeRect(data.pos.x, data.pos.y, data.img:getWidth(), data.img:getHeight())
        }
    end
end

function platforms:update(robots)
    for r,robot in ipairs(robots) do
        for p, platform in ipairs(self.platforms) do
            if robot.state == robot.states.grounded and robot.rect.y == platform.rect.y then
                if robot.rect.x+robot.rect.width*(1-robot.rect.pivotX) < platform.rect.x then
                    robot:changeState(robot.states.falling, robot.updateFalling)
                elseif robot.rect.x-robot.rect.width*robot.rect.pivotX > platform.rect.x+platform.rect.width then
                    robot:changeState(robot.states.falling, robot.updateFalling)
                end
            elseif geometry.overlappingRects(robot.rect, platform.rect) then
                if self:robotCollidingUp(robot, platform) then
                    robot.rect.y = platform.rect.y
                    robot.velocity.y = 0
                    robot:changeState(robot.states.grounded, robot.updateGrounded)
                elseif self:robotCollidingDown(robot, platform) then
                    robot.rect.y = platform.rect.y + platform.rect.height + robot.rect.height
                    robot.velocity.y = 0
                    robot:changeState(robot.states.falling, robot.updateFalling)
                elseif self:robotCollidingLeft(robot, platform) then
                    robot.velocity.x = 0
                    robot.rect.x = platform.rect.x-robot.rect.width*(1-robot.rect.pivotX)
                    if robot.state == robot.states.dashing then
                        robot:changeState(robot.states.falling, robot.updateFalling)
                    end
                elseif self:robotCollidingRight(robot, platform) then
                    robot.velocity.x = 0
                    robot.rect.x = platform.rect.x+platform.rect.width+robot.rect.width*robot.rect.pivotX
                    if robot.state == robot.states.dashing then
                        robot:changeState(robot.states.falling, robot.updateFalling)
                    end
                else
                    debug.log("Unknown collision detected")
                end
            end
        end
    end
end

function platforms:robotCollidingUp(robot, platform)
    return robot.rect.y > platform.rect.y and robot.previousPosition.y < platform.rect.y
end

function platforms:robotCollidingDown(robot, platform)
    return robot.rect.y-robot.rect.height < platform.rect.y+platform.rect.height and
           robot.previousPosition.y-robot.rect.height > platform.rect.y+platform.rect.height
end

function platforms:robotCollidingLeft(robot, platform)
    return robot.rect.x-robot.rect.width*robot.rect.pivotX < platform.rect.x
end

function platforms:robotCollidingRight(robot, platform)
    return robot.rect.x+robot.rect.width*(1-robot.rect.pivotX) > platform.rect.x + platform.rect.width
end

function platforms:draw()
    for i, platform in ipairs(self.platforms) do
        love.graphics.draw(platform.img, platform.rect.x, platform.rect.y)
    end
end


platforms:load()
