local tickable_mt={}
tickable = {}
tickable.NILSTATE = 0
tickable.all = {}
tickable.currentFrame = 0

function tickable.new(f, state)
	local self = setmetatable({},{__index=tickable_mt})
	self.maxFrames = global.MAXFRAMES
	self:init(f,state)
	table.insert(tickable.all,self)
	return self
end

function tickable_mt:init(f, state)
	self.frames = {(state or tickable.NILSTATE)}
	self.framesfrom = (f or 1) - 1
end

function tickable_mt:tick(frame)
end

function tickable_mt:genFrame(f)
	while #self.frames+self.framesfrom<=f do
		table.insert(self.frames,self:tick(self.frames[#self.frames]))
	end
	while #self.frames>self.maxFrames do
		table.remove(self.frames, 1)
		self.framesfrom = self.framesfrom+1
	end
end

function tickable_mt:applyToFrame(f, func, ...)
	if f>self.framesfrom and f<self.framesfrom+global.MAXFRAMES then
		local to = #self.frames
		for i=f-self.framesfrom+1,to do
			self.frames[i]=nil
		end
		func(self.frames[f-self.framesfrom], ...)
	else
		self:init(f,state)
	end
end

function tickable_mt:getFrame(f)
	f=math.floor(f)
	self:genFrame(f+1)
	return self.frames[f-self.framesfrom], self.frames[f-self.framesfrom+1]
end

function tickable_mt:lerp(f)
	return self:getFrame(math.floor(f))
end