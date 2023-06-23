ITEM.name = "Farming pot"
ITEM.model = "models/nater/weedplant_pot.mdl"
ITEM.description = "Farming pot for planting seeds"
ITEM.width = 1
ITEM.height = 1
ITEM.price = 0
ITEM.category = "Farming"

ITEM.functions._Place = {
	name = "Place",
	onRun = function(item)
			local player = item.player;
			local trace = player:GetEyeTraceNoCursor()

			if trace.Hit && (!trace.Entity || trace.Entity == Entity(0)) && player:GetPos():Distance( trace.HitPos ) < 64 then
					local pot = ents.Create("farming_pot")
					pot:SetPos(trace.HitPos)
					pot:SetModel(item.model)
					pot._id = item.uniqueID;
					pot:Spawn()
					pot:Activate()
			elseif !trace.Hit then
				player:notify("You need to look at ground to place it.")
				return false
			elseif trace.Entity && trace.Entity != Entity(0) then
				player:notify("You can't place it on entity.")
				return false
			elseif player:GetPos():Distance( trace.HitPos ) > 64 then
				player:notify("The distance is to high.")
				return false
			end
	end,

	onCanRun = function(item)
			return !item.entity
	end,
}