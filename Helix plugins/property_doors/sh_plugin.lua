PLUGIN.name = "Door property system"
PLUGIN.author = "Ross Cattero"
PLUGIN.description = "Property system for civil protection and citizens."

ix.util.Include("cl_plugin.lua")

for k, v in pairs(file.Find(PLUGIN.folder.."/meta/*", "LUA")) do
	ix.util.Include( "meta/" .. v )
end

ix.doors.category.Load(PLUGIN.folder .. "/door_categories")
ix.doors.sector.Load(PLUGIN.folder .. "/door_sectors")