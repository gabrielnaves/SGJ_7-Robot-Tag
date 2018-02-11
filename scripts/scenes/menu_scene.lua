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
    }
}

function menu_scene:load()
end

function menu_scene:update(dt)
end

function menu_scene:lateUpdate(dt)
end

function menu_scene:draw()
    for i, info in ipairs(self.text_info) do
        local draw_x = measure.screen_width/2 - (font:getWidth(info.text)/2)*info.scale
        love.graphics.print({self.text_color, info.text},
                            math.floor(draw_x), info.height, 0, info.scale, info.scale)
    end
end

function menu_scene:restart()
end


menu_scene:load()
return menu_scene
