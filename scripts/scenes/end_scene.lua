local end_scene = {}

end_scene.name = 'end'

end_scene.text_color = { 255, 255, 255 }

function end_scene:update(dt)
    if mouse.mouseButtonDown then
        current_scene = require ('scripts.scenes.menu_scene')
        score:restart()
    end
end

function end_scene:draw()
    local winner = nil
    local minScore = 999999
    for i=1,player_amount do
        if score.scores[i].tag_time < minScore then
            winner = i
            minScore = score.scores[i].tag_time
        end
    end
    local text1 = "Player " .. winner .. " wins!"
    text_printing.printCentered(text1, self.text_color, measure.screen_width/2, measure.screen_height/2-40, 4)

    minScore = math.floor(minScore * 100) / 100
    local text2 = "Player " .. winner .. " tagged time: " .. minScore
    text_printing.printCentered(text2, self.text_color, measure.screen_width/2, measure.screen_height/2+60, 2)

    local text3 = "click anywhere to continue..."
    text_printing.printCentered(text3, self.text_color, measure.screen_width/2, measure.screen_height-50, 1)
end

return end_scene
