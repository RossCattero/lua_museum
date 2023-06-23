local PLUGIN = PLUGIN;

ITEM.name = "Geiger counter"
ITEM.description = "The geiger counter. It will signalize if user is in radiation area."
ITEM.category = 'Counters'
ITEM.model = Model("models/frp/props/models/datachik1.mdl");

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
	name = 'Toggle',
	OnRun = function(self)
		local client = self.player
		local togg = self:GetData("toggled", false)

		self:SetData("toggled", !togg)
		client:EmitSound("buttons/lever7.wav", 50, math.random(170, 180), 0.25)

		return false
	end,
	OnCanRun = function(self)
			local client = self.player
			local char = client:GetCharacter()
			local detectors = char:GetInventory():GetItemsByUniqueID(self.uniqueID, true)
			local i = #detectors;

			if (i > 1) then
					while (i > 0) do
							local detector = detectors[i];
							if detector != self && detector:GetData("toggled", false) then
									return false;
							end
							i = i - 1;
					end;
			end

			return true;
	end
}

function ITEM:OnTransferred(curInv, inventory)
		self:SetData("toggled", false)
end;