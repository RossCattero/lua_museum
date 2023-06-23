local WOUND = ix.medical.meta or {}

WOUND.__index = WOUND

WOUND.name = "Unknown"
WOUND.index = DMG_GENERIC
WOUND.causeBleeding = false
WOUND.causeInfection = false

function WOUND:__tostring()
	return "WOUND["..self.uniqueID.."]"
end

function WOUND:__eq(other)
	return self:GetID() == other:GetID()
end

function WOUND:GetID()
	return self.id
end

function WOUND:SetData( key, value )
	local data = self:Data()
	
	data[key] = value;
end;

function WOUND:Data()
	return self.data;
end;

function WOUND:GetData(key, default)
	return self.data[key] || default;
end;

function WOUND:CanBleed()
	return self.causeBleeding
end;

function WOUND:Remove()
	ix.medical.instances[ self.id ] = nil;

	if ix.medical.bodies[ self.charID ] then
		ix.medical.bodies[ self.charID ][self.bone][ self.id ] = nil;
		ix.medical.character[ self.charID ][ self.id ] = nil;
	end
end;

function WOUND:Network( receiver )
	net.Start("NETWORK_WOUND")
		net.WriteInt( self.index, 32 ) // Write unsigned INT as wound index
		net.WriteString( self.bone ) // Write string as bone name
		net.WriteUInt( self.occured || 0, 32 ) // Write unsigned INT as wound occure time
		net.WriteUInt( self.id, 16 ) // Write unsigned INT as wound occure time
	net.Send(receiver)
end;

ix.medical.meta = WOUND