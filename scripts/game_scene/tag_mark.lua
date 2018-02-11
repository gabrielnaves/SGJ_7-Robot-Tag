tag_mark = {}

tag_mark.begin = still_animation.new('skull_begin.png', 6, 0.015, 0, 0, 0.5, 1)
tag_mark.loop = still_animation.new('skull_loop.png', 12, 0.015, 0, 0, 0.5, 1)
tag_mark.beginning = true

function tag_mark:setPosition(x, y)
    self.begin.x = x
    self.begin.y = y
    self.loop.x = x
    self.loop.y = y
end

function tag_mark:update(dt)
    if self.beginning then
        self.begin:update(dt)
    else
        self.loop:update(dt)
    end
end

function tag_mark:draw()
    if self.beginning then
        self.begin:draw()
        if self.begin.current_frame == self.begin.frame_count then
            self.beginning = false
        end
    else
        self.loop:draw()
    end
end

function tag_mark:restart()
    self.beginning = true
    self.begin:restartAnimation()
    self.loop:restartAnimation()
end

return tag_mark
