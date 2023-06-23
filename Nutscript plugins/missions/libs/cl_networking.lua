netstream.Hook("nut.mission.stack.sync", function(data)
	nut.mission.stack.Instance(data.charID, data)
end)

netstream.Hook("nut.mission.sync", function(id, data)
	nut.mission.Instance( id, data.uniqueID, data.charID, data )

	nut.mission.RefreshUI()
end)

netstream.Hook("nut.mission.remove", function(id)
	nut.mission.instances[ id ] = nil;

	nut.mission.RefreshUI()
end)

netstream.Hook("nut.mission.openUI", function( )
	if nut.mission.derma && nut.mission.derma:IsValid() then
		nut.mission.derma:Close()
	end

	nut.mission.derma = vgui.Create("MissionsList")
	nut.mission.derma:Refresh()
end)