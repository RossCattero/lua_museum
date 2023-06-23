include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

function ENT:Initialize()
	self:SetModel('models/container_m.mdl')
	self:DrawShadow(true);
	self:SetSolid(SOLID_BBOX);
	self:PhysicsInit(SOLID_BBOX);
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetUseType(SIMPLE_USE);

	self:SetTurned(false)

	local physObj = self:GetPhysicsObject();
	if (IsValid(physObj)) then
		physObj:EnableMotion(true);
		physObj:Wake();
	end;

    ix.item.RegisterInv("GarbageContainer", 10, 10)

    ix.item.NewInv(0, "GarbageContainer", function(inventory)
        inventory.vars.isBag = true
        inventory.vars.isContainer = true

        self:SetInventory(inventory)
    end)
end;

function ENT:StartTouch(ent)

	if ent:GetClass() == 'ix_item' && self.opened then
		local uniqueID = ent:GetItemTable().uniqueID;
		self:EmitSound('physics/cardboard/cardboard_box_impact_hard2.wav')
		self:GetInventory():Add(uniqueID)
		ent:Remove();
	end;
end;

function ENT:OnOptionSelected(player, option, data)
	if !self:GetTurned() then
		if ( option == "Открыть" ) then
			self:SetBodygroup(1, 1)
			self:EmitSound('doors/default_move.wav')

			self.opened = true;
		elseif option == 'Закрыть' then
			self:SetBodygroup(1, 0)
			self:EmitSound('doors/default_stop.wav')

			self.opened = false;
		elseif option == 'Посмотреть' then
			self:OpenInventory(player)
		elseif option == 'Включить процесс переработки' then
			local uniqueID = self:EntIndex()..' - garbage refresh';
			self:SetTurned(true);
			local loopingsound = self:StartLoopingSound('ambient/machines/machine3.wav')
			local itemList = self:GetInventory():GetItems()

			local time = 1;

			for k, v in pairs(itemList) do
				if v then time = time + 1 end;
			end;

			timer.Create(uniqueID, time or 1, 1, function()
				if !IsValid(self) then
					timer.Remove(uniqueID)
					return;
				end;

				for k, v in pairs(itemList) do 
					v:Remove();
					if v.ingredientsRefine then
						for k, v in pairs(v.ingredientsRefine) do
							self:GetInventory():Add(k, v)
						end;
					end;
				end;

				self:StopLoopingSound(loopingsound)
				self:EmitSound('ambient/machines/spindown.wav')
				self:SetTurned(false);
			end)
		end;
	end;
end;

function ENT:GetInventory()
	return ix.item.inventories[self:GetID()]
end

function ENT:SetInventory(inventory)
	if (inventory) then
		self:SetID(inventory:GetID())
	end
end
function ENT:OnRemove()
	local index = self:GetID()

	if (!ix.shuttingDown and !self.ixIsSafe and ix.entityDataLoaded and index) then
		local inventory = ix.item.inventories[index]

		if (inventory) then
			ix.item.inventories[index] = nil

			local query = mysql:Delete("ix_items")
				query:Where("inventory_id", index)
			query:Execute()

			query = mysql:Delete("ix_inventories")
				query:Where("inventory_id", index)
			query:Execute()

			hook.Run("ContainerRemoved", self, inventory)
		end
	end
end

function ENT:OpenInventory(activator)
	local inventory = self:GetInventory()

	if (inventory) then

		ix.storage.Open(activator, inventory, {
			name = 'Мусорный контейнер',
			entity = self,
			searchTime = ix.config.Get("containerOpenTime", 0.7),
			data = {money = 0},
			OnPlayerClose = function()
				ix.log.Add(activator, "closeContainer", 'nothing', inventory:GetID())
			end
		})

		if (self:GetLocked()) then
			self.Sessions[activator:GetCharacter():GetID()] = true
		end

		ix.log.Add(activator, "openContainer", name, inventory:GetID())
	end
end