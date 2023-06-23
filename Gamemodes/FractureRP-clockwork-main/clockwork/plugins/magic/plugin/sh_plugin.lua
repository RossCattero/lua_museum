--[[
	© 2016 Mr. Meow
	Like, feel free to do stuff with my code I guess?
	Like, I don't mind, but you gotta learn to do
	it yourself duh.
--]]

Clockwork.plugin.OldAddPlugin = Clockwork.plugin.OldAddPlugin or Clockwork.plugin.Add;
Clockwork.plugin.OldRegisterPlugin = Clockwork.plugin.OldRegisterPlugin or Clockwork.plugin.Register;
Clockwork.OldPreSchemaExternals = Clockwork.OldPreSchemaExternals or Clockwork.LoadPreSchemaExternals;

-- Detour LoadPreSchemaExternals to make it autorefresh-friendly.
function Clockwork:LoadPreSchemaExternals()
	self.plugin.Add = self.plugin.OldAddPlugin;
	self.plugin.Register = self.plugin.OldRegisterPlugin;

	self:OldPreSchemaExternals();

	CW_SCRIPT_SHARED.clientCode = CW_SCRIPT_SHARED.clientCode:gsub(
		"Clockwork.plugin.__Register = Clockwork.plugin.Register;", 
		"Clockwork.plugin.__Register = Clockwork.plugin.__Register or Clockwork.plugin.Register;"
	);

	CW_SCRIPT_SHARED.clientCode = CW_SCRIPT_SHARED.clientCode:gsub(
		"Clockwork.plugin.__Add = Clockwork.plugin.Add;", 
		"Clockwork.plugin.__Add = Clockwork.plugin.__Add or Clockwork.plugin.Add;"
	);

	function MYSQL_UPDATE_CLASS:AddWhere(key, value)
		if (Clockwork.NoMySQL) then return self; end;

		value = Clockwork.database:Escape(tostring(value));

		if (value == nil) then return self; end;

		self.updateWhere[#self.updateWhere + 1] = string.gsub(key, '?', "\""..value.."\"");
		return self;
	end;
	
	function MYSQL_UPDATE_CLASS:SetValue(key, value)
		if (Clockwork.NoMySQL) then return self; end;

		value = Clockwork.database:Escape(tostring(value));

		if (value == nil) then return; end;

		self.updateVars[key] = "\""..value.."\"";
		return self;
	end;

	function MYSQL_SELECT_CLASS:AddWhere(key, value)
		if (Clockwork.NoMySQL) then return self; end;

		value = Clockwork.database:Escape(tostring(value));

		if (value == nil) then return; end;

		self.selectWhere[#self.selectWhere + 1] = string.gsub(key, '?', "\""..value.."\"");
		return self;
	end;
end;

if (CLIENT) then
	-- Fix clientside freeze due to directory pages creating like bunnies during heat.
	Clockwork.directory.OldAddCategory = Clockwork.directory.OldAddCategory or Clockwork.directory.AddCategory;
	Clockwork.directory.OldAddCode = Clockwork.directory.OldAddCode or Clockwork.directory.AddCode;
	Clockwork.directory.OldAddPage = Clockwork.directory.OldAddPage or Clockwork.directory.AddPage;

	function Clockwork.directory:AddCategory(...)
		if (_G["ClockworkClientsideBooted"]) then return; end;

		return self:OldAddCategory(...);
	end;

	function Clockwork.directory:AddCode(...)
		if (_G["ClockworkClientsideBooted"]) then return; end;

		return self:OldAddCode(...);
	end;

	function Clockwork.directory:AddPage(...)
		if (_G["ClockworkClientsideBooted"]) then return; end;

		return self:OldAddPage(...);
	end;

	function PLUGIN:ClockworkLoadShared(sharedTable)
		_G["ClockworkClientsideBooted"] = true;
	end;
end;

-- A function to include a plugin.
function Clockwork.plugin:Include(directory, bIsSchema)
	local schemaFolder = Clockwork.kernel:GetSchemaFolder();
	local explodeDir = string.Explode("/", directory);
	local folderName = explodeDir[#explodeDir - 1];
	local pathCRC = util.CRC(directory);

	PLUGIN_BASE_DIR = directory;
	PLUGIN_FOLDERNAME = folderName;

	if (bIsSchema) then
		PLUGIN = self:New(); Schema = PLUGIN;

		if (SERVER) then
			local schemaInfo = Clockwork.kernel:GetSchemaGamemodeInfo();
				table.Merge(Schema, schemaInfo);
			CW_SCRIPT_SHARED.schemaData = schemaInfo;
		elseif (CW_SCRIPT_SHARED.schemaData) then
			table.Merge(Schema, CW_SCRIPT_SHARED.schemaData);
		else
			MsgC(Color(255, 100, 0, 255), "\n[Clockwork:Plugin] The schema has no "..schemaFolder..".ini!\n");
		end;

		if (cwFile.Exists(directory.."/sh_schema.lua", "LUA")) then
			AddCSLuaFile(directory.."/sh_schema.lua");
			include(directory.."/sh_schema.lua");
		else
			MsgC(Color(255, 100, 0, 255), "\n[Clockwork:Plugin] The schema has no sh_schema.lua.\n");
		end;

		Schema:Register();
	else
		PLUGIN = self:New();

		if (SERVER) then
			local iniDir = "gamemodes/"..Clockwork.kernel:RemoveTextFromEnd(directory, "/plugin"); 
			local iniTable = Clockwork.config:LoadINI(iniDir.."/plugin.ini", true, true);

			if (iniTable) then
				if (iniTable["Plugin"]) then
					iniTable = iniTable["Plugin"];
					iniTable.isUnloaded = self:IsUnloaded(PLUGIN_FOLDERNAME, true);
						table.Merge(PLUGIN, iniTable);
					CW_SCRIPT_SHARED.plugins[pathCRC] = iniTable;
				else
					MsgC(Color(255, 100, 0, 255), "\n[Clockwork:Plugin] The "..PLUGIN_FOLDERNAME.." plugin has no plugin.ini!\n");
				end;

				if (iniTable["compatibility"]) then
					local compatibility = iniTable["compatibility"];
					local Name = iniTable["name"] or PLUGIN_FOLDERNAME;
					local cwVersion = Clockwork.kernel:GetVersion();
					local cwBuild = Clockwork.kernel:GetBuild();
					local cwVersBuild = Clockwork.kernel:GetVersionBuild();

					if (self:CompareVersion(compatibility, Name, cwVersion, cwBuild)) then
						MsgC(Color(255, 165, 0), "\n[Clockwork:Plugin] The "..Name.." plugin ["..compatibility.."] may not be compatible with Clockwork "..cwVersBuild.."!\nYou might need to update your framework!\n");
					end;
				end
			end;
		else
			local iniTable = CW_SCRIPT_SHARED.plugins[pathCRC];

			if (iniTable) then
				table.Merge(PLUGIN, iniTable);

				if (iniTable.isUnloaded) then
					unloaded[PLUGIN_FOLDERNAME] = true;
				end;
			else
				MsgC(Color(255, 100, 0, 255), "\n[Clockwork:Plugin] The "..PLUGIN_FOLDERNAME.." plugin has no plugin.ini!\n");
			end;
		end;

		local isUnloaded = self:IsUnloaded(PLUGIN_FOLDERNAME, true);
		local isDisabled = self:IsDisabled(PLUGIN_FOLDERNAME, true);
		local shPluginDir = directory.."/sh_plugin.lua";
		local addCSLua = true;

		-- Restore plugin's data on refresh.
		if (self:GetStored()[PLUGIN.name]) then
			PLUGIN = self:GetStored()[PLUGIN.name];
		end;

		if (!isUnloaded and !isDisabled) then
			if (cwFile.Exists(shPluginDir, "LUA")) then
				Clockwork.kernel:IncludePrefixed(shPluginDir);
			end;

			addCSLua = false;
		end;

		if (SERVER and addCSLua) then
			AddCSLuaFile(shPluginDir);
		end;

		PLUGIN:Register();
		PLUGIN = nil;
	end;
end;

-- Fix for sharedvars resetting.
function Clockwork.SharedVars.player:Add(name, class, bPlayerOnly)
	self.vars[name] = self.vars[name] or {
		bPlayerOnly = bPlayerOnly,
		class = class,
		name = name
	};
end;

if (SERVER) then
	local clKernel = fileio.Read("gamemodes/clockwork/framework/cl_kernel.lua");

	if (clKernel:find("local cwClient;")) then
		print("[Voodoo Magic] Patching cl_kernel.lua. You might want to restart your server, just in case.");

		clKernel = clKernel:gsub("local cwClient;", "-- patched");

		fileio.Write("gamemodes/clockwork/framework/cl_kernel.lua", clKernel);
	end;
end;

-- Fix for "[Clockwork:PlayerSharedVars] Couldn't find key 'permaKilled' in sharedVars table. Is it registered?"
if (engine.ActiveGamemode() == "cwhl2rp") then
	-- Called when the Clockwork shared variables are added.
	function PLUGIN:ClockworkAddSharedVars(globalVars, playerVars)
		playerVars:Bool("permaKilled", false);

		_G["ClockworkClientsideBooted"] = true;

		Clockwork.plugin:Remove("ClockworkLogoPlugin");
	end;
end;

if (SERVER) then
	CloudAuthX.OldExternal = CloudAuthX.OldExternal or CloudAuthX.External;

	function CloudAuthX.External(code)
		if (!_G["cwBootComplete"]) then
			return CloudAuthX.OldExternal(code);
		end;
	end;
end;