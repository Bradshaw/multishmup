log = {}
log.messages = {}

function log.update(dt)
	local i = 1
	while i <= #log.messages do
		v = log.messages[i]
		if v.time<=0 then
			table.remove(log.messages,i)
		else
			v.time = v.time - dt
			i = i+1
		end
	end
end

function log.draw()
	for i,v in ipairs(log.messages) do
		if v.imp>1 then
			love.graphics.setColor(255,0,0)
		else
			love.graphics.setColor(255,255,255)
		end
		love.graphics.print(v.msg, 5, 5+10*(i-1))
	end
end

function log.push(msg,importance,time)
	print("Log: "..msg)
	table.insert(log.messages,{time = time or 4, msg = msg, imp = importance or 1})
end