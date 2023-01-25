function CreateCube(world, x, y)
    cube = {}
    cube.body = love.physics.newBody(world, x, y, "static")
    cube.shape = love.physics.newRectangleShape(32, 80)
    cube.fixture = love.physics.newFixture(cube.body, cube.shape, 1)
    cube.fixture:setFriction(0.8)
    cube.fixture:setUserData({type = "cube"})
    cube.body:setFixedRotation(true)
end

function BeginContactCube(fixtureA, fixtureB, contact)
    if (fixtureA:getUserData().type == "player" and
       fixtureB:getUserData().type == "cube") then
        local normal = vector2.new(contact:getNormal())
        if (normal.y == 1) then
            PlayerWin()
        end
    elseif (fixtureA:getUserData().type == "cube" and
           fixtureB:getUserData().type == "player") then
        local normal = vector2.new(contact:getNormal())
        if (normal.y == -1) then
            PlayerWin()
        end
    end
end

function DrawCube()
    love.graphics.polygon("fill", cube.body:getWorldPoints(cube.shape:getPoints()))
end