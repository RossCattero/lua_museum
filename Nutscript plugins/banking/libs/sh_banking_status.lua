nut.banking.status = nut.banking.status or {}
nut.banking.status.list = nut.banking.status.list or {}

function nut.banking.status.LoadFromDir(directory)
	local files, folders = file.Find(directory.."/*", "LUA")

	for _, v in ipairs(files) do
		local path = directory.."/"..v
		nut.banking.status.Register(path:match("sh_([_%w]+)%.lua"), path)
	end
end

function nut.banking.status.Register(uniqueID, path)
	if (!uniqueID) then return; end
	
	bankingStatus = setmetatable({}, nut.meta.bankingStatus)

	if (path) then nut.util.include(path) end
	nut.banking.status.list[ uniqueID ] = bankingStatus;

	bankingStatus = nil
end