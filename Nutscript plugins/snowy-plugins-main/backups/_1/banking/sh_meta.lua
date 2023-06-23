local PLUGIN = PLUGIN;

local plyMeta = FindMetaTable("Player")

function plyMeta:ValidateNPC(class)
		local trace = self:GetEyeTraceNoCursor();
		local ent = trace.Entity;
		if ent && ent:GetClass() == class then
				local distance = self:GetPos():Distance( ent:GetPos() );
				return distance < 128;
		end
		return false;
end;

if CLIENT then
		function plyMeta:BankData()
				local char = self:getChar();
				local BankID = char:getData("banking_account");
				return BankID != 0 && PLUGIN.bankINFO;
		end;
end