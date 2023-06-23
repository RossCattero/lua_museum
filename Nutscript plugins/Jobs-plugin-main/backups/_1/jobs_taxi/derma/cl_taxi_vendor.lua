local PLUGIN = PLUGIN;
local sw, sh = ScrW(), ScrH();
local PANEL = {}
function PANEL:Init()
    self:Adaptate(350, 500)
end;
function PANEL:Populate()
	self.Answers = self:Add("DPanel")
    self.Answers:Dock(TOP);
    self.Answers:SetTall(sh * 0.1)
    self.Answers:PaintLess(true)

    self.Questions = self:Add("CompScroll")
    self.Questions:Dock(BOTTOM);
    self.Questions:SetTall(sh * 0.15)

    self:CallDefaultTalker()
end
function PANEL:CallDefaultTalker()
    local defIndex = TALKER.defAnswer
    local defQuestions = TALKER.defQuestions;
    local defAnswer = TALKER["answers"][defIndex or 0];
    local defQuestion = TALKER["questions"]

    if defAnswer then
        local ans_message = self.Answers:Add("CLabel")
        ans_message:SetText(defAnswer.answer)
        ans_message:SetFont("TaxiFontHuge")
        ans_message:SizeToContents()
    end;

    if istable(defQuestions) && #defQuestions > 0 then
        local i = #defQuestions;
        while (i > 0) do
            local question = defQuestion[ defQuestions[i] ];
            if question && (!question.canSee || (question.canSee && question.canSee(LocalPlayer()))) then
                local quest_message = self.Questions:Add("CompButton")
                quest_message:Dock(TOP)
                quest_message:SetText(question.question)
                quest_message:SetFont("TaxiFontBigger")
                quest_message:SizeToContents()

                quest_message.index = defQuestions[i]

                quest_message.DoClick = function(btn)
                    self:CallReload(btn.index)
                end;
            end;
            i = i - 1; 
        end;
    end
end;
function PANEL:CallReload(index)
    local q = TALKER["questions"][index];
    if !q then return; end

    if q.serivce == "quit" then
        self:Close();
        return;
    end

    if q.opens && q.opens != "" then
        self.Answers:Remove()
        self.Questions:Remove()
        self.Content = self:Add(q.opens)
        self.Content:Dock(FILL)
    end
end;
function PANEL:Paint( w, h )
    if PLUGIN.debug then self:DebugClose() end;
    self:DrawBlur()
end;
vgui.Register( 'TaxiVendor', PANEL, 'SPanel' )
local PANEL = {}
function PANEL:Init()
    self:Dock(FILL)
    self.Header = self:Add("CLabel")
    self.Header:Dock(TOP)
    self.Header:SetText("Read carefully:")
    self.Header:SetTall(sh * 0.085)
    self.Header:SetFont("TaxiFontHuge")

    self.Content = self:Add("CompScroll")
    self.Content:Dock(TOP)
    self.Content:SetTall(sh * 0.3)
    self.Content:DockMargin(sw * 0.005, sh * 0.0, sw * 0.005, 0)

    self.Rules = self.Content:Add("CLabel")
    self.Rules:SetText(TAXI_DATA.rulesForTaxi)
    self.Rules:Dock(FILL)
    self.Rules:SetAutoStretchVertical(true)
    self.Rules:SetWrap(true)

    self.Footer = self:Add("DPanel")
    self.Footer:Dock(FILL)
    self.Footer:PaintLess(true)

    self.LeftButtonBG = self.Footer:Add("DPanel")
    self.LeftButtonBG:Dock(LEFT)
    self.LeftButtonBG:SetWide(sw * 0.085)
    self.LeftButtonBG:PaintLess(true)

    self.accept = self.LeftButtonBG:Add("DButton")
    self.accept:Dock(FILL)
    self.accept:SetText("")
    self.accept:DockMargin(sw * 0.0345, sh * 0.025, sw * 0.0345, sh * 0.025)
    self.accept.Paint = function(s, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(112, 255, 112, 100))
    end;

    self.RButtonBG = self.Footer:Add("DPanel")
    self.RButtonBG:Dock(FILL)
    self.RButtonBG:PaintLess(true)

    self.decline = self.RButtonBG:Add("DButton")
    self.decline:Dock(FILL)
    self.decline:SetText("")
    self.decline:DockMargin(sw * 0.041, sh * 0.025, sw * 0.041, sh * 0.025)
    self.decline.Paint = function(s, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(255, 112, 112, 100))
    end;

    self.accept.DoClick = function(btn)
        if !LocalPlayer():IsTaxi() then
            netstream.Start('taxi::ApplyToTaxi')
            if TAXI.interface && TAXI.interface:IsValid() then
                TAXI.interface:Close()
            end
        end;
    end;

    self.decline.DoClick = function(btn)
        if TAXI.interface && TAXI.interface:IsValid() then
            TAXI.interface:Close()
        end
    end;
