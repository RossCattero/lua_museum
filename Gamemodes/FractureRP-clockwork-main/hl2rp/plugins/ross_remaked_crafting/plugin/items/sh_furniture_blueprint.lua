local ITEM = Clockwork.item:New(nil, true);
ITEM.name = "furniture_Base";
ITEM.uniqueID = "furniture_base";
ITEM.model = "models/props_c17/paper01.mdl";
ITEM.furmodel = "models/props_c17/oildrum001.mdl";
ITEM.weight = 50;
ITEM.useText = "Разложить чертеж";
ITEM.category = "Мебель";
ITEM.blueprint = {
	["items"] = {},
	["instruments"] = {}
};

local function GetStuffNearE(entity, radius)
	local trace = entity:GetEyeTraceNoCursor();

	for k, v in ipairs( ents.FindInSphere(trace.HitPos, radius) ) do
		if v:IsValid() && v:GetClass() == "ross_fur_base" && v:GetNWBool("IsFurniture") then
			return true
		end;
	end;
	return false;
end;

function ITEM:OnUse(player, itemEntity)
	local tr = player:GetEyeTrace();

	if self.blueprint["items"] == nil then
		return;	
	end;

	Clockwork.player:SetAction(player, "WrappingOutBP", 3);
	Clockwork.player:ConditionTimer(player, 3, function()
		if (!player:Alive() || player:GetVelocity():Length() > 0) then
			return false;
		end;
		return true;
	end, function()
		if !GetStuffNearE(player, 90) && player:GetShootPos():Distance(tr.HitPos) <= 256 then
			local entity = ents.Create("ross_fur_base");
			entity:SetModel(self("furmodel"));
			entity:SetPos(tr.HitPos + tr.HitNormal + Vector(0, 0, 30));
			entity:SetAngles(player:GetAngles() + Angle(0, 180, 0));
			entity:SetCollisionGroup( 11 );
			entity:SetNWBool("IsFurniture", true);
			entity:SetNWString("unID", self.uniqueID);
			entity.blueprint = self.blueprint;
			entity:Spawn();
			entity:SetMaterial("models/wireframe");
			entity:SetColor(Color(255, 100, 100))
			
			local physObj = entity:GetPhysicsObject();
	
			if (IsValid(physObj)) then
				physObj:EnableMotion(false);
				physObj:Sleep();
			end;
	
			player:TakeItem(self)
		end;
		Clockwork.player:SetAction(player, "WrappingOutBP", false);
	end);

	return false;
end;

function ITEM:OnDrop(player, position) 
end;

Clockwork.item:Register(ITEM);