local PLUGIN = PLUGIN;

ITEM.name = "Rad-away"
ITEM.description = "Pills, which can be used to remove some radiation from your body."
ITEM.category = 'Medicine'
ITEM.model = Model("models/frp/props/models/antirad.mdl");
ITEM.radAmount = 80;

ITEM.functions.Use = {
	name = 'Use',
	OnRun = function(self)
		local client = self.player;
		
			self:UseTo(client, client)
	end,
}

ITEM.functions.Give = {
	name = 'Give',
	OnRun = function(self)
		local client = self.player;
		local target = client:GetEyeTrace().Entity;

		self:UseTo(client, target)
	end,
	OnCanRun = function(self)
		local client = self.player;
		local trace = client:GetEyeTrace()
		local ent = trace.Entity
		local entPos, clPos = ent:GetPos(), client:GetPos();

		return ent:IsValid() && ent:IsPlayer() && entPos:Distance(clPos) < 64;
	end,
}

function ITEM:UseTo(who, target)
		local min, max = self.minRandom, self.maxRandom
		local char = target:GetCharacter()

		local tox = target:GetRad()
		target:IncRad( math.Clamp(tox-self.radAmount, 0, PLUGIN.maxRadiation) )

		local isMe = who == target;
		who:Notify("You used the "..self.name.." on " .. (isMe && "yourself" || target:Name()))
		target:EmitSound("usesound/pills.wav", 50, math.random(170, 180), 0.25)
		if !isMe then
			target:Notify(who:Name() .. " given "..self.name.." to you. You used it immediately.")
		end;
end;