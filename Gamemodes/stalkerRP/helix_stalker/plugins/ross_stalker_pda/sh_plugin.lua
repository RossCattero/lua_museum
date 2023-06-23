local PLUGIN = PLUGIN

PLUGIN.name = "Stalker PDA plugin"
PLUGIN.author = "Ross"
PLUGIN.description = ""

ix.util.Include("sv_plugin.lua")
ix.util.Include("cl_plugin.lua")

-- ix.command.Add("AddPlayerTask", {
--     description = "Добавить персонажу задание",
--     OnCheckAccess = function(self, client)
--         return client:IsAdmin() or client:IsSuperAdmin() or client:GetCharacter():HasFlags('p')
--     end,
-- 	arguments = {
--         ix.type.player,
--         ix.type.string,
--         ix.type.string,
--         ix.type.string
--     },
-- 	OnRun = function(self, client, player, id, title, description)
-- 		local character = client:GetCharacter()
--         if !player:HasQuest(id) then
--             player:AddQuest(id, title, description)
--             client:Notify('Вы добавили квест '..id..' данному персонажу.')
--         else
--             client:Notify('У этого игрока уже есть такой квест!')
--         end;
-- 	end
-- })

ix.command.Add("CharAddReputation", {
    description = "Добавить репутацию персонажу",
    OnCheckAccess = function(self, client)
        return client:IsAdmin() or client:IsSuperAdmin() or client:GetCharacter():HasFlags('l')
    end,
	arguments = {
        ix.type.player,
        ix.type.number,
    },
	OnRun = function(self, client, player, reputation)
        client:Notify('Вы добавили данному персонажу '..reputation..' репутации.')
	end
})

ix.command.Add("CharAddRank", {
    description = "Добавить известность персонажу",
    OnCheckAccess = function(self, client)
        return client:IsAdmin() or client:IsSuperAdmin() or client:GetCharacter():HasFlags('l')
    end,
	arguments = {
        ix.type.player,
        ix.type.number,
    },
	OnRun = function(self, client, player, renown)
        client:Notify('Вы добавили данному персонажу '..renown..' известности.')
	end
})

-- ix.command.Add("RemPlayerTask", {
--     description = "Убрать задание у персонажа",
--     OnCheckAccess = function(self, client)
--         return client:IsAdmin() or client:IsSuperAdmin() or client:GetCharacter():HasFlags('Z')
--     end,
-- 	arguments = {
--         ix.type.player,
--         ix.type.string,
--     },
-- 	OnRun = function(self, client, player, id)
--         if player:HasQuest(id) then
--             player:RemQuest(id)
--             client:Notify('Вы убрали квест '..id..' данному персонажу.')
--         else
--             client:Notify('У этого персонажа нет такого квеста!')
--         end;
-- 	end
-- })

ix.command.Add("AddGlobalPDA", {
    description = "Проинформировать всех с ПДА",
    OnCheckAccess = function(self, client)
        return client:IsAdmin() or client:IsSuperAdmin() or client:GetCharacter():HasFlags('P')
    end,
	arguments = {
        ix.type.string,
        ix.type.string
    },
    OnRun = function(self, client, type, text)
        local sound, image;
        if type == 'Новость' then
            image = 'icons/notice_documents.png'
            sound = 'stalker/device/pda/pda_alarm.mp3'
        elseif type == 'Уведомление' then
            image = 'icons/notice_kpk.png'
            sound = 'stalker/device/pda/pda_tip.mp3'
        elseif type == 'Предложение' then
            image = 'icons/notice_getmoney.png'
            sound = 'stalker/device/pda/pda_news.mp3'
        elseif type == 'Выброс' then
            image = 'icons/notice_blowout.png'
            sound = 'stalker/device/pda/pda_sos.mp3'
        else
            return;
        end;
        
        if SERVER then
            table.insert(ix.data.Get("GlobalNotifications"), {image, text})
            ix.data.Set("GlobalNotifications", ix.data.Get("GlobalNotifications"))
        end;
        
        for k, v in pairs(player.GetAll()) do
            if v:GetCharacter() && v:GetCharacter():GetInventory():HasItem('ross_stalker_pda') then
                netstream.Start(v, 'Notify_PDA')
                v:EmitSound(sound)
            end;
        end;

	end
})