local PLUGIN = PLUGIN;

ITEM.name = "Rad-X"
ITEM.description = "Pills, which can be used to minimize radiation from zones."
ITEM.category = 'Medicine'
ITEM.model = Model("models/frp/props/models/rad_pills.mdl");

ITEM.percentage = 50;
// The percent of decrease;
ITEM.minRandom = 18; 
ITEM.maxRandom = 30;
// The minimum and maximum random amount of minutes for pills;

if (CLIENT) then
		function ITEM:PaintOver(item, w, h)
			local uniqueID = 'RadXTimer'
			if timer.Exists(uniqueID) then
				surface.SetDrawColor(0, 0, 0, 100)
				surface.DrawRect(0, 0, w, h)

				draw.SimpleText(RFormatTime(timer.RepsLeft(uniqueID)), "DermaDefault", w * 0.26, h * 0.15, Color(255, 255, 255, 100), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			end;
		end
end

ITEM.functions.Use = {
	name = 'Use',
	OnRun = function(self)
		local client = self.player;
		
		self:UseTo(client, client)
	end,
	OnCanRun = function(self)
		local uniqueID = 'RadXTimer'
		
		return !timer.Exists(uniqueID)
	end,
}

ITEM.functions.Give = {
	name = 'Give',
	OnRun = function(self)
		local client = self.player;
		local target = client:GetEyeTrace().Entity;

		if timer.Exists('RadXTimer ' .. target:GetCharacter():GetID()) then
				client:Notify("You can't use it on this target - there's already an existing effect on character.")
				return;
		end

		self:UseTo(client, target)
	end,
	OnCanRun = function(self)
		local client = self.player;
		local trace = client:GetEyeTrace()
		local ent = trace.Entity
		local entPos, clPos = ent:GetPos(), client:GetPos();

		return (ent:IsValid() && ent:IsPlayer() && entPos:Distance(clPos) < 64);
	end,
}

function ITEM:UseTo(who, target)
		local min, max = self.minRandom, self.maxRandom
		local char = target:GetCharacter()

		local time = math.random(min*60, max*60);

		local uniqueID = 'RadXTimer ' .. char:GetID()
		netstream.Start(target, 'rad::syncTimer', time)
		timer.Create(uniqueID, time, 1, function()
			if !timer.Exists(uniqueID) || !target:IsValid() || !target:Alive() || target:GetCharacter() != char then 
				timer.Remove(uniqueID) 
				return; 
			end;
			
			char.RadDecrease = 0;
		end);

		char.RadDecrease = math.Clamp(self.percentage, 0, 100);

		local isMe = who == target;
		who:Notify("You used the "..self.name.." on " .. (isMe && "yourself" || target:Name()))
		target:EmitSound("usesound/pills.wav", 50, math.random(170, 180), 0.25)
		if !isMe then
			target:Notify(who:Name() .. " given "..self.name.." to you. You used it immediately.")
		end;
end;