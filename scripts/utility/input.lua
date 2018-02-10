-- Player-specific input
function newInputHandler(up, down, left, right, jump)
    return {
        up = up,
        down = down,
        left = left,
        right = right,
        jump = jump,

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
        update = function(self)
            local jump = love.keyboard.isDown(jump)
            if not self.jumpButton and jump then
                self.jumpButtonDown = true
            else
                self.jumpButtonDown = false
            end
            self.jumpButton = jump
        end,
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
