
local PLUGIN = PLUGIN;

Clockwork.quickmenu:AddCallback("Спать", nil, function()
	return {
		Callback = function(option)

			if !PlayerIsSleeping(Clockwork.Client) then
				OpenSleepingInfo();
			end;

		end
	};
end);

function PLUGIN:GetPlayerInfoText(playerInfoText)

	local hunger = Clockwork.Client:GetSharedVar("hunger")
	local thirst = Clockwork.Client:GetSharedVar("thirst")
	local sleep = Clockwork.Client:GetSharedVar("sleep")
	
	local hungerText = "---";
	local thirstText = "---";
	local sleepText = "---";

	if hunger <= 25 then
		hungerText = "Вы умираете с голоду!"
	elseif hunger <= 50 then
		hungerText = "Вы голодны."
	elseif hunger <= 75 then
		hungerText = "У вас урчит в животе."
	elseif hunger > 75 then
		hungerText = "Вы сыты."
	end;

	if thirst <= 25 then
		thirstText = "У вас жажда."
	elseif thirst <= 50 then
		thirstText = "Вы чувствуете, что сильно хотите пить."
	elseif thirst <= 75 then
		thirstText = "Вам хочется пить."
	elseif thirst > 75 then
		thirstText = "Вы не хотите пить."
	end;

	if sleep <= 25 then
		sleepText = "Вы не можете стоять на ногах."
	elseif sleep <= 50 then
		sleepText = "Вы чувствуете ломку в мышцах."
	elseif sleep <= 75 then
		sleepText = "Вы чувствуете себя уставшим."
	elseif sleep > 75 then
		sleepText = "Вы не устали."
	end;

	playerInfoText:Add("hunger", "Голод: "..hungerText);
	playerInfoText:Add("thirst", "Жажда: "..thirstText);
	playerInfoText:Add("sleep", "Усталость: "..sleepText);
end;

function PLUGIN:PlayerAdjustMotionBlurs(motionBlurs) 
	local sleep = Clockwork.Client:GetSharedVar("sleep")

	if Clockwork.Client:HasInitialized() && sleep <= 40 then
		motionBlurs.blurTable["needs"] = 0.1
	end;

end;

function PLUGIN:ShouldPlayerScreenFadeBlack()
	if ( PlayerIsSleeping(Clockwork.Client) ) then
		return true
	end;
end;

function PLUGIN:GetProgressBarInfo()
	local action, percentage = Clockwork.player:GetAction(Clockwork.Client, true);

	if (!Clockwork.Client:IsRagdolled()) then
		if (action == "sleeping") then
			return {text = "Сон.", percentage = percentage, flash = percentage < 10};
		end;
		if (action == "PickingUpItem") then
			return {text = "", percentage = percentage, flash = percentage < 10};
		end;
	end;

end;

function PLUGIN:PlayerBindPress(player, bind, bPress)
	local action, percentage = Clockwork.player:GetAction(player, true);
	if action == "sleeping" then
		return true;
	end;
end;


function PLUGIN:GetScreenTextInfo()
    local blackFadeAlpha = Clockwork.kernel:GetBlackFadeAlpha();
    local weight = Clockwork.Client:GetSharedVar("InvWeight");
    local max = Clockwork.player:GetMaxWeight();

	if (weight > max + 2) then
		return {
			alpha = blackFadeAlpha,
			title = "ВЫ ПЕРЕГРУЖЕНЫ!",
			text = "СБРОСЬТЕ С ИНВЕНТАРЯ НЕСКОЛЬКО КИЛОГРАММ!"
		};
	end;
end;

function PLUGIN:GetEntityMenuOptions(entity, options)

	if entity:GetClass() == "sleeping_bag_unpacked" && !entity:GetIsBeingUsed() then
		options["Запаковать"] = "sleeping_bag_pack";
	end;
end;

function OpenSleepingInfo(ent)
    local scrW = surface.ScreenWidth();
    local scrH = surface.ScreenHeight();
    local sW = (scrW/2) - 250;
	local sH = (scrH/2) - 350;

	local frame = vgui.Create("DFrame");
	frame:SetPos(sW, sH)
	frame:SetSize(400, 200)
    frame:SetTitle("")
	frame:SetBackgroundBlur( true )
	frame:SetDraggable( false )
	frame:ShowCloseButton( false )
	frame:MakePopup()
	frame.lblTitle:SetContentAlignment(8)
	frame.lblTitle.UpdateColours = function( label, skin )
		label:SetTextStyleColor( Color( 255, 180, 80, 255 ) )
	end;
	frame.Paint = function(self, w, h)
		if ( self.m_bBackgroundBlur ) then
            Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
        end
		draw.RoundedBoxOutlined(2, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80, 150));
	end;
	
	local DPanelTime = vgui.Create( "DPanel", frame )
    DPanelTime:SetPos( 10, 10 )
    DPanelTime:SetSize( 380, 50 )
    DPanelTime.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 150));
	end;

	local TimeSlider = vgui.Create( "DNumSlider", DPanelTime )
	TimeSlider:SetPos( 10, 10 )
	TimeSlider:SetSize( 360, 30 )
	TimeSlider:SetText( "Время сна" )
	TimeSlider:SetMin( 0 )
	TimeSlider:SetMax( 80 )
	TimeSlider:SetDecimals( 0 )
	TimeSlider.TextArea:SetTextColor(Color(255, 255, 255))
	
	local startsleep = vgui.Create( "DButton", frame )
	startsleep:SetText("[Начать спать]")
	startsleep:SetPos( 70, 160 )
	startsleep:SetSize(100, 30)
	startsleep:SetTextColor(Color(232, 187, 8, 255))
	startsleep.Paint = function(self, x, y)
		if self:IsHovered() then
			draw.RoundedBox(2, 0, 0, x, y, Color(255, 255, 255, 10));
		else
			draw.RoundedBox(2, 0, 0, x, y, Color(0, 0, 0, 150));
		end;
	end;
	
	startsleep.DoClick = function()
		cable.send('StartSleeping', tonumber(TimeSlider:GetValue()) );
    end;

	local closebtn = vgui.Create( "DButton", frame )
	closebtn:SetText("[X]")
	closebtn:SetPos( 10, 160 )
	closebtn:SetSize(50, 30)
	closebtn:SetTextColor(Color(232, 187, 8, 255))
	closebtn.Paint = function(self, x, y)
		if self:IsHovered() then
			draw.RoundedBox(2, 0, 0, x, y, Color(255, 255, 255, 10));
		else
			draw.RoundedBox(2, 0, 0, x, y, Color(0, 0, 0, 150));
		end;
	end;
	
    closebtn.DoClick = function()
		surface.PlaySound("ambient/machines/keyboard2_clicks.wav");
		frame:Close(); frame:Remove();
    end;

end

cable.receive('SelectSleepSettings', function()
	
	OpenSleepingInfo()
end);