local PLUGIN = PLUGIN;
local sw, sh = ScrW(), ScrH();

local PANEL = {}

function PANEL:Init()
	self:SetFocusTopLevel( true )
    self:MakePopup()
    gui.EnableScreenClicker(true);
    self:SetAlpha(0)
    self:AlphaTo(255, .3, 0, function(alpha, pnl) 
		pnl:SetAlpha(255) 
	end);

	self:Adaptate(sw, sh, 0, 0)
end

function PANEL:Populate()
	self.Body = self:Add("DPanel")
	self.Body:Adaptate(700, 700)
	self.Body.Paint = function(s, w, h)
		draw.OutlineRectangle(0, 0, w, h, Color(60, 60, 60), Color(100, 100, 100))
	end;

	self._list = {}

	self.leftPanel = self.Body:Add("DPanel")
	self.leftPanel:Dock(LEFT)
	self.leftPanel:Adaptate(350, 0)
	self.leftPanel.Paint = function(s, w, h)
		local body = LimbBody["body"];
		surface.SetMaterial( body )
		surface.SetDrawColor(Color(255, 255, 255, 255))
		surface.DrawTexturedRect( sw * 0, sh * 0.005, w, h * 0.95 )

		local i = #LimbBody;
		while (i >= 1) do
			local mat = LimbBody[i];
			if mat then
					local name = mat:GetName():match("materials/limbs/([%w_]+)")
					if Limbs[name] then
						surface.SetMaterial( mat )
						surface.SetDrawColor(Color(255, 0, 0, math.min(#Limbs[name] * 65, 200) ))
						surface.DrawTexturedRect( sw * 0, sh * 0.005, w, h * 0.95 )
					end
			end;
			i = i - 1;
		end;
	end;

	self.OpenCanSee = self.Body:Add("DButton")
	self.OpenCanSee:Dock(BOTTOM)
	self.OpenCanSee:SetText("> Кто может меня осмотреть <")
	self.OpenCanSee:DockMargin(2, 0, 2, 5)
	self.OpenCanSee:SetFont("limb-empty")
	self.OpenCanSee.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50))
	end;
	local defaultText, secondText = "> Кто может меня осмотреть <", "> Показать мои характеристики <"

	self.OpenCanSee.DoClick = function(btn)
		if btn.clicked && btn.clicked > CurTime() then return end;
		btn.clicked = CurTime() + 1.5;

		local inj, chList = self.injuries, self.charList;

		local iVisible, chVisible = inj:IsVisible(), chList:IsVisible();

		if !iVisible then inj:SetVisible(true) end;
		inj:AlphaTo(!iVisible && 255 || 0, .5, 0, function(data, pnl)
			if iVisible then inj:SetVisible(!iVisible) end;
		end)
		
		if !chVisible then chList:SetVisible(true) end;
		chList:AlphaTo(!chVisible && 255 || 0, .5, 0, function(data, pnl)
			if chVisible then chList:SetVisible(!chVisible) end;
		end)

		btn:SetText(!chVisible && secondText || defaultText)
	end;

	self.injuries = self.Body:Add("DScrollPanel")
	self.injuries:Dock(FILL)
	self.injuries:DockMargin(2, 5, 2, 5)
	self.injuries.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50))
	end;

	// Будет выводиться список только знакомых персонажей.
	self.charList = self.Body:Add("LimbCharList")
	self.charList:Dock(FILL)
	self.charList:SetVisible(false)
	self.charList:SetAlpha(0)
	self.charList:DockMargin(2, 5, 2, 5)

	self.bloodLevel = self.injuries:Add("BloodDrop")
	self.painLevel = self.injuries:Add("PainDraw")
	for i = 1, #LIMB.LIST do
		local limb = LIMB.LIST[i];
		if limb then
			self.list = self.injuries:Add("LimbList");
			self.list.data = limb;
			self.list:Populate()

			self.list:ReloadInjuries()

			self._list[limb] = self.list
		end;
	end;
end;

function PANEL:OnRemove()
	CloseDermaMenus() 
	LIMB.INT_CD = nil; 
end

function PANEL:Paint(w, h)
	if LIMB.INT_CD && LIMB.INT_CD <= CurTime() && input.IsKeyDown( LIMB.INT_KEY ) then self:Close() end

	self:DrawBlur()
end;


vgui.Register( "Limbs", PANEL, "EditablePanel" )

local PANEL = {}
function PANEL:Init()
		self:Dock(TOP)
		self:DockMargin(0, 5, 0, 5)
end;
function PANEL:Populate()
		local info = self.data;

		self.titleBG = self:Add("DPanel")
		self.titleBG:Dock(TOP)
		self.titleBG.Paint = function(s, w, h) end;

		self.titleBG.title = self.titleBG:Add("DLabel")
		self.titleBG.title:SetText(info.name)
		self.titleBG.title:Dock(FILL)
		self.titleBG.title:SetFont("limb-subtext")
		self.titleBG.title:SetContentAlignment(5)
		self.titleBG.title:SizeToContents()

		self.limbList = self:Add("DListLayout")
		self.limbList:Dock(TOP)
end;

