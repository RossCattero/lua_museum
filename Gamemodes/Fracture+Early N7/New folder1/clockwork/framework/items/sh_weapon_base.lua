local Clockwork = Clockwork;

local ITEM = Clockwork.item:New(nil, true);

ITEM.name = "Weapon Base";
ITEM.useText = "Использовать";
ITEM.useSound = false;
ITEM.category = "Оружие";
ITEM.useInVehicle = false;
ITEM.uniqueID = "weapon_base"

local defaultWeapons = {
	["weapon_357"] = {"357", nil, true},
	["weapon_ar2"] = {"ar2", "ar2altfire", 30},
	["weapon_rpg"] = {"rpg_round", nil, 3},
	["weapon_smg1"] = {"smg1", "smg1_grenade", true},
	["weapon_slam"] = {"slam", nil, 2},
	["weapon_frag"] = {"grenade", nil, 1},
	["weapon_pistol"] = {"pistol", nil, true},
	["weapon_shotgun"] = {"buckshot", nil, true},
	["weapon_crossbow"] = {"xbowbolt", nil, 4}
};

ITEM:AddData("ClipOne", 0, true);
ITEM:AddData("ClipTwo", 0, true);

-- Called to get whether a player has the item equipped.
function ITEM:HasPlayerEquipped(player, bIsValidWeapon)
	local weaponClass = self("weaponClass");
	
	if (SERVER) then
		local weapon = player:GetWeapon(weaponClass);
		local itemTable = Clockwork.item:GetByWeapon(weapon);
		
		if (itemTable and itemTable:IsTheSameAs(self)) then
			return true;
		end;
	end;
	
	if (CLIENT and bIsValidWeapon) then
		return true;
	end;
	
	return false;
end;

-- Called when a player attempts to holster the weapon.
function ITEM:CanHolsterWeapon(player, forceHolster, bNoMsg)
	return true;
end;

-- Called when the unequip should be handled.
function ITEM:OnHandleUnequip(Callback)
	if (self.OnDrop) then
		local menu = DermaMenu();
			menu:SetMinimumWidth(100);
			menu:AddOption("Снять", function()
				Callback();
			end);		
			menu:AddOption("Выкинуть", function()
				Callback("drop");
			end);
			if !self:GetData('FlashLight') then
				menu:AddOption("Повесить фонарик на оружие", function()
					Callback("flashie");
				end);
			end;
			menu:AddOption("Разрядить", function()
				Callback("Разрядить");
			end);
		menu:Open();
	end;
end;

