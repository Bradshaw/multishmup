require("tickable")
require("dumper")

local ship_mt = {}
ship = {}
ship.all = {}

function ship.new(player, frame)
	local self = setmetatable({},{__index = ship_mt})
	self.sim = tickable.new(frame, {
			x = 200,
			y = 400,
			dx = 0,
			dy = 0,
			vx = 0,
			vy = 0,
			cooldown = 0
		})
	self.sim.tick = function(self, frame)
		local vx, vy = 0, 0
		if frame.dx~=0 then
			vx = math.min(3, math.max(-3,(frame.vx + frame.dx/2)))
		else
			if frame.vx>0 then
				vx = frame.vx-1/4
			elseif frame.vx<0 then
				vx = frame.vx+1/4
			end
		end
		if frame.dy~=0 then
			vy = math.min(3, math.max(-3,(frame.vy + frame.dy/2)))
		else
			if frame.vy>0 then
				vy = frame.vy-1/4
			elseif frame.vy<0 then
				vy = frame.vy+1/4
			end
		end
		local x = frame.x+vx
		local y = frame.y+vy
		return {
			vx = vx,
			vy = vy,
			dx = frame.dx,
			dy = frame.dy,
			x = x,
			y = y,
			cooldown = math.max(0,frame.cooldown-1)
		}
	end
	self.sim.lerp = function(self, frame)
		local f1, f2 = self:getFrame(math.floor(frame))
		local interp = 1-(frame-math.floor(frame))
		return {
			x = f1.x*interp + f2.x*(1-interp),
			y = f1.y*interp + f2.y*(1-interp),
			dx = f1.dx*interp + f2.dx*(1-interp),
			dy = f1.dy*interp + f2.dy*(1-interp)
		}
	end
	self.sim:init(frame or 0, {
			x = 200,
			y = 400,
			dx = 0,
			dy = 0,
			vx = 0,
			vy = 0,
			cooldown = 0
		})
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
			client:send("mov "..pnt.ix.." "..pnt.iy.." "..simulator.gameFrame())
			self.sim:applyToFrame(simulator.gameFrame(),function(f, dx, dy)
					f.dx = dx
					f.dy = dy
				end, pnt.ix, pnt.iy)
		end
	end
	self.drawPos = self.sim:lerp(simulator.gameTime())
end

if global.MODE == "client" then

function ship_mt:draw()
	love.graphics.rectangle("fill",self.drawPos.x-3,self.drawPos.y-3,6,6)
end

end