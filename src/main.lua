function love.load(arg)
	require("log")
	font = love.graphics.newImageFont("images/myfont.png",
    " abcdefghijklmnopqrstuvwxyz" ..
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
    "123456789.,!?-+/():;%_`'*__[]\"" ..
    "<>&#=$")
	love.graphics.setFont(font)
	require("ticker")
	gstate = require "gamestate"
	game = require("game")
	require("client")
	client:init()
	gstate.switch(game)
end


function love.focus(f)
	gstate.focus(f)
end

function love.mousepressed(x, y, btn)
	gstate.mousepressed(x, y, btn)
end

function love.mousereleased(x, y, btn)
	gstate.mousereleased(x, y, btn)
end

function love.joystickpressed(joystick, button)
	gstate.joystickpressed(joystick, button)
end

function love.joystickreleased(joystick, button)
	gstate.joystickreleased(joystick, button)
end

function love.quit()
	gstate.quit()
end

function love.keypressed(key, uni)
	gstate.keypressed(key, uni)
end

function love.keyreleased(key, uni)
	gstate.keyreleased(key)
end

function love.update(dt)
	gstate.update(dt)
	log.update(dt)
end

function love.draw()
	gstate.draw()
	log.draw()
end
