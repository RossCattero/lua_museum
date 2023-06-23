local PLUGIN = PLUGIN;
ITEM.name = "Meds"
ITEM.model = "models/zworld_health/bandages.mdl"
ITEM.description = "Medical base"
ITEM.width = 1
ITEM.height = 1
ITEM.price = 0
ITEM.category = "Medicals"
ITEM.injuryCategory = {1, 2, 3, 4, 5, 6, 7, 8} // Check sh_plugin.lua, line №6 PLUGIN.DEFAULT_LIMBS
ITEM.healAmount = 35; // The points that will be added when someone uses this
ITEM.useSound = "usesound/bandage.wav" // the sound when it used
ITEM.stopsBleeding = false; // The item is have to to stop bleeding(true to make it stop bleeding)

ITEM.functions.UseMedicals = {
	name = "Use",
	onRun = function(item)
			local user = item.player;
			
			item:HealSomeone(user, user, 5)

			return false;
	end,

	onCanRun = function(item)
			return !item.entity
	end,
}

ITEM.functions.UseOnSomeone = {
	name = "Use on someone you looking at",
	onRun = function(item)
			local user = item.player;
			local trace = user:Tracer(128);

			item:HealSomeone(user, trace.Entity:IsPlayer() && trace.Entity || trace.Entity:getNetVar("player"), 5)

			return false;
	end,

	onCanRun = function(item)
			local user = item.player;
			local trace = user:Tracer(128);

			return !item.entity && trace.Entity != NULL && trace.Entity:IsPlayer()
	end,
}

function ITEM:HealSomeone(owner, target, time)
		local vel;
		local ent;
		if !time then time = 5; end;
		local trace = owner:Tracer(128);
		local IsSelf = owner == target;

		if self.stopsBleeding && !target:getChar():getData("bleeding") then
			if IsSelf then
					owner:notify("*** I'm not bleeding, but I can use this.")
			else 
					owner:notify("*** The target is not bleeding, but I can still heal with this.")
			end;
		end;

		if table.HasValue(self.injuryCategory, 7) or table.HasValue(self.injuryCategory, "blood") then // 8 is index of blood;
				if target:getChar():getData("bleeding") then
						target:notify("*** I can't use this while bleeding!")
						return;
				end
		end

		if !IsSelf then
				target:notify(owner:Name() .. " is trying to heal you, stand still.")
		end

		owner:setActionMoving("Healing" .. (!IsSelf && ": " .. target:Name() || "..."), time, 
		function() 
				local inv = owner:getChar():getInv():getItems()
				if !inv[ self:getID() ] then return end;

				if !IsSelf && !trace.Entity then
						owner:notify("The target is too far away from you")
						return;
				end

				if self.stopsBleeding then
						if target:getChar():getData("bleeding") then
								target:StopBleeding();
						end;
				end

				for k, v in ipairs(self.injuryCategory) do
						target:SetLimb(v, 
						math.Clamp(target:GetLimb(v) + self.healAmount, 
						0, 
						DefaultLimb(v)))
				end

				target:EmitSound(self.useSound)
				self:remove();
		end, function()
				if !vel then vel = owner:GetVelocity(); end;
				if !IsSelf && !ent then ent = trace.Entity end;
				local inv = owner:getChar():getInv():getItems()
				
				return inv[ self:getID() ] && owner:GetVelocity() == vel && IsSelf || (!IsSelf && trace.Entity == ent)
		end)
end;