function PANEL:ReloadInjuries()
		self.limbList:Clear();

		local bone = Limbs[ self.data.index ]

		if !bone then return end;

		if #bone <= 0 then
			local noInj = self.limbList:Add("DLabel")
			noInj:SetFont("limb-empty")
			noInj:Dock(TOP)
			noInj:SetText("~ Нет повреждений ~")
			noInj:SetTextColor( Color(150, 150, 150) )
			noInj:SetContentAlignment(5)
			noInj:SetTall(35)
		else
			for i = 1, #bone do
				local inj = bone[i];
				if inj then
					local limb = self.limbList:Add("LimbDraw")
					limb.data = inj
					limb.onBone = {self.data.index, i}
					limb:Populate();
				end
			end;
		end;

		self.limbList:InvalidateLayout( true )
		self.limbList:SizeToChildren( false, true )
		self:InvalidateLayout( true )
		self:SizeToChildren( false, true )
end;
vgui.Register( 'LimbList', PANEL, 'EditablePanel' )

local PANEL = {}
function PANEL:Init()
		local blood = math.Round(Blood, 2) .. " ml ";
		local bloodDrop = isbool(Bleeding) && (Bleeding && "Кровотечение" || "Нет кровотечения") || math.Round(Bleeding, 2)
		local drop = !isbool(Bleeding) && bloodDrop > 0 && "(-"..bloodDrop.." ml/sec)" || ""

		self:Dock(TOP)
		self:SetTall( sh * 0.03 )

		self.text = self:Add("DLabel")
		self.text:Dock(FILL)
		self.text:SetFont("limb-text")
		self.text:SetText("Кровь: " .. blood .. drop)
		self.text:SetContentAlignment(5)
		self.text:SetTextColor(Color(200, 50, 50))
		self.text:SizeToContents()
end;
function PANEL:Paint( w, h ) end;
vgui.Register( 'BloodDrop', PANEL, 'EditablePanel' )

local PANEL = {}
function PANEL:Init()
		local clr, font = Color(255, 50, 50), "limb-text"
		if !Pain then 
			Pain = "Нету боли"
			clr = Color(100, 100, 100, 255)
		end;

		self:Dock(TOP)
		self:SetTall( sh * 0.03 )
		self:SetMouseInputEnabled(true)
		self:SetCursor("hand")

		self.text = self:Add("DLabel")
		self.text:Dock(FILL)
		self.text:SetFont(font)
		self.text:SetText(Pain)
		self.text:SetContentAlignment(5)
		self.text:SizeToContents()
		self.text:SetTextColor(clr)
		self.text:DockMargin(sw * 0.003, 0, 0, 0)
end;
function PANEL:Paint( w, h ) end;

function PANEL:OnMousePressed()
	local ply = LocalPlayer();
	local character = ply:GetCharacter();
	local inv = character:GetInventory();
	local items = inv:GetItemsByBase( "base_medicine" );

	local dMenu = DermaMenu()
	for i = 1, #items do
		local item = items[i];
		if item:IsPainkiller() && item:GetData("Amount") > 0 then
			dMenu:AddOption(item.name .. " [" .. item:GetData("Amount") .. "]", function()
				netstream.Start("Limbs::health", "pain", item:GetID(), IsLocalPlayerData or false)
			end)
		end;
	end
	dMenu:Open()
end;

vgui.Register( 'PainDraw', PANEL, 'EditablePanel' )

local PANEL = {}
function PANEL:Init()
	self:SetTall(sh * 0.035)
	self:DockMargin(0, sh * 0.003, 0, 0)

	self:SetMouseInputEnabled(true)
	self:SetCursor("hand")
end;

function PANEL:Populate()
		local data = self.data;
		local injuries = LIMB.INJURIES[data.index]

		local title = injuries.name.." ".. LIMB.STAGES[data.stage].rim or "I"
		local descr = injuries.stageList[data.stage] or ""
		
		self.text = self:Add("DLabel")
		self.text:SetText( title )
		self.text:SetFont("limb-text")
		self.text:Dock(FILL)
		self.text:SetTextColor( data.heal != "" && LIMB.HEAL_CLR || data.infected && LIMB.ROT_CLR || LIMB.INJ_CLR )
		self.text:SetContentAlignment(5)
		self.text:SizeToContents()

		if data.stage then
			self:SetHelixTooltip(function(tooltip)
				local name = tooltip:AddRow("name")
				name:SetText(title)
				name:SetImportant()
				name:SetBackgroundColor(Color(142, 82, 156))
				name:SizeToContents()

				if descr then
					local desc = tooltip:AddRowAfter("name", "description")
					desc:SetText(descr)
					desc:SizeToContents()
				end;

				if !data.infected && data.heal == "" then
					if injuries.causeBlood then
						local blood = tooltip:AddRowAfter("description", "causeBleed")
						blood:SetText(LIMB.BLOOD_TEXT)
						blood:SetTextColor( LIMB.BLOOD_CLR )
						blood:SizeToContents()
					end;
					if LIMB:CanRot(data.index) then
						local rot = tooltip:AddRowAfter("causeBleed", "rot")
						rot:SetText(LIMB.ROT_TEXT)
						rot:SetTextColor( LIMB.ROT_CLR )
						rot:SizeToContents()
					end
				elseif data.infected then
					local inf = tooltip:AddRowAfter("rot", "infection")
					inf:SetText( LIMB.INFECT_TEXT )
					inf:SetTextColor( LIMB.ROT_CLR )
					inf:SizeToContents()
				elseif data.heal != "" then
					local inf = tooltip:AddRowAfter("rot", "heal")
					inf:SetText( "Вылечено при помощи: \"" .. ix.item.list[data.heal].name .. "\"" )
					inf:SetTextColor( LIMB.HEAL_CLR )
					inf:SizeToContents()
				end;						
		
				tooltip:SizeToContents()
			end)
		end;
