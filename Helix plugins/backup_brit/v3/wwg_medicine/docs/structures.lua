/*
	Predefined Object Structures.
*/
-- @medical Structs

/*
	# The object structure for the wound.
	# The wound happens and instances when the damage type is causes injury. Injury on their side causes a wound if can.

	! It is important to have ALL OF THIS DATA.
	@attribute [uniqueID] [string] The 'name' of the wound stored in the global list.
	@attribute [bone] [string] The bone name, where the wound is located.
	@attribute [time] [number] The time (basically os.time()), when the wound is occured.
	@attribute [charID] [number] The number of character ID who owns this wound.
	@attribute [id] [number] The ID of the wound stored by it's instance.

	@table WOUND
	@meta ix.meta.wound
	@location meta/sh_wound.lua
*/

/*
	# The object structure for the body.
	# The body stores all wounds of character and loads(caches) when character is loaded.

	! It is important to have ALL OF THIS DATA.
	@attribute [charID] [number] The number of character ID who owns this body. 
	@attribute [limbs] [table] The array, which contains all limbs of the body.

	@table BODY
	@meta ix.meta.body
	@location meta/sh_body.lua
*/

/*
	# The object structure for the injury.
	# Injury appears to be a result of damage type taken by entity(player). If this damage type is registered as injury - the wound check happens.

	! It is important to have ALL OF THIS DATA.
	@attribute [uniqueID] [string] The 'name' of the injury stored in the global list.
	@attribute [index] [number] The DMG number caused by incoming damage.
	@attribute [bleeding] [bool] Check if the injury can cause bleeding wound.
	@attribute [fracture] [bool] Check if the injury can cause fracture wound.
	@attribute [burn] [bool] Check if the injury can cause burn wound.

	@table INJURY
	@meta ix.meta.injury
	@location meta/sh_injury.lua
*/

/*
	# The object structure for the disease.

	! WIP
*/