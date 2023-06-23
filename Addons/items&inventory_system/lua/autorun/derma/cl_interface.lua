local math = math;

function draw.RoundedBoxOutlined( bordersize, x, y, w, h, color, bordercol )
	x = math.Round( x )
	y = math.Round( y )
	w = math.Round( w )
	h = math.Round( h )
	draw.RoundedBox( bordersize, x, y, w, h, color )
	surface.SetDrawColor( bordercol )
	surface.DrawTexturedRectRotated( x + bordersize/2, y + bordersize/2, bordersize, bordersize, 0 )
	surface.DrawTexturedRectRotated( x + w - bordersize/2, y + bordersize/2, bordersize, bordersize, 270 )
	surface.DrawTexturedRectRotated( x + w - bordersize/2, y + h - bordersize/2, bordersize, bordersize, 180 )
	surface.DrawTexturedRectRotated( x + bordersize/2, y + h - bordersize/2, bordersize, bordersize, 90 )
	surface.DrawLine( x + bordersize, y, x + w - bordersize, y )
	surface.DrawLine( x + bordersize, y + h - 1, x + w - bordersize, y + h - 1 )
	surface.DrawLine( x, y + bordersize, x, y + h - bordersize )
	surface.DrawLine( x + w - 1, y + bordersize, x + w - 1, y + h - bordersize )
end;

local PANEL = {};

function PANEL:Init()
    local sw, sh = ScrW(), ScrH()
    local Sformula = function(width)
        return sw * (width/1920)
    end;
    local Hformula = function(height)
        return sh * (height/1080)
    end;
    self:SetFocusTopLevel( true )
    RunConsoleCommand( '-forward' )
    RunConsoleCommand( '-jump' )
    RunConsoleCommand( '-speed' )
    self:ShowCloseButton( false )
    self:SetTitle('')
    self:SetPos(Sformula(400), Sformula(30))
    self:SetSize( Sformula(800), Sformula(810) )
    self:MakePopup()
    self:SetDraggable(false)

	gui.EnableScreenClicker(true);
end;

