socket = require("socket")
client = {}

function client:init()
	self.tcp = socket.tcp()
	log.push("Attempting connection to server")
	self.tcp:connect("127.0.0.1",1986)
	log.push("Success!")
	self.connected = true
	self.tcp:settimeout(0)
	self.tcp:setoption("tcp-nodelay",true)
	self.tcp:send("Connect\n")
end

function client:update()
	local m, e = self.tcp:receive("*l")
	if e then 
		--log.push(e)
	end
	if m then
		log.push(m)
		self.tcp:send(m.."\n")
	elseif e=="closed" and self.connected then
		log.push("Connection to server was closed")
		self.connected = false
	end
end
