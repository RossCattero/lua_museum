local PLUGIN = PLUGIN;

nut.playerInteract.addFunc("Give money", {
	nameLocalized = "Give money",
	callback = function(target)
			local money = LocalPlayer():getMoney()
			Derma_StringRequest("Money amount", "Write money amount that you're ready to pay", money, function(amount)
					amount = tonumber(amount);
					if amount then
							if amount <= money then
								netstream.Start('inter::giveMoney', target, amount)									
							else
									LocalPlayer():notify("You don't have so much money!")
							end
					else
						LocalPlayer():notify("The value is not a number!")
					end
			end)
	end,
	canSee = function(target)
			local ply = LocalPlayer()
			local money = LocalPlayer():getMoney()

			return money > 0 && !ply:getLocalVar("grabbing")
	end
})

nut.playerInteract.addFunc("Tie character", {
	nameLocalized = "Tie character",
	callback = function(target)
		netstream.Start('tie::tieChar', target)
	end,
	canSee = function(target) 
		local ply = LocalPlayer()
		-- local look = ply:IsTargetTurned(target)
		local hasZip = ply:getChar():getInv():getFirstItemOfType("zip")

		return hasZip && !target:getNetVar("cuffed") && !ply:getLocalVar("grabbing") -- && look
	end
})

nut.playerInteract.addFunc("Untie character", {
	nameLocalized = "Untie character",
	callback = function(target)
		netstream.Start('tie::tieChar', target)
	end,
	canSee = function(target) 
		local ply = LocalPlayer()
		-- local look = ply:IsTargetTurned(target)

		return target:getNetVar("cuffed") && !ply:getLocalVar("grabbing") -- && look
	end
})

nut.playerInteract.addFunc("Search character", {
	nameLocalized = "Search character",
	callback = function(target)
		netstream.Start('search::searchChar', target)
	end,
	canSee = function(target) 
		local ply = LocalPlayer()
		-- local look = ply:IsTargetTurned(target)

		return target:getNetVar("cuffed") && !ply:getLocalVar("grabbing") -- && look
	end
})

nut.playerInteract.addFunc("Grab character", {
	nameLocalized = "Grab character",
	callback = function(target)
		netstream.Start('tie::grabChar', target)
	end,
	canSee = function(target) 
		local ply = LocalPlayer()
		-- local look = ply:IsTargetTurned(target)

		return target:getNetVar("cuffed") && !ply:getLocalVar("grabbing") -- && look
	end
})