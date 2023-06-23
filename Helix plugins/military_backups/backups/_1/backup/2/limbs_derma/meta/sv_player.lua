local PLAYER = FindMetaTable("Player")

function PLAYER:LimbDamagedCallback()
	netstream.Start(self, "LIMB_DAMAGED")
end;