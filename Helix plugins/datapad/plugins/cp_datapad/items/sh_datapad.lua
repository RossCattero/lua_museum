ITEM.name = "Datapad"
ITEM.model = Model("models/kek1ch/pda_v2_kek1ch.mdl")
ITEM.description = "A mobile device which giving access to CCA database."
ITEM.width = 1
ITEM.height = 1
ITEM.noBusiness = true

ITEM.functions.Use = {
	name = "Open datapad",
	OnRun = function(item)
		ix.datapad.Open(item.player)
		return false;
	end,
	OnCanRun = function(item)
		local character = item.player:GetCharacter();

		-- If player is not trying to use the entity from the floor and he is a CCA member;
        return tobool(not item.entity and ix.archive.police.IsCombine(character:GetFaction()))
	end,
}
