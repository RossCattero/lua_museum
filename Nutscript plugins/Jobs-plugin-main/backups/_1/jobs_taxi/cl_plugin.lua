local PLUGIN = PLUGIN;

TAXI = TAXI or {}
TAXI.orders = TAXI.orders or {}

TAXI_SECONDS = TAXI_SECONDS or 0;

netstream.Hook('taxi::phone', function()
		if TAXI.interface && TAXI.interface:IsValid() then TAXI.interface:Close() end;

		TAXI.interface = vgui.Create("Taxi")
		TAXI.interface:Populate()
end);

netstream.Hook('taxi::talkVendor', function()
		if TAXI.interface && TAXI.interface:IsValid() then TAXI.interface:Close() end;

		TAXI.interface = vgui.Create('TaxiVendor')
		TAXI.interface:Populate()
end);

netstream.Hook('taxi::syncTaxiData', function(data)
		if LocalPlayer():GotCustomer() then return; end
		TAXI.orders = data;

		local interface = TAXI.interface
		if !interface then return; end;
		
		local app = TAXI.interface.openedApp;

		if app && app:IsValid() then
			local openedApp = app.app; // Opened database app;
			if openedApp.tasksList && openedApp.tasksList:IsValid() then 
					openedApp:ReloadOrders()
			end;
		end
end);

netstream.Hook('taxi::clearClientside', function()
		LocalPlayer():StopTaxiSearch()

		if TAXI.interface && TAXI.interface:IsValid() then
				local app = TAXI.interface.openedApp;
				
				if app && app:IsValid() then
						local order = app.app;
						if order.taxiInfo then
								order:HideElements(true)
						end
				end
		end
end);

netstream.Hook('taxi::OrderSet', function(data)
		if !data then
				local interface = TAXI.interface
				if !interface then return; end;
				
				local app = TAXI.interface.openedApp;

				if app && app:IsValid() then
					local openedApp = app.app; // Opened database app;
					if openedApp.tasksList && openedApp.tasksList:IsValid() then 
							openedApp.tasksList:Clear()
							openedApp:ReloadOrders()
					end;
				end
				return;
		end

		TAXI.orders = data;

		local interface = TAXI.interface
		if !interface then return; end;
		
		local app = TAXI.interface.openedApp;

		if app && app:IsValid() then
			local openedApp = app.app; // Opened database app;
			if openedApp.tasksList && openedApp.tasksList:IsValid() then 
					openedApp.tasksList:Clear()
					openedApp:SetOrderData()
			end;
		end
end);