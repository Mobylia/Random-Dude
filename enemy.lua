function CreateEnemy(world, x, y, t, i)
    Hurt = love.audio.newSource("Assets/Sound/hurtingenemies.mp3", "static")

    local enemy = {}
    enemy.body = love.physics.newBody(world, x, y, "dynamic")
    enemy.shape = love.physics.newRectangleShape(30, 30)
    enemy.fixture = love.physics.newFixture(enemy.body, enemy.shape, 3)
    enemy.body:setFixedRotation(true)
    enemy.fixture:setFriction(0.9)
    enemy.fixture:setUserData({type = "enemy", index = i})
    enemy.type = t
    enemy.maxvelocity = 200
    enemy.direction = vector2.new(-1, 0)    
    enemy.moveTimer = 0
   
    --enemy.sprites = {}
    --for i = 1, 1, 1 do
        --enemy.sprites[i] = love.graphics.newImage("enemy" .. i .. ".png")
    --end
    --enemy.frame = 1
    --enemy.animationtimer = 0
    --enemy.animationdelay = 0.1


    if enemy.type == 1 then
        enemy.timeToMove = 1.5
    elseif enemy.type == 2 then
        enemy.timeToMove = 3
    end
    return enemy
end

function UpdateEnemies(dt, enemies)
    for i = 1, #enemies, 1 do
        if enemies[i] then
            if enemies[i].type == 1 then
                local moveForce = vector2.mult(enemies[i].direction, 800)
                enemies[i].body:applyForce(moveForce.x, moveForce.y)  
                
                enemies[i].moveTimer = enemies[i].moveTimer + dt
                if (enemies[i].moveTimer > enemies[i].timeToMove) then
                    enemies[i].moveTimer = 0
                    enemies[i].direction = vector2.mult(enemies[i].direction, -1)
                end
                --enemy.animationtimer = enemy.animationtimer + dt
                --if enemy.animationtimer > enemy.animationdelay then
                --enemy.frame = enemy.frame + 1
                --if enemy.frame > 3 then
                --enemy.frame = 1
                --end
                --enemy.animationtimer = 1
                --end

                local velocity = vector2.new(enemies[i].body:getLinearVelocity())
                if velocity.x > 0 then
                    enemies[i].body:setLinearVelocity(math.min(velocity.x, enemies[i].maxvelocity), velocity.y)
                else
                    enemies[i].body:setLinearVelocity(math.max(velocity.x, -enemies[i].maxvelocity), velocity.y)
                end  
            elseif enemies[i].type == 2 then
                enemies[i].moveTimer = enemies[i].moveTimer + dt
                if (enemies[i].moveTimer > enemies[i].timeToMove) then
                    enemies[i].moveTimer = 0
                    local jumpForce = vector2.new(0, -400)
                    enemies[i].body:applyLinearImpulse(jumpForce.x, jumpForce.y)
                end

                 --enemy.animationtimer = enemy.animationtimer + dt
                --if enemy.animationtimer > enemy.animationdelay then
                --enemy.frame = enemy.frame + 4
                --if enemy.frame > 6 then
                --enemy.frame = 4
                --end
                --enemy.animationtimer = 1
                --end
            end
        end
    end
end

function BeginContactEnemy(fixtureA, fixtureB, contact, enemies)
    if (fixtureA:getUserData().type == "player" and 
       fixtureB:getUserData().type == "enemy") then
        local normal = vector2.new(contact:getNormal())
        if (normal.y == 1) then
            enemies[fixtureB:getUserData().index] = nil
            fixtureB:getBody():destroy()
            fixtureB:getShape():release()
            fixtureB:destroy()
            love.audio.play(Hurt)
        else
            KillPlayer()
        end
    elseif (fixtureA:getUserData().type == "enemy" and 
           fixtureB:getUserData().type == "player") then
        local normal = vector2.new(contact:getNormal())
        if (normal.y == -1) then
            enemies[fixtureA:getUsxerData().index] = nil
            fixtureA:getBody():destroy()
            fixtureA:getShape():release()
            fixtureA:destroy()
        else
            KillPlayer()
        end
    end
end

function DrawEnemies(enemies)
    for i = 1, #enemies, 1 do
        if enemies[i] then
            if enemies[i].type == 1 then
                love.graphics.setColor(0.8, 0, 0)
            elseif enemies[i].type == 2 then
                love.graphics.setColor(0.8, 0.8, 0)
            end
            --love.graphics.draw(player.sprites[player.frame], enemies[i].body:getWorldPoints(enemies[i].shape:getPoints()))
            love.graphics.polygon("fill", enemies[i].body:getWorldPoints(enemies[i].shape:getPoints()))
        end
    end
end