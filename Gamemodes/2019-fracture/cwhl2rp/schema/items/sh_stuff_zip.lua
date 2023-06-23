--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();

ITEM.name = "Стяжки";
ITEM.uniqueID = "zip_tie";
ITEM.model = "models/items/crossbowrounds.mdl";
ITEM.weight = 0.2;
ITEM.useText = "Связать";
ITEM.category = "Прочее";
ITEM.description = "Прочные стяжки, имеют большое применение.";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	if (player.isTying) then
		Clockwork.player:Notify(player, {"AlreadyTyingCharacter"});
		
		return false;
	else
		local trace = player:GetEyeTraceNoCursor();
		local target = Clockwork.entity:GetPlayer(trace.Entity);
		
		if (target) then
			if (target:GetSharedVar("IsTied") == 0) then
				if (target:GetShootPos():Distance(player:GetShootPos()) <= 192) then
					if (target:GetAimVector():DotProduct(player:GetAimVector()) > 0 or target:IsRagdolled()) then
						Clockwork.player:SetAction(player, "IsTied", 10);
						
						Clockwork.player:EntityConditionTimer(player, target, trace.Entity, 10, 192, function()
							if (player:Alive() and !player:IsRagdolled() and target:GetSharedVar("IsTied") == 0
							and target:GetAimVector():DotProduct(player:GetAimVector()) > 0) then
								return true;
							end;
						end, function(success)
							if (success) then
								player.isTying = nil;
								
								Schema:TiePlayer(target, true, nil, Schema:PlayerIsCombine(player));
								
								if (Schema:PlayerIsCombine(target)) then
									local location = Schema:PlayerGetLocation(player);
									
									Schema:AddCombineDisplayLine("DownloadingLostRadioInfo", Color(255, 255, 255, 255), nil, player);
									Schema:AddCombineDisplayLine({"RadioContactLostForUnit", location}, Color(255, 0, 0, 255), nil, player);
								end;
								
								player:TakeItem(self);
							else
								player.isTying = nil;
							end;
							
							Clockwork.player:SetAction(player, "IsTied", false);
						end);
					else
						Clockwork.player:Notify(player, {"CannotTieThoseFacingYou"});
						
						return false;
					end;
					
					player.isTying = true;
					
					Clockwork.player:SetMenuOpen(player, false);
					
					return false;
				else
					Clockwork.player:Notify(player, {"CharacterTooFarAway"});
					
					return false;
				end;
			else
				Clockwork.player:Notify(player, {"CharacterAlreadyTied"});
				
				return false;
			end;
		else
			Clockwork.player:Notify(player, {"MustLookAtValidTarget"});
			
			return false;
		end;
	end;
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position)
	if (player.isTying) then
		Clockwork.player:Notify(player, {"YouAreCurrentlyTying"});
		
		return false;
	end;
end;

ITEM:Register();