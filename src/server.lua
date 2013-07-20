if love then
	print("Don't do that you silly billy!")
	love.event.push("quit")
else
	print("Clever girl...")
end

g = {
	PLAYERS = 4
}

socket = require("socket")
clients = {}

function clock()
  return socket.gettime()*1000
end

local lastTime = clock()
function delta()
  local dt = clock() - lastTime
  lastTime = clock()
  return dt
end

function timeSince()
  return clock() - lastTime
end

serv = socket.bind("*",1986,g.PLAYERS)
serv:settimeout(0)
serv:setoption("tcp-nodelay",true)
while true do
	local cl = serv:accept()
	if cl then
		print("Connection")
		cl:setoption("tcp-nodelay",true)
		table.insert(clients, cl)
	end
	for i,v in ipairs(clients) do
		local m, e = v:receive("*l")
		if m then
			print("From #"..i..": "..m) 
			v:send(m.."\n")
		elseif e=="closed" then
			print("Disconnected")
			table.remove(clients,i)
		end
	end
	socket.sleep(0.1)
end


