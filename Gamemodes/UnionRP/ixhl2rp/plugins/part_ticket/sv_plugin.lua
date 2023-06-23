local PLUGIN = PLUGIN;

netstream.Hook('SaveCardInformation', function(player, tbl) 
    local trace = player:GetEyeTraceNoCursor();
    local entity = trace.Entity;

    if IsValid(entity) and entity:GetClass() == 'r_part_terminal' then
        entity.cardInside = tbl;
        tbl['HasCard'] = entity:GetTerminalCard();
    end;
end)


function PLUGIN:OnItemTransferred(item, old, new)
	if (!old.owner and new.owner && item.uniqueID == 'part_ticket') then 
		local char = item.player:GetCharacter();
		local CharData = char:GetData('PDAID');

		if item.uniqueID == 'part_ticket' && Schema.pdaData[CharData] && Schema.pdaData[CharData].cardID == 0 then
			Schema.pdaData[CharData].cardID = item:GetData('partyID')
			ix.data.Set("DataInformation", Schema.pdaData)
		end;
	end;
end


function PLUGIN:LoadData()
	Schema.pdaData = ix.data.Get("DataInformation");

	self:LoadPartTerminals()
end

function PLUGIN:SaveData()
	self:SavePartTerminals()
end

function PLUGIN:SavePartTerminals()
	local data = {}

	for _, v in ipairs(ents.FindByClass("r_part_terminal")) do
			data[#data + 1] = {
                position = v:GetPos(),
                angles = v:GetAngles()
			}
	end

	ix.data.Set("Party_terminals", data)
end
function PLUGIN:LoadPartTerminals()
	for _, v in ipairs(ix.data.Get("Party_terminals") or {}) do
		local terminal = ents.Create("r_part_terminal")
        terminal:SetPos(v.position)
        terminal:SetAngles(v.angles)
		terminal:Spawn()
		terminal:SetTerminalCard(false)

		terminal.cardInside = {
			['name'] = '',
			['age'] = 0,
			['liveplace'] = '',
			['town'] = '',
			['status'] = 'ALPHA',
			['partyID'] = '000000',
			['HasCard'] = false
		}
	end
end