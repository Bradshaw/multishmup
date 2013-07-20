require("tickable")

local ship_mt = {}
ship = {}
ship.all = {}

function ship.new(player)
	local self = setmetatable({},{__index = ship_mt})
	self.sim = tickable.new(0, {
			x = 200,
			y = 400,
			dx = 0,
			dy = 0
		})
	self.sim.tick = function(self, frame)
		return {
			x = frame.x+frame.dx,
			y = frame.y+frame.dy,
			dx = frame.dx,
			dy = frame.dy
		}
	end
	self.sim.lerp = function(self, frame)
		local f1, f2 = self:getFrame(math.floor(frame))
		local interp = frame-math.floor(frame)
		return {
			x = f1.x*interp + f2.x*(1-interp),
			y = f1.y*interp + f2.y*(1-interp),
			dx = f1.dx*interp + f2.dx*(1-interp),
			dy = f1.dy*interp + f2.dy*(1-interp)
		}
	end
	self.controllable = player or "ai"
	self.drawPos = self.sim:lerp(simulator.gameFrame())
	return self
end

function ship_mt:update(dt)
	if self.controllable=="player" then
		local pnt = {}
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
		local prev = self.sim:getFrame(simulator.gameFrame())
		if prev.dx~=pnt.ix or prev.dy~=pnt.iy then
			--client:send("mov "..pnt.ix.." "..pnt.iy)
			self.sim:applyToFrame(simulator.gameFrame(),function(f, dx, dy)
					f.dx = dx
					f.dy = dy
				end, pnt.ix, pnt.iy)
		end

	end
	self.drawPos = self.sim:lerp(simulator.gameFrame())
end

if global.MODE == "client" then

function ship_mt:draw()
	love.graphics.rectangle("fill",self.drawPos.x-3,self.drawPos.y-3,6,6)
end

end