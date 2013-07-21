local tickable_mt={}
tickable = {}
tickable.NILSTATE = 1
tickable.all = {}
tickable.currentFrame = 0

function tickable.new(f, state)
	local self = setmetatable({},{__index=tickable_mt})
	self.maxFrames = global.MAXFRAMES
	self.defaultFrame = state or tickable.NILSTATE
	table.insert(tickable.all,self)
	return self
end

function tickable_mt:init(f, state)
	self.frames = {(state or tickable.NILSTATE)}
	self.framesfrom = (f or 1) - 1
end

function tickable_mt:tick(frame)
	return tickable.NILSTATE
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

function tickable_mt:serialize(f)
	local s = ""
	local state = self:getFrame(f)
	s = s..f.." "..DataDumper(state)
	return s
end

function tickable_mt:applyToFrame(f, func, ...)
	--print(f,self.framesfrom,self.framesfrom+#self.frames)
	while f<=self.framesfrom-3 do
		table.insert(self.frames, 1, self.defaultFrame)
		self.framesfrom = self.framesfrom-1
	end
	--print(f,self.framesfrom,self.framesfrom+#self.frames)
	if f>self.framesfrom+#self.frames then
		self:genFrame(f)
	end
	if f>self.framesfrom and f<	self.framesfrom+global.MAXFRAMES then
		local to = #self.frames
		for i=f-self.framesfrom+1,to do
			self.frames[i]=nil
		end
		func(self.frames[f-self.framesfrom], ...)
	else
		
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