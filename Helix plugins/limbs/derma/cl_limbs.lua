local PLUGIN = PLUGIN;
local sw, sh = ScrW(), ScrH();
local PANEL = {}
function PANEL:Init()
		local ply = LocalPlayer()
		self:Dock(RIGHT)
		self:SetWide( sw * 0.15 )

		self.bodyPanel = self:Add("DPanel")
		self.bodyPanel:Dock(TOP)
		self.bodyPanel:SetTall(sh * 0.3)
		self.bodyPanel.Paint = function(s, w, h)
				local bData = ply:GetLocalVar("Limbs")

				local body = LimbBody["body"];
				surface.SetMaterial( body )
				surface.SetDrawColor(Color(255, 255, 255, 255))
				surface.DrawTexturedRect( sw * 0.04, sh * 0.03, body:Width(), body:Height() )

				local i = #LimbBody;
				while (i >= 1) do
					local mat = LimbBody[i];
					if mat then
							local name = mat:GetName():match("materials/limbs/([%w_]+)")
							if bData[name] then
									surface.SetMaterial( mat )
									surface.SetDrawColor(Color(255, 0, 0, math.min(#bData[name] * 65, 200) ))
									surface.DrawTexturedRect( sw * 0.04, sh * 0.03, mat:Width(), mat:Height() )
							end
					end;
					i = i - 1;
				end;
		end;

		self.injuries = self:Add("DScrollPanel")
		self.injuries:Dock(FILL)
		local i = 1;
		while (i <= #LIMBS_LIST) do
				local limb = LIMBS_LIST[i];
				if limb then
						local dLimb = self.injuries:Add("LimbList");
						dLimb.data = limb;
						dLimb:Populate()

						dLimb:ReloadInjuries()
				end;
				i = i + 1;
		end;

		self.bloodLevel = self:Add("BloodDrop")
		self.painLevel = self:Add("PainDraw")
end;

function PANEL:Paint( w, h ) end;

vgui.Register( 'Limbs', PANEL, 'EditablePanel' )

local PANEL = {}
function PANEL:Init()
		self:Dock(TOP)
		self:DockMargin(0, sw * 0.002, 0, sw * 0.002)
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

		local bones = LocalPlayer():GetLocalVar("Limbs")
		local bone = bones[ self.data.index ]

		if !bone then return end;

		if #bone <= 0 then
				local noInjuries = self.limbList:Add("DLabel")
				noInjuries:SetFont("limb-empty")
				noInjuries:Dock(TOP)
				noInjuries:SetText("~ Нет повреждений ~")
				noInjuries:SetTextColor( Color(150, 150, 150) )
				noInjuries:SetContentAlignment(5)
				noInjuries:SetTall(sh * 0.035)
		else
				local i = 1;
				while (i <= #bone) do
						local inj = bone[i];

						if inj then
								local limb = self.limbList:Add("LimbDraw")
								limb.data = inj
								limb:Populate();
						end

						i = i + 1;
				end;
		end

		self.limbList:InvalidateLayout( true )
		self.limbList:SizeToChildren( false, true )

		self:InvalidateLayout( true )
		self:SizeToChildren( false, true )
end;

function PANEL:Paint( w, h )
		draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50))
end;
vgui.Register( 'LimbList', PANEL, 'EditablePanel' )

local PANEL = {}
function PANEL:Init()
		local bio = LocalPlayer():GetLocalVar("Biology");
		local blood = math.Round(bio.blood, 2);
		local bloodDrop = math.Round(bio.bleeding, 2);
		local drop = bloodDrop > 0 && "(-"..bloodDrop.." ml/sec)" || ""

		self:Dock(TOP)
		self:SetTall( sh * 0.03 )

		self.text = self:Add("DLabel")
		self.text:Dock(FILL)
		self.text:SetFont("limb-text")
		self.text:SetText(blood.." ml"..drop)
		self.text:SetContentAlignment(5)
		self.text:SizeToContents()
		self.text:SetTextColor(Color(200, 50, 50))
end;
function PANEL:Paint( w, h ) end;
vgui.Register( 'BloodDrop', PANEL, 'EditablePanel' )

local PANEL = {}
function PANEL:Init()
		local pain = LocalPlayer():GetLocalVar("Hurt")

		if !pain then return end;
		
		self:Dock(TOP)
		self:SetTall( sh * 0.03 )
		self:SetMouseInputEnabled(true)
		self:SetCursor("hand")

		self.text = self:Add("DLabel")
		self.text:Dock(FILL)
		self.text:SetFont("limb-text")
		self.text:SetText(pain)
		self.text:SetContentAlignment(5)
		self.text:SizeToContents()
		self.text:SetTextColor(Color(255, 50, 50))
		self.text:DockMargin(sw * 0.003, 0, 0, 0)
end;
function PANEL:Paint( w, h ) end;

function PANEL:OnMousePressed()
	local ply = LocalPlayer();
	local character = ply:GetCharacter();
	local inv = character:GetInventory();
	local items = inv:GetItemsByBase( "base_pills" );

	local dMenu = DermaMenu()
	for i = 1, #items do
		local item = items[i];

		if item:GetData("Amount") > 0 then
			dMenu:AddOption(item.name .. " [" .. item:GetData("Amount") .. "]", function()
				netstream.Start("Limbs::healthAction", "pain", item:GetID())
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
		local injuries = LIMB_INJURIES[data.index]

		local title = injuries.name.." ".. LIMB_STAGES[data.stage].rim or "I"
		local descr = injuries.stageList[data.stage] or ""
		
		self.text = self:Add("DLabel")
		self.text:SetText( title )
		self.text:SetFont("limb-text")
		self.text:Dock(FILL)
		self.text:SetTextColor( data.infected && LIMB_ROT_CLR || LIMB_INJ_CLR )
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

						if !data.infected then
							if injuries.causeBlood then
								local blood = tooltip:AddRowAfter("description", "causeBleed")
								blood:SetText(LIMB_BLOOD_TEXT)
								blood:SetTextColor( LIMB_BLOOD_CLR )
								blood:SizeToContents()
							end;
							if LIMB_INJURIES:CanRot(data.index) then
								local rot = tooltip:AddRowAfter("causeBleed", "rot")
								rot:SetText(LIMB_ROT_TEXT)
								rot:SetTextColor( LIMB_ROT_CLR )
								rot:SizeToContents()
							end
						else
							local inf = tooltip:AddRowAfter("rot", "infection")
							inf:SetText( LIMB_INFECT_TEXT )
							inf:SetTextColor( LIMB_ROT_CLR )
							inf:SizeToContents()
						end;						
				
						tooltip:SizeToContents()
				end)
		end;
end;

function PANEL:OnMousePressed()
		-- local data = self.data;
		-- local ply = LocalPlayer();
		-- local character = ply:GetCharacter();
		-- local inv = character:GetInventory();
		-- local items = inv:GetItemsByBase( "base_surgeons" );

		-- local dMenu = DermaMenu()
		-- if data.healed == "" then 
				
		-- 		for id, item in pairs(items) do
		-- 				dMenu:AddOption(item.name, function()
		-- 						PrintTable(item)
		-- 				end)
		-- 		end

		-- else

		-- 		dMenu:AddOption("Снять повязку", function()
							
		-- 		end)

		-- end;
		-- dMenu:Open()
end;

function PANEL:Paint( w, h ) 
		if self:IsHovered() then
				draw.RoundedBox(0, 0, 0, w, h, Color(80, 80, 80, 100))
		end;
end;
vgui.Register( 'LimbDraw', PANEL, 'EditablePanel' )
