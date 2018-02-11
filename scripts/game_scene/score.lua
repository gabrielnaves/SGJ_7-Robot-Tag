score = {}

score.scores = {
    {
        tag_time = 0,
        color = { 65, 150, 220 },
        pos = geometry.makePoint(measure.screen_width/5, 20),
    },
    {
        tag_time = 0,
        color = { 240, 75, 54 },
        pos = geometry.makePoint(2 * measure.screen_width/5, 20),
    },
    {
        tag_time = 0,
        color = { 59, 246, 83 },
        pos = geometry.makePoint(3 * measure.screen_width/5, 20),
    },
    {
        tag_time = 0,
        color = { 240, 120, 215 },
        pos = geometry.makePoint(4 * measure.screen_width/5, 20),
    }
}

score.time = 10
score.timer = score.time

function score:update(dt)
    if current_scene == nil then return end
    if current_scene.name ~= 'game' then return end
    for i, score in ipairs(self.scores) do
        if i > player_amount then break end
        if current_scene.robots[i].tagged then
            score.tag_time = score.tag_time + dt
        end
    end
    self.timer = self.timer - dt
    if self.timer < 0 then
        current_scene:restart()
        current_scene = require('scripts.scenes.end_scene')
    end
end

function score:draw()
    for i, score in ipairs(self.scores) do
        if i > player_amount then break end
        local text = tostring(math.floor(score.tag_time))
        local draw_x = math.floor(score.pos.x - font:getWidth(text) / 2)
        love.graphics.print({score.color, text}, draw_x, score.pos.y)
    end
    self:drawGameTime()
end

function score:drawGameTime()
    local text = tostring(math.floor(self.timer))
    local draw_x = measure.screen_width/2 - font:getWidth(text)
    love.graphics.print({{255, 255, 255}, text}, draw_x, 10, 0, 2, 2)
end

function score:restart()
    self.timer = self.time
    for i, score in ipairs(self.scores) do
        score.tag_time = 0
    end
end
