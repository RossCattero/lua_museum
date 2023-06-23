local PLUGIN = PLUGIN;

ITEM.name = "Dosimeter"
ITEM.description = "The dosimeter. Allows user to check radiation amount in body."
ITEM.category = 'Counters'
ITEM.model = Model("models/frp/props/models/datachik1.mdl");

ITEM.functions.UseDosimeter = {
	name = 'Use',
	OnRun = function(self)
		local client = self.player;
		client:Notify("[Rad amount] => " .. client:GetRad())

		self:UseSoundPlay()
		return false
	end
}

ITEM.functions.UseDosimeterOn = {
	name = 'Use on target',
	OnRun = function(self)
		local client = self.player;
		local target = client:GetEyeTrace().Entity;
		client:Notify("[Rad amount of ".. target:Name() .."] => " .. target:GetRad())
		target:Notify( client:Name() .. " is checking your radiation level. " .. "[Rad amount] => " .. target:GetRad())
		
		self:UseSoundPlay(target)
		return false
	end,
	OnCanRun = function(self)
		local client = self.player;
		local trace = client:GetEyeTrace()
		local ent = trace.Entity
		local entPos, clPos = ent:GetPos(), client:GetPos();

		return ent:IsValid() && ent:IsPlayer() && entPos:Distance(clPos) < 64;
	end,
}

function ITEM:UseSoundPlay()
		local client = self.player;
		if target then client = target end;
		
		client:EmitSound("buttons/lightswitch2.wav", 50, math.random(170, 180), 0.25)
end;