local PLUGIN = PLUGIN

function PLUGIN:PlayerLoadedCharacter(client, character, prev)
    timer.Simple(.25, function()
		// Переменная для данных игрока, которого осматривают
		client:SetLocalVar("inspChar", nil)
    end)
end

function PLUGIN:OnPlayerOptionSelected(target, client, option)
	if option == "Осмотреть" && target:CanBeMedicalObserved( client:GetCharacter():GetID() ) then
		local Limbs, BIO = target:GetLimbs(), target:GetBIO()
		client:SetLocalVar("inspChar", target)

		for k, v in pairs( INJURIES.INSTANCES ) do
			if tonumber(v.charID) == target:GetCharacter():GetID() then
				netstream.Start(client, "NETWORK_INJURY_INSTANCE", v.index, v:GetID(), v.data)
			end
		end
		local data = {
			Limbs = Limbs,
			Blood = BIO.blood,
			Pain = BIO.pain,
			Bleeding = BIO.bleed
		}

		netstream.Start(client, "OPEN_LIMBS_UI", data)
	end
end;

netstream.Hook("MED_RECOGNIZE_ADD", function(client, id)
	local character = client:GetCharacter()
	local chr = ix.char.loaded[id]

	if character:DoesRecognize(chr) && chr != character && !client:CanLookMed( id ) then
		client:AddLookMed( id )
	end
end);

netstream.Hook("LIMB_HEAL", function(client, itemID, bone, index)
	local target = client:IsInspectingCharacter() || client;

	if !target || !target:Alive() || target != client && !target:CanBeMedicalObserved( client:GetCharacter():GetID() ) then 
		netstream.Start(client, "CLOSE_LIMBS_UI")
		return 
	end;

	local char = client:GetCharacter();
	local inv = char:GetInventory();
	local item = inv:GetItemByID(itemID);

	if item then
		local healText = "Heal"..target:SteamID()
		
		client:SetLocalVar("isHealing", true)
		client:SetAction("", item.useTime || 5, 
		function()
			item:Heal(target, bone, index)
			client:SetLocalVar("isHealing", false)
		end)
		timer.Create(healText, .5, item.parameters && item.parameters.useTime || 5, function()
			local stop = false;

			if target != client && client:Tracer(128).Entity != target then
				stop = true;
			end;
			
			if !target:IsValid() || !target:Alive() || client:GetActiveWeapon():GetClass() != "ix_hands" then
				client:Notify("Ваши руки должны быть пустыми!")
				stop = true;
			end

			if stop then
				client:SetLocalVar("isHealing", false)
				client:SetAction(false);
				timer.Remove(healText)
			end
		end)
	end
end);

netstream.Hook("LIMB_HEAL_CLEAR", function(client, id)
	local target = client:IsInspectingCharacter() || client;

	if !target || !target:Alive() || target != client && !target:CanBeMedicalObserved( client:GetCharacter():GetID() ) then 
		netstream.Start(client, "CLOSE_LIMBS_UI")
		return 
	end;

	local wound = INJURIES.Find(id)
	if !wound then return end;

	local healed = wound:IsHealed();

	if healed != "" then
		local amount = wound:GetData("healAmount")

		if amount >= 100 then
			wound:Remove();
		else
			local item = ix.item.list[healed]
			local char = target:GetCharacter();
			local inventory = char:GetInventory()

			if item then
				inventory:Add(healed)
			end

			if item:CanStopBleeding() then
				target:Blood( 0, wound && wound:GetData("bleed", 0) )
			end;
			
			wound:SetData("expire", wound:GetData("expire") + (wound:GetData("healTime") - wound:GetData("occured")) )

			wound:Heal( false )
		end
		
	end;
end);