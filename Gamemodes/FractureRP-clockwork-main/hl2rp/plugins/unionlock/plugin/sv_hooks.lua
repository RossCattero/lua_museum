local PLUGIN = PLUGIN;

-- Called when Clockwork has loaded all of the entities.
function PLUGIN:ClockworkInitPostEntity()
	self:LoadUnionLocks();
end;

-- Called just after data should be saved.
function PLUGIN:PostSaveData()
	self:SaveUnionLocks();
end;

-- Called when a player attempts to lock an entity.
function PLUGIN:PlayerCanLockEntity(player, entity)
	if (Clockwork.entity:IsDoor(entity) and IsValid(entity.unionLock)) then
		if (Clockwork.config:Get("union_lock_overrides"):Get() or entity.unionLock:IsLocked()) then
			return false;
		end;
	end;
end;

-- Called when a player attempts to unlock an entity.
function PLUGIN:PlayerCanUnlockEntity(player, entity)
	if (Clockwork.entity:IsDoor(entity) and IsValid(entity.unionLock)) then
		if (Clockwork.config:Get("union_lock_overrides"):Get() or entity.unionLock:IsLocked()) then
			return false;
		end;
	end;
end;

-- Called when a player attempts to use an entity.
function PLUGIN:PlayerUse(player, entity)
	local overlayText = entity:GetNetworkedString("GModOverlayText");
	local curTime = CurTime();
	local faction = player:GetFaction();
	
	if (player:KeyDown(IN_SPEED) and Clockwork.entity:IsDoor(entity)) then
		if ((Schema:PlayerIsCombine(player) or player:GetFaction() == FACTION_ADMIN or player:HasItemByID("union_card")) and IsValid(entity.unionLock)) then
			if (!player.nextUnionLock or curTime >= player.nextUnionLock) then
				entity.unionLock:ToggleWithChecks(player);
				
				player.nextUnionLock = curTime + 3;
			end;
			
			return false;
		end;
	end;
end;

-- Called when an entity has been breached.
function PLUGIN:EntityBreached(entity, activator)
	if (Clockwork.entity:IsDoor(entity)) then
		if (!IsValid(entity.unionLock)) then
			if (!IsValid(activator) or string.lower( entity:GetClass() ) != "prop_door_rotating") then
				Clockwork.entity:OpenDoor(entity, 0, true, true);
			else
				self:BustDownDoor(activator, entity);
			end;
		elseif (IsValid(activator) and activator:IsPlayer() and Schema:PlayerIsCombine(activator)) then
			if (string.lower( entity:GetClass() ) == "prop_door_rotating") then
				entity.unionLock:ActivateSmokeCharge( (entity:GetPos() - activator:GetPos() ):GetNormal() * 10000 );
			else
				entity.unionLock:SetFlashDuration(2);
			end;
		else
			entity.unionLock:SetFlashDuration(2);
		end;
	end;
end;