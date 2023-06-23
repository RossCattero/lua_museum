-- Gambling buttons storage;
Gambling.buttons = Gambling.buttons or {
    ["coinflip"] = {
        text = "Coinflip",
        image = Gambling.images.coins,
        onRun = function(panel)
            -- $ callback on left panel button 'Coinflip' click;

            Gambling.ui.content:Clear()

            Gambling.ui.coinflip = Gambling.ui.content:Add("Gambling__coinflip")
            Gambling.ui.coinflip:Dock(FILL)
        end,
    },
    ["jackpot"] = {
        text = "Jackpot",
        image = Gambling.images.chart,
        onRun = function(panel)
            -- $ callback on left panel button 'Jackpot' click;

            Gambling.ui.content:Clear()

            Gambling.ui.coinflip = Gambling.ui.content:Add("Gambling__chart")
            Gambling.ui.coinflip:Dock(FILL)
        end,
    },
}