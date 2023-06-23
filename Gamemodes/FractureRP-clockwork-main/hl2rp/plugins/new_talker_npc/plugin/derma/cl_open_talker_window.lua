local PANEL = {};
local ourMat = Material( "gui/gradient" )
local FractureCol = Color(255, 97, 0)

function PANEL:Init()
    RunConsoleCommand( '-forward' )
    RunConsoleCommand( '-jump' )
    RunConsoleCommand( '-speed' )
    self:SetFocusTopLevel( true )
    local scrW = surface.ScreenWidth();
    local scrH = surface.ScreenHeight();

	self:SetPos((scrW/2) - 350, (scrH/2) - 350) 
    self:SetSize( 600, 700 )
    self:ShowCloseButton( false )
    self:SetTitle('')
    self:MakePopup()

    self.HideQuestions = {}

    local pW, pH = self:GetSize(); local pX, pY = self:GetPos();

    self.anwsers = vgui.Create("DPanel", self)
    self.anwsers:SetPos(10, 10);
    self.anwsers:SetSize(pW - 20, pH - 200)
    function self.anwsers:Paint(w, h)
        draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 100), FractureCol )
    end;
    
    pW, pH = self.anwsers:GetSize(); pX, pY = self.anwsers:GetPos();
    
    self.questions = vgui.Create("DPanel", self)
    self.questions:SetPos(pX, pY + 510);
    self.questions:SetSize(pW, pH - 330)
    function self.questions:Paint(w, h)
        draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 100), FractureCol )
    end;
    local pnl = self
        
    self.scrollAnwsers = vgui.Create( "DScrollPanel", self.anwsers )
    self.scrollAnwsers:Dock( FILL )
    
    self.scrollQuestions = vgui.Create( "DScrollPanel", self.questions )
    self.scrollQuestions:Dock( FILL )

    gui.EnableScreenClicker(true);
end;

function PANEL:AddAnwsers(id, inside, who)
    local pnl = self;
    local clr = Color(255, 0, 0)

    if who then
        if who == 'seller' then
            who = pnl.sellerInfo['name']
            clr = Color(100, 100, 200)
        else
            who = Clockwork.Client:GetName()
            clr = Color(100, 200, 100)
        end;
    else
        return;
    end;

    local anwser = self.scrollAnwsers:Add( "DPanel" )
    anwser:SetAlpha(0)
    anwser:SetText( '' )
    anwser:SetSize(0, 65)
    anwser:Dock( TOP )
    anwser:DockMargin( 5, 5, 5, 5 )
    function anwser:Paint(w, h)
        surface.SetDrawColor( 255, 97, 0, 100 )
        surface.SetMaterial( ourMat	)
        surface.DrawTexturedRect( 0, 0, w, h )
        draw.DrawText( who, "DermaDefault", 10, 5, color_white, TEXT_ALIGN_LEFT )      
        draw.DrawText( ConvertSomeText(inside.text), "DermaDefault", 10, 30, color_white, TEXT_ALIGN_LEFT )
    end;

    if inside.quest && !HasQuestByID(pnl.sellerInfo['name'], pnl.playerQuests) then
        self.acceptButton = vgui.Create( "DButton", anwser )
        self.acceptButton:SetText( "Принять" )
        self.acceptButton:SetPos( 420, 5 )
        self.acceptButton:SetSize( 55, 15 )
        self.acceptButton:SetColor(FractureCol)
        self.acceptButton.DoClick = function(self)
            self:Hide()
            pnl.denybutton:Hide()

            if !HasQuestByID(pnl.sellerInfo['name'], pnl.playerQuests) then
                cable.send('AcceptQuest', inside.quest, {pnl.ids, pnl.sellerInfo['name']} );
            end;
        end   
        self.acceptButton.Paint = function(self, w, h)
            draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(0, 0, 0, 150), FractureCol);
            if HasQuestByID(pnl.sellerInfo['name'], pnl.playerQuests) then
                self:Remove();
            end;
        end;
    
        self.denybutton = vgui.Create( "DButton", anwser )
        self.denybutton:SetText( "Отклонить" )
        self.denybutton:SetPos( 480, 5 )
        self.denybutton:SetSize( 65, 15 )
        self.denybutton:SetColor(FractureCol)
        self.denybutton.DoClick = function(self)
            self:Hide()
            pnl.acceptButton:Hide()
        end
        self.denybutton.Paint = function(self, w, h)
            draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(0, 0, 0, 150), FractureCol);
            if HasQuestByID(pnl.sellerInfo['name'], pnl.playerQuests) then
                self:Remove();
            end;
        end;
    elseif inside.quest && HasQuestByID(pnl.sellerInfo['name'], pnl.playerQuests) then
        self.finishButton = vgui.Create( "DButton", anwser )
        self.finishButton:SetText( "Закончить" )
        self.finishButton:SetPos( 420, 5 )
        self.finishButton:SetSize( 55, 15 )
        self.finishButton:SetColor(FractureCol)
        self.finishButton.DoClick = function(self)
            self:Hide()
            pnl.declineButton:Hide()
        end   
        self.finishButton.Paint = function(self, w, h)
            draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(0, 0, 0, 150), FractureCol);
        end;
    
        self.declineButton = vgui.Create( "DButton", anwser )
        self.declineButton:SetText( "Отклонить" )
        self.declineButton:SetPos( 480, 5 )
        self.declineButton:SetSize( 65, 15 )
        self.declineButton:SetColor(FractureCol)
        self.declineButton.DoClick = function(self)
            self:Hide()
            pnl.finishButton:Hide()
        end
        self.declineButton.Paint = function(self, w, h)
            draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(0, 0, 0, 150), FractureCol);
        end;
    end;

    if inside.CallOnAppear then
        for k, v in pairs(self.talkTable) do
            if table.HasValue(inside.CallOnAppear, k) then
                self:AddQuestions(k)
            end;
        end;
    end;

    anwser:AlphaTo(255, 0.5, 0, function()
        if inside.sound then
            surface.PlaySound( inside.sound )
        end;
    end)
    
