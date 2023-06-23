local PLUGIN = PLUGIN;

ADDJOB_SETTINGS = ADDJOB_SETTINGS or {
	lastJob = 0
}

netstream.Hook('jobVendor::openInterface', function()
		if VENDOR_INTERFACE && VENDOR_INTERFACE:IsValid() then
				VENDOR_INTERFACE:Close()
		end

		VENDOR_INTERFACE = vgui.Create("TalkerVendor")
		VENDOR_INTERFACE:Populate()
end);

netstream.Hook('jobVendor::addJobPlace', function(data)
		POSES = data;

		if VENDOR_INTERFACE && VENDOR_INTERFACE:IsValid() then
				VENDOR_INTERFACE:Close()
		end

		VENDOR_INTERFACE = vgui.Create("AddJobPlace")
		VENDOR_INTERFACE:Populate()
end);

netstream.Hook('jobVendor::updateRemoveList', function(data)
		if VENDOR_INTERFACE && VENDOR_INTERFACE:IsValid() then
				POSES = data; 
				VENDOR_INTERFACE.bgRemove:Refresh(POSES)
		end
end);

netstream.Hook('jobVendor::callPosAmount', function(data)
		JOBPOSES = data;
end);

netstream.Hook('jobVendor::sendTheEntity', function(ent)
		HALO_SEARCH = ent;
end);

netstream.Hook('jobVendor::stopJobTimer', function()
		local user = LocalPlayer();
		if user:WorkInProgress() then
				timer.Remove("WorkTime: " .. user:getChar():getID())
		end
end);


hook.Add( "PreDrawHalos", "jobVendor::searchHalo", function()
		if HALO_SEARCH then
				halo.Add( {HALO_SEARCH}, Color(255, 100, 100, 255), 0, 0, 10, true, true )
		end;
end)

hook.Add( "PostDrawTranslucentRenderables", "jobVendor::drawObjText", function()

		if !LocalPlayer():getChar() then return end;

		local job = LocalPlayer():GetJobID();
		if job == 0 || !HALO_SEARCH then return end;
		
		local pos = HALO_SEARCH:GetPos()
		local text = LocalPlayer():GetJobName():upper();
		local tpos = pos + Vector(0, 0, 10);
		local toscreen = tpos:ToScreen()
		local meters = math.Round( tpos:Distance( LocalPlayer():GetPos() ) / 28 ) .. " m"
		local uniqueID = "WorkTime: " .. LocalPlayer():getChar():getID();

		cam.Start2D()
				draw.SimpleText(text, "JobHighlight", toscreen.x, toscreen.y, color_white, 1 )
				if timer.Exists(uniqueID) then
						local time = string.FormattedTime( timer.RepsLeft(uniqueID), "%02i:%02i:%02i" )
						
						draw.SimpleText(time, "JobHighlight", toscreen.x, toscreen.y+30, color_white, 1 )
				end;
				draw.SimpleText(meters, "JobHighlight", toscreen.x, toscreen.y+60, color_white, 1 )
		cam.End2D()
end)