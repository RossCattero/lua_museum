

net.Receive("NETWORK_WOUND", function(len)
	local index = net.ReadInt(32)
	local bone = net.ReadString()
	local time = net.ReadInt(32)
	local id = net.ReadInt(16)

	local wound = ix.medical.New( index, id )
	wound.bone = bone
	wound.occured = time > 0 && time || os.time()
end)