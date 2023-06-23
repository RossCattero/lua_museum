/*----------------------\
| Created by Viomi      |
| viomi@openmailbox.org |
\----------------------*/

-- Called each tick.
function Schema:Tick()
	if (IsValid(Clockwork.Client)) then
		if (self:PlayerIsCombine(Clockwork.Client) && Clockwork.Client:GetSharedVar("GasMaskInfo") >= 2) then
			local curTime = CurTime()
			local health = Clockwork.Client:Health()
			local armor = Clockwork.Client:Armor()

			if (!self.nextHealthWarning or curTime >= self.nextHealthWarning) then
				if (self.lastHealth) then
					if (health < self.lastHealth) then
						if (health == 0) then
							self:AddCombineDisplayLine( "ОШИБКА! Отключение...", Color(255, 0, 0, 255) )
						else
							self:AddCombineDisplayLine( "ВНИМАНИЕ! Обнаружена физическая травма...", Color(255, 0, 0, 255) )
						end
						
						self.nextHealthWarning = curTime + 15
					elseif (health > self.lastHealth) then
						if (health == 100) then
							self:AddCombineDisplayLine( "Физические системы восстановлены...", Color(0, 255, 0, 255) )
						else
							self:AddCombineDisplayLine( "Физические системы восстанавливаются...", Color(0, 0, 255, 255) )
						end
						
						self.nextHealthWarning = curTime + 15
					end
				end
				
				if (self.lastArmor) then
					if (armor < self.lastArmor) then
						if (armor == 0) then
							self:AddCombineDisplayLine( "ВНИМАНИЕ! Защита получила исчерпывающий урон...", Color(255, 0, 0, 255) )
						else
							self:AddCombineDisplayLine( "Внимание! Защита получила урон...", Color(255, 0, 0, 255) )
						end
						
						self.nextHealthWarning = curTime + 15
					elseif (armor > self.lastArmor) then
						if (armor == 100) then
							self:AddCombineDisplayLine( "Защита восстановлена...", Color(0, 255, 0, 255) )
						else
							self:AddCombineDisplayLine( "Защита восстанавливается...", Color(0, 0, 255, 255) )
						end
						
						self.nextHealthWarning = curTime + 15
					end
				end
			end
			
			if (!self.nextRandomLine or curTime >= self.nextRandomLine) then
				local text = self.randomDisplayLines[ math.random(1, #self.randomDisplayLines) ]
				
				if (text and self.lastRandomDisplayLine != text) then
					self:AddCombineDisplayLine(text)
					
					self.lastRandomDisplayLine = text
				end
				
				self.nextRandomLine = curTime + 3
			end
			
			self.lastHealth = health
			self.lastArmor = armor
		end
	end
end