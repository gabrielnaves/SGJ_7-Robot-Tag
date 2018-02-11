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
        pos = geometry.makePoint(4 * measure.screen_width/5, 20),
    }
}

function score:update(dt)
    if current_scene == nil then return end
    if current_scene.name ~= 'game' then return end
    for i, score in ipairs(self.scores) do
        if current_scene.robots[i].tagged then
            score.tag_time = score.tag_time + dt
        end
    end
end

function score:draw()
    for i, score in ipairs(self.scores) do
        local text = tostring(math.floor(score.tag_time))
        local draw_x = math.floor(score.pos.x - font:getWidth(text) / 2)
        love.graphics.print({score.color, text}, draw_x, score.pos.y)
    end
end
