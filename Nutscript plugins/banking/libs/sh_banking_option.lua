nut.banking.option = nut.banking.option or {};
nut.banking.option.list = nut.banking.option.list or {}

function nut.banking.option.LoadFromDir(directory)
	local files, folders = file.Find(directory.."/*", "LUA")

	for _, v in ipairs(files) do
		local path = directory.."/"..v
		nut.banking.option.Register(path:match("sh_([_%w]+)%.lua"), path)
	end
end

function nut.banking.option.Register(uniqueID, path)
	if (!uniqueID) then return; end
	
	bankingOption = setmetatable({}, nut.meta.bankingOption)

	if (path) then nut.util.include(path) end
	nut.banking.option.list[ bankingOption.position or #nut.banking.option.list + 1 ] = bankingOption;

	bankingOption = nil
end