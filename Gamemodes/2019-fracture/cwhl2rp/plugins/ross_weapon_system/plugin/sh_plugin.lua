
local PLUGIN = PLUGIN;

Clockwork.kernel:IncludePrefixed("cl_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");

local function GetClientSideInfo(itemTable)
	local clientSideInfo = "";
	local ic = itemTable.category
	local cond = itemTable:GetData("Quality")
	local text = ""
	local condcol = Color(255, 255, 255)
	local hasMagaizne = itemTable:GetData("Mag");

	if (cond) then
		if cond >= 9 then
			text = "В хорошем состоянии.";
			condcol = Color(10, 210, 0);
		elseif cond >= 6 then
			text = "В нормальном состоянии.";
			condcol = Color(70, 190, 0);
		elseif cond >= 3 then
			text = "В поношеном состоянии.";
			condcol = Color(170, 100, 0);		
		elseif cond < 3 then
			text = "Изношено.";
			condcol = Color(200, 60, 0);
		end;
	end;

	if hasMagaizne == true then
		text2 = "Есть магазин"
		clr = Color(0, 255, 0);
	elseif hasMagaizne == false then
		text2 = "Нет магазина"
		clr = Color(200, 0, 0)
	end;

		clientSideInfo = Clockwork.kernel:AddMarkupLine(clientSideInfo, "Качество: "..itemTable:GetData("PriceForSalesman")..".", Color(255, 255, 255));
	if (ic == "Weapons" or ic == "Оружие") then

		clientSideInfo = Clockwork.kernel:AddMarkupLine(clientSideInfo, "Качество: "..cond..".", Color(255, 255, 255));
		clientSideInfo = Clockwork.kernel:AddMarkupLine(clientSideInfo, text, condcol);
		clientSideInfo = Clockwork.kernel:AddMarkupLine(clientSideInfo, text2, clr);

	return (clientSideInfo != "" and clientSideInfo);

	end;	
end;