function PANEL:Populate()
    local sw, sh = ScrW(), ScrH()
    local Sformula = function(width)
        return sw * (width/1920)
    end;
    local Hformula = function(height)
        return sh * (height/1080)
    end;

    self.backgroundmodelPanel = self:Add("Panel")
    self.backgroundmodelPanel:SetPos( Sformula(10), Hformula(10) )
    self.backgroundmodelPanel:SetSize( Sformula(300), Hformula(400) )
    self.backgroundmodelPanel.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
    end;
    self.modelPanel = self.backgroundmodelPanel:Add("DModelPanel")
    self.modelPanel:Dock(FILL)
    self.modelPanel:SetModel(LocalPlayer():GetModel())
    self.modelPanel:SetFOV( 55 )
    self.modelPanel:SetCamPos(Vector(60, 0, 55))
    function self.modelPanel:LayoutEntity( Entity ) return end

    self.scrollBGs = self:Add("DScrollPanel")
    self.scrollBGs:SetPos( Sformula(315), Hformula(10))
    self.scrollBGs:SetSize( Sformula(75), Hformula(400) )

    self.BGsGrid = self.scrollBGs:Add("DGrid")
    self.BGsGrid:SetCols( 1 )
    self.BGsGrid:SetColWide( 60 )
    self.BGsGrid:SetRowHeight( 60 )
    self.BGsGrid:DockPadding(10, 10, 10, 10)

		local buttonList = {}

    for k, v in pairs(LocalPlayer():GData("ClothesData") or {}) do

        local bg_btn = vgui.Create( "DButton" )
        bg_btn:SetSize(Sformula(55), Hformula(55))
        bg_btn:SetText("")
        bg_btn:SetTextColor(color_white)
        bg_btn.Paint = function(s, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
        end;
        local bg_btn_image = bg_btn:Add( "ModelImage" )
        bg_btn_image:Dock(FILL)
        bg_btn_image.model = ""
        bg_btn_image:SetModel(bg_btn_image.model)
        function bg_btn_image:PerformLayout(w, h)
            if !bg_btn_image.model or bg_btn_image.model == "" then
                self:SetVisible(false);
                self:GetParent():SetText(k)
            end;
        end;
        function bg_btn_image:OnMousePressed(code)
            if (code == MOUSE_LEFT) then

            end
        end
				buttonList[k] = bg_btn_image
        self.BGsGrid:AddItem( bg_btn )
    end;

    self.BarsList = self:Add("DScrollPanel")
    self.BarsList:SetPos( Sformula(395), Hformula(10) )
    self.BarsList:SetSize( Sformula(395), Hformula(400) )
    self.BarsList.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
    end;

    for k, v in pairs(invaddon.BarsModule.bars or {}) do
        local InfoBar = self.BarsList:Add("Panel")
        InfoBar:Dock(TOP)
        InfoBar:DockMargin(10, 10, 10, 10)
        InfoBar.Paint = function(s, w, h)
            draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 100), Color(0,0,0,100) )
            draw.RoundedBox(0, 0, 0, (sw * (460/sw))*( invaddon.BarsModule:GetBars()[k]["val"] / invaddon.BarsModule:GetBars()[k]["max"]), h, invaddon.BarsModule:GetBars()[k]["clr"])
            draw.SimpleTextOutlined( k, "DermaDefault", 5, 4, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, color_black )
            if s:IsHovered() then
                draw.SimpleTextOutlined( "["..invaddon.BarsModule:GetBars()[k].val .. "] / [" .. invaddon.BarsModule:GetBars()[k].max.."]", "DermaDefault", s:GetWide() - 65, 4, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, color_black )
            end;
        end;
    end;

    self.InventoryPanel = self:Add("Panel")
    self.InventoryPanel:SetPos( Sformula(10), Hformula(420) )
    self.InventoryPanel:SetSize( Sformula(780), Hformula(340) )
    self.InventoryPanel.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
    end;

    self.InventoryFilter = self.InventoryPanel:Add("Panel")
    self.InventoryFilter:SetPos( Sformula(10), Hformula(10))
    self.InventoryFilter:SetSize( Sformula(125), Hformula(325) )
    self.InventoryFilter.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
    end;

    local categoryToFind = ""

    for k, v in pairs(_CategoriesOfItems or {}) do
        local filterTab = self.InventoryFilter:Add("DButton")
        filterTab:SetSize(Sformula(0), Hformula(25))
        filterTab:SetText(k)
        filterTab.AnimationColor = {
            r = 0,
            g = 0,
            b = 0
        };
        filterTab:SetTextColor(color_white)
        filterTab:Dock( TOP )
        filterTab:SetContentAlignment(5)
        filterTab:DockMargin( 5, 5, 5, 2 )
        filterTab.Paint = function(s, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(s.AnimationColor["r"], s.AnimationColor["g"], s.AnimationColor["b"], 100))
            if categoryToFind == k then
                s.AnimationColor["r"] = math.Approach( s.AnimationColor["r"], 100, 1000 * FrameTime() )
                s.AnimationColor["g"] = math.Approach( s.AnimationColor["g"], 255, 1000 * FrameTime() )
                s.AnimationColor["b"] = math.Approach( s.AnimationColor["b"], 100, 1000 * FrameTime() )
            else
                s.AnimationColor["r"] = math.Approach( s.AnimationColor["r"], 0, 1000 * FrameTime() )
                s.AnimationColor["g"] = math.Approach( s.AnimationColor["g"], 0, 1000 * FrameTime() )
                s.AnimationColor["b"] = math.Approach( s.AnimationColor["b"], 0, 1000 * FrameTime() )
            end;
        end;
        filterTab.DoClick = function(s)
            if !categoryToFind or categoryToFind == "" then
                categoryToFind = k;
            elseif categoryToFind == k then
                categoryToFind = ""
            elseif categoryToFind != k then
                categoryToFind = kg;
            end;
        end;
    end;

    self.InventoryScroll = self.InventoryPanel:Add("DScrollPanel")
    self.InventoryScroll:SetPos( Sformula(140), Hformula(10) )
    self.InventoryScroll:SetSize( Sformula(630), Hformula(325) )
    self.InventoryScroll.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
    end;
		self.distanceTable = {}
    local inventory = LocalPlayer():GData("PlayerInventory");
    if table.Count(inventory) > 0 then
            for k, v in pairs(inventory) do
                local itemTable = self.InventoryScroll:Add("DButton")
								self.distanceTable[v.itemID] = itemTable
                itemTable:SetSize(Sformula(0), Hformula(55))
                itemTable:Dock( TOP )
                itemTable:SetText("")
                itemTable.NewAlpha = 255;
                itemTable.category = v.category;
                itemTable:DockMargin( 5, 5, 5, 2 )
                itemTable.Paint = function(s, w, h)
                    if categoryToFind != "" && categoryToFind != tostring(s.category) then
                        s.NewAlpha = math.Approach( s.NewAlpha, 0, 1000 * FrameTime() )
                        s:SetAlpha(s.NewAlpha)
                    else
                        s.NewAlpha = math.Approach( s.NewAlpha, 255, 1000 * FrameTime() )
                        s:SetAlpha(s.NewAlpha)
                    end;
                    draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
                    draw.SimpleText(v.name..", "..v.weight..' kg, '..v.space..' slots  ['..v.category..']', "DermaDefault", 60, 5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                end;
                itemTable.DoClick = function(s)
										local itemInteractionMenu = DermaMenu()
										for a, b in pairs(v.funcs) do
												if b.CanDo(LocalPlayer():HasItemByID(v.uniqueID, v.itemID), LocalPlayer()) then
													itemInteractionMenu:AddOption( b.name, function()
															netstream.Start("[R]_ITEM_option_selected", v.uniqueID, v.itemID, a)
													end);
											 	end;
										end;
										itemInteractionMenu:Open()

                    -- local itemUse = DermaMenu()
                    -- if v.OnUse then
                    --     itemUse:AddOption( "Use", function()
										-- 			if LocalPlayer():HasItemByID(v.uniqueID, v.itemID) then
                    --         netstream.Start("[R]_UseItemInventory", v.uniqueID, v.itemID)
										-- 				if !v.OnUse() then return end;
										-- 				s:Remove();
										-- 			end;
                    --     end)
                    -- end;
                    -- itemUse:AddOption( "Drop", function()
                    --     if LocalPlayer():HasItemByID(v.uniqueID, v.itemID) then
                    --         netstream.Start("[R]_DropItemInventory", v.uniqueID, v.itemID)
                    --         s:Remove()
                    --     end;
                    -- end)
										-- if v.isClothes then
										-- 	itemUse:AddOption( "Equip", function()
										-- 		buttonList[v.slot]:SetVisible(true)
										-- 		buttonList[v.slot].model = v.model
										-- 		buttonList[v.slot]:SetModel(v.model)
										-- 	end);
										-- end;
                    -- itemUse:Open()
                end;
                local itemTable_model = itemTable:Add( "ModelImage" )
                itemTable_model:SetSize(Sformula(55), Hformula(55))
                itemTable_model:SetModel(v.model)

                local itemTable_description = itemTable:Add( "DLabel" )
                itemTable_description:SetPos(Sformula(60), Hformula(25))
                itemTable_description:SetSize(Sformula(520), Hformula(25))
                itemTable_description:SetText(v.description)
                itemTable_description:SetWrap(true)
                itemTable_description:SetAutoStretchVertical(true)
            end;
    end;

    self.closeButton = self:Add("DButton")
    self.closeButton:SetPos( Sformula(10), Hformula(765) )
    self.closeButton:SetSize( Sformula(200), Hformula(40) )
    self.closeButton:SetText("Close inventory")
    self.closeButton:SetTextColor(color_white)
    self.closeButton.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
    end;
    self.closeButton.DoClick = function()
        self:Close()
    end;

    self.dropMoney = self:Add("DButton")
    self.dropMoney:SetPos( Sformula(220), Hformula(765) )
    self.dropMoney:SetSize( Sformula(165), Hformula(40) )
    self.dropMoney:SetText("")
    self.dropMoney:SetTextColor(color_white)
    self.dropMoney.Paint = function(s, w, h)
        local trace = LocalPlayer():GetEyeTrace()
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
        if trace.Entity:IsPlayer() then
            draw.SimpleText("Give money: ", "DermaDefault", 5, 10, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        else
            draw.SimpleText("Drop money: ", "DermaDefault", 5, 10, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        end;
    end;
		local cashAmount = tonumber(LocalPlayer():GData("Cash", 0));
    self.dropMoney.DoClick = function(self)
        local amount = tonumber(self.TextEntry:GetValue())
        if amount > 0 && cashAmount > 0 && amount <= cashAmount && (cashAmount - amount) >= 0 then
            netstream.Start("[R]_DropCash", self.TextEntry:GetValue() )
            self:GetParent().MoneyCount:SetText("Cash: "..(cashAmount - amount).."$")
        end;
    end;
    self.dropMoney.TextEntry = self.dropMoney:Add( "DNumberWang" )
    self.dropMoney.TextEntry:SetPos( Sformula(105), Hformula(5) )
    self.dropMoney.TextEntry:SetSize( Sformula(50), Hformula(25) )
    self.dropMoney.TextEntry.OnEnter = function( self ) end

    local crystalls = LocalPlayer():GData("Crystalls", 0);

    self.MoneyCount = self:Add("DLabel")
    self.MoneyCount:SetPos( Sformula(395), Hformula(765) )
    self.MoneyCount:SetSize( Sformula(100), Hformula(30) )
    self.MoneyCount:SetText("Cash: "..cashAmount.."$")

    self.CrystallCount = self:Add("DLabel")
    self.CrystallCount:SetPos( Sformula(500), Hformula(765) )
    self.CrystallCount:SetSize( Sformula(100), Hformula(30) )
    self.CrystallCount:SetText("Crytalls: "..crystalls.." c")
end;

function PANEL:Paint( w, h )
    Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
    draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
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

vgui.Register( "OpenPlayerInventory", PANEL, "DFrame" )
