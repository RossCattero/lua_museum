local PLUGIN = PLUGIN;

function PLUGIN:CalcView(client, origin, angles, fov)
	local entity = client:getNetVar("grabRag")

	if !entity || (client:GetViewEntity() ~= client) then return end

	if (entity && Entity(entity) && !client:ShouldDrawLocalPlayer()) then
		local ent = Entity(entity)
		local index = ent:LookupAttachment("eyes")

		if (index) then
			local data = ent:GetAttachment(index)

			if (data) then
				view = view or {}
				view.origin = data.Pos
				view.angles = data.Ang
			end
			
			return view
		end
	end

	return view
end