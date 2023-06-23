include("shared.lua"); 
AddCSLuaFile("cl_init.lua"); 
AddCSLuaFile("shared.lua");

function ENT:Use(act)
	if !act:IsAdmin() then 
		self:UseProxy( act )
	end;
end;

function ENT:UseProxy( act )
	if act.bankingCD && act.bankingCD > CurTime() then
		return;
	end
	local account = nut.banking.instances[ act:getChar():getID() ];

	if account then
		if account:Sync( act ) then
			net.Start( "nut.banking.account.open" )
			net.Send( act )
		end;
		act.bankingCD = CurTime() + 5;
	else
		net.Start( "nut.banking.account.create" )
		net.Send( act )
	end
end;