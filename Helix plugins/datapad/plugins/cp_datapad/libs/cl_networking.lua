net.Receive("ix.datapad.open", function(len)
    local asAdmin = net.ReadBool()

    if ix.datapad.ui and ix.datapad.ui:IsValid() then
        ix.datapad.ui:Close()
    end;

    ix.datapad.ui = vgui.Create("Datapad")
    ix.datapad.ui:Populate()

    -- It's the variable to check if player is opening the datapad as admin;
    -- Player can't hack it, because serverside is checking it too.
    -- See sv_networking.lua > net.Receive("ix.datapad.send")
    ix.datapad.asAdmin = asAdmin;
end)

net.Receive("ix.datapad.data", function(len)
    local dataLen = net.ReadUInt( 16 )
	local data = net.ReadData( dataLen )
	data = util.Decompress( data );
    data = util.JSONToTable(data)

    local newData = {}
    for k, v in pairs(data) do
        newData[#newData + 1] = v;
    end;

    ix.archive.instances = newData
end)

net.Receive("ix.datapad.logs.send", function(len)
    local dataLen = net.ReadUInt( 16 )
	local data = net.ReadData( dataLen )
	data = util.Decompress( data );
    data = util.JSONToTable(data)

    ix.archive.logs.list = data;
end)