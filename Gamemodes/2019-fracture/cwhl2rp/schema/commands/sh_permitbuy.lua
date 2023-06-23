--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local COMMAND = Clockwork.command:New("PermitBuy");
COMMAND.tip = "Purchase a permit for your character.";
COMMAND.text = "<string Name>";
COMMAND.flags = "s";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if (Clockwork.config:Get("permits"):Get()) then
		if (player:GetFaction() == FACTION_CITIZEN) then
			if (Clockwork.player:HasFlags(player, "x")) then
				local permits = {};
				local permit = string.lower( arguments[1] );
				
				for k, v in pairs( Clockwork.item:GetAll() ) do
					if (v.cost and v.access and !Clockwork.kernel:HasObjectAccess(player, v)) then
						if (string.find(v.access, "1")) then
							permits.generalGoods = (permits.generalGoods or 0) + (v.cost * v.batch);
						else
							for k2, v2 in pairs(Schema.customPermits) do
								if (string.find(v.access, v2.flag)) then
									permits[v2.key] = (permits[v2.key] or 0) + (v.cost * v.batch);
									
									break;
								end;
							end;
						end;
					end;
				end;
				
				if (table.Count(permits) > 0) then
					for k, v in pairs(permits) do
						if (string.lower(k) == permit) then
							local cost = v;
							
							if (Clockwork.player:CanAfford(player, cost)) then
								if (permit == "generalgoods") then
									Clockwork.player:GiveCash(player, -cost, "buying general goods permit");
									Clockwork.player:GiveFlags(player, "1");
								else
									local permitTable = Schema.customPermits[permit];
									
									if (permitTable) then
										Clockwork.player:GiveCash(player, -cost, "buying "..string.lower(permitTable.name).." permit");
										Clockwork.player:GiveFlags(player, permitTable.flag);
									end;
								end;
								
								timer.Simple(0.5, function()
									if (IsValid(player)) then
										Clockwork.datastream:Start(player, "RebuildBusiness", true);
									end;
								end);
							else
								local amount = cost - player:QueryCharacter("cash");
								Clockwork.player:Notify(player, "You need another "..Clockwork.kernel:FormatCash(amount, nil, true).."!");
							end;
							
							return;
						end;
					end;
					
					if (permit == "generalgoods" or Schema.customPermits[permit]) then
						Clockwork.player:Notify(player, "You already have this permit!");
					else
						Clockwork.player:Notify(player, "This is not a valid permit!");
					end;
				else
					Clockwork.player:Notify(player, "You already have this permit!");
				end;
			elseif (string.lower( arguments[1] ) == "business") then
				local cost = Clockwork.config:Get("business_cost"):Get();
				
				if (Clockwork.player:CanAfford(player, cost)) then
					Clockwork.player:GiveCash(player, -cost, "buying business permit");
					Clockwork.player:GiveFlags(player, "x");
					
					timer.Simple(0.25, function()
						if (IsValid(player)) then
							Clockwork.datastream:Start(player, "RebuildBusiness", true);
						end;
					end);
				else
					local amount = cost - player:QueryCharacter("cash");
					Clockwork.player:Notify(player, "You need another "..Clockwork.kernel:FormatCash(amount, nil, true).."!");
				end;
			else
				Clockwork.player:Notify(player, "This is not a valid permit!");
			end;
		else
			Clockwork.player:Notify(player, "You are not a citizen!");
		end;
	else
		Clockwork.player:Notify(player, "The permit system has not been enabled!");
	end;
end;

COMMAND:Register();