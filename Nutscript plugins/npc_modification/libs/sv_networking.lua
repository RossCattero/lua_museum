netstream.Hook("nut.rossnpc.updateData", function(client, index, data)
	local isAdmin = client:IsAdmin();
	if isAdmin then
		local entity = Entity(tonumber(index))
		if IsValid(entity) && entity.Base == "base_ross_npc" then
			entity:SetData( data )
		end;
	else
		client:notify("You don't have access to this menu!")
	end;
end)