ix.datapad = ix.datapad or {}

if CLIENT then
    ix.datapad.colors = {
        main = Color(24, 56, 92),
        border = Color(51, 106, 168),
        text = Color(255, 255, 255),
        disabled_text = Color(100, 100, 100),
        citizen_color = Color(100, 255, 100),
    }

    --- Adaptate UI positions for any screens
    --- @param Panel table (A PANEL object)
    --- @param w number (Width of the PANEL object)
    --- @param h number (Height of the PANEL object)
    --- @param x number|nil (Optional) (X position of the PANEL object)
    --- @param y number|nil (Optional) (Y position of the PANEL object)
    function ix.datapad.Adaptate(Panel, w, h, x, y)
        local offset = 50
        local screenWidth, screenHeight = ScrW(), ScrH() - offset
        local positions = (x and y and x + y >= 0)

        w = math.Clamp(w, 10, screenWidth);
        h = math.Clamp(h, 10, screenHeight);
        Panel:SetSize( screenWidth * (w / screenWidth), screenHeight * (h / screenHeight) )

        x = positions and math.Clamp(x, 0, 1.25) or 0;
        y = positions and math.Clamp(y, 0, 1.25) or 0;
        Panel:SetPos( screenWidth * x, screenHeight * y - offset )

        if not positions then Panel:Center() end
    end;
end;