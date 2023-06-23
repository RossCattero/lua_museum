-- 'Scary' library
ix.scary = ix.scary or {}

-- Library NPCs list
ix.scary.instances = ix.scary.instances or {}

-- Library events list
ix.scary.events = ix.scary.events or {}

-- Library npc target class name
ix.scary.target = "npc_drg_dbddemogorgon"

-- Load scary events data
function ix.scary.LoadFromDir(directory)
	local files, folder = file.Find(directory.."/*", "LUA")

	for _, v in ipairs(files) do
		local path = directory.."/"..v
		ix.scary.Register(path:match("sh_([_%w]+)%.lua"), path)
	end
end

-- Register scary events data
function ix.scary.Register(uniqueID, path)
	if (not uniqueID) then return; end
	
	scary = setmetatable({}, ix.meta.scary)
	
	if (path) then ix.util.Include(path) end
	ix.scary.events[ uniqueID ] = scary;

	scary = nil
end

-- Use this if you want to spawn entity which will communicate properly with this plugin
-- Or, if you'll use ents.Create directly - add this entity to instances list manually
--- @param position vector
function ix.scary.SpawnEntity(position)
	if not ix.scary.target then
		error("Scary > Can't find a scary target index on library!")
		return;
	end;
	if ix.scary.target == "" then
		error("Scary > Entity target class in empty!")
		return
	end;
	if not position then
		error("Scary > Can't spawn entity on nil position!")
		return
	end;

	local entity = ents.Create(ix.scary.target)
	entity:SetPos(position)
	entity:Spawn()

	ix.scary.instances[entity] = true
end;