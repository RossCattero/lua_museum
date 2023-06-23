local PLUGIN = PLUGIN
local user = FindMetaTable("Player")

function user:SortInjuries(limb)
	local data = self:GetCharacter():GetData("Limbs")
	data = data[limb];

	local buffer = {}
	for k, v in pairs(data) do
		buffer[#buffer + 1] = v;
	end

	data[limb] = buffer;
end