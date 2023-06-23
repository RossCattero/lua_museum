local PLUGIN = PLUGIN;

function PLUGIN:GetEntityMenuOptions(entity, options)
	if (entity:GetClass() == "cw_notepad_holder") then
		options["Открыть"] = "cw_notepad_holder_open";
	end;
end;

-- Called when an entity's target ID HUD should be painted.
function PLUGIN:HUDPaintEntityTargetID(entity, info)
	local colorTargetID = Clockwork.option:GetColor("target_id");
	local colorWhite = Clockwork.option:GetColor("white");
	
	if (entity:GetClass() == "cw_notepad_holder") then
		info.y = Clockwork.kernel:DrawInfo("Шкафчик для блокнотов", info.x, info.y, colorTargetID, info.alpha)
		info.y = Clockwork.kernel:DrawInfo("Вы можете положить в него блокнот.", info.x, info.y, colorWhite, info.alpha)
	end
end;

function OpenNotepadForMe(notepadTBL)
    local scrW = surface.ScreenWidth();
    local scrH = surface.ScreenHeight();
    local sW = (scrW/2) - 250;
    local sH = (scrH/2) - 350;
    local PosForText = 480;
	local frame = vgui.Create("DFrame");
	frame:SetPos(sW, sH)
	frame:SetSize(560, 610)
    frame:SetTitle("")
    frame.currentpage = 1;
	frame:SetBackgroundBlur( true )
	frame:SetDraggable( false )
	frame:ShowCloseButton( false )
	frame:MakePopup()
	frame.lblTitle:SetContentAlignment(8)
	frame.lblTitle.UpdateColours = function( label, skin )
		label:SetTextStyleColor( Color( 255, 180, 80, 255 ) )
	end;
	frame.Paint = function(self, w, h)
        draw.RoundedBoxOutlined(2, 0, 0, w, h, Color(0, 0, 0, 150), Color(255, 180, 80, 150));
        draw.DrawText( "Страница: "..frame.currentpage.."/"..notepadTBL["pages"], "DermaDefault", 240, PosForText + 55, Color(232, 187, 8, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
    end;
	
	local closebtn = vgui.Create( "DButton", frame )
	closebtn:SetText("[X]")
	closebtn:SetPos( 490, 570 )
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
        cable.send('ClosePad', notepadTBL);
    end;
    
    if notepadTBL["owner"] == "" then 
        OpenNotepadEDIT(frame, notepadTBL)
    elseif notepadTBL["owner"] != "" && notepadTBL["owner"] == Clockwork.Client:GetName() then 
        OpenNotepadEDIT(frame, notepadTBL)
    elseif notepadTBL["owner"] != "" && notepadTBL["owner"] != Clockwork.Client:GetName() then
        OpenEasyly(frame, notepadTBL)
    end;

end;

function OpenNotepadEDIT(frame, notepadTBL)
    local GetTitle = vgui.Create( "DTextEntry", frame ) 
	GetTitle:SetPos( 20, 20 )
	GetTitle:SetSize( 520, 20 )
	GetTitle:SetText( notepadTBL["title"] )
    GetTitle:SetMultiline(true);
    GetTitle.OnTextChanged = function(self)
        local txt = self:GetValue()
        local amt = string.utf8len(txt)
        if amt > 30 then
            GetTitle:SetText(GetTitle.OldText)
            GetTitle:SetValue(GetTitle.OldText)
        else
            GetTitle.OldText = txt;
        end;
    end;

    local NotepadTypeText = vgui.Create( "DTextEntry", frame ) 
	NotepadTypeText:SetPos( 20, 45 )
    NotepadTypeText:SetSize( 520, 430 )
    if table.Count(notepadTBL["information"]) ~= 0 then
        NotepadTypeText:SetText( notepadTBL["information"][frame.currentpage] )
    else
        NotepadTypeText:SetText( "" )
    end;
    NotepadTypeText:SetMultiline(true);
    NotepadTypeText.OnTextChanged = function(self)
        local txt = NotepadTypeText:GetValue()
        local amt = string.len(txt)
        if amt > 2580 then
            NotepadTypeText:SetText(NotepadTypeText.OldText)
            NotepadTypeText:SetValue(NotepadTypeText.OldText)
        else
            NotepadTypeText.OldText = txt;
        end;
    end;
    
    local NotepadGridd = vgui.Create( "DGrid", frame )
    NotepadGridd:SetPos( 84, 500 )
    NotepadGridd:SetColWide( 133 )
    NotepadGridd:SetRowHeight( 20 )
	
	for i = 1, 3 do		
		local NotepadFor = vgui.Create( "DButton" )
		NotepadFor:SetSize( 120, 20 )
        NotepadFor:SetText("")
        NotepadFor:SetTextColor(Color(232, 187, 8, 255));
        NotepadFor.Paint = function(self, x, y)
            draw.RoundedBox(2, 0, 0, x, y, Color(0, 0, 0, 150));
            if i == 1 then 
                self:SetText("Предыдущая страница")
            elseif i == 2 then 
                self:SetText("Заполнить страницу")
            elseif i == 3 then 
                self:SetText("Следующая страница")
            end;
        end;
        NotepadFor.DoClick = function()
            local pattern = '[\\/:%*%?"<>|]' -- a set of all restricted characters
            if i == 1 then 
                if notepadTBL["pages"] > 1 && frame.currentpage > 1 then
                    frame.currentpage = math.Clamp(frame.currentpage - 1, 1, notepadTBL["pages"]);
                    NotepadTypeText:SetText(notepadTBL["information"][frame.currentpage])
                end;
            end;
            if i == 2 then
                if !Clockwork.player:IsAdmin(player) then
                    notepadTBL["information"][frame.currentpage] = string.gsub(NotepadTypeText:GetValue(), pattern, "")
                else
                    notepadTBL["information"][frame.currentpage] = NotepadTypeText:GetValue()
                end;
                notepadTBL["title"] = GetTitle:GetValue()
            end;
            if i == 3 then
                if notepadTBL["pages"] > 1 then
                    frame.currentpage = math.Clamp(frame.currentpage + 1, 0, notepadTBL["pages"])
                    NotepadTypeText:SetText(notepadTBL["information"][frame.currentpage])
                end;
            end;
		end;
		NotepadGridd:AddItem( NotepadFor )
    end;
    
    local CheckBoxInventory = vgui.Create( "DCheckBoxLabel", frame )
    CheckBoxInventory:SetPos( 20, 550 )
    CheckBoxInventory:SetText( "Запретить поднимать в инвентарь" )
    CheckBoxInventory:SetValue( notepadTBL["pickup"] )
    CheckBoxInventory:SetTextColor(Color(255, 255, 255, 255))
    function CheckBoxInventory:OnChange( val )
        if !val then
            cable.send('EditPadSettings', "Pick", 0, notepadTBL);
        elseif val then
            cable.send('EditPadSettings', "Pick", 1, notepadTBL);
        end;
        
    end

    local AddOwnerToNotepad = vgui.Create( "DButton", frame )
	AddOwnerToNotepad:SetText("Добавить владельца")
	AddOwnerToNotepad:SetPos( 20, 570 )
	AddOwnerToNotepad:SetSize(170, 30)
	AddOwnerToNotepad:SetTextColor(Color(232, 187, 8, 255))
	AddOwnerToNotepad.Paint = function(self, x, y)
		if self:IsHovered() then
			draw.RoundedBox(2, 0, 0, x, y, Color(255, 255, 255, 10));
		else
			draw.RoundedBox(2, 0, 0, x, y, Color(0, 0, 0, 150));
		end;
    end;
    AddOwnerToNotepad.DoClick = function(self)
        cable.send('EditPadSettings', "Owner", Clockwork.Client:GetName(), notepadTBL);
    end;
end;


function OpenEasyly(frame, notepadTBL)
    local htmlPanel = vgui.Create("DHTML", frame);
    htmlPanel:SetHTML([[
                <!DOCTYPE html>
            <html>
                <head>
                    <style>
                    body {
                        background-color: white;
                        font-family: "Times New Roman", Times, serif;
                        word-wrap: break-word;
                        padding: 2px;
                        font-size: 15px;
                    }
                    #titleForNotepad {
                        text-align: center;
                        font-family: "Times New Roman", Times, serif;
                    }
                    </style>
                </head>
        
                <body>
                
                <h2 id = "titleForNotepad">]]..notepadTBL["title"]..[[</h2>
                <hr>

                <p>]]..notepadTBL["information"][frame.currentpage]..[[</p>
    
                </body>
                
            </html>
    ]]);
    htmlPanel:SetPos( 20, 20 );
    htmlPanel:SetSize(520, 500);
    htmlPanel:SetWrap(true);

    local NotepadGridd = vgui.Create( "DGrid", frame )
    NotepadGridd:SetPos( 150, 555 )
    NotepadGridd:SetColWide( 133 )
    NotepadGridd:SetRowHeight( 20 )
	
	for i = 1, 2 do		
		local NotepadFor = vgui.Create( "DButton" )
		NotepadFor:SetSize( 120, 20 )
        NotepadFor:SetText("")
        NotepadFor:SetTextColor(Color(232, 187, 8, 255));
        NotepadFor.Paint = function(self, x, y)
            draw.RoundedBox(2, 0, 0, x, y, Color(0, 0, 0, 150));
            if i == 1 then 
                self:SetText("Предыдущая страница")
            elseif i == 2 then 
                self:SetText("Следующая страница")
            end;
        end;
		NotepadFor.DoClick = function()
            if i == 1 then 
                if notepadTBL["pages"] > 1 && frame.currentpage > 1 then
                    frame.currentpage = math.Clamp(frame.currentpage - 1, 1, notepadTBL["pages"]);

                    htmlPanel:SetHTML([[
                    <!DOCTYPE html>
                    <html>
                        <head>
                            <style>
                            body {
                                background-color: white;
                                font-family: "Times New Roman", Times, serif;
                                word-wrap: break-word;
                                padding: 2px;
                                font-size: 15px;
                            }
                            #titleForNotepad {
                                text-align: center;
                                font-family: "Times New Roman", Times, serif;
                            }
                            </style>
                        </head>
                            
                        <body>
                
                        <h2 id = "titleForNotepad">]]..notepadTBL["title"]..[[</h2>
                        <hr>

                        <p>]]..notepadTBL["information"][frame.currentpage]..[[</p>
    
                        </body>
                
                        </html>
                    ]]);
                end;
            end;

            if i == 2 then
                if notepadTBL["pages"] > 1 then
                    frame.currentpage = math.Clamp(frame.currentpage + 1, 0, notepadTBL["pages"])
    
                        htmlPanel:SetHTML([[
                        <!DOCTYPE html>
                        <html>
                            <head>
                                <style>
                                body {
                                    background-color: white;
                                    font-family: "Times New Roman", Times, serif;
                                    word-wrap: break-word;
                                    padding: 2px;
                                    font-size: 15px;
                                }
                                </style>
                            </head>
                                
                            <body>
    
                            <p>]]..notepadTBL["information"][frame.currentpage]..[[</p>
        
                            </body>
                    
                            </html>
                        ]]);
                    end;
                end;
            end;
		NotepadGridd:AddItem( NotepadFor )
    end;
end;

cable.receive('NotepadOpen', function(tbl)
	OpenNotepadForMe(tbl)
end);