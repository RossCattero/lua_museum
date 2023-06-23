util.AddNetworkString("ix.doors.setDoor")

net.Receive("ix.doors.setDoor", function(len, client)
	local data = net.ReadString();

	print(data)
end)