end;

function PANEL:AddQuestions(id)
    local pnl = self;
    
    local question = self.scrollQuestions:Add( "DButton" )
    question:SetText( '' )
    question:Dock( TOP )
    question:DockMargin( 5, 5, 5, 5 )
    function question:DoClick(self)
        if string.find(id, "endtalking") then
            pnl:Close()
        else
            if pnl.talkTable[id].RemoveOnAppear then
                for a, b in pairs(pnl.talkTable[id].RemoveOnAppear) do
                    if !table.HasValue(pnl.HideQuestions, b) then
                        table.insert(pnl.HideQuestions, b)
                    end;
                end;
            end;
            pnl:AddAnwsers(id, pnl.talkTable[id], 'player')
            if pnl.talkTable[id].CallAnwser then
                for a, b in pairs(pnl.talkTable[id].CallAnwser) do
                    pnl:AddAnwsers(b, pnl.talkTable[b], 'seller')
                end;
            end;
            if pnl.talkTable[id].CallQuestions then
                for a, b in pairs(pnl.talkTable[id].CallQuestions) do
                    pnl:AddQuestions(b)
                    if table.HasValue(pnl.HideQuestions, b) then
                        table.RemoveByValue(pnl.HideQuestions, b)
                    end;
                end;
            end;
        end;
        surface.PlaySound("ui/buttonclick.wav");
    end;
    function question:Paint(w, h)     

    if table.HasValue(pnl.HideQuestions, id) then
        self:SetVisible(false)
    else
        self:SetVisible(true)
    end;
    
    if self:IsHovered() then
        clr = Color(100, 255, 100)
    else
        clr = Color(255, 255, 255, 255)
    end;
                    
        draw.DrawText( pnl.talkTable[id].text, "DermaDefault", 10, 5, clr, TEXT_ALIGN_LEFT )
    end; 
end;

function PANEL:Paint( w, h )
    Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
    draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 100), FractureCol )
    -- self:CloseOnMinus()
end;

function PANEL:Close()
    self:SetVisible(false); self:Remove();
    gui.EnableScreenClicker(false);
end;

function PANEL:CloseOnMinus()
    if input.IsKeyDown( KEY_PAD_MINUS ) then
        surface.PlaySound("ui/buttonclick.wav");
        self:Close();
    end;
end;

