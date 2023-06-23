local user = FindMetaTable("Player")

function user:HaveArmorInSlot(index)
		local char = self:GetCharacter();
		local data = char:GetData("Clothes");
		local clothes = data[index];

		return clothes && clothes.equiped.uniqueID
end;