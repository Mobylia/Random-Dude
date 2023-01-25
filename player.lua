local player

function CreatePlayer(world, x, y)
    Jumping = love.audio.newSource("Assets/Sound/jump.mp3", "static")
    Dying = love.audio.newSource("Assets/Sound/Dying.mp3", "static")

    player = {}
    player.body = love.physics.newBody(world, x, y, "dynamic")
    player.shape = love.physics.newRectangleShape(32, 80)
    player.fixture = love.physics.newFixture(player.body, player.shape, 1)
    player.fixture:setFriction(0.8)
    player.fixture:setUserData({type = "player"})
    player.body:setFixedRotation(true)
    player.maxvelocity = 200
    player.onground = false
    player.alive = true

    --player.sprites = {}
    --for i = 1, 1, 1 do
        --player.sprites[i] = love.graphics.newImage("NormalDude" .. i .. ".png")
    --end
    --player.frame = 1
    --player.animationtimer = 0
    --player.animationdelay = 0.1
end

function BeginContactPlayer(fixtureA, fixtureB, contact)
    if (fixtureA:getUserData().type == "player" and
       fixtureB:getUserData().type == "platform") then
        local normal = vector2.new(contact:getNormal())
        if (normal.y == 1) then
            player.onground = true
        end
    elseif (fixtureA:getUserData().type == "platform" and
           fixtureB:getUserData().type == "player") then
        local normal = vector2.new(contact:getNormal())
        if (normal.y == -1) then
            player.onground = true
        end
    elseif (fixtureA:getUserData().type == "platform" and
           fixtureB:getUserData().type == "player") then
        local normal = vector2.new(contact:getNormal())
        if (normal.y == -1) then
            player.onground = true
        end
    elseif (fixtureA:getUserData().type == "platform" and
           fixtureB:getUserData().type == "player") then
        local normal = vector2.new(contact:getNormal())
        if (normal.y == -1) then
            player.onground = true
        end    
    end
end

function UpdatePlayer(dt)
    if player.alive then
        if love.keyboard.isDown("right", "d") then
            local moveForce = vector2.new(700, 0)
            player.body:applyForce(moveForce.x, moveForce.y)

            --player.animationtimer = player.animationtimer + dt
            --if player.animationtimer > player.animationdelay then
                --player.frame = player.frame + 1
                --if player.frame > 4 then
                --player.frame = 1
                --end
                --player.animationtimer = 1
            --end
        end
        if love.keyboard.isDown("left", "a") then
            local moveForce = vector2.new(-700, 0)
            player.body:applyForce(moveForce.x, moveForce.y)

            --player.animationtimer = player.animationtimer + dt
            --if player.animationtimer > player.animationdelay then
                --player.frame = player.frame + 5
                --if player.frame > 8 then
                --player.frame = 4
                --end
                --player.animationtimer = 1
            --end
        end
        if love.keyboard.isDown("up", "space", "w") and (player.onground == true) then
            local moveForce = vector2.new(0, -300)
            player.body:applyLinearImpulse(moveForce.x, moveForce.y)
            player.onground = false
            love.audio.play(Jumping)

            --player.animationtimer = player.animationtimer + dt
            --if player.animationtimer > player.animationdelay then
                --player.frame = player.frame + 9
                --if player.frame > 11 then
                --player.frame = 9
                --end
                --player.animationtimer = 0
            --end
        end
    end
    local velocity = vector2.new(player.body:getLinearVelocity())
    if velocity.x > 0 then
        player.body:setLinearVelocity(math.min(velocity.x, player.maxvelocity), velocity.y)
    else
        player.body:setLinearVelocity(math.max(velocity.x, -player.maxvelocity), velocity.y)
    end
end

function DrawPlayer()
    if player.alive then
        --love.graphics.draw(player.sprites[player.frame], player.body:getWorldPoints(player.shape:getPoints()))
        love.graphics.polygon("fill", player.body:getWorldPoints(player.shape:getPoints()))
    end
end

function GetPlayerPosition()
    return vector2.new(player.body:getPosition())
end

function KillPlayer()
    player.alive = false
    love.audio.play(Dying)
    game_state = 'Death'
end

function PlayerWin()
    game_state = 'Victory'
end