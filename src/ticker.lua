ticker = {}

function ticker:init()
	self.curTime = 0
	self.off = 0
	self.items = {}
	self.frames = {}
end


function ticker:track(thing)
	table.insert(self.items,thing)
end

function ticker.setState(state)
	self.curTime = state.curTime
	self.curTime = state.curTime
end

function ticker:tick(frame)
	
end

function ticker:update(dt)
	self.curTime=self.curTime+dt
end