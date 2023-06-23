
ITEM.name = "Datapad"
ITEM.model = Model("models/props_junk/popcan01a.mdl")
ITEM.description = "A datapad item for accessing datapad database"
ITEM.width = 1
ITEM.height = 1
ITEM.noBusiness = true

ITEM.functions.Use = {
	OnRun = function(item)
		ix.datapad.OpenUI(item.player)
		return true
	end,
	OnCanRun = function(item)
		return ix.ranks.Permission(ix.ranks.GetRank(item.player:GetCharacter()), ix.ranks.permissions.open_datapad)
	end,
}
