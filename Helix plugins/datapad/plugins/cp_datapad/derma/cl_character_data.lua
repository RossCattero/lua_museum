--[[
    Data panel with buttons to display on the right of character list;
]]

local PANEL = {}

function PANEL:Init()
    -- Data to send to server;
    self.send_data = {}

    local inst = LocalPlayer():GetLocalVar("_persona")

    local archivedRank = inst.rank:lower();
    if not archivedRank then
        ix.archive.ui:Close()
        return;
    end;

    local onHover = function(s, width, height)
        s.clr_default = s.clr_default or table.Copy(self.loyality_points:GetTextColor())
        if s:IsHovered() then
            s:SetTextColor( 
                Color(
                    s.clr_default.r - 50,
                    s.clr_default.g - 50,
                    s.clr_default.b - 50
                )
            )
        else
            s:SetTextColor(s.clr_default)
        end;
    end;
    self:DockPadding(20, 5, 20, 5)

    self.wrapper = self:Add("Datapad_scroll")
    self.wrapper:Dock(FILL)

    self.name = self.wrapper:Add("Datapad_character_name")
    self.name:Dock(TOP)
    self.name:SetText("-")

    self.loyality_points = self.wrapper:Add("DLabel")
    self.loyality_points:Dock(TOP)
    self.loyality_points:SetText("Loyality points: -")
    self.loyality_points:SetContentAlignment(4)
    self.loyality_points:SetFont("Datapad_data_text")
    self.loyality_points:SetMouseInputEnabled(true)
    self.loyality_points:SetCursor("hand")
    self.loyality_points:SetEnabled( ix.ranks.Permission(archivedRank, ix.ranks.permissions.edit_citizens) )
    self.loyality_points.PaintOver = onHover
    self.loyality_points.OnMousePressed = function(button)
        if not button:IsEnabled() then
            return;
        end
        Derma_StringRequest( "Set loyality points", "Write down loyality points amount", self.send_data.loyality, function(text)
            text = tonumber(text)
            if not text then
                Derma_Message("You need to specify a number data!", "Error", "OK")
                return;
            end;

            self:SetLoyality(text)
            self.apply:SetEnabled(true)
        end)
    end;
    self.loyality_points:SetVisible(false)

    self.criminal_points = self.wrapper:Add("DLabel")
    self.criminal_points:Dock(TOP)
    self.criminal_points:SetText("Criminal points: -")
    self.criminal_points:SetContentAlignment(4)
    self.criminal_points:SetFont("Datapad_data_text")
    self.criminal_points:SetMouseInputEnabled(true)
    self.criminal_points:SetCursor("hand")
    self.criminal_points:SetEnabled( ix.ranks.Permission(archivedRank, ix.ranks.permissions.edit_citizens) )
    self.criminal_points.PaintOver = onHover
    self.criminal_points.OnMousePressed = function(button)
        if not button:IsEnabled() then
            return;
        end

        Derma_StringRequest( "Set criminal points", "Write down criminal points amount", self.send_data.criminal, function(text)
            text = tonumber(text)
            if not text then
                Derma_Message("You need to specify a number data!", "Error", "OK")
                return;
            end;

            self:SetCriminal(text)
            self.apply:SetEnabled(true)
        end)
    end;
    self.criminal_points:SetVisible(false)

    self.apartment = self.wrapper:Add("DLabel")
    self.apartment:Dock(TOP)
    self.apartment:SetText("Apartment: -")
    self.apartment:SetContentAlignment(4)
    self.apartment:SetFont("Datapad_data_text")
    self.apartment:SetMouseInputEnabled(true)
    self.apartment:SetCursor("hand")
    self.apartment:SetEnabled( ix.ranks.Permission(archivedRank, ix.ranks.permissions.edit_citizens) )
    self.apartment.PaintOver = onHover
    self.apartment.OnMousePressed = function(button)
        if not button:IsEnabled() then
            return;
        end

        Derma_StringRequest( "Set apartment", "Write down apartment text (16 letters max)", self.send_data.apartment, 
        function(text)
            text = string.sub(text, 1, 16)
            self:SetApartment(text)
            self.apply:SetEnabled(true)
        end)
    end;
    self.apartment:SetVisible(false)

    self.notes = self.wrapper:Add("Datapad_character_input")
    self.notes:Dock(TOP)
    self.notes:SetTall(350)
    self.notes:SetTitle("Notes:")
    self.notes:SetVisible(false)
    self.notes:SetEnabled( ix.ranks.Permission(archivedRank, ix.ranks.permissions.edit_citizens) )
    self.notes.input.OnChange = function(entry)
        if not entry:IsEnabled() then
            return;
        end

        self.send_data.notes = entry:GetText()
        self.apply:SetEnabled(true)
    end;

    self.bol = self.wrapper:Add("Datapad_character_input")
    self.bol:Dock(TOP)
    self.bol:SetTall(50)
    self.bol:SetTitle("BOL status:")
    self.bol:SetTitleColor(Color(255, 100, 100))
    self.bol:SetMultiline(false)
    self.bol:SetVisible(false)
    self.bol:SetEnabled( ix.ranks.Permission(archivedRank, ix.ranks.permissions.edit_citizens) )
    self.bol.input.OnChange = function(entry)
        if not entry:IsEnabled() then
            return;
        end

        self.send_data.bol = entry:GetText()
        self.apply:SetEnabled(true)
    end;

    local cca = ix.ranks.Permission(archivedRank, ix.ranks.permissions.cca_access);
    local setSterelized = ix.ranks.Permission(archivedRank, ix.ranks.permissions.set_sterilized)
    local setRanks = ix.ranks.Permission(archivedRank, ix.ranks.permissions.set_ranks)
    local setCertifications = ix.ranks.Permission(archivedRank, ix.ranks.permissions.set_certifications)
    local logs = ix.ranks.Permission(archivedRank, ix.ranks.permissions.access_logs);

    self.sterilized_credits = self.wrapper:Add("DLabel")
    self.sterilized_credits:Dock(TOP)
    self.sterilized_credits:SetText("Sterilized credits: -")
    self.sterilized_credits:SetContentAlignment(4)
    self.sterilized_credits:SetFont("Datapad_data_text")
    self.sterilized_credits:SetMouseInputEnabled(true)
    self.sterilized_credits:SetEnabled( cca and setSterelized )
    self.sterilized_credits.OnMousePressed = function(button)
        if not button:IsEnabled() then
            return;
        end
        Derma_StringRequest( "Set sterilized credits", "Write down sterilized credits amount", self.send_data.sterilization, 
        function(text)
            text = tonumber(text)
            if not text then
                Derma_Message("You need to specify a number data!", "Error", "OK")
                return;
            end;

            self:SetSterillizedCredits(text)
            self.apply:SetEnabled(true)
        end)
    end;
    self.sterilized_credits:SetVisible(false)

    self.rank_choose = self.wrapper:Add("Panel")
    self.rank_choose:Dock(TOP)

    local rank_label = self.rank_choose:Add("DLabel")
    rank_label:SetText("CCA rank:")
    rank_label:SetFont("Datapad_data_text")
    rank_label:SizeToContents()
    rank_label:Dock(LEFT)

    self.rank = self.rank_choose:Add("DComboBox")
    self.rank:Dock(FILL)
    self.rank:SetValue("NONE")
    self.rank:SetFont("Datapad_data_text")
    self.rank:SetTextColor(Color(255, 255, 255))
    self.rank:SetEnabled( cca and setRanks )
    self.rank.OnSelect = function(combo, index, value, data)
        if not combo:IsEnabled() then
            return;
        end;
        self.send_data.rank = data;

        if self.apply and self.apply:IsValid() then
            self.apply:SetEnabled(true)
        end;
    end;

    for k, v in pairs(ix.ranks.list) do
        if ix.ranks.Get(k).value < ix.ranks.Get(archivedRank).value then
            self.rank:AddChoice(Format("[%s] %s", k, v.name), k, k == ix.ranks.default)
        end;
    end;
    self.rank_choose:SetVisible(false)

    self.certifications = self.wrapper:Add("Datapad_scroll")
    self.certifications:Dock(TOP)
    self.certifications:SetTall(300)

    for k, v in SortedPairs( ix.certifications.list ) do
        local certification = self.certifications:Add( "DCheckBoxLabel" )
        certification:Dock(TOP)
        certification:SetText(v.name)
        certification:SetFont("Datapad_data_text")
        certification:SetTextColor(v.color)
        certification:DockMargin(5, 5, 0, 5)
        certification:SizeToContents()
        certification.data = v;
        certification:SetEnabled(cca and setCertifications)
        certification.OnChange = function(checkbox, val)
            self.send_data.certifications[ checkbox.data.uniqueID ] = val;
            self.apply:SetEnabled(true)
        end

        certification.Label:SetHelixTooltip(function(tooltip)
            local pnl = tooltip:Add("Panel")
            pnl:Dock(FILL)
            pnl:DockPadding(5, 0, 5, 0)

            local rank = pnl:Add("DLabel")
            rank:Dock(LEFT)
            rank:SetText("["..v.rank.."] ")
            rank:SetFont("Datapad_data_text")
            rank:SizeToContents()

            local class = pnl:Add("DLabel")
            class:Dock(LEFT)
            class:SetTextColor(v.color)
            class:SetText("["..v.class.."] ")
            class:SetFont("Datapad_data_text")
            class:SizeToContents()

            local name = pnl:Add("DLabel")
            name:Dock(LEFT)
            name:SetText(v.name)
            name:SetFont("Datapad_data_text")
            name:SizeToContents()
            
            pnl:InvalidateLayout( true )
            pnl:SizeToChildren( true, true )

            tooltip:SizeToContents()
        end)
    end;

    self.certifications:SetVisible(false)
    
    -- ====================================
    if logs then
        self.logs = self.wrapper:Add("Datapad_logs")
        self.logs:Dock(TOP)
        self.logs:SetTall(350)
    end;
    -- ====================================

    self.apply = self.wrapper:Add("DButton")
    self.apply:Dock(TOP)
    self.apply:SetTall(35)
    self.apply:SetText("Apply")
    self.apply:SetTextColor(Color(255, 255, 255))
    self.apply:SetFont("Datapad_data_info")
    self.apply:SetEnabled(false)
    self.apply.Paint = function(s, w, h)
        if not s:IsEnabled() then
            s:SetAlpha(100)
            s:SetTextColor(Color(255, 255, 255))
        else
            s:SetAlpha(255)
            s:SetTextColor(Color(100, 255, 100, 255))
        end;
    end;
    self.apply.DoClick = function(button)
        if not Cooldown or Cooldown < RealTime() then
            surface.PlaySound("buttons/blip1.wav")
            net.Start("ix.datapad.send")
                net.WriteString(util.TableToJSON(self.send_data))
            net.SendToServer()

            for num, num_data in ipairs(ix.archive.instances) do
                if num_data.id == self.send_data.id then
                    for k, v in pairs(self.send_data) do
                        if ix.archive.instances[num][k] then
                            ix.archive.instances[num][k] = v;
                        end;
                    end;
                    self.apply:SetEnabled(false)
                    break;
                end;
            end;
            Cooldown = RealTime() + 0.5;
        else
            ix.util.Notify("You can't do this right now.")
        end;
    end;
