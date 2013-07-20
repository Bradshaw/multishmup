simulator = {}
simulator.time = 0

function simulator.update(dt)
	simulator.time = simulator.time+dt
end

function simulator.netFrame()
	return math.floor(simulator.time*global.NETRATE)
end

function simulator.gameFrame()
	return math.floor(simulator.time*global.GAMERATE)
end