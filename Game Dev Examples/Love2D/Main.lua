

function love.load()

    -- Declare variables
    player = {}
    player.x = 0
    player.bullets = {}


    player.fire = function()

      bullet = {}
      bullet.x = player.x
      bullet.y = 400
      table.insert(player.bullets, bullet)

    end

    -- Starting point
    player.x = 250

end


function love.update(dt)

    -- Controls
    if love.keyboard.isDown('right') then
        player.x = player.x + 1

    elseif love.keyboard.isDown('left') then
        player.x = player.x - 1

    end


    if love.keyboard.isDown('z') then

        player.fire()

    end

end


function love.draw()

    love.graphics.setColor(180, 50, 50)
    love.graphics.rectangle('fill', player.x, 400, 50, 20)

    for fire, bullet in pairs(player.bullets) do

        love.graphics.rectangle('fill', bullet.x, bullet.y, 10, 10 )

    end

end
