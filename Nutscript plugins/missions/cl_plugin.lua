local PLUGIN = PLUGIN;

function PLUGIN:PostDrawTranslucentRenderables()
	if !LocalPlayer():getChar() then return end;
	
	if next(nut.mission.instances) != nil then
		local entities = {};
		for id, mission in pairs(nut.mission.instances) do
			local ending = Entity(tonumber(mission.endPoint));
			if ending && !entities[mission.endPoint] then
				entities[mission.endPoint] = true;
				
				local position = ending:GetPos();
				local text = mission.name;
				local fixedPosition = position + Vector( 0, 0, 50 );
				local toScreen = fixedPosition:ToScreen();
				local meters = math.Round( fixedPosition:Distance( LocalPlayer():GetPos() ) / 28 ) .. " m"
				
				cam.Start2D()
					if mission.createTime then
						local time = string.FormattedTime( (mission.createTime + mission.finishTime) - os.time(), "%02i:%02i:%02i" )
						
						draw.SimpleText(time, "BankingTitle", toScreen.x, toScreen.y+30, color_white, 1 )
					end;
					draw.SimpleText(text, "BankingTitle", toScreen.x, toScreen.y, Color(210, 210, 210), 1 )
					draw.SimpleText(meters, "BankingTitle", toScreen.x, toScreen.y + 60, Color(210, 210, 210), 1 )
				cam.End2D()
			end;
		end;
	end;
end;

function PLUGIN:PreDrawHalos()
	local list = nut.mission.FindEntities( LocalPlayer() );
	if list && #list > 0 then
		halo.Add( list, Color(255, 100, 100, 255), 0, 0, 10, true, true )
	end;
end;