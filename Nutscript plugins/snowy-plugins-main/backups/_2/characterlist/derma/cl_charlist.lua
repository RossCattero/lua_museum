local PANEL = {}
local sw, sh = ScrW(), ScrH()

function PANEL:Init()
    self:SetFocusTopLevel( true )
    self:MakePopup()
    self:Adaptate(900, 650, 0.27, 0.25)
    gui.EnableScreenClicker(true);
    self:SetAlpha(0)
    self:AlphaTo(255, 0.3, 0, function(alpha, pnl)
        pnl:SetAlpha(255)
    end);
    
    self.bodyGroupText = {}
end

function PANEL:Paint(w, h) 
    Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
    surface.SetDrawColor(Color(70, 70, 70, 225))
    surface.DrawRect(0, 0, w, h)
    surface.SetDrawColor(Color(0, 99, 191))
    surface.DrawOutlinedRect( 0, 0, w, h, 1 )	
end;

function PANEL:Populate() 
    self.CloseBG = self:Add("Panel")
    self.CloseBG:Dock(TOP)
    self.CloseBG:DockMargin(7, 7, 7, 7)

    self.SearchCharacter = self.CloseBG:Add("ModEntry")
    self.SearchCharacter:Dock(LEFT)
    self.SearchCharacter:SetWide(sw * 0.08)
    self.SearchCharacter:SetFont("SearchFont")
    self.SearchCharacter:SetPlaceholderText("Search...")
    self.SearchCharacter:SetUpdateOnType(true);
	self.SearchCharacter.OnValueChange = function(entry, val)
        local data = CHARDATA;
        local characters = {};
        for k, v in pairs(CHARDATA) do
            v = pon.decode(v)
            if v[entry.criterio || 2]:match(val) then
                characters[k] = pon.encode(v);
            end
        end
        self:ReloadData(characters) 
    end;
    self.SearchCharacter:SetDisabled(true)

    self.SearchCriterio = self.CloseBG:Add("ModCombo")
    self.SearchCriterio:SetWide(sw * 0.08)
    self.SearchCriterio:SetText("Choose search criterio")
    self.SearchCriterio:DockMargin(7, 0, 0, 0)
    self.SearchCriterio:AddChoice("Character name", 2)
    self.SearchCriterio:AddChoice("Faction", 5)
    self.SearchCriterio.OnSelect = function( combo, i, val, data )
        self.SearchCharacter.criterio = data
	    self.SearchCharacter:SetDisabled(false)
    end

    self.CloseButton = self.CloseBG:Add("MButt")
    self.CloseButton:Dock(RIGHT)
    self.CloseButton:SetWide(sw * 0.02)
    self.CloseButton:SetText("X")
    self.CloseButton:InitHover(Color(60, 60, 60), Color(80, 80, 80), 1)
    self.CloseButton.Paint = function(s, w, h)
        s:HoverButton(w, h)
    end;
    self.CloseButton.DoClick = function(btn)
        self:Close()
    end;

    self.CharacterList = self:Add("DListView")
    self.CharacterList:Dock(FILL)
    self.CharacterList:SetMultiSelect(false)
    self.CharacterList:AddColumn("ID")
    self.CharacterList:AddColumn("Character name")
    self.CharacterList:AddColumn("Steam name")
    self.CharacterList:AddColumn("Description")
    self.CharacterList:AddColumn("Faction")
    self.CharacterList:AddColumn("Money")
    self.CharacterList:AddColumn("Banned")
    self.CharacterList:AddColumn("Banned by")

    self:ReloadData(CHARDATA)

    self.CharInfo = self:Add("ModScroll")
    self.CharInfo:Dock(RIGHT)
    self.CharInfo:SetAlpha(0)
    self.CharInfo:SetWide(sw * 0.15)
    self.CharInfo.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25, 50))
    end;

    self.pModel = self.CharInfo:Add( "nutModelPanel" )
    self.pModel:SetModel("")
    self.pModel:Dock(TOP)
    self.pModel:SetZPos(0)
    self.pModel:SetTall(sh * 0.18)
    self.pModel:SetCamPos( Vector(30, 90, 45) )

    self.lbl = self.CharInfo:Add('ModLabel')
    self.lbl:SetText("Name: ")
    self.lbl:SetZPos(1)
    self.lbl:SetFont("InfoFont")

    self.setName = self.CharInfo:Add("ModEntry")
    self.setName:Dock(TOP)
    self.setName:SetZPos(2)
    self.setName:DockMargin(10, 5, 10, 5)
    self.setName:SetFont("SearchFont")
    self.setName:SetPlaceholderText("Name...")

    self.lbl = self.CharInfo:Add('ModLabel')
    self.lbl:SetText("Description: ")
    self.lbl:SetFont("InfoFont")
    self.lbl:SetZPos(3)

    self.setDesc = self.CharInfo:Add("ModEntry")
    self.setDesc:Dock(TOP)
    self.setDesc:SetZPos(4)
    self.setDesc:DockMargin(10, 5, 10, 5)
    self.setDesc:SetFont("SearchFont")
    self.setDesc:SetPlaceholderText("Description...")

    self.lbl = self.CharInfo:Add('ModLabel')
    self.lbl:SetText("Faction: ")
    self.lbl:SetFont("InfoFont")
    self.lbl:SetZPos(5)

    self.factionList = self.CharInfo:Add("DListView")
    self.factionList:Dock(TOP)
    self.factionList:SetTall(sh * 0.1)
    self.factionList:SetZPos(6)
    self.factionList:DockMargin(10, 5, 10, 5)
    self.factionList:SetMultiSelect(false)
    self.factionList:AddColumn("Faction name")
    self.factionList:AddColumn("Whitelisted")

    self.lbl = self.CharInfo:Add('ModLabel')
    self.lbl:SetText("Playermodel: ")
    self.lbl:SetFont("InfoFont")
    self.lbl:SetZPos(7)

    self.setPM = self.CharInfo:Add("ModEntry")
    self.setPM:Dock(TOP)
    self.setPM:SetZPos(8)
    self.setPM:DockMargin(10, 5, 10, 5)
    self.setPM:SetFont("SearchFont")
    self.setPM:SetPlaceholderText("Type playermodel...")
    self.setPM:SetUpdateOnType(true);
	self.setPM.OnValueChange = function(entry, val)
        self.pModel.Entity:SetModel(val)
        self.pModel.Entity:ResetSequence("LineIdle01")
        self:RefreshBodyGroupTree();
    end;

    self.lbl = self.CharInfo:Add('ModLabel')
    self.lbl:SetText("Bodygroups: ")
    self.lbl:SetFont("InfoFont")
    self.lbl:SetZPos(9)

    self.BodyGroupTree = self.CharInfo:Add('DTree')
    self.BodyGroupTree:Dock(TOP)
    self.BodyGroupTree:SetZPos(10)
    self.BodyGroupTree:SetTall(250)
    self.BodyGroupTree:DockMargin(5, 5, 5, 5)

    self.lbl = self.CharInfo:Add('ModLabel')
    self.lbl:SetText("Skin: ")
    self.lbl:SetFont("InfoFont")
    self.lbl:SetZPos(11)

    self.setSkin = self.CharInfo:Add("ModEntry")
    self.setSkin:Dock(TOP)
    self.setSkin:SetZPos(12)
    self.setSkin:DockMargin(10, 5, 10, 5)
    self.setSkin:SetFont("SearchFont")
    self.setSkin:SetPlaceholderText("Type skin...")
    self.setSkin:SetUpdateOnType(true);
	self.setSkin.OnValueChange = function(entry, val)
        self.pModel.Entity:SetSkin(tonumber(val) or 0)
    end;

    self.submit = self.CharInfo:Add("MButt")
    self.submit:SetFont("InfoFont")
    self.submit:Dock(TOP)
    self.submit:SetZPos(13)
    self.submit:DockMargin(10, 5, 10, 5)
    self.submit:SetText("Submit")
    self.submit:SetTall(sh * 0.04)
    self.submit:InitHover(Color(60, 60, 60), Color(80, 80, 80), 1)
    self.submit.Paint = function(s, w, h)
        s:HoverButton(w, h)
    end;
    self.submit.DoClick = function(btn)
        SENDDATA = {}
        SENDDATA["id"] = SELECTEDID[1]
        SENDDATA["name"] = self.setName:GetValue()
        SENDDATA["desc"] = self.setDesc:GetValue()
        SENDDATA["factions"] = {}
        for id, LineD in pairs(self.factionList:GetLines()) do
            SENDDATA["factions"][LineD.Columns[1]:GetValue()] = LineD.Columns[2]:GetValue()
        end
        SENDDATA["model"] = self.setPM:GetValue()
        SENDDATA["bodygroups"] = self.bodyGroupText
        SENDDATA["skin"] = self.setSkin:GetValue()
        SENDDATA["steamID"] = SELECTEDID[2]

        netstream.Start('charList::sendChanges', SENDDATA)
        surface.PlaySound("buttons/button16.wav")
    end;
    
    self.banChar = self.CharInfo:Add("MButt")
    self.banChar:SetFont("InfoFont")
    self.banChar:Dock(TOP)
    self.banChar:SetZPos(14)
    self.banChar:DockMargin(10, 5, 10, 5)
    self.banChar:SetText("Ban")
    self.banChar:SetTall(sh * 0.04)
    self.banChar:InitHover(Color(60, 60, 60), Color(80, 80, 80), 1)
    self.banChar:SetTextColor(Color(200, 100, 100))
    self.banChar.Paint = function(s, w, h)
        s:HoverButton(w, h)
    end;
    self.banChar.DoClick = function(btn)
        if btn.Disable then return end;
        if SELECTEDID[1] then
            netstream.Start('charList::action', SELECTEDID[1], true)
            self.banChar.Disable = true;
            self.unBanChar.Disable = false;
        end;
        surface.PlaySound("buttons/button16.wav")
    end;
    
    self.unBanChar = self.CharInfo:Add("MButt")
    self.unBanChar:SetFont("InfoFont")
    self.unBanChar:DockMargin(10, 5, 10, 5)
    self.unBanChar:Dock(TOP)
    self.unBanChar:SetZPos(15)
    self.unBanChar:SetTextColor(Color(100, 200, 100))
    self.unBanChar:SetText("Unban")
    self.unBanChar:SetTall(sh * 0.04)
    self.unBanChar:InitHover(Color(60, 60, 60), Color(80, 80, 80), 1)
    self.unBanChar.Paint = function(s, w, h)
        s:HoverButton(w, h)
    end;
    self.unBanChar.DoClick = function(btn)
        if btn.Disable then return end;
        if SELECTEDID[1] then
            netstream.Start('charList::action', SELECTEDID[1], false)
            self.banChar.Disable = false
            self.unBanChar.Disable = true
        end;
        surface.PlaySound("buttons/button16.wav")
    end;
