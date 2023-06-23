-- This is a scary event class
local scary = ix.meta.scary or {}

-- Indexation
scary.__index = scary

-- Trigger this event on 150 units near NPC
scary.distance = 0

-- Play this sound on event trigger
scary.sound = ""

-- The sound volume
scary.volume = 0

-- Set the flashlight flicking chance
scary.flashlight_percent = 0

function scary:__tostring()
	return "Scary event " .. self.path
end

ix.meta.scary = scary