-- Called when a Clockwork item has initialized.
function PLUGIN:ClockworkItemInitialized(itemTable)
	local ic = itemTable.category;
	local id = itemTable.uniqueID;
		if (itemTable.GetClientSideInfo) then
			itemTable.OldGetClientSideInfo = itemTable.GetClientSideInfo;
			itemTable.NewGetClientSideInfo = GetClientSideInfo;
			itemTable.GetClientSideInfo = function(itemTable)
				local existingText = itemTable:OldGetClientSideInfo();
				local additionText = itemTable:NewGetClientSideInfo() or "";
				local totalText = (existingText and existingText.."" or "")..additionText;
				
				return (totalText != "" and totalText);
			end;
		else
			itemTable.GetClientSideInfo = GetClientSideInfo;
		end;

		itemTable:AddData("PriceForSalesman", math.random(0.1, 2), true);
	if (ic == "Weapons" or ic == "Оружие") then
		itemTable:AddData("Quality", 10, true);
		itemTable:AddData("Mag", false, true);
		itemTable:AddData("NameMag", "", true);

		-- Винтовки.
		if id == "tfa_ins2_aks74u" then
			itemTable:AddData("RollDamage", 2, true);

		elseif id == "tfa_ins2_ak12" then
			itemTable:AddData("RollDamage", 4, true);

		elseif id == "tfa_ins2_akm" then
			itemTable:AddData("RollDamage", 3, true);

		elseif id == "tfa_ins2_makm" then
			itemTable:AddData("RollDamage", 3, true);

		elseif id == "tfa_ins2_akz" then
			itemTable:AddData("RollDamage", 3, true);

		elseif id == "tfa_ins2_asval" then
			itemTable:AddData("RollDamage", 3, true);

		elseif id == "tfa_ins2_c7e_redux" then
			itemTable:AddData("RollDamage", 3, true);

		elseif id == "tfa_ins2_famas" then
			itemTable:AddData("RollDamage", 4, true);

		elseif id == "tfa_ins2_g36c" then
			itemTable:AddData("RollDamage", 3, true);

		elseif id == "tfa_ins2_galil" then
			itemTable:AddData("RollDamage", 3, true);

		elseif id == "tfa_ins2_gol" then
			itemTable:AddData("RollDamage", 4, true);

		elseif id == "tfa_ins2_sai_gry" then
			itemTable:AddData("RollDamage", 3, true);

		elseif id == "tfa_ins2_k98" then
			itemTable:AddData("RollDamage", 4, true);

		elseif id == "tfa_ins2_krissv" then
			itemTable:AddData("RollDamage", 4, true);

		elseif id == "tfa_ins2_mk18" then
			itemTable:AddData("RollDamage", 3, true);

		elseif id == "tfa_ins2_mosin" then
			itemTable:AddData("RollDamage", 4, true);

		elseif id == "tfa_ins2_mp5k" then
			itemTable:AddData("RollDamage", 2, true);

		elseif id == "tfa_ins2_mp7" then
			itemTable:AddData("RollDamage", 3, true);

		elseif id == "tfa_ins2_pkp" then
			itemTable:AddData("RollDamage", 4, true);

		elseif id == "tfa_ins2_rpk" then
			itemTable:AddData("RollDamage", 4, true);

		elseif id == "tfa_ins2_scarl" then
			itemTable:AddData("RollDamage", 3, true);

		elseif id == "tfa_ins2_sc_evo" then
			itemTable:AddData("RollDamage", 3, true);

		elseif id == "tfa_ins2_svd" then
			itemTable:AddData("RollDamage", 4, true);

		elseif id == "tfa_ins2_svt40" then
			itemTable:AddData("RollDamage", 3, true);

		elseif id == "tfa_ins2_uzi" then
			itemTable:AddData("RollDamage", 2, true);

			-- Пистолеты
		elseif id == "tfa_ins2_deagle" then
			itemTable:AddData("RollDamage", 2, true);

		elseif id == "tfa_ins2_fiveseven" then
			itemTable:AddData("RollDamage", 2, true);

		elseif id == "tfa_ins2_usp_match" then
			itemTable:AddData("RollDamage", 2, true);

		elseif id == "tfa_ins2_thanez_cobra" then
			itemTable:AddData("RollDamage", 3, true);

		elseif id == "tfa_ins2_p220" then
			itemTable:AddData("RollDamage", 2, true);

		elseif id == "tfa_ins2_p226" then
			itemTable:AddData("RollDamage", 2, true);

		elseif id == "tfa_ins2_pm" then
			itemTable:AddData("RollDamage", 2, true);

		elseif id == "tfa_ins2_tt33" then
			itemTable:AddData("RollDamage", 2, true);

		elseif id == "tfa_ins2_usp45" then
			itemTable:AddData("RollDamage", 2, true);

			-- Дробовики.
		elseif id == "tfa_ins2_doublebarrel" then
			itemTable:AddData("RollDamage", 3, true);

		elseif id == "tfa_ins2_fort500" then
			itemTable:AddData("RollDamage", 3, true);

		elseif id == "tfa_ins2_spas12" then
			itemTable:AddData("RollDamage", 3, true);

			-- Холодное оружие.
		elseif id == "tfa_nmrih_cleaver" then
			itemTable:AddData("RollDamage", 2, true);

		elseif id == "tfa_nmrih_etool" then
			itemTable:AddData("RollDamage", 2, true);

		elseif id == "tfa_nmrih_fireaxe" then
			itemTable:AddData("RollDamage", 2, true);

		elseif id == "tfa_nmrih_crowbar" then
			itemTable:AddData("RollDamage", 2, true);

		elseif id == "tfa_nmrih_bcd" then
			itemTable:AddData("RollDamage", 3, true);

		elseif id == "tfa_nmrih_machete" then
			itemTable:AddData("RollDamage", 3, true);

		elseif id == "tfa_nmrih_bat" then
			itemTable:AddData("RollDamage", 2, true);

		end;
	end;

end;