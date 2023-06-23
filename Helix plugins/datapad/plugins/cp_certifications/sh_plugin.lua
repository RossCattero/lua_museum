PLUGIN.name = "Datapad > certifications"
PLUGIN.author = "Ross Cattero"
PLUGIN.description = "Certifications list for datapad."

ix.util.Include( "meta/sh_certification.lua" )
ix.certifications.LoadFromDir(PLUGIN.folder .. "/certifications")
