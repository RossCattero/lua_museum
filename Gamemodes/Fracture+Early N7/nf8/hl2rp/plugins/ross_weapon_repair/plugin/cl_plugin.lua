local PLUGIN = PLUGIN;

function PLUGIN:GetProgressBarInfo()
	local action, percentage = Clockwork.player:GetAction(Clockwork.Client, true);

	if (!Clockwork.Client:IsRagdolled()) then
		if (action == "WEAPONREPAIR") then
			return {text = "Работа с оружием.", percentage = percentage, flash = percentage < 10};
		end;
	end;

end;

-- Called when an entity's target ID HUD should be painted.
function PLUGIN:HUDPaintEntityTargetID(entity, info)
	local colorTargetID = Clockwork.option:GetColor("target_id");
	local colorWhite = Clockwork.option:GetColor("white");
	
	if entity:GetClass() == 'ross_repair_table' then
		local cond = entity:GetQuality();
		local textI = '';
		local condcol = colorWhite;

		if (cond) then
			if cond >= 9 then
				textI = "В хорошем состоянии.";
				condcol = Color(10, 210, 0);
			elseif cond >= 6 then
				textI = "В нормальном состоянии.";
				condcol = Color(70, 190, 0);
			elseif cond >= 3 then
				textI = "В поношеном состоянии.";
				condcol = Color(170, 100, 0);		
			elseif cond < 3 then
				textI = "Изношено.";
				condcol = Color(200, 60, 0);
			end;
		end;

		if entity:GetweaponUID() != '' then
			info.y = Clockwork.kernel:DrawInfo(Clockwork.item:FindByID( entity:GetweaponUID() ).name, info.x, info.y, colorWhite, info.alpha);
			info.y = Clockwork.kernel:DrawInfo("Качество оружия: "..textI, info.x, info.y, condcol, info.alpha);
			info.y = Clockwork.kernel:DrawInfo("Качество набора: "..entity:GetRepairQuality(), info.x, info.y, colorWhite, info.alpha);
		end;
	end;
	
end;

function PLUGIN:GetEntityMenuOptions(entity, options)

	if entity:GetClass() == "ross_repair_table" then
		if entity:GetweaponUID() != '' then
			options["Взять оружие"] = "weapon_take_table";
		end;
		if entity:GetHasInstruments() then
			options["Починить оружие"] = "weapon_repair_table";
			options['Забрать инструменты'] = 'take_repair_item';
		end;
	end;

end;

function OpenWeaponReairPanel(weaponList, repairInfo)
    local function GetChance()
        return 30 + Clockwork.attributes:Get('collecting') * 10;
    end;
    local function AllowedToRepair(id)
        if repairInfo.w[ id ] == true then
            return true, "Да";
        end;
        return false, "Нет";
    end;
	local scrW = surface.ScreenWidth();
    local scrH = surface.ScreenHeight();
    local findRepair = Clockwork.item:FindByID(repairInfo['id']);

	local frame = vgui.Create("DFrame");
    frame:SetPos((scrW/2) - 350, (scrH/2) - 350) 
    frame:SetSize(310, 210)
	frame:SetTitle("")
	frame.weaponID = '';
    frame:SetBackgroundBlur( true )
    frame:SetDraggable( false )
    frame:ShowCloseButton( false )
    frame:MakePopup()
    frame.lblTitle:SetContentAlignment(8)
    frame.lblTitle.UpdateColours = function( label, skin )
    	label:SetTextStyleColor( Color( 255, 180, 80, 255 ) )
    end;
    frame.Paint = function(self, w, h)
		draw.RoundedBoxOutlined( 0, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80) )
		surface.SetDrawColor( Color(255, 180, 80) )
		surface.DrawLine( 0, 50, 310, 50 )
		surface.DrawLine( 160, 50, 160, 210 )
		if findRepair then
			draw.DrawText( "Название инструмента: \n"..findRepair.name, "DermaDefault", 5, 60, Color(255, 180, 80), TEXT_ALIGN_LEFT )
			draw.DrawText( "Качество инструмента: "..tostring(repairInfo.q).."%", "DermaDefault", 5, 90, Color(255, 180, 80), TEXT_ALIGN_LEFT )
			draw.DrawText( "Шанс починки: "..tostring(GetChance()).."%", "DermaDefault", 5, 110, Color(255, 180, 80), TEXT_ALIGN_LEFT )
			draw.DrawText( "Количество починки: +"..tostring(repairInfo.a).."%", "DermaDefault", 5, 130, Color(255, 180, 80), TEXT_ALIGN_LEFT )
			draw.DrawText( "Минимальное качество: "..tostring(repairInfo.m).."%", "DermaDefault", 5, 150, Color(255, 180, 80), TEXT_ALIGN_LEFT )
		end;
		if frame.weaponID != "" then
			local isAllowed, humanLanguage = AllowedToRepair(weaponList[ frame.weaponID  ].WepType);
			draw.DrawText( "Название оружия: \n"..Clockwork.item:FindByID(weaponList[ frame.weaponID  ].uniqueID).name, "DermaDefault", 165, 60, Color(255, 180, 80), TEXT_ALIGN_LEFT )
            draw.DrawText( "Качество оружия: "..tostring(weaponList[ frame.weaponID  ].quality*10).."%", "DermaDefault", 165, 90, Color(255, 180, 80), TEXT_ALIGN_LEFT )
            draw.DrawText( "Для выбранного оружия: "..humanLanguage, "DermaDefault", 5, 170, Color(255, 180, 80), TEXT_ALIGN_LEFT )
		end;
		if input.IsKeyDown( KEY_PAD_MINUS ) then
			surface.PlaySound("ui/buttonclick.wav");
			self:Close(); self:Remove();
		end;
	end;

	local closeMe = vgui.Create( "DButton", frame )
	closeMe:SetText( "X" )
	closeMe:SetPos( 245, 5 )
	closeMe:SetSize( 60, 40 )
	closeMe.DoClick = function(self)
		frame:Close(); frame:Remove();
	end;

	local repair = vgui.Create( "DButton", frame )
	repair:SetText( "Чинить" )
	repair:SetPos( 170, 5 )
	repair:SetSize( 60, 40 )
	repair.DoClick = function(self)
		
		if frame.weaponID != '' then
			local isAllowed, humanLanguage = AllowedToRepair(weaponList[ frame.weaponID ].WepType);
			local info1 = weaponList[ frame.weaponID ];
			if isAllowed then
				cable.send('CleanWeaponUP', {
					repairInfo.id, -- Uniqueid набора
					repairInfo.a, -- Количество при починке
					GetChance(), -- Шанс починки
					repairInfo.q, -- Качество набора
					repairInfo.m, -- Минимальное качество для починки
					info1.uniqueID, -- UID оружия
					frame.weaponID, -- ItemID оружия
					info1.quality -- Качество оружия
				});
				frame:Close(); frame:Remove();
			end;

		end;

	end;

	local weaponsList = vgui.Create( "DComboBox", frame )
	weaponsList:SetPos( 10, 20 )
	weaponsList:SetSize( 100, 20 )
	for k, v in pairs(weaponList) do
		weaponsList:AddChoice( k )
	end;
	weaponsList.OnSelect = function( self, index, value )
		frame.weaponID  = value
	end

end;

cable.receive('OpenRepairWeapons', function(weaponList, repairInfo)
	OpenWeaponReairPanel(weaponList, repairInfo)
end);