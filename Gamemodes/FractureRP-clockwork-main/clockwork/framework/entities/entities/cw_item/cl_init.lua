--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).

	Clockwork was created by Conna Wiles (also known as kurozael.)
	http://cloudsixteen.com/license/clockwork.html
--]]

include("shared.lua")

-- Called when the target ID HUD should be painted.
function ENT:HUDPaintTargetID(x, y, alpha)
	if (Clockwork.entity:HasFetchedItemData(self)) then
		local itemTable = Clockwork.entity:FetchItemTable(self);

		if (Clockwork.plugin:Call("PaintItemTargetID", x, y, alpha, itemTable)) then
			local colorTargetID = Clockwork.option:GetColor("target_id");
			local colorWhite = Clockwork.option:GetColor("white");
			local color = itemTable("color") or colorTargetID;
			
			y = Clockwork.kernel:DrawInfo(L(itemTable("name")), x, y, color, alpha);
			
			if (itemTable.OnHUDPaintTargetID) then
				local newY = itemTable:OnHUDPaintTargetID(self, x, y, alpha);
				
				if (newY == false) then
					return;
				end;
				
				if (type(newY) == "number") then
					y = newY;
				end;
			end;
			
			y = Clockwork.kernel:DrawInfo(itemTable("weightText", itemTable("weight").."kg"), x, y, colorWhite, alpha);
			
			local spaceUsed = itemTable("space");
			if (Clockwork.inventory:UseSpaceSystem() and spaceUsed > 0) then
				y = Clockwork.kernel:DrawInfo(itemTable("spaceText", spaceUsed.."l"), x, y, colorWhite, alpha);
			end

			if itemTable:IsBasedFrom('food_base') then
				local portions = itemTable:GetData("useAmount");
				local canGar = itemTable.canBeGarbaged;
				if portions > 0 then
					y = Clockwork.kernel:DrawInfo("Количество порций: "..portions, x, y, Color(190, 150, 150), alpha);
				elseif canGar && portions == 0 then
					y = Clockwork.kernel:DrawInfo("Мусор.", x, y, Color(190, 150, 150), alpha);
				end;
			end;
			if itemTable:IsBasedFrom('clothes_base') then
				local one_text, one_color = itemTable:GetQuality();
				local two_text, two_color = itemTable:GetArmor();
				local three_text, three_color = itemTable:IsWarming();
				y = Clockwork.kernel:DrawInfo("Качество одежды: "..tostring(one_text), x, y, one_color, alpha);
				if (itemTable:GetData('Armor') > 0) then
					y = Clockwork.kernel:DrawInfo("Качество брони: "..tostring(two_text), x, y, two_color, alpha);
				end;
				y = Clockwork.kernel:DrawInfo("Качество обогревания: "..tostring(three_text), x, y, three_color, alpha);
				if itemTable.allowBattery then
					y = Clockwork.kernel:DrawInfo("Индикатор батареи: "..tostring( self:GetData('Battery') ), x, y, Color(100, 100, 255), alpha);
				end;
			end;
			
		end;
	end;
end;

-- Called each frame.
function ENT:Think()
	if (!Clockwork.entity:HasFetchedItemData(self)) then
		Clockwork.entity:FetchItemData(self);
		return;
	end;
	
	local itemTable = Clockwork.entity:FetchItemTable(self);
	
	if (itemTable.OnEntityThink) then
		local nextThink = itemTable:OnEntityThink(self);
		
		if (type(nextThink) == "number") then
			self:NextThink(CurTime() + nextThink);
		end;
	end;
	
	Clockwork.plugin:Call("ItemEntityThink", itemTable, self);
end;

-- Called when the entity should draw.
function ENT:Draw()
	if (!Clockwork.entity:HasFetchedItemData(self)) then
		return;
	end;
	
	local drawModel = true;
	local itemTable = Clockwork.entity:FetchItemTable(self);
	local shouldDrawItemEntity = Clockwork.plugin:Call("ItemEntityDraw", itemTable, self);
	
	if (shouldDrawItemEntity == false
	or (itemTable.OnDrawModel and itemTable:OnDrawModel(self) == false)) then
		drawModel = false;
	end;
	
	if (drawModel) then
		self:DrawModel();
	end;
end;