function PANEL:Populate(data, iid, sinfo, quests, npc)
    local pnl = self;

    self.talkTable = data;
    self.ids = iid;
    self.sellerInfo = sinfo;
    self.playerQuests = quests;
    self.npctable = npc
    
    for id, inside in pairs(pnl.talkTable) do

        if inside.default && inside.isAnwser then

            local anwser = pnl.scrollAnwsers:Add( "DPanel" )
            anwser:SetAlpha(0)
            anwser:SetText( '' )
            anwser:SetSize(0, 65)
            anwser:Dock( TOP )
            anwser:DockMargin( 5, 5, 5, 5 )
            function anwser:Paint(w, h)
                surface.SetDrawColor( 255, 97, 0, 100 )
                surface.SetMaterial( ourMat	)
                surface.DrawTexturedRect( 0, 0, w, h )

                draw.DrawText( pnl.sellerInfo['name'], "DermaDefault", 10, 5, color_white, TEXT_ALIGN_LEFT )      
                draw.DrawText( ConvertSomeText(inside.text), "DermaDefault", 10, 30, color_white, TEXT_ALIGN_LEFT )
            end;

            if inside.quest then
                if !HasQuestByID(pnl.sellerInfo['name'], quests) then
                    self.acceptButton = vgui.Create( "DButton", anwser )
                    self.acceptButton:SetText( "Принять" ) self.acceptButton:SetColor(FractureCol)
                    self.acceptButton:SetPos( 420, 5 ) self.acceptButton:SetSize( 55, 15 )
                    self.acceptButton.DoClick = function(self)
                        if !HasQuestByID(pnl.sellerInfo['name'], pnl.playerQuests) then
                            self:SetDisabled(true);
                            pnl.infoButton:SetDisabled(true);
                            cable.send('AcceptQuest', inside.quest, {pnl.ids, pnl.sellerInfo['name']} );
                            pnl.infoButton:AlphaTo(0, 0.5, 0, function()
                                if self:IsValid() then
                                    self:Remove();
                                end;
                            end);
                            self:AlphaTo(0, 0.5, 0, function()
                                if self:IsValid() then
                                    table.insert(pnl.playerQuests, inside.quest);
                                    self:Remove();
                                end;
                            end);
                        end;
                    end   
                    self.acceptButton.Paint = function(self, w, h)
                        if HasQuestByID(pnl.sellerInfo['name'], pnl.playerQuests) then
                            self:Remove();
                        end;
                        dohover(self, w, h)
                    end;
                elseif HasQuestByID(pnl.sellerInfo['name'], pnl.playerQuests) then
                    self.finishButton = vgui.Create( "DButton", anwser )
                    self.finishButton:SetPos( 420, 5 ) self.finishButton:SetSize( 55, 15 )
                    self.finishButton:SetText( "Закончить" ) self.finishButton:SetColor(FractureCol)
                    self.finishButton.DoClick = function(self)
                        local hasquest = HasQuestByID(pnl.sellerInfo['name'], pnl.playerQuests);
                        local cantake = PLAYER_Cantakequest( inside.quest['type'], Clockwork.inventory:GetClient(), inside.quest['needToDo'], npc )
                        if hasquest && cantake then
                            self:SetDisabled(true);
                            pnl.declineButton:SetDisabled(true);
                            pnl.infoButton:SetDisabled(true);
                            self:AlphaTo(0, 0.5, 0, function()
                                if self:IsValid() then
                                    cable.send('FinishQuest', inside.quest, {pnl.ids, pnl.sellerInfo['name']} );
                                    for k, v in pairs(pnl.playerQuests) do
                                        if v.vendorName == pnl.sellerInfo['name'] then
                                            pnl.playerQuests[k] = nil;
                                        end;
                                    end;
                                    self:Remove();
                                end;
                            end);
                            pnl.declineButton:AlphaTo(0, 0.5, 0, function()
                                if pnl.declineButton:IsValid() then
                                    pnl.declineButton:Remove();
                                end;
                            end);
                            pnl.infoButton:AlphaTo(0, 0.5, 0, function()
                                if pnl.infoButton:IsValid() then
                                    pnl.infoButton:Remove();
                                end;
                            end);
                        end;
                    end;
                    self.finishButton.Paint = function(self, w, h)
                        if !HasQuestByID(pnl.sellerInfo['name'], pnl.playerQuests) then
                            self:Remove();
                        end;
                        dohover(self, w, h)
                    end;

                    self.declineButton = vgui.Create( "DButton", anwser )
                    self.declineButton:SetText( "Отклонить" ) self.declineButton:SetColor(FractureCol)
                    self.declineButton:SetPos( 350, 5 ) self.declineButton:SetSize( 65, 15 )
                    self.declineButton.DoClick = function(self)
                        local hasquest = HasQuestByID(pnl.sellerInfo['name'], pnl.playerQuests)
                        if hasquest then
                            self:SetDisabled(true);
                            pnl.finishButton:SetDisabled(true);
                            pnl.infoButton:SetDisabled(true);
                            self:AlphaTo(0, 0.5, 0, function()
                                if self:IsValid() then
                                    cable.send('DeclineQuest', inside.quest, {pnl.ids, pnl.sellerInfo['name']} );
                                    for k, v in pairs(pnl.playerQuests) do
                                        if v.vendorName == pnl.sellerInfo['name'] then
                                            pnl.playerQuests[k] = nil;
                                        end;
                                    end;                                    
                                    self:Remove();
                                end;
                            end);
                            pnl.finishButton:AlphaTo(0, 0.5, 0, function()
                                if pnl.finishButton:IsValid() then
                                    pnl.finishButton:Remove();
                                end;
                            end);
                            pnl.infoButton:AlphaTo(0, 0.5, 0, function()
                                if pnl.infoButton:IsValid() then
                                    pnl.infoButton:Remove();
                                end;
                            end);
                        end;
                    end
                    self.declineButton.Paint = function(self, w, h)
                        if !HasQuestByID(pnl.sellerInfo['name'], pnl.playerQuests) then
                            self:Remove();
                        end;
                        dohover(self, w, h)
                    end;                    
                end;
                self.infoButton = vgui.Create( "DButton", anwser )
                self.infoButton:SetText( "Информация" )
                self.infoButton:SetPos( 480, 5 )
                self.infoButton:SetSize( 75, 15 )
                self.infoButton:SetColor(FractureCol)
                self.infoButton.DoClick = function(self)
                    if pnl.acceptButton then
                        pnl:CallQuestInfo( inside.quest )
                    elseif pnl.declineButton then
                        for k, v in pairs(pnl.playerQuests) do
                            if v.vendorName == pnl.sellerInfo['name'] then
                                pnl:CallQuestInfo( v )
                            end;
                        end;
                    end;
                end
                self.infoButton.Paint = function(self, w, h)
                    dohover(self, w, h)
                end;
            end;

            anwser:AlphaTo(255, 0.5, 0, function() if inside.sound then surface.PlaySound( inside.sound ) end  end)
        end;
    
        if inside.CallOnAppear then
            for k, v in pairs(pnl.talkTable) do
                if table.HasValue(inside.CallOnAppear, k) then
                    pnl:AddQuestions(k)
                end;
            end;
        end;
    end;
