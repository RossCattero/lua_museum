local PLUGIN = PLUGIN;

function PLUGIN:LoadData()

	self:LoadCoffeeTerminals()
end

function PLUGIN:SaveData()
	self:SaveCoffeeTerminals()
end

function PLUGIN:SaveCoffeeTerminals()
	local data = {}

	for _, v in ipairs(ents.FindByClass("r_coffee_machine")) do
			data[#data + 1] = {
                position = v:GetPos(),
                angles = v:GetAngles()
			}
	end

	ix.data.Set("CoffeeTerminals", data)
end
function PLUGIN:LoadCoffeeTerminals()
	for _, v in ipairs(ix.data.Get("CoffeeTerminals") or {}) do
		local terminal = ents.Create("r_coffee_machine")
        terminal:SetPos(v.position)
        terminal:SetAngles(v.angles)
		terminal:Spawn()
	end
end