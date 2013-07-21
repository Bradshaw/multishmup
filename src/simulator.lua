simulator = {}
simulator.time = 0
simulator.lag = 0

function simulator.update(dt)
	simulator.time = simulator.time+dt
end

function simulator.netFrame()
	return math.floor(math.max(0,(simulator.time+simulator.lag))*global.NETRATE)
end

function simulator.gameTime()
	return math.max(0,(simulator.time+simulator.lag))*global.GAMERATE
end

function simulator.gameFrame()
	return math.floor(math.max(0,(simulator.time+simulator.lag))*global.GAMERATE)
end

function simulator.setGameFrame(t)
	simulator.time = t/global.GAMERATE
end
