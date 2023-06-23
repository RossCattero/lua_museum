invaddon.BarsModule = {};
invaddon.BarsModule.bars = {}

function invaddon.BarsModule:AddBar(index, value, maxvalue, color)
    self.bars[index] = {
            val = value,
            max = maxvalue,
            clr = color
        }
end;

function invaddon.BarsModule:GetBars()
    return self.bars or {}
end;

function invaddon.BarsModule:GetBar(index)
    return self.bars[index] or 0;
end;