end

function PANEL:SetLoyality(amount)
    self.loyality_points:SetText(Format("Loyality points: %s", amount))
    self.send_data.loyality = amount;
end;

function PANEL:SetCriminal(amount)
    self.criminal_points:SetText(Format("Criminal points: %s", amount))
    self.send_data.criminal = amount;
end;

function PANEL:SetApartment(name)
    self.apartment:SetText(Format("Apartment: %s", name))
    self.send_data.apartment = name;
end;

function PANEL:SetNotes(text)
    self.notes:SetText(text)
    self.send_data.notes = text
end;

function PANEL:SetBOL(text)
    self.bol:SetText(text)
    self.send_data.bol = text
end;

function PANEL:SetSterillizedCredits(amount)
    self.sterilized_credits:SetText(Format("Sterilized Credits: %s", amount))
    self.send_data.sterilization = amount;
end;

function PANEL:SetRank(rankName)
    for k, v in ipairs(self.rank.Choices) do
        if string.lower(self.rank:GetOptionData(k)) == string.lower(rankName) then
            self.rank:ChooseOptionID(k)
            self.send_data.rank = self.rank:GetOptionData(k);
            return;
        end;
    end;
end;

function PANEL:SetCertifications(certifications)
    self.send_data.certifications = {}

    for k, checkbox in ipairs( self.certifications:GetCanvas():GetChildren() ) do
        checkbox:SetChecked(certifications[checkbox.data.uniqueID])
        self.send_data.certifications[checkbox.data.uniqueID] = certifications[checkbox.data.uniqueID] and true;
    end;
