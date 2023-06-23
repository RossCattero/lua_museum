--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local Clockwork = Clockwork;
local PLUGIN = PLUGIN;
local pairs = pairs;
local table = table;
local vgui = vgui;
local math = math;

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	self:SetSize(Clockwork.menu:GetWidth(), Clockwork.menu:GetHeight());
	
	self.panelList = vgui.Create("cwPanelList", self);
 	self.panelList:SetPadding(2);
 	self.panelList:SetSpacing(2);
 	self.panelList:SizeToContents();
	self.panelList:EnableVerticalScrollbar();
	
	self:Rebuild();
end;

-- A function to rebuild the panel.
function PANEL:Rebuild()
	self.panelList:Clear();
	
	local categories = {};
	local recipesList = {};
	
	for k, v in pairs(PLUGIN.recipe:GetAll()) do
		if (PLUGIN.recipe:CanPlayerSeeRecipe(v)) then
			local recipeCategory = v.category;
			recipesList[recipeCategory] = recipesList[recipeCategory] or {};
			recipesList[recipeCategory][#recipesList[recipeCategory] + 1] = v;
		end;
	end;
	
	for k, v in pairs(recipesList) do
		categories[#categories + 1] = {
			recipesList = v,
			category = k
		};
	end;
	
	table.sort(categories, function(a, b)
		return a.category < b.category;
	end);
	
	if (#categories == 0) then
		local label = vgui.Create("cwInfoText", self);
			label:SetText("У вас нету доступа в меню "..Clockwork.option:GetKey("name_crafting", true).."а !");
			label:SetInfoColor("red");
		self.panelList:AddItem(label);
		
		PLUGIN:PlayerCraftingRebuilt(self, categories);
	else
		PLUGIN:PlayerCraftingRebuilt(self, categories);
		
		for k, v in pairs(categories) do
			local collapsibleCategory = Clockwork.kernel:CreateCustomCategoryPanel(v.category, self.panelList);
				self.panelList:AddItem(collapsibleCategory);
			
			local categoryList = vgui.Create("DPanelList", collapsibleCategory);
				categoryList:EnableHorizontal(true);
				categoryList:SetAutoSize(true);
				categoryList:SetPadding(4);
				categoryList:SetSpacing(4);
			collapsibleCategory:SetContents(categoryList);
			
			table.sort(v.recipesList, function(a, b)
				return a.name < b.name;
			end);
			
			for k2, v2 in pairs(v.recipesList) do
				self.recipeData = {
					recipe = v2
				};
				
				categoryList:AddItem(vgui.Create("cwCraftingItem", self));
			end;
		end;
	end;
	
	self.panelList:InvalidateLayout(true);
end;

-- Called when the menu is opened.
function PANEL:OnMenuOpened()
	if (Clockwork.menu:IsPanelActive(self)) then
		self:Rebuild();
	end;
end;

-- Called when the panel is selected.
function PANEL:OnSelected() self:Rebuild(); end;

-- Called when the layout should be performed.
function PANEL:PerformLayout(w, h)
	self.panelList:StretchToParent(4, 28, 4, 4);
	self:SetSize(w, math.min(self.panelList.pnlCanvas:GetTall() + 32, ScrH() * 0.75));
end;

-- Called when the panel is painted.
function PANEL:Paint(w, h)
	draw.RoundedBox(0,0,0,w,h,Color(0,0,0,150))
	
	return true;
end;

-- Called each frame.
function PANEL:Think()
	self:InvalidateLayout(true);
end;

vgui.Register("cwCrafting", PANEL, "EditablePanel");

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	local recipeData = self:GetParent().recipeData;
		self:SetSize(40, 40);
		self.recipe = recipeData.recipe;
	PLUGIN:PlayerAdjustCraftingRecipe(self.recipe);
	
	local model, skin = PLUGIN.recipe:GetIconInfo(self.recipe);
	self.spawnIcon = Clockwork.kernel:CreateMarkupToolTip(vgui.Create("cwSpawnIcon", self));
	
	if (Clockwork.CraftCooldown and CurTime() < Clockwork.CraftCooldown) then
		self.spawnIcon:SetCooldown(Clockwork.CraftCooldown);
	end;
	
	-- Called when the spawn icon is clicked.
	function self.spawnIcon.DoClick(spawnIcon)
		Clockwork.datastream:Start("CraftRecipe", self.recipe.uniqueID);
	end;
	
	self.spawnIcon:SetModel(model, skin);
	self.spawnIcon:SetToolTip("");
	self.spawnIcon:SetSize(40, 40);
end;

-- Called each frame.
function PANEL:Think()
	self.spawnIcon:SetMarkupToolTip(
		PLUGIN.recipe:GetMarkupToolTip(self.recipe, false)
	);

	local color = Color(255, 0, 0, 255);
	if (PLUGIN.recipe:PlayerCanCraftRecipe(self.recipe, Clockwork.Client, Clockwork.inventory:GetClient())) then
		color = Color(0, 255, 0, 255);
	end;

	self.spawnIcon:SetColor(color);
end;

function PANEL:Paint(w, h)
    draw.RoundedBox(0,0,0,w,h,Color(0,0,0,150))
end
	
vgui.Register("cwCraftingItem", PANEL, "DPanel");