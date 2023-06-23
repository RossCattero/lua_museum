local PLUGIN = PLUGIN;

local plyMeta = FindMetaTable("Player")

if CLIENT then
		function plyMeta:BankData()
				local char = self:getChar();
				local BankID = char:getData("banking_account");
				return BankID != 0 && PLUGIN.bankINFO;
		end;
end