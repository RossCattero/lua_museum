local PLUGIN = PLUGIN
local aaa = Material('icons/n_unknown.png')

function HasHisOwnPDA(ply, password, id)
  local character = ply:GetCharacter()
  local FindPDAs = character:GetInventory():GetItemsByUniqueID('ross_stalker_pda')
      for k, v in pairs(FindPDAs) do
          if v && v:GetData('messageID') == id then
              if password then
                  if v:GetData('password') == password then
                      return v;
                  else
                      return false;
                  end;
              elseif !password then
                  return v;
              end;
          end;
      end;
  return false;
end;
function IsLookingOnPDA(ply, password, id)
  local trace = ply:GetEyeTraceNoCursor()
  if !trace or ply:GetPos():Distance(trace.HitPos) > 128 then return false end;
  local entity = trace.Entity
  local class = entity:GetClass();
  if class != "ix_item" then return false; end;
  local item = entity:GetItemTable() or {};
  local data = entity:GetNetVar("data") or {};
  if class == "ix_item" && item.uniqueID == 'ross_stalker_pda' && data.messageID == id && ply:GetPos():Distance(trace.HitPos) < 128 then
      if password then
          if data.password == password then
              return entity
          else
              return false;
          end;
      elseif !password then
          return entity
      end;
  end;
  return false;
end;

netstream.Hook("STALKER_OPENPDA", function(id)
  if (PLUGIN.pdaDerma and PLUGIN.pdaDerma:IsValid()) then
		PLUGIN.pdaDerma:Close();
  end;
  PLUGIN.pdaDerma = vgui.Create("STALKER_OpenPDA");
  PLUGIN.pdaDerma:Populate(id)
end)

netstream.Hook("STALKER_PDA_OPENINFO", function(data, web, nots)
  if (PLUGIN.pdaDerma and PLUGIN.pdaDerma:IsValid()) then
    PLUGIN.pdaDerma:Close();
  end;
  PLUGIN.pdaDerma = vgui.Create("STALKER_OpenPDAInfo");
  PLUGIN.pdaDerma:Populate(data.allmessages, data.messageID, data.notes, web, nots)
end)

netstream.Hook("PDA_message_undercontrol", function(message, who, fac)
    if PLUGIN.pdaDerma then
      local stalkermessage = PLUGIN.pdaDerma.stalker_messages;
      if !PLUGIN.pdaDerma.stalker_messages then return end;
      local attachmessageWEB = stalkermessage:Add( "Panel" )
      attachmessageWEB:Dock( TOP )
      attachmessageWEB:DockMargin( 5, 5, 5, 5 )
      attachmessageWEB:SetSize(0, 100)
      attachmessageWEB.DoClick = function()
      end;
      attachmessageWEB.Paint = function(self, w, h)
        draw.RoundedBoxOutlined( 2, 0, 0, w, h, Color(23, 24, 26, 255), Color(63, 64, 68) )
        draw.SimpleText( who, "StalkerGraffitiFontLittle", 10, 10, Color(232, 187, 8), TEXT_ALIGN_LEFT )
        draw.SimpleText( fac, "StalkerGraffitiFontLittle", 15, 25, Color(232, 187, 8), TEXT_ALIGN_LEFT )
      end;
      local messageText = attachmessageWEB:Add("DLabel")
      messageText:SetPos(100, 5)
      messageText:SetFont("StalkerGraffitiFont")
      messageText:SetContentAlignment( 7 )
      messageText:SetSize( 605, 90 )
      messageText:SetText(message)
      messageText:SetWrap(true)

      stalkermessage:Rebuild()
    end;
end)

netstream.Hook('Notify_PDA', function()
  chat.AddText(Color(160, 133, 24), "*На ваш ПДА пришло уведомление...*")
end)