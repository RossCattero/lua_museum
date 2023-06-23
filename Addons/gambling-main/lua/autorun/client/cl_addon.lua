-- Gambling UI holder;
Gambling.ui = Gambling.ui or NULL

-- Colors storage;
Gambling.colors = {
    main = Color(62, 62, 62),
    left_panel = Color(39, 39, 39, 255),
    top_panel = Color(68, 165, 228),
    cross = Color(255, 100, 100),
    button_clr = Color(51, 217, 90)
}

-- Images storage;
Gambling.images = {
    coins = Material("materials/coins.png", "noclamp smooth"),
    chart = Material("materials/pie-chart.png", "noclamp smooth"),
}

Gambling.click_sound = "buttons/blip1.wav"

--- Adaptate UI positions for any screens
--- @param Panel table (A PANEL object)
--- @param w number (Width of the PANEL object)
--- @param h number (Height of the PANEL object)
--- @param x number|nil (Optional) (X position of the PANEL object)
--- @param y number|nil (Optional) (Y position of the PANEL object)
function Gambling.Adaptate(Panel, w, h, x, y)
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

-- DEBUG purposes
-- Please, remove if you don't need it.
concommand.Add( "debug_gambling", function( ply, cmd, args, str )
    if Gambling.ui and Gambling.ui:IsValid() then
        Gambling.ui:Close()
    end;
    
    Gambling.ui = vgui.Create("Gambling")
    Gambling.ui:Populate()
end )