end;

-- Load character's data and all info.
function PANEL:Load( data )
    if next(data) == nil then
        return;
    end;

    self.send_data = {
        cid = data.cid,
        id = data.id,
        asAdmin = ix.datapad.asAdmin
    }

    self:SetVisible(true)
    self.name:SetVisible(true)

    if data.cid then        
        self.name:SetText(Format("%s, #%s", data.name, data.cid))

        self.sterilized_credits:SetVisible(false)
        self.rank_choose:SetVisible(false)
        self.certifications:SetVisible(false)
        self.loyality_points:SetVisible(true)
        self:SetLoyality(data.loyality)
        self.criminal_points:SetVisible(true)
        self:SetCriminal(data.criminal)
        self.apartment:SetVisible(true)
        self:SetApartment(data.apartment)
        self.notes:SetVisible(true)
        self:SetNotes(data.notes or "")
        self.bol:SetVisible(true)
        self:SetBOL(data.bol or "")

        self.apply:SetEnabled(false)
    else
        self.name:SetText(Format("%s", data.name))

        self.loyality_points:SetVisible(false)
        self.criminal_points:SetVisible(false)
        self.apartment:SetVisible(false)
        self.notes:SetVisible(false)
        self.bol:SetVisible(false)

        self.sterilized_credits:SetVisible(true)
        self:SetSterillizedCredits(data.sterilization)

        self.rank_choose:SetVisible(true)
        self:SetRank(data.rank)

        self.certifications:SetVisible(true)
        self:SetCertifications(data.certifications)

        self.apply:SetEnabled(false)

    end;
end;

function PANEL:Paint(w, h)
    surface.SetDrawColor(ix.datapad.colors.border)
	surface.DrawOutlinedRect(0, 0, w, h, 2)
end;

vgui.Register("Datapad_character_data", PANEL, "EditablePanel")
