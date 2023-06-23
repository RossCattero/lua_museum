
-- The shared init file. You'll want to fill out the info for your schema and include any other files that you need.

-- Schema info
Schema.name = "STALKERRP"
Schema.author = "Росс Жейски"
Schema.description = "Welcome to your misery."

function GetHitGroupBone(trace)
	if trace.HitWorld then
		return 0;
	end;
	local ent, pbone = trace.Entity, trace.PhysicsBone
	local bone = ent:TranslatePhysBoneToBone( pbone )
	local bonename = ent:GetBoneName( bone );
	bonename = bonename:lower()
	if bonename:find('head') then
		return 1
	elseif bonename:find('spine') or 
	bonename:find('pelvis') or 
	bonename:find('hips') then
		return 2
	elseif bonename:find('forearm') or 
	bonename:find('arm') or 
	bonename:find('upperarm') or 
	bonename:find('hand') then
		return 4
	elseif bonename:find('thigh') or 
	bonename:find('leg') or 
	bonename:find('flapa') or 
	bonename:find('calf') or 
	bonename:find('foot') then
		return 6
	end;
	return 0;
end;

ix.util.Include("cl_schema.lua")
ix.util.Include("sv_schema.lua")

ix.util.Include("cl_hooks.lua")
ix.util.Include("sh_hooks.lua")
ix.util.Include("sv_hooks.lua")

-- You'll need to manually include files in the meta/ folder, however.
ix.util.Include("meta/sh_character.lua")
ix.util.Include("meta/sh_player.lua")
ix.util.Include("libs/thirdparty/sh_netstream2.lua")

Schema.voices.Add("LONER", "Отойди1", "Отойди-ка от сюда подальше, мужик.", "human_01/stalker/threat/back_off/backoff_1.mp3")
Schema.voices.Add("LONER", "Оружие1", "Оружие убрал.", "human_01/stalker/threat/drop_weapon/dropweapon_1.mp3")
Schema.voices.Add("LONER", "ШуткаВступление", "Внимание! Выдаю шутку юмора!", "human_01/stalker/talk/intros/intro_joke_3.mp3")
Schema.voices.Add("LONER", "МузПауза", "Всё, музыкальная пауза.", "human_01/stalker/talk/intros/intro_music_4.mp3")
Schema.voices.Add("LONER", "Анекдот1", "*Рассказывает анекдот*", "human_01/stalker/talk/jokes/joke_1.mp3")
Schema.voices.Add("LONER", "Анекдот2", "*Рассказывает анекдот*", "human_01/stalker/talk/jokes/joke_2.mp3")
Schema.voices.Add("LONER", "Анекдот3", "*Рассказывает анекдот*", "human_01/stalker/talk/jokes/joke_3.mp3")
Schema.voices.Add("LONER", "Анекдот4", "*Рассказывает анекдот*", "human_01/stalker/talk/jokes/joke_4.mp3")
Schema.voices.Add("LONER", "Анекдот5", "*Рассказывает анекдот*", "human_01/stalker/talk/jokes/joke_5.mp3")
Schema.voices.Add("LONER", "Анекдот6", "*Рассказывает анекдот*", "human_01/stalker/talk/jokes/joke_6.mp3")
Schema.voices.Add("LONER", "Анекдот7", "*Рассказывает анекдот*", "human_01/stalker/talk/jokes/joke_7.mp3")
Schema.voices.Add("LONER", "Анекдот8", "*Рассказывает анекдот*", "human_01/stalker/talk/jokes/joke_8.mp3")
Schema.voices.Add("LONER", "Анекдот9", "*Рассказывает анекдот*", "human_01/stalker/talk/jokes/joke_9.mp3")
Schema.voices.Add("LONER", "Анекдот10", "*Рассказывает анекдот*", "human_01/stalker/talk/jokes/joke_10.mp3")
Schema.voices.Add("LONER", "Анекдот11", "*Рассказывает анекдот*", "human_01/stalker/talk/jokes/joke_11.mp3")
Schema.voices.Add("LONER", "Анекдот12", "*Рассказывает анекдот*", "human_01/stalker/talk/jokes/joke_12.mp3")
Schema.voices.Add("LONER", "Анекдот13", "*Рассказывает анекдот*", "human_01/stalker/talk/jokes/joke_13.mp3")
Schema.voices.Add("LONER", "Заманал", "Ты заманал, понял!?", "human_01/stalker/talk/use/abuse_2.mp3")
Schema.voices.Add("LONER", "НеГоворить", "Не буду я говорить.", "human_01/stalker/talk/use/no_default_1.mp3")
Schema.voices.Add("LONER", "ПотомПоговорим", "Мужик, ты сдурел? Потом поговорим!", "human_01/stalker/talk/use/no_fight_2.mp3")
Schema.voices.Add("LONER", "ОружиеУбери", "Сначала оружие убери, а потом и разговор.", "human_01/stalker/talk/use/no_weapon_1.mp3")
-- Schema.voices.Add("LONER", "", "", "")