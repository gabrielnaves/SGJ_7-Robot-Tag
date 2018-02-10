robot_bulb = {}

robot_bulb.img = love.graphics.newImage('assets/robot_bulb.png')
robot_bulb.num_frames = 8
robot_bulb.frame_width = robot_bulb.img:getWidth() / robot_bulb.num_frames
robot_bulb.frame_height = robot_bulb.img:getHeight()
robot_bulb.frames = {
    love.graphics.newQuad(robot_bulb.frame_width*0, 0, robot_bulb.frame_width, robot_bulb.frame_height, robot_bulb.img:getWidth(), robot_bulb.img:getHeight()),
    love.graphics.newQuad(robot_bulb.frame_width*1, 0, robot_bulb.frame_width, robot_bulb.frame_height, robot_bulb.img:getWidth(), robot_bulb.img:getHeight()),
    love.graphics.newQuad(robot_bulb.frame_width*2, 0, robot_bulb.frame_width, robot_bulb.frame_height, robot_bulb.img:getWidth(), robot_bulb.img:getHeight()),
    love.graphics.newQuad(robot_bulb.frame_width*3, 0, robot_bulb.frame_width, robot_bulb.frame_height, robot_bulb.img:getWidth(), robot_bulb.img:getHeight()),
    love.graphics.newQuad(robot_bulb.frame_width*4, 0, robot_bulb.frame_width, robot_bulb.frame_height, robot_bulb.img:getWidth(), robot_bulb.img:getHeight()),
    love.graphics.newQuad(robot_bulb.frame_width*5, 0, robot_bulb.frame_width, robot_bulb.frame_height, robot_bulb.img:getWidth(), robot_bulb.img:getHeight()),
    love.graphics.newQuad(robot_bulb.frame_width*6, 0, robot_bulb.frame_width, robot_bulb.frame_height, robot_bulb.img:getWidth(), robot_bulb.img:getHeight()),
    love.graphics.newQuad(robot_bulb.frame_width*7, 0, robot_bulb.frame_width, robot_bulb.frame_height, robot_bulb.img:getWidth(), robot_bulb.img:getHeight()),
}

function robot_bulb.draw(frame, x, y)
    love.graphics.draw(robot_bulb.img, robot_bulb.frames[frame], x, y)
end
