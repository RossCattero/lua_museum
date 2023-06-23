local PLUGIN = PLUGIN;
local sw, sh = ScrW(), ScrH();

local PANEL = {}
function PANEL:Init()
	self:SetTall(sh * 0.035)
	self:DockMargin(0, sh * 0.003, 0, 0)

	self:SetMouseInputEnabled(true)
	self:SetCursor("hand")
end;

function PANEL:Populate()
		local index = self.data;
		local Wound = INJURIES.INSTANCES[index]
		if !Wound then 
			self:Remove()
			return 
		end;

		local title = Wound.name.." ".. INJURIES.STAGES[Wound:GetData("stage")].rim or "I"

		local heal = Wound:IsHealed();
		
		self.text = self:Add("DLabel")
		self.text:SetText( title )
		self.text:SetFont( "LIMB_TEXT" )
		self.text:Dock(FILL)
		self.text:SetTextColor( 
			heal != "" && LIMBS.HEAL_CLR || Wound:IsInfected() && LIMBS.ROT_CLR || LIMBS.INJ_CLR 
		)
		self.text:SetContentAlignment(5)
		self.text:SizeToContents()

		if !Wound:GetData("stage") then return end;

		self:SetHelixTooltip(function(tooltip)
			local name = tooltip:AddRow("name")
			name:SetText(title)
			name:SetImportant()
			name:SetBackgroundColor(Color(142, 82, 156))
			name:SizeToContents()

			if description then
			local description = tooltip:AddRowAfter("name", "description")
				description:SetText(Wound.stages[Wound:GetData("stage")] or "")
				description:SizeToContents()
			end;

			if !Wound:IsInfected() then
				if Wound:IsBleeding() && heal == "" && Wound:GetData("healTime") > 0 then
					local blood = tooltip:AddRowAfter("description", "causeBleed")
					blood:SetText( LIMBS.BLOOD_TEXT )
					blood:SetTextColor( LIMBS.BLOOD_CLR )
					blood:SizeToContents()
				end
				if Wound:CanInfect() then
					local rot = tooltip:AddRowAfter("causeBleed", "rot")
					rot:SetText( LIMBS.ROT_TEXT )
					rot:SetTextColor( LIMBS.ROT_CLR )
					rot:SizeToContents()
				end
			elseif Wound:IsInfected() then
				local infected = tooltip:AddRowAfter("rot", "infection")
				infected:SetText( LIMBS.INFECT_TEXT )
				infected:SetTextColor( LIMBS.ROT_CLR )
				infected:SizeToContents()
			end		
	
			if heal != "" then
				local item = ix.item.list[heal];
				if item then
					local infected = tooltip:AddRowAfter("rot", "heal")
					infected:SetText( "Вылечено при помощи: \"" .. item.name .. "\"" )
					infected:SetTextColor( LIMBS.HEAL_CLR )
					infected:SizeToContents()
				end;
			end;

			tooltip:SizeToContents()
		end)
end;

function PANEL:OnMousePressed()
	local ply = LocalPlayer();
	local Wound = INJURIES.INSTANCES[self.data]
	if !Wound then return end;

	local character = ply:GetCharacter();
	local inv = character:GetInventory();
	local items = inv:GetItemsByBase( "base_medicine" );

	local menu = DermaMenu()

	if Wound:IsHealed() == "" then
		for id, item in ipairs( items ) do
			if item:IsBandage() && item:CanHeal( Wound.index ) && item:GetAmount() > 0 then
				menu:AddOption( item.name .. " [" .. item:GetAmount() .. "]", function() 
					netstream.Start("LIMB_HEAL", item:GetID(), self.bone, self.index)
				end)
			end
		end
	else
		menu:AddOption( "Снять, содрать", function() 
			netstream.Start("LIMB_HEAL_CLEAR", self.data)
		end)
	end

	menu:Open()
end;

function PANEL:Paint( w, h ) 
	if self:IsHovered() then
		draw.RoundedBox(0, 0, 0, w, h, Color(80, 80, 80, 100))
	end;
end;
vgui.Register( 'LIMBSDraw', PANEL, 'EditablePanel' )