
local PLUGIN = PLUGIN;

local player = FindMetaTable( "Player" )

function player:HasBackpack()
	local items = Clockwork.inventory:GetAsItemsList(self:GetInventory());

	for k, v in ipairs(items) do
		if v.baseItem == "ross_backpack_base" && v:GetData("Used") == true then
			return true;
		end;
	end;
	return false;
end;

function player:CreateBackpackEntity(model)
    if (!IsValid(self)) then 
		return;
	end;

	local bone = self:LookupBone("ValveBiped.Bip01_Spine")
	local ragdollEntity = self:GetRagdollEntity();
	local position, angles = self:GetBonePosition(bone);
		
	if (ragdollEntity) then
		position, angles = ragdollEntity:GetBonePosition(bone);
	end;
		
	local x = angles:Up() * -0.4
	local y = angles:Right() * -15
    local z = angles:Forward() * 25
		
	angles:RotateAroundAxis(angles:Forward(), 0);
	angles:RotateAroundAxis(angles:Right(), 180);
	angles:RotateAroundAxis(angles:Up(), 90);

	self.backpack = ents.Create("attachment_backpack");
    self.backpack:SetPos( position + x + y + z );
    self.backpack:SetAngles(angles);
	self.backpack:SetParent(self);
    self.backpack:FollowBone( self, bone );
	self.backpack:SetCollisionGroup( 20 );
	self.backpack:SetModel(model);
    self.backpack:Spawn();
end;

function PLUGIN:PlayerSaveCharacterData(player, data)
	if (data["BackpacksComp"]) then
		data["BackpacksComp"] = data["BackpacksComp"];
	else
	      data["BackpacksComp"] = {
			  min = 0,
			  max = 5
		  };
	end;
end;

function PLUGIN:PlayerRestoreCharacterData(player, data)
	if ( !data["BackpacksComp"] ) then
		data["BackpacksComp"] = {
			min = 0,
			max = 5
		};
    end;
end;

function PLUGIN:PlayerThink(player, curTime, infoTable)
	if !player:HasBackpack() then
		if player:GetInventoryWeight() >= player:GetMaxWeight() then
			infoTable.walkSpeed = infoTable.walkSpeed - player:GetInventoryWeight()/10
			infoTable.crouchedSpeed = infoTable.crouchedSpeed - player:GetInventoryWeight()/10
			infoTable.jumpPower = infoTable.jumpPower - player:GetInventoryWeight()/10
			infoTable.runSpeed = infoTable.runSpeed - player:GetInventoryWeight()/10
		end;
	elseif player:HasBackpack() then
		infoTable.walkSpeed = infoTable.walkSpeed - player:GetInventoryWeight()/100
		infoTable.crouchedSpeed = infoTable.crouchedSpeed - player:GetInventoryWeight()/100
		infoTable.jumpPower = infoTable.jumpPower - player:GetInventoryWeight()/100
		infoTable.runSpeed = infoTable.runSpeed - player:GetInventoryWeight()/100
	end;
end;
