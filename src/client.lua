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
	local m, e = self:receive()
	if e then 
		--log.push(e)
	end
	if m then
		local cmd, params = m:match("^(%S*) (.*)")
		if pnt and cmd == "pos" then
			local x, y = params:match("^(%S*) (%S*)")
			pnt.x = x
			pnt.y = y
		end
	elseif e=="closed" and self.connected then
		-- Lost connection
		log.push("Connection to server was closed")
		self.connected = false
	end
end
