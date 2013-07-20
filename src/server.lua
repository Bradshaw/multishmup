if love then
	print("Don't do that you silly billy!")
	love.event.push("quit")
else
	print("Clever girl...")
end

require("global")
require("tickable")
require("ship")
global.MODE = "server"

socket = require("socket")
clent_mt = {
	x = 200,
	y = 400,
	dx = 0,
	dy = 0
}

function clent_mt:send(d)
	self.tcp:send(d.."\n")
end
function clent_mt:receive()
	return self.tcp:receive("*l")
end
clients = {}

function getID()
	lastID = (lastID or 1)+1
	return lastID
end

function clock()
  return socket.gettime()
end

function timeSince()
  return clock() - lastTime
end

function doConnections()
	local cl = serv:accept()
	if cl then
		local cc = setmetatable({},{__index=clent_mt})
		print("Connection")
		cl:setoption("tcp-nodelay",true)
		cl:settimeout(0)
		cc.tcp = cl
		clients[getID()] = cc
		cc:send("Connection OK!")
	end
end


function doSendReceive()
	for k,v in pairs(clients) do
		local m, e = v:receive()
		if m then
			-- Do deal with message
			local cmd, params = m:match("^(%S*) (.*)")
			if cmd == "mov" then
				local x, y = params:match("^(%S*) (%S*)")
				v.dx = x
				v.dy = y
			end
		elseif e=="closed" then
			-- Disconnect client
			print("Disconnected")
			clients[k]=nil
		end
	end
end


function updateGame(dt)
	for k,v in pairs(clients) do
		v.x = v.x + v.dx * 100 * dt
		v.y = v.y + v.dy * 100 * dt
		v:send("pos "..v.x.." "..v.y)
	end
end

local lastTime = clock()
function delta()
  local dt = clock() - lastTime
  lastTime = clock()
  return dt
end

print("Initialised functions")

serv = socket.bind("*",1986,global.PLAYERS)
serv:settimeout(0)
serv:setoption("tcp-nodelay",true)

sleepy = global.NETTIME
avdt = global.NETTIME
print("Server online")
while true do
	dt = delta()
	if (dt/2000)>global.NETTIME then
		print("WARNING: Underrunning!")
		print("Delta: "..dt)
	end
	doConnections()
	doSendReceive()
	updateGame(dt)
	avdt = (avdt + dt)/2
	if global.NETTIME*2-avdt>0 then
		socket.sleep(global.NETTIME*2-avdt)
	end
	--]]
end
