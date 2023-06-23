FACTION.name = "Delivery faction"
FACTION.isDefault = false
FACTION.desc = "Faction for delivery tasks."
FACTION.color = Color(100, 100, 100)
FACTION.models = {
	"models/Humans/Group03/Male_05.mdl"
}
function FACTION:onTransfered(client, oldFaction)
	hook.Run("PlayerLoadout", client)
end

FACTION_DELIVERY = FACTION.index
