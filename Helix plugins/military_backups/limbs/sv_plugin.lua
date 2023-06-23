local PLUGIN = PLUGIN;

netstream.Hook("LIMB_ACTION", function(target, action, bone, inj)
	if LIMB.ACTIONS && LIMB.ACTIONS[action] then LIMB.ACTIONS[action](target, bone, inj) end
end)

netstream.Hook("Limbs::health", function(client, bone, itemID, isLocal)
	local trace = client:Tracer(128)
	local ent = trace.Entity;
	local target = !isLocal && ent:IsValid() && ent:IsPlayer() && ent || isLocal && client || nil

	if !target || !target:Alive() then 
		netstream.Start(client, "Limbs::ClosePanel")
		return 
	end;
	
	local char = client:GetCharacter();
	local inv = char:GetInventory();
	local item = inv:GetItemByID(itemID);

	if item && !target:UnActive() then

		client:SetLocalVar("isHealing", true)

		client:SetAction("", item.useTime || 5, 
		function()
			item:Use(target, bone)
			client:SetLocalVar("isHealing", false)
		end)
		local healText = "Heal"..target:SteamID()
		timer.Create(healText, 1, item.useTime || 5, function()
			if target != client && client:Tracer(128).Entity != target then
				client:SetLocalVar("isHealing", false)
				client:Notify("Вы должны смотреть на цель!")
				client:SetAction(false);
				timer.Remove(healText)
				return;
			end;
			
			// У персонажа должны быть пустые руки
			if !target:IsValid() || !target:Alive() || client:GetActiveWeapon():GetClass() != "ix_hands" then
				client:Notify("Ваши руки заняты!")
				timer.Remove(healText)
				client:SetAction(false);
				client:SetLocalVar("isHealing", false)
			end
		end)
		
	end
end)

netstream.Hook("Limb::AddCharacterToReco", function(client, id)
	local char = client:GetCharacter()
	local reco = char:GetData("reco", {})

	local findCharacter = ix.char.loaded[id];

	if !findCharacter then return end;

	if char:DoesRecognize(findCharacter) then
		reco[id] = !reco[id] && true || nil;
	end
	
	char:SetData("reco", reco)
	client:SetLocalVar("reco", reco)
	client:SetNetVar("reco", reco)
end)

/*
	TODO:

	Инфицирование после входа, проверка таймера
	Снимание повязок
	Убирание инфекции после принятия нужных таблеток
	
	Игрок должен сам подняться, если у него мало шока, достаточно крови и не слишком много боли
	Если игрок прыгает при переломах кости, то ему становится больно
	Сделать проверку на количество шока, чтобы игрок мог подняться
	Тряска рук от боли
	Автообновление при лечении, удалении повреждений
*/