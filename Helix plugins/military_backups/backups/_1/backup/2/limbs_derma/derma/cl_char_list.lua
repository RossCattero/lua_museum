local PANEL = {}
function PANEL:Init()
	self.info = self:Add("DLabel")
	self.info:SetText( "Кого я помню:" )
	self.info:SetFont("LIMB_SUBTEXT")
	self.info:Dock(TOP)
	self.info:SetContentAlignment(5)
	self.info:SizeToContents()

	self.charList = self:Add("DListLayout")
	self.charList:Dock(TOP)

	local chr, players, reco = LocalPlayer():GetCharacter(), player.GetAll(), false
	
	for i = 1, #players do
		local ply = players[i];
		local character = ply:GetCharacter()

		if character && chr:DoesRecognize(character) && chr != character then
			local char = self.charList:Add("LimbCharList__char")
			char:Dock(TOP)
			char:Populate( character:GetID() )

			reco = true;
		end;
	end

	if !reco then
		self.lbl = self:Add("DLabel")
		self.lbl:SetText( "Я никого не помню" )
		self.lbl:SetFont("LIMB_EMPTY")
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

function PANEL:Populate(id)
	if !id then self:Remove() return end;
	local ply = LocalPlayer()
	local info = ply:CanLookMed( id )

	local char = ix.char.loaded[id]

	self.name = id;

	self.text = self:Add("DLabel")
	self.text:Dock(FILL)
	self.text:SetText( char.vars['name'].." [ "..(steamworks.GetPlayerName( ply:SteamID64() ) || "Unknown").." ]" )
	self.text:SetFont("LIMB_SUBTEXT")
	self.text:SetContentAlignment(5)
	self.text:SizeToContents()

	self.text:SetTextColor(ply:CanLookMed( self.name ) && Color(100, 255, 100) || Color(255, 255, 255))
end;

function PANEL:OnMousePressed()
	local name = self.name
	if !name || (self.press && self.press > CurTime()) then return end; self.press = CurTime() + 1;

	local ply = LocalPlayer()
	local info = ply:CanLookMed( self.name )

	netstream.Start("MED_RECOGNIZE_ADD", name)

	timer.Simple(.1, function()
		if ply:CanLookMed( self.name ) then
			self.text:SetTextColor(Color(100, 255, 100))
		else
			self.text:SetTextColor(Color(255, 255, 255))
		end
	end);
end;

function PANEL:Paint( w, h ) end;
vgui.Register( 'LimbCharList__char', PANEL, 'EditablePanel' )