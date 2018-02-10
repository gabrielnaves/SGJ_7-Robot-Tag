-- Player-specific input
function newInputHandler(up, down, left, right, jump, dash)
    return {
        up = up,
        down = down,
        left = left,
        right = right,
        jump = jump,
        dash = dash,

        verticalAxis = function(self)
            local result = 0
            if love.keyboard.isDown(self.up) then result = result - 1 end
            if love.keyboard.isDown(self.down) then result = result + 1 end
            return result
        end,

        horizontalAxis = function(self)
            local result = 0
            if love.keyboard.isDown(self.left) then result = result - 1 end
            if love.keyboard.isDown(self.right) then result = result + 1 end
            return result
        end,

        jumpButton = false,
        jumpButtonDown = false,
        updateJump = function(self)
            local jump = love.keyboard.isDown(jump)
            if not self.jumpButton and jump then
                self.jumpButtonDown = true
            else
                self.jumpButtonDown = false
            end
            self.jumpButton = jump
        end,

        dashButton = false,
        dashButtonDown = false,
        updateDash = function(self)
            local dash = love.keyboard.isDown(dash)
            if not self.dashButton and dash then
                self.dashButtonDown = true
            else
                self.dashButtonDown = false
            end
            self.dashButton = dash
        end,

        update = function(self)
            self:updateJump()
            self:updateDash()
        end
    }
end

mouse = {}

-- Mouse input
mouse.mouseX = 0
mouse.mouseY = 0
mouse.mouseButton = false
mouse.mouseButtonDown = false

function mouse:update()
    local mouseDown = love.mouse.isDown(1)
    if mouseDown and not self.mouseButton then
        self.mouseButtonDown = true
    else
        self.mouseButtonDown = false
    end
    self.mouseButton = mouseDown
    self.mouseX = love.mouse.getX()
    self.mouseY = love.mouse.getY()
end
