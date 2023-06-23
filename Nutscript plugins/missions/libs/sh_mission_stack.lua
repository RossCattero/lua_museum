nut.mission = nut.mission or {};
nut.mission.stack = nut.mission.stack or {};
nut.mission.stack.instances = nut.mission.stack.instances or {};

function nut.mission.stack.New(charID, data)
	local stack = setmetatable({}, nut.meta.stack)
		stack.charID = charID or 0
		for k, v in pairs(data) do
			if v != nil then
				stack[ k ] = v;
			end;
		end;
	return stack
end

function nut.mission.stack.Instance(charID, data)
	if !data then data = {} end;

	data.list = data.list or {};
	data.cooldowns = data.cooldowns or {};
	nut.mission.stack.instances[ charID ] = nut.mission.stack.New(charID, data)

	return nut.mission.stack.instances[ charID ];
end;