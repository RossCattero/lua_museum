local PLUGIN = PLUGIN;
local sw, sh = ScrW(), ScrH();

local PANEL = {}
function PANEL:Init()
	local pain = INJURIES.FindPain( LIMBS_DATA.Pain )
	if !pain then return end;

	self:Dock(TOP)
	self:SetTall( sh * 0.03 )
	self:SetMouseInputEnabled(true)
	self:SetCursor("hand")

	self.text = self:Add("DLabel")
	self.text:Dock(FILL)
	self.text:SetFont("LIMB_TEXT")
	self.text:SetText( pain.name )
	self.text:SetContentAlignment(5)
	self.text:SizeToContents()
	self.text:SetTextColor(Color(255, 50, 50))
	self.text:DockMargin(sw * 0.003, 0, 0, 0)
end;
function PANEL:Paint( w, h ) end;

function PANEL:OnMousePressed()
	-- local ply = LocalPlayer();
	-- local character = ply:GetCharacter();
	-- local inv = character:GetInventory();
	-- local items = inv:GetItemsByBase( "base_medicine" );

	-- local dMenu = DermaMenu()
	-- for i = 1, #items do
	-- 	local item = items[i];
	-- 	if item:IsPainkiller() && item:GetData("Amount") > 0 then
	-- 		dMenu:AddOption(item.name .. " [" .. item:GetData("Amount") .. "]", function()
	-- 			netstream.Start("Limbs::health", "pain", item:GetID(), IsLocalPlayerData or false)
	-- 		end)
	-- 	end;
	-- end
	-- dMenu:Open()
end;

vgui.Register( 'PainDraw', PANEL, 'EditablePanel' )