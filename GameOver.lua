function GameOver()
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        --game_Sounds['confirm']:play();
        --game_State_Machine:change('start');
    end
end

function GameOverState:render(dt)
    --    love.graphics.printf("You Died", 0, 150, window_width, 'center')
    --    love.graphics.printf("Press Enter", 0, 550, window_width, 'center')
end