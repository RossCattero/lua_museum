local PLUGIN = PLUGIN;


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