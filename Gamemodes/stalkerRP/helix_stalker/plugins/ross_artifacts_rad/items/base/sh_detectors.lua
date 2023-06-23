
ITEM.name = "Детектор"
ITEM.description = "Детектор"
ITEM.category = "Детекторы"
ITEM.model = "models/Gibs/HGIBS.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.weight = 0.3

if (CLIENT) then
	function ITEM:PaintOver(item, w, h)
		if (item:GetData("toggled")) then
			surface.SetDrawColor(110, 255, 110, 100)
			surface.DrawRect(w - 14, h - 14, 8, 8)
		end
	end
end

function ITEM.postHooks.drop(item, status)
	item:SetData("toggled", false)
end

ITEM.functions.Toggle = {
	name = 'Переключить',
	OnRun = function(itemTable)
		local character = itemTable.player:GetCharacter()
		local detectors = character:GetInventory():GetItemsByBase(itemTable.base, true)
		local bCanToggle = true

		if (#detectors > 1) then
			for k, v in ipairs(detectors) do
				if (v != itemTable and v:GetData("toggled", false)) then
					bCanToggle = false
					break
				end
			end
		end

		if (bCanToggle) then
			itemTable:SetData("toggled", !itemTable:GetData("toggled", false))
			itemTable.player:EmitSound("buttons/lever7.wav", 50, math.random(170, 180), 0.25)
		end

		return false
	end
}

function ITEM:OnTransferred(curInv, inventory)
	self:SetData("toggled", false)
end;