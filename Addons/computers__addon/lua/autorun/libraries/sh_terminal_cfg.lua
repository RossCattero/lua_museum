function cmdExists(cmd)
	return PREFIX && string.StartWith(cmd, PREFIX) && CMDLIST[cmd];
end;