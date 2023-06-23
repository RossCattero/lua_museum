local PLUGIN = PLUGIN;

local user = FindMetaTable("Player")

--[[
user:setActionMoving("Action", 1, 
function() 
end, function()
end)
]]--
-- Performs a delayed action on a player, remaked;
function user:setActionMoving(text, time, callback, cancel, startTime, finishTime)
	if (time and time <= 0) && cancel && cancel(self) then
		if (callback) then
			callback(self)
		end
		return
	end

	time = time or 5
	startTime = startTime or CurTime()
	finishTime = finishTime or (startTime + time)

	if (text == false) then
		timer.Remove("nutMovAct" .. self:UniqueID())
		netstream.Start(self, "actBar")
		return
	end

	netstream.Start(self, "actBar", startTime, finishTime, text)

	if (callback) then
		timer.Create("nutMovAct" .. self:UniqueID(), 1, time, function()
			if cancel && !cancel(self) then
					timer.Remove("nutMovAct" .. self:UniqueID())
					netstream.Start(self, "actBar")
					return
			end
			if (IsValid(self)) && timer.RepsLeft("nutMovAct" .. self:UniqueID()) < 1 && ((cancel && cancel(self)) || !cancel) then
				callback(self)
			end
		end)
	end
end

function user:DoingMovAction()
		return timer.Exists("nutMovAct" .. self:UniqueID())
end;