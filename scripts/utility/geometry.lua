geometry = {}

function geometry.makePoint(x, y)
    return { x=x, y=y }
end

function geometry.makeRect(x, y, width, height, pivotX, pivotY)
    pivotX = pivotX or 0.0
    pivotY = pivotY or 0.0
    return { x=x, y=y, width=width, height=height, pivotX=pivotX, pivotY=pivotY }
end

function geometry.isPointInRect(point, rect)
    local rx = rect.x - rect.width*rect.pivotX
    local ry = rect.y - rect.height*rect.pivotY
    return point.x > rx and point.x < rx+rect.width and
           point.y > ry and point.y < ry+rect.height
end

function geometry.overlappingRects(rect1, rect2)
    local rx1 = rect1.x - rect1.width*rect1.pivotX
    local ry1 = rect1.y - rect1.height*rect1.pivotY
    local rx2 = rect2.x - rect2.width*rect2.pivotX
    local ry2 = rect2.y - rect2.height*rect2.pivotY

    return rx2 < rx1+rect1.width and rx1 < rx2+rect2.width and
           ry2 < ry1+rect1.height and ry1 < ry2+rect2.height
end