end;

function PANEL:CallQuestInfo(quest)
    local needtable = {};
    local rewardTable = {};

    for k, v in pairs(quest['needToDo']) do
        table.insert(needtable, k..'['..v..']')
    end;
    for k, v in pairs(quest['rewardToGet']) do
        table.insert(rewardTable, k..'['..v..']')
    end;
    Derma_Message( "Тип:"..quest['type'].."\nНужно: "..table.concat( needtable, ', ' )..".\nНаграда: "..table.concat( rewardTable, ', ' )..'.\nТокены: '..quest['rewardTokens'], "Информация", "Понял" )
end;

function PLAYER_Cantakequest( type, inventory, sellerquests, npcs )
    local littlebuffer = {};
    if type == 'Собирательство' then
        for k, v in pairs(sellerquests) do
            if Clockwork.inventory:HasItemCountByID(inventory, k, v) then
                table.insert(littlebuffer, true)
            elseif !Clockwork.inventory:HasItemCountByID(inventory, k, v) then
                table.insert(littlebuffer, false)
            end;
        end;
    elseif type == 'Убийство НПС' && npcs then
        for k, v in pairs(sellerquests) do
            if npcs[k] == sellerquests[k] then
                table.insert(littlebuffer, true)
            elseif npcs[k] != sellerquests[k] then
                table.insert(littlebuffer, false)
            end;
        end;
    end;

    if !table.HasValue(littlebuffer, false) && table.Count(littlebuffer) != 0 then return true end;
    return false;
end;

function dohover(pnl, w, h)
	if !pnl.nol then
		pnl.nol = 0
	end;
	if pnl:IsHovered() then
		pnl.nol = math.Approach( pnl.nol, w, 300 * FrameTime() )
		draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(255, 255, 255, 150), Color(255, 97, 0));
	else
		pnl.nol = 0
		draw.RoundedBoxOutlined(0, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 97, 0));
	end;
end;

vgui.Register( "RossSalesmanOpen", PANEL, "DFrame" )