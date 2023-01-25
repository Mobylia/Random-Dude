require "Dependencies"

local game_state = 'Main Menu', 'Death', 'Victory'
local menus = { 'Play', 'Quit' }
local selected_menu_item = 1
local window_width
local window_height
local font_height
local draw_menu
local draw_death
local draw_victory
local menu_keypressed
local draw_settings
local settings_keypressed
local draw_game
local game_keypressed
local world
local level = {}
local enemies = {}

function draw_menu()
    local horizontal_center = window_width / 2
    local vertical_center = window_height / 2
    local start_y = vertical_center - (font_height * (#menus / 2))
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf("Lost Dude", 0, 150, window_width, 'center')
  
    for i = 1, #menus do
        if i == selected_menu_item then
            love.graphics.setColor(1, 1, 0, 1)
        else
            love.graphics.setColor(1, 1, 1, 1)
        end
        love.graphics.printf(menus[i], 0, start_y + font_height * (i-1), window_width, 'center')
    end
end

function draw_game()
    love.graphics.newImage('Assets/real_background.png')

    local playerposition = GetPlayerPosition()
    love.graphics.push()
    love.graphics.translate(-playerposition.x + 200, 0)
    love.graphics.setColor(1, 1, 1)
    DrawPlayer()
    DrawCube()
    love.graphics.setColor(0, 1, 0)
    DrawLevel(level)
    DrawEnemies(enemies)
    love.graphics.pop()

end

function draw_death()
    local horizontal_center = window_width / 2
    local vertical_center = window_height / 2
    local start_y = vertical_center - (font_height * (#menus / 2))
    love.graphics.newImage('Assets/background.png')
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf("You...Died...", 0, 150, window_width, 'center')
end

function draw_victory()
    local horizontal_center = window_width / 2
    local vertical_center = window_height / 2
    local start_y = vertical_center - (font_height * (#menus / 2))
    love.graphics.newImage('Assets/background.png')
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf("You Won", 0, 150, window_width, 'center')

    for i = 1, #menus do
        if i == selected_menu_item then
            love.graphics.setColor(1, 1, 0, 1)
        else
            love.graphics.setColor(1, 1, 1, 1)
        end
        love.graphics.printf(menus[i], 0, start_y + font_height * (i-1), window_width, 'center')
    end
end

function love.keypressed(key, scan_code, is_repeat)
    if game_state == 'Main Menu' then
        menu_keypressed(key)
    else
        game_keypressed(key)
    end

    if game_state == 'Victory' then
        game_keypressed(key)
    end

    if game_state == 'Death' then
        game_keypressed(key)
    end
end

function menu_keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif love.keyboard.isDown("up") then
        selected_menu_item = selected_menu_item - 1
        if selected_menu_item < 1 then
            selected_menu_item = #menus
        end

    elseif love.keyboard.isDown("down") then
        selected_menu_item = selected_menu_item + 1
        if selected_menu_item > #menus then
            selected_menu_item = 1
        end

    elseif key == 'return' then
        if menus[selected_menu_item] == 'Play' then
            game_state = 'game'
        elseif menus[selected_menu_item] == 'Quit' then
            love.event.quit()
        end
    end
end

function game_keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.load()
        Lost = love.audio.newSource("Assets/Sound/losing.mp3", "stream")
        Won = love.audio.newSource("Assets/Sound/winning.mp3", "stream")
        background = love.audio.newSource("Assets/Sound/Background.mp3", "stream")
        window_width, window_height = love.graphics.getDimensions()
        local font = love.graphics.setNewFont(30)
        font_height = font:getHeight()

        love.physics.setMeter(64)
        world = love.physics.newWorld(0, 9.81 * love.physics.getMeter(), true)
        world:setCallbacks(BeginContact, nil, nil, nil)

        CreatePlayer(world, 100, 100)
        CreateCube(world, 6000, 520)
    
        level[1] = CreatePlatform(world, 200, 575, 1000, 50) 
        level[2] = CreatePlatform(world, 400, 420, 100, 30)
        level[3] = CreatePlatform(world, 1200, 575, 600, 50)
        level[4] = CreatePlatform(world, 1200, 420, 500, 30)
        level[5] = CreatePlatform(world, 2000, 420, 500, 30)
        level[6] = CreatePlatform(world, 2800, 575, 500, 30)
        level[7] = CreatePlatform(world, 3400, 420, 600, 50)
        level[8] = CreatePlatform(world, 4200, 575, 600, 50)
        level[9] = CreatePlatform(world, 5000, 420, 600, 50)
        level[10] = CreatePlatform(world, 5800, 575, 600, 50)
        level[11] = CreatePlatform(world, 0, 100, 100, 1000)
        level[12] = CreatePlatform(world, 6100, 100, 100, 1000)
        
        enemies[1] = CreateEnemy(world, 400, 300, 2, 2)
        enemies[2] = CreateEnemy(world, 700, 420, 1, 1)
        
        enemies[3] = CreateEnemy(world, 1400, 300, 2, 2)
        enemies[4] = CreateEnemy(world, 1400, 500, 1, 1)

        enemies[5] = CreateEnemy(world, 1300, 300, 1, 1)
        enemies[6] = CreateEnemy(world, 2300, 300, 2, 2)
        
        enemies[7] = CreateEnemy(world, 2100, 300, 2, 1)
        enemies[8] = CreateEnemy(world, 2300, 300, 1, 2)

        enemies[9] = CreateEnemy(world, 2800, 300, 1, 1)
        enemies[10] = CreateEnemy(world, 3000, 300, 2, 2)

        enemies[11] = CreateEnemy(world, 3500, 300, 2, 1)
        enemies[12] = CreateEnemy(world, 3700, 300, 1, 2)

        enemies[13] = CreateEnemy(world, 4300, 300, 1, 1)
        enemies[14] = CreateEnemy(world, 4500, 300, 2, 2)

        enemies[15] = CreateEnemy(world, 5100, 300, 2, 1)
        enemies[16] = CreateEnemy(world, 5300, 300, 1, 2)

        enemies[17] = CreateEnemy(world, 5900, 300, 1, 1)
        enemies[18] = CreateEnemy(world, 6100, 300, 2, 2)
end

function BeginContact(fixtureA, fixtureB, contact)
    BeginContactPlayer(fixtureA, fixtureB, contact)
    BeginContactEnemy(fixtureA, fixtureB, contact, enemies)
end

function love.update(dt)
    love.audio.play(background)
    if game_state == 'game' then
    end
    if game_state == 'Death' then
        love.audio.play(Lost)
    end
    if game_state == 'Victorus' then
        love.audio.play(Won)
    end
    UpdatePlayer(dt)
    UpdateEnemies(dt, enemies)
    world:update(dt)
end

function love.draw()
    if game_state == 'Main Menu' then
        draw_menu()
    else
        draw_game()
    end

    if game_state == 'Death' then
        draw_death()
    end

    if game_state == 'Victory' then
        draw_victory()
    end
end
-- Made by Rodrigo Farinha