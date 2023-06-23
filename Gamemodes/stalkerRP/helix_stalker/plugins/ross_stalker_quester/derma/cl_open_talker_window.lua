local PANEL = {};
local ourMat = Material( "gui/gradient" )
local FractureCol = Color(255, 97, 0)

local green = Color(100, 255, 100)
local red = Color(255, 100, 100)

local talkingBackground = Material( "materials/textures/dialogue.png" )

local mutantIcon, itemIcon = Material("materials/icons/notice_mutant.png"), Material("materials/icons/notice_food.png")

function PANEL:Init()
    RunConsoleCommand( '-forward' )
    RunConsoleCommand( '-jump' )
    RunConsoleCommand( '-speed' )
    self:SetFocusTopLevel( true )
    local sw, sh = ScrW(), ScrH()

	self:SetPos(sw*0.35, sh * 0.2) 
    self:SetSize( sw * 0.313, sh * 0.65 )
    self:ShowCloseButton( false )
    self:SetTitle('') self:MakePopup()

    self.HideQuestions = {}

    self.scrollAnwsers = self:Add( "DScrollPanel" )
    self.scrollAnwsers:SetPos(sw * 0.011, sh * 0.032);
    self.scrollAnwsers:SetSize(sw * 0.289, sh * 0.395)

    self.scrollQuestions = self:Add( "DScrollPanel" )
    self.scrollQuestions:SetPos(sw * 0.01, sh * 0.445);
    self.scrollQuestions:SetSize(sw * 0.290, sh * 0.175)
    gui.EnableScreenClicker(true);
end;

function PANEL:AddAnwsers(id, inside, who)
    local pnl = self;
    local clr = Color(255, 0, 0)

    if who == 'seller' then who = pnl.sellerInfo['name'] clr = Color(100, 100, 200)
    else who = LocalPlayer():GetName() clr = Color(188, 175, 14) end;

    local anwser = self.scrollAnwsers:Add("DLabel")
    anwser:SetAlpha(0)
    anwser:SetFont("StalkerGraffitiFontLittle")
    anwser:SetText("".."\n"..inside.text)
    anwser:Dock(TOP)
    anwser:SetTextColor(color_white)
    anwser:SetExpensiveShadow(1, color_black)
    anwser:SetWrap(true)
    anwser:SetAutoStretchVertical(true)
    anwser:SizeToContents()
    anwser:DockMargin(5, 5, 5, 5)
    anwser.Paint = function(_, w, h)
        draw.DrawText( who, "StalkerGraffitiFont", 3, 0, clr, TEXT_ALIGN_LEFT )      
    end;

    if inside.quest then
        self:AddTaskInfo(inside.quest)
    end;
             
    if inside.CallOnAppear then
        for k, v in pairs(self.talkTable) do
            if table.HasValue(inside.CallOnAppear, k) then
                self:AddQuestions(k)
            end;
        end;
    end;
    anwser:AlphaTo(255, 1, 0, function()
        if inside.sound then surface.PlaySound( inside.sound ) end;
    end)
    
end;

local function PlayerCanReadyQuest(id)
    local questTable = LocalPlayer():GetLocalVar("QuestList", {})
    if !questTable[id] then return false end;
    local task = questTable[id]
    local char = LocalPlayer():GetCharacter();
    local inv = char:GetInventory();
    local npcs = LocalPlayer():GetLocalVar('NPC_task_list', {})
    local charNPCs = char:GetData('NPC_task_list', {})
    local invList = inv:GetItems()

    if task.type == "Истребление мутантов" then
        for k, v in pairs(task["needToDo"]) do
            if npcs[id][k] < v then
                return false;
            end;
        end;
    else
        for k, v in pairs(task["needToDo"]) do
            if inv:GetItemCount(k) < v then
                return false;
            end;
        end;
    end;

    return true;
end;

local function PlayerHasQuest(id)
    local questTable = LocalPlayer():GetLocalVar("QuestList", {})

    return tobool(questTable[ id ]);
end;

