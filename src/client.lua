socket = require("socket")
client = {}
global.MODE = "client"

function client:init(ip, port)
	self.tcp = socket.tcp()
	log.push("Attempting connection to server")
	if self.tcp:connect(ip or "127.0.0.1",port or 1986) then
		log.push("Success!")
		self.connected = true
		self.tcp:settimeout(0)
		self.tcp:setoption("tcp-nodelay",true)
		self.tcp:send("Connect\n")
	else
		log.push("Connection failed")
	end
end

function client:send(d)
	self.tcp:send(d.."\n")
end

function client:receive()
	return self.tcp:receive("*l")
end

function client:update()
	local m, e = true, true
	local done = 0
	while m do
		m, e = self:receive()
		if e then 
			--log.push(e)
		end
		if m then
			local cmd, params = m:match("^(%S*) (.*)")
			cmd = cmd or m
			if pnt and cmd == "pos" then
				local x, y = params:match("^(%S*) (%S*)")
				pnt.x = x
				pnt.y = y
			end
			if cmd == "f" then
				simulator.setGameFrame(tonumber(params))
				
			end
			if cmd == "ping" then
				local s = ""
				for i=0,math.random(10) do
					s = s.." "
				end
				--log.push(s.."!")
				self:send("pong")
			end
			if cmd == "lag" then
				if simulator.lag == 0 then
					--simulator.lag = tonumber(params)
				else
					--simulator.lag = -tonumber(params) --(tonumber(params) + simulator.lag*9)/10
				end
			end
			if cmd == "reposa" then
				player.sim:applyToFrame(simulator.gameFrame(),function(f, x, y)
					f.x = x
					f.y = y
				end, pnt.x, pnt.y)
			end
			if cmd == "spawn" then
				log.push(params)
			end
		elseif e=="closed" and self.connected then
			-- Lost connection
			log.push("Connection to server was closed")
			self.connected = false
		end
		done = done + 1
	end
	if done > 0 then
		--log.push(done)
	end
end
