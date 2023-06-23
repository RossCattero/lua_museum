--- Helping procedure wrapper for opening a datapad
--- @param client table (A target player)
function ix.datapad.OpenUI( client )
    if not client then ErrorNoHalt("Can't open UI for unexisting player!") end;
    
    net.Start("ix.datapad.gui")
    net.Send(client)
end;