end;

function PANEL:ReloadData(data)
    self.CharacterList:Clear()
    for k, v in pairs(data) do
        v = pon.decode(v)
        local line = self.CharacterList:AddLine(unpack(v))
        line.data = v;

        line.OnSelect = function(btn)
            SELECTEDID = {v[1], v[13]}
            self.BodyGroupTree:Clear()
            self.factionList:Clear()
            self.pModel:SetModel(v[9])
            self.setName:SetText(v[2])
            self.setDesc:SetText(v[4])
            self.setPM:SetText(v[9])
            self.setSkin:SetText(v[11])
            self.pModel.Entity:SetBodyGroups(v[14])
            self.pModel.Entity:SetSkin(v[11])

            for id, fac in pairs(nut.faction.teams) do
                if fac.isDefault then continue end;
                local facline = self.factionList:AddLine(fac.uniqueID, v[12][SCHEMA.folder][fac.uniqueID] or false)
                facline.OnSelect = function(line)
                    self.factionList:UnselectAll()

                    for numLine, LineD in pairs(self.factionList:GetLines()) do
                        local val = tobool(facline.Columns[2]:GetValue())
                        if !val then
                            facline.Columns[2]:SetText( "true" )
                            break;
                        elseif val then
                            facline.Columns[2]:SetText( "false" )
                            break;
                        end
                    end
                    return;
                end;
            end

            self.banChar.Disable = v[7];
            self.unBanChar.Disable = !v[7];

            self.CharInfo:AlphaTo(255, .3, 0, function(data, pnl)
                self:RefreshBodyGroupTree();
            end)
        end;
    end 
end;

function PANEL:RefreshBodyGroupTree()
    timer.Simple(0.5, function()
        self.BodyGroupTree:Clear()
        local mdl = self.pModel
        local bodyNum = mdl.Entity:GetNumBodyGroups()
        for i = 1, bodyNum - 1 do
            self.bodyGroupText[i] = 0;
            local bodygroup = mdl.Entity:GetBodygroupName( i );
            local BodyGroup = self.BodyGroupTree:AddNode( bodygroup, 'icon16/page_white_width.png' )

            for x = 0, mdl.Entity:GetBodygroupCount( i ) - 1 do
                local SubBodyGroup = BodyGroup:AddNode( x, 'icon16/page_white_width.png' )

                SubBodyGroup.DoClick = function(btn)
                    self.bodyGroupText[i + 1] = x
                    mdl.Entity:SetBodygroup(i, x)
                end;
            end;
        end;
    end)
end;

vgui.Register( "CharacterList", PANEL, "EditablePanel" )