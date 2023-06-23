local PLUGIN = PLUGIN;

netstream.Hook("OpenPDA", function(characterList, chatList)
    if (PLUGIN.pdaDerma and PLUGIN.pdaDerma:IsValid()) then
        PLUGIN.pdaDerma:Close();
    end;
    PLUGIN.pdaDerma = vgui.Create("CombinePDA");
    PLUGIN.pdaDerma:Populate( characterList, chatList )
end)

netstream.Hook("SyncMessageOnClient", function(name, time, text)

    local VGUI = PLUGIN.pdaDerma
    if VGUI && VGUI.filePanel && VGUI.filePanel.chatList then

        local chatMessage = VGUI.filePanel.chatList:Add( "Panel" )
        chatMessage:Dock( TOP )
        chatMessage:DockMargin( 5, 5, 5, 5 )
        chatMessage:SetTall(50)
        chatMessage:DockPadding(5, 5, 5, 5)
        chatMessage.Paint = function(s, w, h)
            draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 255), Color(255, 255, 255) )
        end;
    
        local chatTime = chatMessage:Add('DLabel')
        chatTime:SetText(time)
        chatTime:Dock(TOP)
        chatTime:SetContentAlignment(7)
        chatTime:SetWrap(true)
        local WhoIs = chatMessage:Add('DLabel')
        WhoIs:SetText(name)
        WhoIs:Dock(TOP)
        WhoIs:SetContentAlignment(7)
        WhoIs:SetWrap(true)
    
        local messageText = chatMessage:Add('DLabel')
        messageText:SetText(text)
        messageText:Dock(FILL)
        messageText:SetContentAlignment(7)
        messageText:SetWrap(true)
        
        chatMessage.Paint = function(s, w, h)
            draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 255), Color(255, 255, 255) )
        end;
        
        chatMessage:SetTall(80 + (utf8.len(messageText:GetText()) / 50) * 8);

    end;
end)

netstream.Hook("SyncLogFileOnClients", function(id, time, type, text)

    local VGUI = PLUGIN.pdaDerma
    if VGUI && VGUI.filePanel && VGUI.filePanel.NotesList then

        local notePanel = VGUI.filePanel.NotesList:Add( "Panel" )
        notePanel:Dock( TOP )
        notePanel:DockMargin( 5, 5, 5, 5 )
        notePanel:SetTall(50)
        notePanel:DockPadding(5, 5, 5, 5)
        notePanel.Paint = function(s, w, h)
            draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 255), Color(255, 255, 255) )
        end;
    
        local noteTime = notePanel:Add('DLabel')
        noteTime:SetText(time)
        noteTime:Dock(TOP)
        noteTime:SetContentAlignment(7)
        noteTime:SetWrap(true)
        local WhoDone = notePanel:Add('DLabel')
        WhoDone:SetText(type)
        WhoDone:Dock(TOP)
        WhoDone:SetContentAlignment(7)
        WhoDone:SetWrap(true)
    
        local messageTXT = notePanel:Add('DLabel')
        messageTXT:SetText(text)
        messageTXT:Dock(FILL)
        messageTXT:SetContentAlignment(7)
        messageTXT:SetWrap(true)
        
        notePanel.Paint = function(s, w, h)
            draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 255), Color(255, 255, 255) )
        end;
        
        notePanel:SetTall(80 + (utf8.len(messageTXT:GetText()) / 50) * 8);

    end;
end)