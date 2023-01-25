function CreatePlatform(world, x, y, width, height)
    local platform = {}
    platform.body = love.physics.newBody(world, x, y, "static")
    platform.shape = love.physics.newRectangleShape(width, height)
    platform.fixture = love.physics.newFixture(platform.body, platform.shape, 1)
    platform.fixture:setUserData({type = "platform"})
    return platform
end

function DrawLevel(level)
    for i = 1, #level, 1 do
        love.graphics.polygon("fill", level[i].body:getWorldPoints(level[i].shape:getPoints()))
    end
end