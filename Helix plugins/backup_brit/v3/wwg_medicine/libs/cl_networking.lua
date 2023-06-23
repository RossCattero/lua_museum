--- Networking
-- @medical Clientside networking

//	Receive the wound from the server and insert it to the specified ID in local array;
net.Receive("NETWORK_WOUND", function(len)
	// The uniqueID of wound;
	local uniqueID = net.ReadString(); 

	// The bone where wound is located;
	local bone = net.ReadString();

	// The time when the wound occured;
	local time = net.ReadUInt( 32 );

	// The ID of the wound;
	local id = net.ReadUInt( 16 );

	// Written datastring;
	local dataLen = net.ReadUInt( 16 )
	local data = net.ReadData( dataLen )
	data = util.Decompress( data );

	// Make new wound and add all needed info to it;
	local wound = ix.wound.New(uniqueID, id)
	wound.charID = LocalPlayer():GetCharacter():GetID();
	wound.bone = bone;
	wound.time = time || os.time();
	wound.data = util.JSONToTable( data ) 
end)

// Receive the signal to remove specified wound by ID;
net.Receive("NETWORK_WOUND_REMOVE", function(len)
	// The ID of the wound;
	local id = net.ReadUInt( 16 );

	// Remove the wound if found the actual ID;
	if ix.wound.instances[ id ] then
		ix.wound.instances[ id ] = nil;
	end;
end)

// Receive the data from server and insert it to wound data array;
net.Receive("NETWORK_WOUND_DATA", function(len)
	// The ID of the wound;
	local id = net.ReadUInt(16);

	// The key of data;
	local key = net.ReadString();

	// The networked value;
	local value = net.ReadType()

	// Find the wound in local array;
	local wound = ix.wound.instances[id];

	// If wound is found - insert on key position the actual value;
	if wound then
		wound.data[key] = value;
	end
end)