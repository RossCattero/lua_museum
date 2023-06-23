ITEM.name = "Defibrillator"
ITEM.model = "models/Items/battery.mdl"
ITEM.description = "The defibrillator to wake up dead character"
ITEM.width = 2
ITEM.height = 2
ITEM.price = 0
ITEM.category = "Medicals"

ITEM.functions.UseDefib = {
	name = "Use on target",
	onRun = function(item)
			local user = item.player;
			local trace = user:Tracer(128);
			local vel;
			local ent;

			local target = trace.Entity:getNetVar("player");
			if !target || !target:getLocalVar("unconscious") || !target:getLocalVar("unc_giveup") then
				user:notify("You can't revive this or them.")
				return;
			end;

			user:EmitSound("items/suitchargeok1.wav")
			target:notify(user:Name() .. " is trying to revive you.")
			user:setActionMoving("Reviving: " .. target:Name(), 2, 
			function() 
					if !target then
						user:notify("The target is too far away from you")
						return;
					end
					target:setUnconsious(false)
					user:EmitSound("ambient/energy/weld2.wav")
			end, function()
					if !vel then vel = user:GetVelocity(); end;
					if !ent then ent = target end;
					return user:GetVelocity() == vel 
					&& target == ent
			end)

			return false;
	end,

	onCanRun = function(item)
			local user = item.player;
			local trace = user:Tracer(128);
			local target = trace.Entity:getNetVar("player")

			return !item.entity 
			&& trace.Entity != NULL 
			&& trace.Entity:GetClass() == "prop_ragdoll"
			&& target
	end,
}