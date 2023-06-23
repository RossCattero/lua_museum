function Clockwork.kernel:ModifyPhysDesc(description)
	if (!string.utf8len(description)) then
		return "!!!Incorrect Description!!!"
	end
	
	local bSuccess, value = pcall(string.utf8sub, description, 1, 96);
	
	if (!bSuccess) then
		return "!!!Incorrect Description!!!"
	end
	
	if (string.utf8len(description) and string.utf8len(description) <= 99) then
		if (!string.find(string.sub(description, -1), "%p")) then
			return description..".";
		else
			return description;
		end;
	else
		if (string.utf8sub(description, 96, 96)==" ") then
			return string.utf8sub(description, 1, 95).."...";
		else
			return string.utf8sub(description, 1, 96).."...";
		end;
	end;
end;