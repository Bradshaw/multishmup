local state = gstate.new()


function state:init()
	player = ship.new("player")
	pnt = {x = 5, y = 5}
end


function state:enter()

end


function state:focus()

end


function state:mousepressed(x, y, btn)

end


function state:mousereleased(x, y, btn)
	
end


function state:joystickpressed(joystick, button)
	
end


function state:joystickreleased(joystick, button)
	
end


function state:quit()
	
end


function state:keypressed(key, uni)
	if key=="escape" then
		love.event.push("quit")
	end
	if key==" " or key=="lctrl" or key=="rctrl" or key=="lalt" or key=="ralt" or key=="return" or key=="kp0" then
		log.push("FIRE!")
		player.sim:applyToFrame(simulator.gameFrame(),function(f, firing)
					f.firing = firing
				end, true)
	end
	if key == "p" then
		player.sim:serialize(simulator.gameFrame())
	end
end


function state:keyreleased(key, uni)
	if key==" " or key=="lctrl" or key=="rctrl" or key=="lalt" or key=="ralt" or key=="return" or key=="kp0" then
		log.push("STAHP!")
		player.sim:applyToFrame(simulator.gameFrame(),function(f, firing)
					f.firing = firing
				end, false)
	end
end


function state:update(dt)
	simulator.update(dt)
	client:update(dt)
	player:update(dt)
end


function state:draw()
	player:draw()
	--love.graphics.rectangle("line",pnt.x-5,pnt.y-5,10,10)
end

return state