function PANEL:AddTaskInfo(InfoQuest)
    local sw, sh = ScrW(), ScrH()
    local q_id = InfoQuest["quid"];

    local quest = self.scrollAnwsers:Add("Panel")
    quest:Dock(TOP)
    quest:SetSize(0, 60)
    quest:DockMargin(5, 5, 5, 5)     
    quest.Paint = function(s, w, h)
        draw.RoundedBoxOutlined( 2, 0, 0, w, h, Color(23, 24, 26, 255), Color(63, 64, 68) )
    end;
    quest.Material = quest:Add( "DImage" )
    quest.Material:SetSize(50, 50)
    quest.Material:SetPos( 5, 5 )
    quest.Material:DockMargin( 10, 10, 10, 10 )
    if InfoQuest.type == "Собирательство" then
        quest.Material:SetImage("materials/icons/notice_food.png")
    else
        quest.Material:SetImage("materials/icons/notice_mutant.png")
    end;

    quest.AcceptButton = quest:Add("DButton")
    quest.AcceptButton:SetPos(sw * 0.24, sh * 0.017)
    quest.AcceptButton:SetSize(75, 20)
    quest.AcceptButton:SetText("Принять")

    quest.AcceptButton.PaintOver = function(s, w, h)
        if PlayerHasQuest(q_id) then
            if PlayerCanReadyQuest(q_id) then
                quest.AcceptButton:SetText("Завершить")
                quest.AcceptButton:SetTextColor(green)
            elseif !PlayerCanReadyQuest(q_id) then
                quest.AcceptButton:SetText("Отклонить")
                quest.AcceptButton:SetTextColor(red)
            end;
        else
            quest.AcceptButton:SetText("Принять")
            quest.AcceptButton:SetTextColor(color_white)
        end;
    end;

    quest.AcceptButton.DoClick = function()
        if !quest.AcceptButton.ClickCool or CurTime() >= quest.AcceptButton.ClickCool then
            quest.AcceptButton.ClickCool = CurTime() + 1;
            netstream.Start("PlayerQuest_setting", InfoQuest, quest.AcceptButton:GetValue())
        end;
    end;

    quest.Label = quest:Add( "DLabel" )
    quest.Label:SetSize(350, 50)
    quest.Label:SetFont("StalkerFont")
    quest.Label:SetPos( 60, 5 )
    quest.Label:SetText("Задача: "..InfoQuest.type)

    local needtable, rewardTable, name = {}, {}, nil;

    for k, v in pairs(InfoQuest['needToDo']) do 
        if InfoQuest.type == "Собирательство" then
            name = ix.item.list[k].name
        else
            name = k;
        end;
        table.insert(needtable, "\n"..name..' ['..v..' шт.]') 
    end;
    for k, v in pairs(InfoQuest['rewardToGet']) do 
        if InfoQuest.type == "Собирательство" then
            name = ix.item.list[k].name 
        else
            name = k;
        end;
        table.insert(rewardTable, "\n"..name..' ['..v..' шт.]') 
    end;

    local NeedString = table.concat( needtable, ', ' );
    local RewardString = table.concat( rewardTable, ', ' )
    if NeedString == nil or NeedString == "" then
        NeedString = "Ничего не нужно."
    end;
    if RewardString == nil or RewardString == "" then
        RewardString = "Ничего нет."
    end;

    quest.Material:SetHelixTooltip(function(tooltip)
		local client = LocalPlayer()

		if (IsValid(self) and IsValid(client)) then
            local t1 = tooltip:AddRow("needString")
            t1:SetText("Нужно: "..NeedString) 
            t1:SetFont("StalkerGraffitiFontLittle")
            t1:SizeToContents()
            local t2 = tooltip:AddRow("rewardString")
            t2:SetText("Награда: "..RewardString) 
            t2:SetFont("StalkerGraffitiFontLittle")
            t2:SizeToContents()
            local t3 = tooltip:AddRow("rewardString")
            t3:SetText("Деньги: "..InfoQuest['rewardTokens'].." рублей.") 
            t3:SetFont("StalkerGraffitiFontLittle")
            t3:SizeToContents()
		end
	end)
end;


function PANEL:AddQuestions(id)
    
    local question = self.scrollQuestions:Add( "DButton" )
    question:SetText( '' )
    question:Dock( TOP )
    question:DockMargin( 5, 5, 5, 5 )
    question.DoClick = function()
        if string.find(id, "endtalking") then
            self:Close()
        else
            if self.talkTable[id].RemoveOnAppear then
                for a, b in pairs(self.talkTable[id].RemoveOnAppear) do
                    if !table.HasValue(self.HideQuestions, b) then
                        table.insert(self.HideQuestions, b)
                    end;
                end;
            end;
            self:AddAnwsers(id, self.talkTable[id], 'player')
            if self.talkTable[id].CallAnwser then
                for a, b in pairs(self.talkTable[id].CallAnwser) do
                    self:AddAnwsers(b, self.talkTable[b], 'seller')
                end;
            end;
            if self.talkTable[id].CallQuestions then
                for a, b in pairs(self.talkTable[id].CallQuestions) do
                    self:AddQuestions(b)
                    if table.HasValue(self.HideQuestions, b) then
                        table.RemoveByValue(self.HideQuestions, b)
                    end;
                end;
            end;
        end;
        surface.PlaySound("ui/buttonclick.wav");
    end;
    question.Paint = function(s, w, h)     

    if table.HasValue(self.HideQuestions, id) then
        s:SetVisible(false)
    else
        s:SetVisible(true)
    end;
    
    if s:IsHovered() then
        clr = Color(200, 200, 200)
    else
        clr = Color(255, 255, 255)
    end;
                    
        draw.DrawText( self.talkTable[id].text, "DermaDefault", 10, 5, clr, TEXT_ALIGN_LEFT )
    end; 
end;

function PANEL:Paint( w, h )
    Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
    surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( talkingBackground )
    surface.DrawTexturedRect( 0, 0, w, h )
    self:CloseOnMinus()
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

function PANEL:Populate(t1, t2, t3)

    self.talkTable = t1
    self.ids = t2;
    self.sellerInfo = t3;
    
    for id, inside in pairs(self.talkTable) do
        if inside.default && inside.isAnwser then
            local anwser = self.scrollAnwsers:Add("DLabel")
            anwser:SetAlpha(0)
            anwser:SetFont("StalkerGraffitiFontLittle")
            anwser:SetText("".."\n"..inside.text)
            anwser:Dock(TOP)
            anwser:SetTextColor(color_white)
            anwser:SetExpensiveShadow(1, color_black)
            anwser:SetWrap(true)
            anwser:SetAutoStretchVertical(true)
            anwser:SizeToContents()
            anwser:DockMargin(5, 5, 5, 5)     
            anwser.Paint = function(_, w, h)
                draw.DrawText( self.sellerInfo["name"], "StalkerGraffitiFont", 3, 0, Color(100, 255, 100), TEXT_ALIGN_LEFT )      
            end;       
                     
            if inside.quest then
                self:AddTaskInfo(inside.quest)
            end;

            if inside.CallOnAppear then
                for k, v in pairs(self.talkTable) do
                    if table.HasValue(inside.CallOnAppear, k) then
                        self:AddQuestions(k)
                    end;
                end;
            end;
            anwser:AlphaTo(255, 1, 0, function()
                if inside.sound then
                    surface.PlaySound( inside.sound )
                end;
            end)
        end;
    end;
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

vgui.Register( "OpenTalkingPanel", PANEL, "DFrame" )