
local PLUGIN = PLUGIN;

function PLUGIN:EntityHandleMenuOption(player, entity, option, arguments)
	local ec = entity:GetClass();

	if (ec == "ross_cp_callmonitor" && entity:GetTurn() == false && arguments == "r_monitor_on") then
        self:SetTurn(true);
    elseif (ec == "ross_cp_callmonitor" && entity:GetTurn() == true && arguments == "r_monitor_off") then
        self:SetTurn(false);
    end;

end;

function Schema:PostPlayerSpawn(player, lightSpawn, changeClass, firstSpawn)
    if (!lightSpawn) then
        local citizenData = player:GetCharacterData("CitizenInfo")
		
        if (!player:HasItemByID("citizen_civ_card") && !player:GetCharacterData("GivenCitizenCard") && !Schema:PlayerIsCombine(player)) then
            player:GiveItem(Clockwork.item:CreateInstance("citizen_civ_card"));
            player:SetCharacterData("GivenCitizenCard", true);
            if player:FindItemByID("citizen_civ_card") then
                player:FindItemByID("citizen_civ_card"):GetData("CardInformation")["OwnerName"] = player:Name();
                player:FindItemByID("citizen_civ_card"):GetData("CardInformation")["OwnerCID"] = player:GetCharacterData("CitizenID")
                citizenData["parentedCardNumber"] = player:FindItemByID("citizen_civ_card").ItemID;
            end;
        end;
        
	end;
	
end;