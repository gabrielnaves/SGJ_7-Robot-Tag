text_printing = {}

function text_printing.printCentered(text, color, x, y, scale)
    local draw_x = math.floor(x-font:getWidth(text)/2 * scale)
    local draw_y = math.floor(y-font:getHeight(text)/2 * scale)
    love.graphics.print({color, text}, draw_x, draw_y, 0, scale, scale)
end
