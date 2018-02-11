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
        height = measure.screen_height / 2 - 20,
        scale = 1,
    }
}

menu_scene.right_arrow = still_image.new('right_arrow.png', measure.screen_width/2 + 50, measure.screen_height/2+40, 0.5, 0.5)
menu_scene.left_arrow = still_image.new('left_arrow.png', measure.screen_width/2 - 50, measure.screen_height/2+40, 0.5, 0.5)
menu_scene.right_arrow_rect = geometry.makeRect(menu_scene.right_arrow.x, menu_scene.right_arrow.y,
                                                menu_scene.right_arrow.width, menu_scene.right_arrow.height,
                                                menu_scene.right_arrow.pivotX, menu_scene.right_arrow.pivotY)
menu_scene.left_arrow_rect = geometry.makeRect(menu_scene.left_arrow.x, menu_scene.left_arrow.y,
                                               menu_scene.left_arrow.width, menu_scene.left_arrow.height,
                                               menu_scene.left_arrow.pivotX, menu_scene.left_arrow.pivotY)

menu_scene.player_amount = 2

function menu_scene:update(dt)
    if mouse.mouseButtonDown then
        if geometry.isPointInRect(geometry.makePoint(mouse.mouseX, mouse.mouseY), self.right_arrow_rect) then
            self.player_amount = gamemath.clamp(self.player_amount+1, 4, 2)
        elseif geometry.isPointInRect(geometry.makePoint(mouse.mouseX, mouse.mouseY), self.left_arrow_rect) then
            self.player_amount = gamemath.clamp(self.player_amount-1, 4, 2)
        end
    end
end

function menu_scene:lateUpdate(dt)
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
end

function menu_scene:drawPlayerAmount()
    local draw_x = measure.screen_width/2 - font:getWidth(tostring(self.player_amount))/2
        love.graphics.print({self.text_color, tostring(self.player_amount)},
                            math.floor(draw_x), measure.screen_height/2+20, 0, 2, 2)
end

function menu_scene:restart()
end

return menu_scene
