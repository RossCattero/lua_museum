net.Receive("ix.datapad.gui", function(len)
    if ix.datapad.gui and ix.datapad.gui:IsValid() then
        ix.datapad.gui:Close()
    end

    ix.datapad.gui = vgui.Create("Datapad")
    ix.datapad.gui:Populate()
end)