end;
vgui.Register( 'Taxi_agreement', PANEL, 'EditablePanel' )
local PANEL = {}
function PANEL:Init()
    self:Dock(FILL)
    self:DockMargin(sw * 0.005, sh * 0.005, sw * 0.005, sh * 0.005)

    self.Content = self:Add("CompScroll")
    self.Content:Dock(FILL)
    self.Content:DockMargin(0, sh * 0.2, 0, 0)

    self.buttons = {};
    table.insert(self.buttons, {
        title = "[Leave]",
        canClick = function(btn)
            return true
        end,
        onClick = function(btn)
            if TAXI.interface && TAXI.interface:IsValid() then
                TAXI.interface:Close()
            end
        end,
    })
    table.insert(self.buttons, {
        title = "Spawn me a taxi",
        canClick = function(ply, btn)
            return !ply:HasTaxi()
        end,
        onClick = function(btn)
            netstream.Start('taxi::ParentTaxi')            
        end,
    })
    table.insert(self.buttons, {
        title = "Remove my taxi",
        canClick = function(ply, btn)
            return ply:HasTaxi()
        end,
        onClick = function(btn)
            netstream.Start('taxi::ParentTaxi')  
        end,
    })
    table.insert(self.buttons, {
        title = "I don't want to work at taxi anymore",
        canClick = function(ply, btn)
            return true
        end,
        onClick = function(btn)
            Derma_Query("You'll be transfered to default faction", "Are you sure?", "Yes", 
            function() 
                netstream.Start('taxi::ApplyToTaxi')
                 if TAXI.interface && TAXI.interface:IsValid() then
                    TAXI.interface:Close()
                end
            end, 
            "Decline")
        end,
    })

    local i = #self.buttons;
    while (i > 0) do
        local button = self.Content:Add("CompButton")
        button:Dock(TOP)
        button:SetText(self.buttons[i].title);
        button:SetFont("TaxiFontBigger")
        button.index = i;
        button.DoClick = function(btn)
            local buttons = self.buttons;
            local b = buttons[btn.index];
            if !b then return; end

            if b.canClick && b.canClick(LocalPlayer(), btn) then
                if SPAWNCAR_CD && SPAWNCAR_CD >= CurTime() then return end;
                SPAWNCAR_CD = CurTime() + 1;
                b.onClick(btn)
                timer.Simple(0.5, function()
                    if !TAXI.interface || !self.Content then return end;

                    local content = self.Content:GetCanvas():GetChildren();
                    local j = #content;
                    while (j > 0) do
                        if content[j] && content[j].index then // Searching for buttons in scroll panel; Finding an index = can hide it;
                            local index = content[j].index;
                            if buttons[index].canClick(LocalPlayer(), content[j]) then
                                content[j]:SetDisabled(false)
                                content[j]:SetAlpha(255)
                            else
                                content[j]:SetDisabled(true)
                                content[j]:SetAlpha(100)
                            end
                        end
                        j = j - 1;
                    end;
                end);
            end
        end;
        if !self.buttons[i].canClick(LocalPlayer(), button) then // Same as above, but locally ^^^
            button:SetDisabled(true)
            button:SetAlpha(100)
        end
        button:SizeToContents()
        i = i - 1;
    end;
end;
vgui.Register( 'Taxi_about', PANEL, 'EditablePanel' )