-- Called when a player has unequipped the item.
function ITEM:OnPlayerUnequipped(player, extraData)
	local weapon = player:GetWeapon(self("weaponClass"));
	local carrywep = player:GetActiveWeapon()

	local ammocount = player:GetAmmoCount( carrywep.Primary.Ammo );
	if (!IsValid(weapon)) then return; end;
	
	local itemTable = Clockwork.item:GetByWeapon(weapon);
	
	if (itemTable:IsTheSameAs(self)) then
		local class = weapon:GetClass();

		if (extraData == "Разрядить") then 
			if (self:GetData("Mag") && player:GetInventoryWeight() + Clockwork.item:FindByID(self:GetData("NameMag")).weight <= player:GetMaxWeight()) then
				if self:GetData("ClipOne") > 0 && ammocount == 0 then
					player:GiveItem( Clockwork.item:CreateInstance(self:GetData("NameMag"), nil, {Clip = self:GetData("ClipOne")}) );
					player:RemoveAmmo(self:GetData("ClipOne"), carrywep.Primary.Ammo);
					self:SetData("ClipOne", 0);
					carrywep:SetClip1( 0 );
					carrywep:SetClip2( 0 );
				elseif ammocount >= 0 then
					
					player:GiveItem( Clockwork.item:CreateInstance(self:GetData("NameMag"), nil, {Clip = ammocount}) );
					player:RemoveAmmo(ammocount, carrywep.Primary.Ammo);					
					self:SetData("ClipTwo", 0);
					carrywep:SetClip1( 0 );
					carrywep:SetClip2( 0 );
				elseif player:GetInventoryWeight() + Clockwork.item:FindByID(self:GetData("NameMag")).weight > player:GetMaxWeight() then
					Clockwork.chatBox:SendColored(player, Color(255, 0, 0), "У вас недостаточно места в инвентаре!")
				else
					Clockwork.chatBox:SendColored(player, Color(255, 0, 0), "Это оружие не валидно!")
					return false;
				end;
				self:SetData("Mag", false);
				self:SetData("NameMag", "");
			end;

		elseif (extraData == "flashie") then 
			local flashlight = player:FindItemByID('cw_flashlight'); local tape = player:FindItemByID('materials_tape');

			if flashlight && tape then

				player:TakeItems({
					flashlight,
					tape
				})
				self:SetData('FlashLight', true);
				player:EmitSound('usesound/slot.mp3')

			else
				Clockwork.player:Notify(player, 'У вас нету фонарика или изоленты!')
			end;

		elseif (extraData != "drop") then
			if (Clockwork.plugin:Call("PlayerCanHolsterWeapon", player, self, weapon)) then
				if (player:GiveItem(self)) then
					Clockwork.plugin:Call("PlayerHolsterWeapon", player, self, weapon);
					if self:GetData("ClipOne") >= 0 && ammocount == 0 then
						self:SetData("ClipOne", self:GetData("ClipOne"));
						player:RemoveAmmo(itemTable:GetData("ClipOne"), carrywep.Primary.Ammo);
					end;
					if ammocount >= 0 && self:GetData("ClipOne") == 0 then
						self:SetData("ClipOne", ammocount);
						player:RemoveAmmo(ammocount, carrywep.Primary.Ammo);
					end;
					player:StripWeapon(class);
					player:SelectWeapon("cw_hands");
				end;
			end;
		elseif (Clockwork.plugin:Call("PlayerCanDropWeapon", player, self, weapon)) then
			local trace = player:GetEyeTraceNoCursor();
			
			if (player:GetShootPos():Distance(trace.HitPos) <= 192) then
				local entity = Clockwork.entity:CreateItem(player, self, trace.HitPos);
				
				if (IsValid(entity)) then
					Clockwork.entity:MakeFlushToGround(entity, trace.HitPos, trace.HitNormal);
					Clockwork.plugin:Call("PlayerDropWeapon", player, self, entity, weapon);
					player:TakeItem(self, true);

					if self:GetData("ClipOne") >= 0 && ammocount == 0 then
						self:SetData("ClipOne", self:GetData("ClipOne"));
						player:RemoveAmmo(itemTable:GetData("ClipOne"), carrywep.Primary.Ammo);
					end;
					if ammocount >= 0 && self:GetData("ClipOne") == 0 then
						self:SetData("ClipOne", ammocount);
						player:RemoveAmmo(ammocount, carrywep.Primary.Ammo);
					end;

					player:StripWeapon(class);
					player:SelectWeapon("cw_hands");
				end;
			else
				Clockwork.player:Notify(player, {"CannotDropWeaponFar"});
			end;
		end;
	end;
end;

-- A function to get whether the item has a secondary clip.
function ITEM:HasSecondaryClip()
	return !self("hasNoSecondaryClip");
end;

-- A function to get whether the item has a primary clip.
function ITEM:HasPrimaryClip()
	return !self("hasNoPrimaryClip");
end;

-- A function to get whether the item is a throwable weapon.
function ITEM:IsThrowableWeapon()
	return self("isThrowableWeapon");
end;

-- A function to get whether the item is a fake weapon.
function ITEM:IsFakeWeapon()
	return self("isFakeWeapon");
end;

-- A function to get whether the item is a melee weapon.
function ITEM:IsMeleeWeapon()
	return self("isMeleeWeapon");
end;

-- Called when the item is given to a player as a weapon.
function ITEM:OnWeaponGiven(player, weapon)

	local wip = player:GetActiveWeapon()
	local clipOne = self:GetData("ClipOne");
	local clipTwo = self:GetData("ClipTwo");
	
	if clipTwo > 0 then
		player:GiveAmmo(math.Clamp(clipTwo, 0, weapon:GetMaxClip1() ), weapon.Primary.Ammo)
	end;

	if (clipOne > 0) then
		weapon:SetClip1(clipOne);
	end;
	
	if (clipTwo > 0) then
		weapon:SetClip2(clipTwo);
	end;
