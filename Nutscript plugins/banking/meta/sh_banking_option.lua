local bankingOption = nut.meta.bankingOption or {}

bankingOption.__index = bankingOption

bankingOption.name = "None";
bankingOption.icon = "";
bankingOption.Callback = function() end;
bankingOption.CanRun = function() return true end;

function bankingOption:__tostring()
	return "Banking option > " .. self.name
end

nut.meta.bankingOption = bankingOption