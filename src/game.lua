local state = gstate.new()


function state:init()
	pnt = {
		x = 200,
		y = 400,
		ix = 0,
		iy = 0,
		ox = 0,
		oy = 0
	}
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
end


function state:keyreleased(key, uni)
end


function state:update(dt)
	client:update(dt)
	pnt.ix = 0
	pnt.iy = 0
	if love.keyboard.isDown("left", "q", "a") then
		pnt.ix = pnt.ix-1
	end
	if love.keyboard.isDown("right", "d") then
		pnt.ix = pnt.ix+1
	end
	if love.keyboard.isDown("up", "z", "w") then
		pnt.iy = pnt.iy-1
	end
	if love.keyboard.isDown("down", "s") then
		pnt.iy = pnt.iy+1
	end
	print(pnt.ix,pnt.iy,pnt.ox,pnt.oy)
	if pnt.ox~=pnt.ix or pnt.oy~=pnt.iy then
		client:send("mov "..pnt.ix.." "..pnt.iy)
		pnt.ox = pnt.ix
		pnt.oy = pnt.iy
	end
end


function state:draw()
	love.graphics.rectangle("fill",pnt.x-3, pnt.y-3, 6, 6)
end

return state