end;

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	local weaponClass = self("weaponClass");
	if (!player:HasWeapon(weaponClass)) then
		player:Give(weaponClass, self);
		
		local weapon = player:GetWeapon(weaponClass);
		
		if (IsValid(weapon)) then
			if (self.OnEquip) then
				self:OnEquip(player);
			end;
			
			player:RebuildInventory();
		else
			return false;
		end;
	else
		local weapon = player:GetWeapon(weaponClass);
		
		if (IsValid(weapon) and self.OnAlreadyHas) then
			if (Clockwork.item:GetByWeapon(weapon) == self) then
				self:OnAlreadyHas(player);
			end;
		end;
		
		return false;
	end;
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

-- Called when the item should be setup.
function ITEM:OnSetup()
	if (!self("weaponClass")) then
		self:Override("weaponClass", self("uniqueID"));
	end;
	
	self:Override("weaponClass", string.lower(self("weaponClass")));
	
	timer.Simple(2, function()
		local weaponClass = self("weaponClass");
		local weaponTable = weapons.GetStored(weaponClass);
		
		if (weaponTable) then
			if (!self("primaryAmmoClass")) then
				if (weaponTable.Primary and weaponTable.Primary.Ammo) then
					self:Override("primaryAmmoClass", weaponTable.Primary.Ammo);
				end;
			end;
			
			if (!self("secondaryAmmoClass")) then
				if (weaponTable.Secondary and weaponTable.Secondary.Ammo) then
					self:Override("secondaryAmmoClass", weaponTable.Secondary.Ammo);
				end;
			end;
			
			if (!self("primaryDefaultAmmo")) then
				if (weaponTable.Primary and weaponTable.Primary.DefaultClip) then
					if (weaponTable.Primary.DefaultClip > 0) then
						if (weaponTable.Primary.ClipSize == -1) then
							self:Override("primaryDefaultAmmo", weaponTable.Primary.DefaultClip);
							self:Override("hasNoPrimaryClip", true);
						else
							self:Override("primaryDefaultAmmo", true);
						end;
					end;
				end;
			end;
			
			if (!self("secondaryDefaultAmmo")) then
				if (weaponTable.Secondary and weaponTable.Secondary.DefaultClip) then
					if (weaponTable.Secondary.DefaultClip > 0) then
						if (weaponTable.Secondary.ClipSize == -1) then
							self:Override("secondaryDefaultAmmo", weaponTable.Secondary.DefaultClip);
							self:Override("hasNoSecondaryClip", true);
						else
							self:Override("secondaryDefaultAmmo", true);
						end;
					end;
				end;
			end;
		elseif (defaultWeapons[weaponClass]) then
			if (!self("primaryAmmoClass")) then
				self:Override("primaryAmmoClass", defaultWeapons[weaponClass][1]);
			end;
			
			if (!self("secondaryAmmoClass")) then
				self:Override("secondaryAmmoClass", defaultWeapons[weaponClass][2]);
			end;
			
			if (!self("primaryDefaultAmmo")) then
				self:Override("primaryDefaultAmmo", defaultWeapons[weaponClass][3]);
			end;
			
			if (!self("secondaryDefaultAmmo")) then
				self:Override("secondaryDefaultAmmo", defaultWeapons[weaponClass][4]);
			end;
		end;
	end);
end;

-- Called when a player holsters the item.
function ITEM:OnHolster(player, bForced) 
end;

if (CLIENT) then
	function ITEM:GetClientSideInfo()
		if (!self:IsInstance()) then
			return;
		end;
		
		local clientSideInfo = "";
		local clipOne = self:GetData("ClipOne");
		local clipTwo = self:GetData("ClipTwo");
		
		if (clipOne > 0) then
			clientSideInfo = Clockwork.kernel:AddMarkupLine(clientSideInfo, L("ItemInfoClipOne", clipOne));
		end;
		
		if (clipTwo > 0) then
			clientSideInfo = Clockwork.kernel:AddMarkupLine(clientSideInfo, L("ItemInfoClipTwo", clipTwo));
		end;
		
		return (clientSideInfo != "" and clientSideInfo);
	end;
end;

Clockwork.item:Register(ITEM);