local menu_scene = {}

menu_scene.name = 'menu'

menu_scene.text_color = { 255, 255, 255 }
menu_scene.text_info = {
    {
        text = "Robot Tag",
        height = 15,
        scale = 4,
    },
    {
        text = "a game by Gabriel Naves",
        height = 100,
        scale = 1,
    },
    {
        text = "Player amount:",
        height = measure.screen_height / 2 - 60,
        scale = 1,
    }
}

menu_scene.player_input_texts = {
    "Player 1 buttons.:  Movement: WASD, Jump: space, Dash: left shift",
    "Player 2 buttons.:  Movement: arrows, Jump: M, Dash: N",
    "Player 3 buttons.:  Movement: TFGH, Jump: C, Dash: X",
    "Player 4 buttons.:  Movement: IJKL, Jump: B, Dash: V",
}

menu_scene.right_arrow = still_image.new('right_arrow.png', measure.screen_width/2 + 50, measure.screen_height/2, 0.5, 0.5)
menu_scene.left_arrow = still_image.new('left_arrow.png', measure.screen_width/2 - 50, measure.screen_height/2, 0.5, 0.5)
menu_scene.right_arrow_rect = geometry.makeRect(menu_scene.right_arrow.x, menu_scene.right_arrow.y,
                                                menu_scene.right_arrow.width, menu_scene.right_arrow.height,
                                                menu_scene.right_arrow.pivotX, menu_scene.right_arrow.pivotY)
menu_scene.left_arrow_rect = geometry.makeRect(menu_scene.left_arrow.x, menu_scene.left_arrow.y,
                                               menu_scene.left_arrow.width, menu_scene.left_arrow.height,
                                               menu_scene.left_arrow.pivotX, menu_scene.left_arrow.pivotY)

menu_scene.play_button = still_image.new('play_button.png', measure.screen_width/2, measure.screen_height - 50, 0.5, 0.5)
menu_scene.play_rect = geometry.makeRect(menu_scene.play_button.x, menu_scene.play_button.y,
                                         menu_scene.play_button.width, menu_scene.play_button.height,
                                         menu_scene.play_button.pivotX, menu_scene.play_button.pivotY)

function menu_scene:update(dt)
    if mouse.mouseButtonDown then
        if geometry.isPointInRect(geometry.makePoint(mouse.mouseX, mouse.mouseY), self.right_arrow_rect) then
            player_amount = gamemath.clamp(player_amount+1, 4, 2)
        elseif geometry.isPointInRect(geometry.makePoint(mouse.mouseX, mouse.mouseY), self.left_arrow_rect) then
            player_amount = gamemath.clamp(player_amount-1, 4, 2)
        elseif geometry.isPointInRect(geometry.makePoint(mouse.mouseX, mouse.mouseY), self.play_rect) then
            current_scene = require("scripts.scenes.game_scene")
        end
    end
end

function menu_scene:draw()
    for i, info in ipairs(self.text_info) do
        local draw_x = measure.screen_width/2 - (font:getWidth(info.text)/2)*info.scale
        love.graphics.print({self.text_color, info.text},
                            math.floor(draw_x), info.height, 0, info.scale, info.scale)
    end
    self.right_arrow:draw()
    self.left_arrow:draw()
    self:drawPlayerAmount()
    self:drawPlayerInputs()
    self:drawPlayButton()
end

function menu_scene:drawPlayerAmount()
    local draw_x = measure.screen_width/2 - font:getWidth(tostring(player_amount))/2
        love.graphics.print({self.text_color, tostring(player_amount)},
                            math.floor(draw_x), measure.screen_height/2-20, 0, 2, 2)
end

function menu_scene:drawPlayerInputs()
    local draw_y = measure.screen_height/2 + 60
    local draw_x = nil
    for i=1,player_amount do
        draw_x = measure.screen_width/2 - font:getWidth(self.player_input_texts[i])/2
        love.graphics.print({self.text_color, tostring(self.player_input_texts[i])},
                            math.floor(draw_x), draw_y)
        draw_y = draw_y + 30
    end
end

function menu_scene:drawPlayButton()
    self.play_button:draw()
    local play_text = "Play"
    local draw_x = measure.screen_width/2 - font:getWidth(play_text)
    local draw_y = self.play_button.y - font:getHeight(play_text)
    love.graphics.print({{0, 0, 0}, tostring(play_text)}, math.floor(draw_x), math.floor(draw_y), 0, 2, 2)
end

return menu_scene