end;

function PANEL:OnMousePressed()
	local data = self.data;
	local iNum = data.index;

	local ply = LocalPlayer();
	local character = ply:GetCharacter();
	local inv = character:GetInventory();
	local items = inv:GetItemsByBase( "base_medicine" );

	local dMenu = DermaMenu()
	if data.heal == "" then
		for i = 1, #items do
			local item = items[i];

			if item:IsBandages()
			&& iNum && item:GetCanHeal(iNum)
			&& LIMB.INJURIES[iNum] && item:GetAmount() > 0 then
				dMenu:AddOption(item.name .. " [" .. item:GetAmount() .. "]", function()
					netstream.Start("Limbs::health", self.onBone, item:GetID(), IsLocalPlayerData or false)
				end)
			end;
		end
	elseif data.heal != "" then
		dMenu:AddOption("Снять повязку " .. ( data.healAmount > CurTime() && "(Чистая)" || "(Грязная)"), function()

		end)
	end

	dMenu:Open()
end;

function PANEL:Paint( w, h ) 
	if self:IsHovered() then
		draw.RoundedBox(0, 0, 0, w, h, Color(80, 80, 80, 100))
	end;
end;
vgui.Register( 'LimbDraw', PANEL, 'EditablePanel' )

local PANEL = {}
function PANEL:Init()
	self.info = self:Add("DLabel")
	self.info:SetText( "Кого я помню:" )
	self.info:SetFont("limb-subtext")
	self.info:Dock(TOP)
	self.info:SetContentAlignment(5)
	self.info:SizeToContents()

	self.charList = self:Add("DListLayout")
	self.charList:Dock(TOP)

	local selfChar = LocalPlayer():GetCharacter()
	local players = player.GetAll()

	local reco = false;

	for i = 1, #players do
		local ply = players[i];
		local character = ply:GetCharacter()

		local doesRecognize = selfChar:DoesRecognize(character)

		if doesRecognize && selfChar != character then
			local char = self.charList:Add("LimbCharList__char")
			char:Dock(TOP)
			char.pointer = character;

			char:Populate()

			reco = true;
		end;
	end

	if !reco then
		self.lbl = self:Add("DLabel")
		self.lbl:SetText( "Я никого не помню" )
		self.lbl:SetFont("limb-empty")
		self.lbl:Dock(TOP)
		self.lbl:SetContentAlignment(5)
		self.lbl:SizeToContents()
	end

	self.charList:InvalidateLayout( true )
	self.charList:SizeToChildren( false, true )
end;

function PANEL:Paint( w, h ) 
	draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 150))
end;
vgui.Register( 'LimbCharList', PANEL, 'EditablePanel' )

local PANEL = {}
function PANEL:Init() 
	self:SetMouseInputEnabled(true)
	self:SetCursor("hand")

	self:DockMargin(5, 5, 5, 5)
end;

function PANEL:Populate()
	local data = self.pointer;
	if !data then self:Remove() return end;

	local ply = data.player;
	ply = player.GetAll()[ply];

	if !ply then self:Remove() return end;

	local name, nick = ply:GetName(), steamworks.GetPlayerName( ply:SteamID64() ) || "Unknown"

	local info = LocalPlayer():GetLocalVar("reco", {})

	self.text = self:Add("DLabel")
	self.text:SetText( name .. " [ " .. nick .." ]" )
	self.text:SetFont("limb-subtext")
	self.text:Dock(TOP)
	self.text:SetContentAlignment(5)
	self.text:SizeToContents()

	self.text:SetTextColor(info[data.id || 0] && Color(100, 255, 100) || Color(255, 255, 255))
end;

function PANEL:OnMousePressed()
	local data = self.pointer;
	if !data || (self.press && self.press > CurTime()) then return end;
	self.press = CurTime() + 1;

	local info = LocalPlayer():GetLocalVar("reco", {})

	netstream.Start("Limb::AddCharacterToReco", data.id)

	// Обновить еще раз, чтобы получить актуальные данные
	timer.Simple(.1, function()
		info = LocalPlayer():GetLocalVar("reco", {})
		if info[data.id] then
			self.text:SetTextColor(Color(100, 255, 100))
		else
			self.text:SetTextColor(Color(255, 255, 255))
		end
	end);
end;

function PANEL:Paint( w, h ) end;
vgui.Register( 'LimbCharList__char', PANEL, 'EditablePanel' )