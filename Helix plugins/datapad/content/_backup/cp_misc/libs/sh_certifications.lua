-- Certifications library
ix.certifications = ix.certifications or {}

-- Certifications list
ix.certifications.list = ix.certifications.list or {}

--- Load all certifications from a directory
--- @param directory string
function ix.certifications.LoadFromDir(directory)
	local files, folder = file.Find(directory.."/*", "LUA")

	for _, v in ipairs(files) do
		local path = directory.."/"..v
		ix.certifications.Register(path:match("sh_([_%w]+)%.lua"), path)
	end
end

--- Register a certifications class
--- @param uniqueID string
--- @param path string
function ix.certifications.Register(uniqueID, path)
	if (not uniqueID) then return; end
	
	Certification = setmetatable({}, ix.meta.certification)
	Certification.uniqueID = uniqueID
	
	if (path) then ix.util.Include(path) end

	ix.certifications.list[ uniqueID ] = Certification;

	Certification = nil
end