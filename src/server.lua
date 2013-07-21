if love then
	print("Don't do that you silly billy!")
	love.event.push("quit")
else
	print("Clever girl...")
end

require("global")
require("simulator")
require("tickable")
require("ship")
global.MODE = "server"

socket = require("socket")
clent_mt = {}

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
		cc.ship = ship.new("client", simulator.gameFrame())
		for k,v in pairs(clients) do
			cc:send("spawn player "..k.." "..v.ship.sim:serialize(simulator.gameFrame()))
		end
		clients[getID()] = cc
		cc:send("ping")
		cc.ptime = clock()
		cc.checktime = 0
		cc:send("f "..simulator.gameFrame())
	end
end


function doSendReceive(dt)
	for k,v in pairs(clients) do
		v.checktime = v.checktime+dt
		if v.checktime>1 then
			v.checktime = 0
			v:send("ping")
			v:send("repos")
		end
		local m, e = true, true
		while m do
			m, e = v:receive()
			if m then
				-- Do deal with message
				local cmd, params = m:match("^(%S*) (.*)")
				cmd = cmd or m
				if cmd == "mov" then
					local x, y, f = params:match("^(%S*) (%S*) (%S*)")
					v.ship.sim:applyToFrame(tonumber(f),
						function(f, dx, dy)
							--print(f)
							f.dx = dx
							f.dy = dy
						end, tonumber(x), tonumber(y))
				end
				if cmd=="pong" then
					v.ping = clock()-v.ptime
					v:send("lag "..v.ping)
					--v:send("ping")
				end

			elseif e=="closed" then
				-- Disconnect client
				print("Disconnected")
				clients[k]=nil
			end
		end

	end
end


function updateGame(dt)
	simulator.update(dt)
	for k,v in pairs(clients) do
		v.ship:update()
		local chipo = v.ship.sim:lerp(simulator.gameFrame())
		v:send("pos "..chipo.x.." "..chipo.y)
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
	--print(getID())
	dt = delta()
	if (dt/2000)>global.NETTIME then
		print("WARNING: Underrunning!")
		print("Delta: "..dt)
	end
	doConnections(dt)
	doSendReceive(dt)
	updateGame(dt)
	avdt = (avdt + dt)/2
	if global.NETTIME*2-avdt>0 then
		socket.sleep(global.NETTIME*2-avdt)
	end
	--]]
end
