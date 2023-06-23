--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

table.insert(Clockwork.voices.chatClasses, "request");
table.insert(Clockwork.voices.chatClasses, "radio");
table.insert(Clockwork.voices.chatClasses, "dispatch");

Clockwork.voices:RegisterGroup("Dispatch", false, function(player)
	local faction = player:GetFaction(); local rank = Schema:GetCombineRank(player:Name());

	return faction == FACTION_SCANNER || (Schema:PlayerIsCombine(player) && (rank == "DvL" || rank == "SeC") );
end);

Clockwork.voices:RegisterGroup("Combine", false, function(player)
	local faction = player:GetFaction();

	return Schema:PlayerIsCombine(player) and faction != FACTION_SCANNER;
end);

Clockwork.voices:RegisterGroup("Human_Male", false, function(player)
	local model = player:GetModel():lower()

	return (model:find("_male_") || model:find("ross")) && !Schema:PlayerIsCombine(player)
end)

Clockwork.voices:RegisterGroup("Human_Female", false, function(player)
	local model = player:GetModel():lower()

	return model:find("_female_") && !Schema:PlayerIsCombine(player)
end)

Clockwork.voices:RegisterGroup("Vortigaunt", false, function(player)
	return player:GetFaction() == FACTION_VORTIGAUNT;
end);

Clockwork.voices:Add("Dispatch", "DAnti-Citizen", "Attention ground units. Anti-citizen reported in this community. Code: LOCK, CAUTERIZE, STABILIZE.", "npc/overwatch/cityvoice/f_anticitizenreport_spkr.wav");
Clockwork.voices:Add("Dispatch", "DAnti-Civil", "Protection team alert. Evidence of anti-civil activity in this community. Code: ASSEMBLE, PLAN, CONTAIN.", "npc/overwatch/cityvoice/f_anticivilevidence_3_spkr.wav");
Clockwork.voices:Add("Dispatch", "DPerson Interest", "Attention please. Unidentified person of interest confirm your civil status with local protection team immediately.", "npc/overwatch/cityvoice/f_confirmcivilstatus_1_spkr.wav");
Clockwork.voices:Add("Dispatch", "DCitizen Inaction", "Citizen reminder. Inaction is conspiracy. Report counter behaviour to a Civil Protection team immediately.", "npc/overwatch/cityvoice/f_innactionisconspiracy_spkr.wav");
Clockwork.voices:Add("Dispatch", "DUnrest Structure", "Alert community ground protection units, local unrest structure detected. ASSEMBLE, ADMINISTER, PACIFY.", "npc/overwatch/cityvoice/f_localunrest_spkr.wav");
Clockwork.voices:Add("Dispatch", "DStatus Evasion", "Attention protection team. Status evasion in progress in this community. RESPOND, ISOLATE, ENQUIRE.", "npc/overwatch/cityvoice/f_protectionresponse_1_spkr.wav");
Clockwork.voices:Add("Dispatch", "DLockdown", "Attention all ground protection teams. Judgment waiver now in effect. Capital prosecution is discretionary.", "npc/overwatch/cityvoice/f_protectionresponse_5_spkr.wav");
Clockwork.voices:Add("Dispatch", "DRations Deducted", "Attention occupants. Your block is now charged with permissive inactive cohesion. Five ration units deducted.", "npc/overwatch/cityvoice/f_rationunitsdeduct_3_spkr.wav");
Clockwork.voices:Add("Dispatch", "DInspection", "Citizen notice. Priority identification check in progress. Please assemble in your designated inspection positions.", "npc/overwatch/cityvoice/f_trainstation_assemble_spkr.wav");
Clockwork.voices:Add("Dispatch", "DInspection 2", "Attention please. All citizens in local residential block, assume your inspection positions.", "npc/overwatch/cityvoice/f_trainstation_assumepositions_spkr.wav");
Clockwork.voices:Add("Dispatch", "DMiscount Detected", "Attention resident. Miscount detected in your block. Co-operation with your Civil Protection team permit full ration reward.", "npc/overwatch/cityvoice/f_trainstation_cooperation_spkr.wav");
Clockwork.voices:Add("Dispatch", "DInfection", "Attention resident. This block contains potential civil infection. INFORM, CO-OPERATE, ASSEMBLE.", "npc/overwatch/cityvoice/f_trainstation_inform_spkr.wav");
Clockwork.voices:Add("Dispatch", "DRelocation", "Citizen notice. Failure to co-operate will result in permanent off-world relocation.", "npc/overwatch/cityvoice/f_trainstation_offworldrelocation_spkr.wav");
Clockwork.voices:Add("Dispatch", "DUnrest Code", "Attention community. Unrest procedure code is now in effect. INOCULATE, SHIELD, PACIFY. Code: PRESSURE, SWORD, STERILIZE.", "npc/overwatch/cityvoice/f_unrestprocedure1_spkr.wav");
Clockwork.voices:Add("Dispatch", "DEvasion", "Attention please. Evasion behaviour consistent with mal-compliant defendant. Ground protection team, alert. Code: ISOLATE, EXPOSE, ADMINISTER.", "npc/overwatch/cityvoice/f_evasionbehavior_2_spkr.wav");
Clockwork.voices:Add("Dispatch", "DIndividual", "Individual. You are charged with social endangerment, level one. Protection unit, prosecution code: DUTY, SWORD, MIDNIGHT.", "npc/overwatch/cityvoice/f_sociolevel1_4_spkr.wav");
Clockwork.voices:Add("Dispatch", "DAutonomous", "Attention all ground protection teams. Autonomous judgement is now in effect, sentencing is now discretionary. Code: AMPUTATE, ZERO, CONFIRM.", "npc/overwatch/cityvoice/f_protectionresponse_4_spkr.wav");
Clockwork.voices:Add("Dispatch", "DCitizenship", "Individual. You are convicted of multi anti-civil violations. Implicit citizenship revoked. Status: MALIGNANT.", "npc/overwatch/cityvoice/f_citizenshiprevoked_6_spkr.wav");
Clockwork.voices:Add("Dispatch", "DMalcompliance", "Individual. You are charged with capital malcompliance, anti-citizen status approved.", "npc/overwatch/cityvoice/f_capitalmalcompliance_spkr.wav");
Clockwork.voices:Add("Dispatch", "DExogen", "Overwatch acknowledges critical exogen breach, AirWatch augmentation force dispatched and inbound. Hold for reinforcements.", "npc/overwatch/cityvoice/fprison_airwatchdispatched.wav");
Clockwork.voices:Add("Dispatch", "DFailure", "Attention ground units. Mission failure will result in permanent off-world assignment. Code reminder: SACRIFICE, COAGULATE, PLAN.", "npc/overwatch/cityvoice/fprison_missionfailurereminder.wav");

Clockwork.voices:Add("Combine", "Sweeping", "Sweeping for suspect.", "npc/metropolice/hiding02.wav");
Clockwork.voices:Add("Combine", "Isolate", "Isolate!", "npc/metropolice/hiding05.wav");
Clockwork.voices:Add("Combine", "You Can Go", "Alright, you can go.", "npc/metropolice/vo/allrightyoucango.wav");
Clockwork.voices:Add("Combine", "Need Assistance", "Eleven-ninety-nine, officer needs assistance!", "npc/metropolice/vo/11-99officerneedsassistance.wav");
Clockwork.voices:Add("Combine", "Administer", "Administer.", "npc/metropolice/vo/administer.wav");
Clockwork.voices:Add("Combine", "Affirmative", "Affirmative.", "npc/metropolice/vo/affirmative.wav");
Clockwork.voices:Add("Combine", "All Units Move In", "All units move in!", "npc/metropolice/vo/allunitsmovein.wav");
Clockwork.voices:Add("Combine", "Amputate", "Amputate.", "npc/metropolice/vo/amputate.wav");
Clockwork.voices:Add("Combine", "Anti-Citizen", "Anti-citizen.", "npc/metropolice/vo/anticitizen.wav");
Clockwork.voices:Add("Combine", "Citizen", "Citizen.", "npc/metropolice/vo/citizen.wav");
Clockwork.voices:Add("Combine", "Copy", "Copy.", "npc/metropolice/vo/copy.wav");
Clockwork.voices:Add("Combine", "Cover Me", "Cover me, I'm going in!", "npc/metropolice/vo/covermegoingin.wav");
Clockwork.voices:Add("Combine", "Assist Trespass", "Assist for a criminal trespass!", "npc/metropolice/vo/criminaltrespass63.wav");
Clockwork.voices:Add("Combine", "Destroy Cover", "Destroy that cover!", "npc/metropolice/vo/destroythatcover.wav");
Clockwork.voices:Add("Combine", "Don't Move", "Don't move!", "npc/metropolice/vo/dontmove.wav");
Clockwork.voices:Add("Combine", "Final Verdict", "Final verdict administered.", "npc/metropolice/vo/finalverdictadministered.wav");
Clockwork.voices:Add("Combine", "Final Warning", "Final warning!", "npc/metropolice/vo/finalwarning.wav");
Clockwork.voices:Add("Combine", "First Warning", "First warning, move away!", "npc/metropolice/vo/firstwarningmove.wav");
Clockwork.voices:Add("Combine", "Get Down", "Get down!", "npc/metropolice/vo/getdown.wav");
Clockwork.voices:Add("Combine", "Get Out", "Get out of here!", "npc/metropolice/vo/getoutofhere.wav");
Clockwork.voices:Add("Combine", "Suspect One", "I got suspect one here.", "npc/metropolice/vo/gotsuspect1here.wav");
Clockwork.voices:Add("Combine", "Help", "Help!", "npc/metropolice/vo/help.wav");
Clockwork.voices:Add("Combine", "Running", "He's running!", "npc/metropolice/vo/hesrunning.wav");
Clockwork.voices:Add("Combine", "Hold It", "Hold it right there!", "npc/metropolice/vo/holditrightthere.wav");
Clockwork.voices:Add("Combine", "Move Along Repeat", "I said move along.", "npc/metropolice/vo/isaidmovealong.wav");
Clockwork.voices:Add("Combine", "Malcompliance", "Issuing malcompliance citation.", "npc/metropolice/vo/issuingmalcompliantcitation.wav");
Clockwork.voices:Add("Combine", "Keep Moving", "Keep moving!", "npc/metropolice/vo/keepmoving.wav");
Clockwork.voices:Add("Combine", "Lock Position", "All units, lock your position!", "npc/metropolice/vo/lockyourposition.wav");
Clockwork.voices:Add("Combine", "Trouble", "Lookin' for trouble?", "npc/metropolice/vo/lookingfortrouble.wav");
Clockwork.voices:Add("Combine", "Look Out", "Look out!", "npc/metropolice/vo/lookout.wav");
Clockwork.voices:Add("Combine", "Minor Hits", "Minor hits, continuing prosecution.", "npc/metropolice/vo/minorhitscontinuing.wav");
Clockwork.voices:Add("Combine", "Move", "Move!", "npc/metropolice/vo/move.wav");
Clockwork.voices:Add("Combine", "Move Along", "Move along!", "npc/metropolice/vo/movealong3.wav");
Clockwork.voices:Add("Combine", "Move Back", "Move back, right now!", "npc/metropolice/vo/movebackrightnow.wav");
Clockwork.voices:Add("Combine", "Move It", "Move it!", "npc/metropolice/vo/moveit2.wav");
Clockwork.voices:Add("Combine", "Hardpoint", "Moving to hardpoint.", "npc/metropolice/vo/movingtohardpoint.wav");
Clockwork.voices:Add("Combine", "Officer Help", "Officer needs help!", "npc/metropolice/vo/officerneedshelp.wav");
Clockwork.voices:Add("Combine", "Privacy", "Possible level three civil privacy violator here!", "npc/metropolice/vo/possiblelevel3civilprivacyviolator.wav");
Clockwork.voices:Add("Combine", "Judgement", "Suspect prepare to receive civil judgement!", "npc/metropolice/vo/prepareforjudgement.wav");
Clockwork.voices:Add("Combine", "Priority Two", "I have a priority two anti-citizen here!", "npc/metropolice/vo/priority2anticitizenhere.wav");
Clockwork.voices:Add("Combine", "Prosecute", "Prosecute!", "npc/metropolice/vo/prosecute.wav");
Clockwork.voices:Add("Combine", "Amputate Ready", "Ready to amputate!", "npc/metropolice/vo/readytoamputate.wav");
Clockwork.voices:Add("Combine", "Rodger That", "Rodger that!", "npc/metropolice/vo/rodgerthat.wav");
Clockwork.voices:Add("Combine", "Search", "Search!", "npc/metropolice/vo/search.wav");
Clockwork.voices:Add("Combine", "Shit", "Shit!", "npc/metropolice/vo/shit.wav");
Clockwork.voices:Add("Combine", "Sentence Delivered", "Sentence delivered.", "npc/metropolice/vo/sentencedelivered.wav");
Clockwork.voices:Add("Combine", "Sterilize", "Sterilize!", "npc/metropolice/vo/sterilize.wav");
Clockwork.voices:Add("Combine", "Take Cover", "Take cover!", "npc/metropolice/vo/takecover.wav");
Clockwork.voices:Add("Combine", "Restrict", "Restrict!", "npc/metropolice/vo/restrict.wav");
Clockwork.voices:Add("Combine", "Restricted", "Restricted block.", "npc/metropolice/vo/restrictedblock.wav");
Clockwork.voices:Add("Combine", "Second Warning", "This is your second warning!", "npc/metropolice/vo/thisisyoursecondwarning.wav");
Clockwork.voices:Add("Combine", "Verdict", "You want a non-compliance verdict?", "npc/metropolice/vo/youwantamalcomplianceverdict.wav");
Clockwork.voices:Add("Combine", "Backup", "Backup!", "npc/metropolice/vo/backup.wav");
Clockwork.voices:Add("Combine", "Apply", "Apply.", "npc/metropolice/vo/apply.wav");
Clockwork.voices:Add("Combine", "Restriction", "Terminal restriction zone.", "npc/metropolice/vo/terminalrestrictionzone.wav");
Clockwork.voices:Add("Combine", "Complete", "Protection complete.", "npc/metropolice/vo/protectioncomplete.wav");
Clockwork.voices:Add("Combine", "Location Unknown", "Suspect location unknown.", "npc/metropolice/vo/suspectlocationunknown.wav");
Clockwork.voices:Add("Combine", "Can 1", "Pick up that can.", "npc/metropolice/vo/pickupthecan1.wav");
Clockwork.voices:Add("Combine", "Can 2", "Pick... up... the can.", "npc/metropolice/vo/pickupthecan2.wav");
Clockwork.voices:Add("Combine", "Wrap It", "That's it, wrap it up.", "npc/combine_soldier/vo/thatsitwrapitup.wav");
Clockwork.voices:Add("Combine", "Can 3", "I said pickup the can!", "npc/metropolice/vo/pickupthecan3.wav");
Clockwork.voices:Add("Combine", "Can 4", "Now, put it in the trash can.", "npc/metropolice/vo/putitinthetrash1.wav");
Clockwork.voices:Add("Combine", "Can 5", "I said put it in the trash can!", "npc/metropolice/vo/putitinthetrash2.wav");
Clockwork.voices:Add("Combine", "Now Get Out", "Now get out of here!", "npc/metropolice/vo/nowgetoutofhere.wav");
Clockwork.voices:Add("Combine", "Haha", "Haha.", "npc/metropolice/vo/chuckle.wav");
Clockwork.voices:Add("Combine", "X-Ray", "X-Ray!", "npc/metropolice/vo/xray.wav");
Clockwork.voices:Add("Combine", "Patrol", "Patrol!", "npc/metropolice/vo/patrol.wav");
Clockwork.voices:Add("Combine", "Serve", "Serve.", "npc/metropolice/vo/serve.wav");
Clockwork.voices:Add("Combine", "Knocked Over", "You knocked it over, pick it up!", "npc/metropolice/vo/youknockeditover.wav");
Clockwork.voices:Add("Combine", "Watch It", "Watch it!", "npc/metropolice/vo/watchit.wav");
Clockwork.voices:Add("Combine", "Restricted Canals", "Suspect is using restricted canals at...", "npc/metropolice/vo/suspectusingrestrictedcanals.wav");
Clockwork.voices:Add("Combine", "505", "Subject is five-oh-five!", "npc/metropolice/vo/subjectis505.wav");
Clockwork.voices:Add("Combine", "404", "Possible four-zero-oh here!", "npc/metropolice/vo/possible404here.wav");
Clockwork.voices:Add("Combine", "Vacate", "Vacate citizen!", "npc/metropolice/vo/vacatecitizen.wav");
Clockwork.voices:Add("Combine", "Escapee", "Priority two escapee.", "npc/combine_soldier/vo/prioritytwoescapee.wav");
Clockwork.voices:Add("Combine", "Objective", "Priority one objective.", "npc/combine_soldier/vo/priority1objective.wav");
Clockwork.voices:Add("Combine", "Payback", "Payback.", "npc/combine_soldier/vo/payback.wav");
Clockwork.voices:Add("Combine", "Got Him Now", "Affirmative, we got him now.", "npc/combine_soldier/vo/affirmativewegothimnow.wav");
Clockwork.voices:Add("Combine", "Antiseptic", "Antiseptic.", "npc/combine_soldier/vo/antiseptic.wav");
Clockwork.voices:Add("Combine", "Cleaned", "Cleaned.", "npc/combine_soldier/vo/cleaned.wav");
Clockwork.voices:Add("Combine", "Engaged Cleanup", "Engaged in cleanup.", "npc/combine_soldier/vo/engagedincleanup.wav");
Clockwork.voices:Add("Combine", "Engaging", "Engaging.", "npc/combine_soldier/vo/engaging.wav");
Clockwork.voices:Add("Combine", "Full Response", "Executing full response.", "npc/combine_soldier/vo/executingfullresponse.wav");
Clockwork.voices:Add("Combine", "Heavy Resistance", "Overwatch advise, we have heavy resistance.", "npc/combine_soldier/vo/heavyresistance.wav");
Clockwork.voices:Add("Combine", "Inbound", "Inbound.", "npc/combine_soldier/vo/inbound.wav");
Clockwork.voices:Add("Combine", "Lost Contact", "Lost contact!", "npc/combine_soldier/vo/lostcontact.wav");
Clockwork.voices:Add("Combine", "Move In", "Move in!", "npc/combine_soldier/vo/movein.wav");
Clockwork.voices:Add("Combine", "Harden Position", "Harden that position!", "npc/combine_soldier/vo/hardenthatposition.wav");
Clockwork.voices:Add("Combine", "Go Sharp", "Go sharp, go sharp!", "npc/combine_soldier/vo/gosharpgosharp.wav");
Clockwork.voices:Add("Combine", "Delivered", "Delivered.", "npc/combine_soldier/vo/delivered.wav");
Clockwork.voices:Add("Combine", "Necrotics Inbound", "Necrotics, inbound!", "npc/combine_soldier/vo/necroticsinbound.wav");
Clockwork.voices:Add("Combine", "Necrotics", "Necrotics.", "npc/combine_soldier/vo/necrotics.wav");
Clockwork.voices:Add("Combine", "Outbreak", "Outbreak!", "npc/combine_soldier/vo/outbreak.wav");
Clockwork.voices:Add("Combine", "Copy That", "Copy that.", "npc/combine_soldier/vo/copythat.wav");
Clockwork.voices:Add("Combine", "Outbreak Status", "Outbreak status is code.", "npc/combine_soldier/vo/outbreakstatusiscode.wav");
Clockwork.voices:Add("Combine", "Overwatch", "Overwatch!", "npc/combine_soldier/vo/overwatch.wav");
Clockwork.voices:Add("Combine", "Preserve", "Preserve!", "npc/metropolice/vo/preserve.wav");
Clockwork.voices:Add("Combine", "Pressure", "Pressure!", "npc/metropolice/vo/pressure.wav");
Clockwork.voices:Add("Combine", "Phantom", "Phantom!", "npc/combine_soldier/vo/phantom.wav");
Clockwork.voices:Add("Combine", "Stinger", "Stinger!", "npc/combine_soldier/vo/stinger.wav");
Clockwork.voices:Add("Combine", "Shadow", "Shadow!", "npc/combine_soldier/vo/shadow.wav");
Clockwork.voices:Add("Combine", "Savage", "Savage!", "npc/combine_soldier/vo/savage.wav");
Clockwork.voices:Add("Combine", "Reaper", "Reaper!", "npc/combine_soldier/vo/reaper.wav");
Clockwork.voices:Add("Combine", "Victor", "Victor!", "npc/metropolice/vo/victor.wav");
Clockwork.voices:Add("Combine", "Sector", "Sector!", "npc/metropolice/vo/sector.wav");
Clockwork.voices:Add("Combine", "Inject", "Inject!", "npc/metropolice/vo/inject.wav");
Clockwork.voices:Add("Combine", "Dagger", "Dagger!", "npc/combine_soldier/vo/dagger.wav");
Clockwork.voices:Add("Combine", "Blade", "Blade!", "npc/combine_soldier/vo/blade.wav");
Clockwork.voices:Add("Combine", "Razor", "Razor!", "npc/combine_soldier/vo/razor.wav");
Clockwork.voices:Add("Combine", "Nomad", "Nomad!", "npc/combine_soldier/vo/nomad.wav");
Clockwork.voices:Add("Combine", "Judge", "Judge!", "npc/combine_soldier/vo/judge.wav");
Clockwork.voices:Add("Combine", "Ghost", "Ghost!", "npc/combine_soldier/vo/ghost.wav");
Clockwork.voices:Add("Combine", "Sword", "Sword!", "npc/combine_soldier/vo/sword.wav");
Clockwork.voices:Add("Combine", "Union", "Union!", "npc/metropolice/vo/union.wav");
Clockwork.voices:Add("Combine", "Helix", "Helix!", "npc/combine_soldier/vo/helix.wav");
Clockwork.voices:Add("Combine", "Storm", "Storm!", "npc/combine_soldier/vo/storm.wav");
Clockwork.voices:Add("Combine", "Spear", "Spear!", "npc/combine_soldier/vo/spear.wav");
Clockwork.voices:Add("Combine", "Vamp", "Vamp!", "npc/combine_soldier/vo/vamp.wav");
Clockwork.voices:Add("Combine", "Nova", "Nova!", "npc/combine_soldier/vo/nova.wav");
Clockwork.voices:Add("Combine", "Mace", "Mace!", "npc/combine_soldier/vo/mace.wav");
Clockwork.voices:Add("Combine", "Grid", "Grid!", "npc/combine_soldier/vo/grid.wav");
Clockwork.voices:Add("Combine", "Kilo", "Kilo!", "npc/combine_soldier/vo/kilo.wav");
Clockwork.voices:Add("Combine", "Echo", "Echo!", "npc/combine_soldier/vo/echo.wav");
Clockwork.voices:Add("Combine", "Dash", "Dash!", "npc/combine_soldier/vo/dash.wav");
Clockwork.voices:Add("Combine", "Apex", "Apex!", "npc/combine_soldier/vo/apex.wav");
Clockwork.voices:Add("Combine", "Jury", "Jury!", "npc/metropolice/vo/jury.wav");
Clockwork.voices:Add("Combine", "King", "King!", "npc/metropolice/vo/king.wav");
Clockwork.voices:Add("Combine", "Lock", "Lock!", "npc/metropolice/vo/lock.wav");
Clockwork.voices:Add("Combine", "Vice", "Vice!", "npc/metropolice/vo/vice.wav");
Clockwork.voices:Add("Combine", "Zero", "Zero!", "npc/metropolice/vo/zero.wav");
Clockwork.voices:Add("Combine", "Zone", "Zone!", "npc/metropolice/vo/zone.wav");

Clockwork.voices:Add("Vortigaunt", "Accept Charge", "Accept the charge.", "vo/npc/vortigaunt/acceptcharge.wav");
Clockwork.voices:Add("Vortigaunt", "Accompany", "Gladly we accompany.", "vo/npc/vortigaunt/accompany.wav");
Clockwork.voices:Add("Vortigaunt", "Affirmed", "Affirmed.", "vo/npc/vortigaunt/affirmed.wav");
Clockwork.voices:Add("Vortigaunt", "All For Now", "That is all for now.", "vo/npc/vortigaunt/allfornow.wav");
Clockwork.voices:Add("Vortigaunt", "Allow Me", "Allow me.", "vo/npc/vortigaunt/allowme.wav");
Clockwork.voices:Add("Vortigaunt", "As You Wish", "As you wish.", "vo/npc/vortigaunt/asyouwish.wav");
Clockwork.voices:Add("Vortigaunt", "Believe The Opposite", "We believe the opposite.", "vo/npc/vortigaunt/vanswer03.wav");
Clockwork.voices:Add("Vortigaunt", "By Our Honor", "By our honor.", "vo/npc/vortigaunt/ourhonor.wav");
Clockwork.voices:Add("Vortigaunt", "Calm", "Caaaalm yourself.", "vo/npc/vortigaunt/calm.wav");
Clockwork.voices:Add("Vortigaunt", "Caution", "Caution!", "vo/npc/vortigaunt/caution.wav");
Clockwork.voices:Add("Vortigaunt", "Certainly", "Certainly.", "vo/npc/vortigaunt/certainly.wav");
Clockwork.voices:Add("Vortigaunt", "Concern", "Your concern is touching.", "vo/npc/vortigaunt/vanswer07.wav");
Clockwork.voices:Add("Vortigaunt", "Delay", "Is there reason for delay?", "vo/npc/vortigaunt/reasondelay.wav");
Clockwork.voices:Add("Vortigaunt", "Done", "Done.", "vo/npc/vortigaunt/done.wav");
Clockwork.voices:Add("Vortigaunt", "Dreamed", "We have dreamed of this moment.", "vo/npc/vortigaunt/dreamed.wav");
Clockwork.voices:Add("Vortigaunt", "Empower Us", "Empower us!", "vo/npc/vortigaunt/empowerus.wav");
Clockwork.voices:Add("Vortigaunt", "Expected", "We expected this much.", "vo/npc/vortigaunt/vanswer05.wav");
Clockwork.voices:Add("Vortigaunt", "Failed You", "We fear we have failed you.", "vo/npc/vortigaunt/fearfailed.wav");
Clockwork.voices:Add("Vortigaunt", "For Freedom", "For freedom!", "vo/npc/vortigaunt/forfreedom.wav");
Clockwork.voices:Add("Vortigaunt", "Forward", "Forward!", "vo/npc/vortigaunt/forward.wav");
Clockwork.voices:Add("Vortigaunt", "Gladly", "Gladly.", "vo/npc/vortigaunt/gladly.wav");
Clockwork.voices:Add("Vortigaunt", "Halt", "Halt.", "vo/npc/vortigaunt/halt.wav");
Clockwork.voices:Add("Vortigaunt", "Here", "Here.", "vo/npc/vortigaunt/here.wav");
Clockwork.voices:Add("Vortigaunt", "Hold", "Hold.", "vo/npc/vortigaunt/hold.wav");
Clockwork.voices:Add("Vortigaunt", "Hold Still", "Hold still.", "vo/npc/vortigaunt/holdstill.wav");
Clockwork.voices:Add("Vortigaunt", "Hope", "Hope is in sight.", "vo/npc/vortigaunt/vques03.wav");
Clockwork.voices:Add("Vortigaunt", "Hopeless", "Our cause seems hopeless.", "vo/npc/vortigaunt/hopeless.wav");
Clockwork.voices:Add("Vortigaunt", "Honor", "It is an honor.", "vo/npc/vortigaunt/honor.wav");
Clockwork.voices:Add("Vortigaunt", "Honored", "We are honored.", "vo/npc/vortigaunt/wehonored.wav");
Clockwork.voices:Add("Vortigaunt", "Honor Is Ours", "The honor is ours.", "vo/npc/vortigaunt/honourours.wav");
Clockwork.voices:Add("Vortigaunt", "Illusions", "You are not the first to harbor such illusions.", "vo/npc/vortigaunt/vanswer02.wav");
Clockwork.voices:Add("Vortigaunt", "Know You", "We know you.", "vo/npc/vortigaunt/weknowyou.wav");
Clockwork.voices:Add("Vortigaunt", "Lead On", "Lead on.", "vo/npc/vortigaunt/leadon.wav");
Clockwork.voices:Add("Vortigaunt", "Lead Us", "Lead us.", "vo/npc/vortigaunt/leadus.wav");
Clockwork.voices:Add("Vortigaunt", "Live To Serve", "We live to serve.", "vo/npc/vortigaunt/livetoserve.wav");
Clockwork.voices:Add("Vortigaunt", "Lost All Dear", "We have lost all dear to us.", "vo/npc/vortigaunt/alldear.wav");
Clockwork.voices:Add("Vortigaunt", "Mutual", "Our purpose is mutual.", "vo/npc/vortigaunt/mutual.wav");
Clockwork.voices:Add("Vortigaunt", "Mutual Feeling", "The feeling is mutual.", "vo/npc/vortigaunt/vanswer16.wav");
Clockwork.voices:Add("Vortigaunt", "Mystery", "We serve the same mystery.", "vo/npc/vortigaunt/mystery.wav");
Clockwork.voices:Add("Vortigaunt", "Onward", "Onward!", "vo/npc/vortigaunt/onward.wav");
Clockwork.voices:Add("Vortigaunt", "Opaque", "Your mind is opaque.", "vo/npc/vortigaunt/opaque.wav");
Clockwork.voices:Add("Vortigaunt", "Our Place", "Our place is here.", "vo/npc/vortigaunt/.wav");
Clockwork.voices:Add("Vortigaunt", "Pleasure", "With pleasure...", "vo/npc/vortigaunt/pleasure.wav");
Clockwork.voices:Add("Vortigaunt", "Prevail", "We shall prevail.", "vo/npc/vortigaunt/prevail.wav");
Clockwork.voices:Add("Vortigaunt", "Regrettable", "This is regrettable.", "vo/npc/vortigaunt/regrettable.wav");
Clockwork.voices:Add("Vortigaunt", "Stand Clear", "Stand clear!", "vo/npc/vortigaunt/standclear.wav");
Clockwork.voices:Add("Vortigaunt", "Still Here", "We are still here.", "vo/npc/vortigaunt/stillhere.wav");
Clockwork.voices:Add("Vortigaunt", "Survived 1", "We have survived darker times.", "vo/npc/vortigaunt/vques06.wav");
Clockwork.voices:Add("Vortigaunt", "Survived 2", "We have survived worse across the ages.", "vo/npc/vortigaunt/seenworse.wav");
Clockwork.voices:Add("Vortigaunt", "That Is All", "That is all.", "vo/npc/vortigaunt/thatisall.wav");
Clockwork.voices:Add("Vortigaunt", "This Body", "This body is yours to command.", "vo/npc/vortigaunt/bodyyours.wav");
Clockwork.voices:Add("Vortigaunt", "To The Void", "To the void with you!", "vo/npc/vortigaunt/tothevoid.wav");
Clockwork.voices:Add("Vortigaunt", "Trouble No More", "That one shall trouble us no more.", "vo/npc/vortigaunt/troubleus.wav");
Clockwork.voices:Add("Vortigaunt", "Turning Point", "This marks a turning point.", "vo/npc/vortigaunt/vques04.wav");
Clockwork.voices:Add("Vortigaunt", "Unconvinced", "We remain unconvinced.", "vo/npc/vortigaunt/vanswer01.wav");
Clockwork.voices:Add("Vortigaunt", "V1", "Ah'Glaa.", "vo/npc/vortigaunt/vortigese02.wav");
Clockwork.voices:Add("Vortigaunt", "V2", "Tahh.", "vo/npc/vortigaunt/vortigese03.wav");
Clockwork.voices:Add("Vortigaunt", "V3", "Dew'it.", "vo/npc/vortigaunt/vortigese04.wav");
Clockwork.voices:Add("Vortigaunt", "V4", "Langh.", "vo/npc/vortigaunt/vortigese05.wav");
Clockwork.voices:Add("Vortigaunt", "V5", "Gangh.", "vo/npc/vortigaunt/vortigese07.wav");
Clockwork.voices:Add("Vortigaunt", "V6", "Gulanga!", "vo/npc/vortigaunt/vortigese08.wav");
Clockwork.voices:Add("Vortigaunt", "V7", "Gallah'lung.", "vo/npc/vortigaunt/vortigese09.wav");
Clockwork.voices:Add("Vortigaunt", "V8", "Gerr, galling gerr a'la gam.", "vo/npc/vortigaunt/vortigese11.wav");
Clockwork.voices:Add("Vortigaunt", "V9", "Gerr, lung'gung. Jella'gerr.", "vo/npc/vortigaunt/vortigese12.wav");
Clockwork.voices:Add("Vortigaunt", "We Assure", "Likewise, we assure.", "vo/npc/vortigaunt/vanswer15.wav");
Clockwork.voices:Add("Vortigaunt", "We Can Spare", "That is all we can spare.", "vo/npc/vortigaunt/allwecanspare.wav");
Clockwork.voices:Add("Vortigaunt", "We Stay", "Here we stay.", "vo/npc/vortigaunt/herewestay.wav");
Clockwork.voices:Add("Vortigaunt", "We Will Help", "We will help you.", "vo/npc/vortigaunt/wewillhelp.wav");
Clockwork.voices:Add("Vortigaunt", "Where To", "Where to now? And to what end?", "vo/npc/vortigaunt/whereto.wav");
Clockwork.voices:Add("Vortigaunt", "Wish Right", "We wish you are right.", "vo/npc/vortigaunt/vanswer12.wav");
Clockwork.voices:Add("Vortigaunt", "Worthless", "Our life is worthless, unless spent on freedom.", "vo/npc/vortigaunt/worthless.wav");
Clockwork.voices:Add("Vortigaunt", "Yes", "Yessss.", "vo/npc/vortigaunt/yes.wav");
Clockwork.voices:Add("Vortigaunt", "Yes forward", "Yes, forward.", "vo/npc/vortigaunt/yesforward.wav");

Clockwork.voices:Add("Human_Female", "ALMOST MADE SENSE", "That... almost made sense", "vo/npc/female01/vanswer09.wav")
Clockwork.voices:Add("Human_Female", "ATE SOMETHING BAD", "I think I ate something bad", "vo/npc/female01/question27.wav")
Clockwork.voices:Add("Human_Female", "BAD MEMORY", "Someday, this will all be a bad memory", "vo/npc/female01/question20.wav")
Clockwork.voices:Add("Human_Female", "BEHIND YOU", "Behind you", {"vo/npc/female01/behindyou01.wav", "vo/npc/female01/behindyou01.wav"})
Clockwork.voices:Add("Human_Female", "BETTER MYSELF", "Couldn't have put it better myself", "vo/npc/female01/vanswer08.wav")
Clockwork.voices:Add("Human_Female", "BETTING MAN", "I'm not a betting man... but the odds are not good", "vo/npc/female01/question21.wav")
Clockwork.voices:Add("Human_Female", "BULLSHIT", "This is bullshit", "vo/npc/female01/question26.wav")
Clockwork.voices:Add("Human_Female", "CHANGE IS IN THE AIR", "Finally change is in the air", "vo/npc/female01/question16.wav")
Clockwork.voices:Add("Human_Female", "CIVIL PROTECTION", "Civil Protection", "vo/npc/female01/civilprotection01.wav")
--Clockwork.voices:Add("Human_Female", "COMBINE", "Combine", {"vo/npc/female01/combine01.wav", "vo/npc/female01/combine01.wav"})
Clockwork.voices:Add("Human_Female", "COMING IN HERE", "They're definitely coming in here", "vo/trainyard/female01/cit_window_use02.wav")
Clockwork.voices:Add("Human_Female", "CONCENTRATE ON THE TASK", "L-let's concentrate on the task at hand", "vo/npc/female01/answer18.wav")
Clockwork.voices:Add("Human_Female", "CPS", "CP's", "vo/npc/female01/cps01.wav")
Clockwork.voices:Add("Human_Female", "DARE SAY", "If you dare say - that's gotta hurt - I'll kill you", "vo/npc/female01/gordead_ans07.wav")
Clockwork.voices:Add("Human_Female", "DECENT MEAL", "I don't know about you, but I'm ready to join Civil Protection just to get a decent meal", "vo/trainyard/female01/cit_foodline04.wav")
Clockwork.voices:Add("Human_Female", "DEJA VU", "Woah, Déjà vu", "vo/npc/female01/question05.wav")
Clockwork.voices:Add("Human_Female", "DESERVE THIS", "What did I do to deserve this", "vo/npc/female01/vanswer14.wav")
Clockwork.voices:Add("Human_Female", "DO NICELY", "This'll do nicely", "vo/npc/female01/thislldonicely01.wav")
Clockwork.voices:Add("Human_Female", "DOESN'T LOOK GOOD", "This doesn't look good", "vo/trainyard/female01/cit_window_use01.wav")
Clockwork.voices:Add("Human_Female", "DOING SOMETHING", "Shouldn't we be... doing something", "vo/npc/female01/doingsomething.wav")
Clockwork.voices:Add("Human_Female", "DON'T BE SO SURE", "Don't be so sure of that", "vo/npc/female01/answer21.wav")
Clockwork.voices:Add("Human_Female", "DON'T DREAM", "I don't dream anymore", "vo/npc/female01/question03.wav")
Clockwork.voices:Add("Human_Female", "DON'T FEEL ANYTHING", "I don't feel anything, anymore", "vo/npc/female01/question18.wav")
Clockwork.voices:Add("Human_Female", "DON'T TELL ME", "Don't tell me", "vo/npc/female01/gordead_ans03.wav")
Clockwork.voices:Add("Human_Female", "DONE FOR", "We're done for", "vo/npc/female01/gordead_ans14.wav")
Clockwork.voices:Add("Human_Female", "DONE THIS BEFORE", "He's done this before, he'll be okay", "vo/npc/female01/gordead_ans18.wav")
Clockwork.voices:Add("Human_Female", "DWELL ON IT", "Try not to dwell on it", "vo/npc/female01/answer04.wav")
Clockwork.voices:Add("Human_Female", "EAT A HORSE", "I could eat a horse, hooves and all", "vo/npc/female01/question09.wav")
Clockwork.voices:Add("Human_Female", "END LIKE THIS", "It's not supposed to end like this", "vo/npc/female01/gordead_ques14.wav")
Clockwork.voices:Add("Human_Female", "ENDED UP WITH YOU", "Sometimes, I wonder how I ended up with you", "vo/npc/female01/vquestion04.wav")
Clockwork.voices:Add("Human_Female", "EXCUSE ME", "Excuse me", "vo/npc/female01/excuseme02.wav")
Clockwork.voices:Add("Human_Female", "FANTASTIC", "Fan-tastic", "vo/npc/female01/fantastic01.wav")
Clockwork.voices:Add("Human_Female", "FEEL IT", "Do you feel it? I feel it", "vo/npc/female01/question17.wav")
Clockwork.voices:Add("Human_Female", "FIGURES", "Figures", "vo/npc/female01/answer03.wav")
Clockwork.voices:Add("Human_Female", "FINALLY", "Finally", "vo/npc/female01/finally.wav")
Clockwork.voices:Add("Human_Female", "FINALLY COME", "I can't believe this day has finally come", "vo/npc/female01/question10.wav")
Clockwork.voices:Add("Human_Female", "FIRST TIME", "Wouldn't be the first time", "vo/npc/female01/answer36.wav")
Clockwork.voices:Add("Human_Female", "FIRST TIME FOR EVERYTHING", "There's a first time for everything", "vo/npc/female01/answer40.wav")
Clockwork.voices:Add("Human_Female", "FREEDOM", "You smell that? It's freedom", "vo/npc/female01/question07.wav")
Clockwork.voices:Add("Human_Female", "GET DOWN", "Get down", "vo/npc/female01/getdown02.wav")
Clockwork.voices:Add("Human_Female", "GET GOING", "Are we gonna get going, soon", "vo/npc/female01/getgoingsoon.wav")
Clockwork.voices:Add("Human_Female", "GET TO YOU", "Try not to let it get to you", "vo/npc/female01/answer35.wav")
Clockwork.voices:Add("Human_Female", "GET USED TO", "Some things I just... never get used to", "vo/npc/female01/vquestion02.wav")
Clockwork.voices:Add("Human_Female", "GOING SO WELL", "Things were going so well", "vo/npc/female01/gordead_ans02.wav")
Clockwork.voices:Add("Human_Female", "GONNA BE SICK", "I'm gonna be sick", "vo/npc/female01/gordead_ans19.wav")
Clockwork.voices:Add("Human_Female", "GONNA GET IT", "Oh no, now we're really gonna get it", "vo/trainyard/female01/cit_tvbust05.wav")
Clockwork.voices:Add("Human_Female", "GONNA MATE", "When this is all over, I'm gonna mate", "vo/npc/female01/question29.wav")
Clockwork.voices:Add("Human_Female", "GOOD GOD", "Good God", "vo/npc/female01/goodgod.wav")
Clockwork.voices:Add("Human_Female", "GOT IT", "You got it", "vo/npc/female01/yougotit02.wav")
Clockwork.voices:Add("Human_Female", "GOT ONE", "I Got one", "vo/npc/female01/gotone02.wav")
Clockwork.voices:Add("Human_Female", "GOT THAT FROM ME", "You got that from me", "vo/npc/female01/vanswer06.wav")
Clockwork.voices:Add("Human_Female", "GOTTA RELOAD", "Gotta reload", "vo/npc/female01/gottareload01.wav")
Clockwork.voices:Add("Human_Female", "GUNSHIP", "Gunship", "vo/npc/female01/gunship02.wav")
Clockwork.voices:Add("Human_Female", "GUT", "Pain Hit in the gut", "vo/npc/female01/hitingut01.wav")
Clockwork.voices:Add("Human_Female", "GUTTER", "Your mind is in the gutter", "vo/npc/female01/answer20.wav")
Clockwork.voices:Add("Human_Female", "HAWAII", "Don't forget Hawaii", "vo/npc/female01/answer34.wav")
Clockwork.voices:Add("Human_Female", "HEADCRABS", "Headcrabs", "vo/npc/female01/headcrabs01.wav")
Clockwork.voices:Add("Human_Female", "HEADS UP", "Heads up!", "vo/npc/female01/headsup02.wav")
Clockwork.voices:Add("Human_Female", "HELL OUT", "Get the hell, outta here", "vo/npc/female01/gethellout.wav")
Clockwork.voices:Add("Human_Female", "HELP YOU", "I'd like to help you, but it's out of the question", "vo/trainyard/female01/cit_pedestrian05.wav")
Clockwork.voices:Add("Human_Female", "HELP", "Help", "vo/npc/female01/help01.wav")
Clockwork.voices:Add("Human_Female", "HERE AMMO", "Here! Ammo", "vo/npc/female01/ammo03.wav")
Clockwork.voices:Add("Human_Female", "HERE COME THE HACKS", "Here come the hacks", "vo/npc/female01/herecomehacks01.wav")
Clockwork.voices:Add("Human_Female", "HERE THEY COME", "Here they come", "vo/npc/female01/heretheycome01.wav")
Clockwork.voices:Add("Human_Female", "HI", "Hi", "vo/npc/female01/hi01.wav")
Clockwork.voices:Add("Human_Female", "HOLD AGAINST", "I won't hold it against you", "vo/npc/female01/answer02.wav")
Clockwork.voices:Add("Human_Female", "HOW ABOUT THAT", "How 'bout that", "vo/npc/female01/answer25.wav")
Clockwork.voices:Add("Human_Female", "HUNGRY", "God, I'm hungry", "vo/npc/female01/question28.wav")
Clockwork.voices:Add("Human_Female", "I'M READY", "Okay, I'm ready", "vo/npc/female01/okimready01.wav")
Clockwork.voices:Add("Human_Female", "IM BUSY", "Can't you see I'm busy", "vo/npc/female01/busy02.wav")
Clockwork.voices:Add("Human_Female", "IM HURT", "I'm hurt", "vo/npc/female01/imhurt01.wav")
Clockwork.voices:Add("Human_Female", "INCOMING", "Incoming", "vo/npc/female01/incoming02.wav")
Clockwork.voices:Add("Human_Female", "KILLING ME", "Stop, you're killing me", "vo/npc/female01/vanswer13.wav")
Clockwork.voices:Add("Human_Female", "KNOW WHAT", "'Know what you mean", "vo/npc/female01/answer08.wav")
Clockwork.voices:Add("Human_Female", "LEAD THE WAY", "You lead the way", "vo/npc/female01/leadtheway01.wav")
Clockwork.voices:Add("Human_Female", "LEAVE IT ALONE", "Leave it alone", "vo/npc/female01/answer38.wav")
Clockwork.voices:Add("Human_Female", "LIKE THAT", "Hah, like that?", "vo/npc/female01/likethat.wav")
Clockwork.voices:Add("Human_Female", "LITTLE CORNER", "I've got my little corner and I'm sticking to it", "vo/npc/female01/littlecorner01.wav")
Clockwork.voices:Add("Human_Female", "LIVE MY LIFE", "If I could live my life over again...", "vo/npc/female01/question13.wav")
Clockwork.voices:Add("Human_Female", "LOOK OUT BELOW", "Look out below", "vo/npc/female01/cit_dropper04.wav")
Clockwork.voices:Add("Human_Female", "LOOK SUSPICIOUS", "Don't sit near me, it'll look suspicious", "vo/trainyard/female01/cit_bench03.wav")
Clockwork.voices:Add("Human_Female", "MATTER OF TIME", "It was just a matter of time", "vo/trainyard/female01/cit_window_use03.wav")
Clockwork.voices:Add("Human_Female", "MIND ON YOUR WORK", "Keep your mind on your work", "vo/npc/female01/answer19.wav")
Clockwork.voices:Add("Human_Female", "MOAN1", "Ugh... agh", "vo/npc/female01/moan01.wav")
Clockwork.voices:Add("Human_Female", "MOAN2", "Ugh... agh-hgh", "vo/npc/female01/moan02.wav")
Clockwork.voices:Add("Human_Female", "MOAN3", "Ugh...", "vo/npc/female01/moan03.wav")
Clockwork.voices:Add("Human_Female", "MOAN4", "Oghhh", "vo/npc/female01/moan04.wav")
Clockwork.voices:Add("Human_Female", "MOAN5", "Aaagh", "vo/npc/female01/moan05.wav")
Clockwork.voices:Add("Human_Female", "MORE INFORMATION", "That's more information than I require", "vo/npc/female01/answer26.wav")
Clockwork.voices:Add("Human_Female", "MUMBO JUMBO", "Enough of your mumbo-jumbo", "vo/npc/female01/vanswer01.wav")
Clockwork.voices:Add("Human_Female", "MY ARM", "Gagh, my arm", "vo/npc/female01/myarm02.wav")
Clockwork.voices:Add("Human_Female", "MY GUT", "Hgh, my gut", "vo/npc/female01/mygut02.wav")
Clockwork.voices:Add("Human_Female", "MY LEG", "Agh, my leg", "vo/npc/female01/myleg01.wav")
Clockwork.voices:Add("Human_Female", "NEIGHBOURHOOD", "Here goes the rest of the neighbourhood", "vo/trainyard/female01/cit_window_use04.wav")
Clockwork.voices:Add("Human_Female", "NEVER CAN TELL", "Never can tell", "vo/npc/female01/answer23.wav")
Clockwork.voices:Add("Human_Female", "NEVER GOING TO MAKE", "They're never going to make a stalker out of me", "vo/npc/female01/question15.wav")
Clockwork.voices:Add("Human_Female", "NEW IN TOWN", "New in town, aren't you", "vo/trainyard/female01/cit_pedestrian01.wav")
Clockwork.voices:Add("Human_Female", "NICE", "Nice", "vo/npc/female01/nice01.wav")
Clockwork.voices:Add("Human_Female", "NIP THAT KINDA TALK", "You should nip that kinda talk in the bud", "vo/npc/female01/answer31.wav")
Clockwork.voices:Add("Human_Female", "NO ARGUMENT", "No argument there", "vo/npc/female01/answer33.wav")
Clockwork.voices:Add("Human_Female", "NO KIDS", "I'm glad there's no kids around to see this", "vo/npc/female01/question30.wav")
Clockwork.voices:Add("Human_Female", "NOT GOING TO TELL", "I'm not even going to tell you what that reminds me of", "vo/npc/female01/question14.wav")
Clockwork.voices:Add("Human_Female", "NOT OUT HERE", "I can't be seen talking to you, not out here", "vo/trainyard/female01/cit_bench02.wav")
Clockwork.voices:Add("Human_Female", "NOT SURE", "I'm not sure how to take that", "vo/npc/female01/vanswer03.wav")
Clockwork.voices:Add("Human_Female", "NOT THE MAN I THOUGHT", "You're not the man I thought you were", "vo/npc/female01/notthemanithought01.wav")
Clockwork.voices:Add("Human_Female", "NOW WHAT", "Now what?", "vo/npc/female01/gordead_ans01.wav")
Clockwork.voices:Add("Human_Female", "OH GOD", "Oh god", "vo/npc/female01/gordead_ans04.wav")
Clockwork.voices:Add("Human_Female", "OH NO", "Oh no", "vo/npc/female01/gordead_ans05.wav")
Clockwork.voices:Add("Human_Female", "OKAY", "Okay", "vo/npc/female01/ok01.wav")
Clockwork.voices:Add("Human_Female", "ONE OF THOSE DAYS", "I just knew it was going to be one of those days", "vo/npc/female01/question25.wav")
Clockwork.voices:Add("Human_Female", "ONE WAY", "That's... one way of looking at it", "vo/npc/female01/answer15.wav")
Clockwork.voices:Add("Human_Female", "ORIGINAL THOUGHT", "Have you ever had an original thought", "vo/npc/female01/answer16.wav")
Clockwork.voices:Add("Human_Female", "OUT OF YOUR WAY", "Lemme get out of your way", "vo/npc/female01/outofyourway02.wav")
Clockwork.voices:Add("Human_Female", "OVER HERE", "Over here", "vo/npc/female01/overhere01.wav")
Clockwork.voices:Add("Human_Female", "OVER THERE", "Over there", "vo/npc/female01/overthere01.wav")
Clockwork.voices:Add("Human_Female", "PAIN1", "Ow", "vo/npc/female01/ow01.wav")
Clockwork.voices:Add("Human_Female", "PAIN10", "Agh", "vo/npc/female01/pain09.wav")
Clockwork.voices:Add("Human_Female", "PAIN2", "Ugh", "vo/npc/female01/pain01.wav")
Clockwork.voices:Add("Human_Female", "PAIN3", "Ugh", "vo/npc/female01/pain02.wav")
Clockwork.voices:Add("Human_Female", "PAIN4", "Agh", "vo/npc/female01/pain03.wav")
Clockwork.voices:Add("Human_Female", "PAIN5", "Ugh", "vo/npc/female01/pain04.wav")
Clockwork.voices:Add("Human_Female", "PAIN6", "Hugh", "vo/npc/female01/pain05.wav")
Clockwork.voices:Add("Human_Female", "PAIN7", "Augh", "vo/npc/female01/pain06.wav")
Clockwork.voices:Add("Human_Female", "PAIN8", "Ugh", "vo/npc/female01/pain07.wav")
Clockwork.voices:Add("Human_Female", "PAIN9", "Ugh", "vo/npc/female01/pain08.wav")
Clockwork.voices:Add("Human_Female", "PARDON ME", "Pardon me", "vo/npc/female01/pardonme01.wav")
Clockwork.voices:Add("Human_Female", "PERSONALLY", "Should I take that personally", "vo/npc/female01/vanswer04.wav")
Clockwork.voices:Add("Human_Female", "PLEASE NO", "Please no", "vo/npc/female01/gordead_ans06.wav")
Clockwork.voices:Add("Human_Female", "PUT UP WITH YOU", "That's why we put up with you", "vo/npc/female01/vanswer07.wav")
Clockwork.voices:Add("Human_Female", "READY WHEN YOU ARE", "Ready when you are", "vo/npc/female01/readywhenyouare01.wav")
Clockwork.voices:Add("Human_Female", "RELOAD", "Cover me while I reload", "vo/npc/female01/coverwhilereload01.wav")
Clockwork.voices:Add("Human_Female", "RIGHT ON", "Right on", "vo/npc/female01/answer32.wav")
Clockwork.voices:Add("Human_Female", "RUN", "Run", "vo/npc/female01/strider_run.wav")
Clockwork.voices:Add("Human_Female", "RUN LIFE", "Run for your life", "vo/npc/female01/runforyourlife01.wav")
Clockwork.voices:Add("Human_Female", "SAME HERE", "Same here", "vo/npc/female01/answer07.wav")
Clockwork.voices:Add("Human_Female", "SCANNERS", "Scanners", "vo/npc/female01/scanners01.wav")
Clockwork.voices:Add("Human_Female", "SCARING THE PIDGEONS", "You're scaring off the pidgeons", "vo/trainyard/female01/cit_bench04.wav")
Clockwork.voices:Add("Human_Female", "SELL INSURANCE", "To think all I used to ever want to do was sell insurance", "vo/npc/female01/question02.wav")
Clockwork.voices:Add("Human_Female", "SHELLING", "They're shelling us", "vo/canals/female01/stn6_shellingus.wav")
Clockwork.voices:Add("Human_Female", "SHOWER", "I can't remember the last time I had a shower", "vo/npc/female01/question19.wav")
Clockwork.voices:Add("Human_Female", "SHUT UP2", "I'm not even going to tell you to shut up", "vo/npc/female01/answer17.wav")
Clockwork.voices:Add("Human_Female", "SORRY", "Sorry", "vo/npc/female01/sorry01.wav")
Clockwork.voices:Add("Human_Female", "SPEAK ENGLISH", "Speak English", "vo/npc/female01/vanswer05.wav")
Clockwork.voices:Add("Human_Female", "SPREAD THE WORD", "Spread the word", "vo/npc/female01/gordead_ans10.wav")
Clockwork.voices:Add("Human_Female", "STAY HERE", "I'll stay here", "vo/npc/female01/illstayhere01.wav")
Clockwork.voices:Add("Human_Female", "STICKING HERE", "I'm sticking here", "vo/npc/female01/imstickinghere01.wav")
Clockwork.voices:Add("Human_Female", "STOP LOOKING", "Stop looking at me like that", "vo/npc/female01/vquestion01.wav")
Clockwork.voices:Add("Human_Female", "STRIDER", "Strider", "vo/npc/female01/strider.wav")
Clockwork.voices:Add("Human_Female", "SUPPLIES", "Hey down there! Supplies", "vo/npc/female01/cit_dropper01.wav")
Clockwork.voices:Add("Human_Female", "SURE ABOUT THAT", "You sure about that", "vo/npc/female01/answer37.wav")
Clockwork.voices:Add("Human_Female", "TAKE COVER", "Take cover", "vo/npc/female01/takecover02.wav")
Clockwork.voices:Add("Human_Female", "TAKE MEDKIT", "Take this medkit", "vo/npc/female01/health03.wav")
Clockwork.voices:Add("Human_Female", "TALK ABOUT IT LATER", "Can't we talk about this later", "vo/npc/female01/answer05.wav")
Clockwork.voices:Add("Human_Female", "TALKING TO YOURSELF", "You're talking to yourself again", "vo/npc/female01/answer09.wav")
Clockwork.voices:Add("Human_Female", "THE POINT", "What's the point", "vo/npc/female01/gordead_ans12.wav")
Clockwork.voices:Add("Human_Female", "THE USE", "What's the use?", "vo/npc/female01/gordead_ans11.wav")
Clockwork.voices:Add("Human_Female", "THINKING ABOUT", "Doesn't bare thinking about", "vo/npc/female01/answer12.wav")
Clockwork.voices:Add("Human_Female", "THIS CAN'T BE", "This can't be", "vo/npc/female01/gordead_ques06.wav")
Clockwork.voices:Add("Human_Female", "THIS IS BAD", "This is bad", "vo/npc/female01/gordead_ques10.wav")
Clockwork.voices:Add("Human_Female", "THIS WAR", "I don't think this war is ever gonna end", "vo/npc/female01/question01.wav")
Clockwork.voices:Add("Human_Female", "THOUGHT ANGRY", "We thought you were here to help", "vo/npc/female01/heretohelp01.wav")
Clockwork.voices:Add("Human_Female", "THOUGHT SAD", "We thought you were here to help", "vo/npc/female01/heretohelp02.wav")
Clockwork.voices:Add("Human_Female", "TOMBSTONE", "I'll put it on your tombstone", "vo/npc/female01/answer11.wav")
Clockwork.voices:Add("Human_Female", "TOO LOUD", "I wouldn't say that too loud...", "vo/npc/female01/answer10.wav")
Clockwork.voices:Add("Human_Female", "TRUSTED", "We trusted you", "vo/npc/female01/wetrustedyou02.wav")
Clockwork.voices:Add("Human_Female", "TUNE", "I can't get this tune out of my head... Whistling", "vo/npc/female01/question23.wav")
Clockwork.voices:Add("Human_Female", "UNWANTED ATTENTION", "Stay back, you'll attract unwanted attention", "vo/trainyard/female01/cit_bench01.wav")
Clockwork.voices:Add("Human_Female", "WAIT IN LINE", "You gotta be damn hungry to wait in line for this crap", "vo/trainyard/female01/cit_foodline03.wav")
Clockwork.voices:Add("Human_Female", "WAITING FOR SOMEBODY", "You waiting for somebody", "vo/npc/female01/waitingsomebody.wav")
Clockwork.voices:Add("Human_Female", "WANNA BET", "Wanna bet", "vo/npc/female01/answer27.wav")
Clockwork.voices:Add("Human_Female", "WASN'T PART OF THE PLAN", "I'm pretty sure this wasn't part of the plan", "vo/npc/female01/question11.wav")
Clockwork.voices:Add("Human_Female", "WATCH OUT", "Watch out!", "vo/npc/female01/watchout.wav")
Clockwork.voices:Add("Human_Female", "WELL NOW WHAT", "Well... now what", "vo/npc/female01/gordead_ans15.wav")
Clockwork.voices:Add("Human_Female", "WHAT AM I SUPPOSED TO DO ABOUT IT", "What am I suppose to do about it", "vo/npc/female01/answer29.wav")
Clockwork.voices:Add("Human_Female", "WHAT I THINK", "Doesn't anyone care what I think", "vo/npc/female01/question22.wav")
Clockwork.voices:Add("Human_Female", "WHAT YOU'RE DOING", "Watch what you're doing", "vo/npc/female01/watchwhat.wav")
Clockwork.voices:Add("Human_Female", "WHO AM I KIDDING", "When this is all over... Who am I kidding", "vo/npc/female01/question04.wav")
Clockwork.voices:Add("Human_Female", "WHOOPS", "Whoops", "vo/npc/female01/whoops01.wav")
Clockwork.voices:Add("Human_Female", "WHY ARE YOU TELLING ME", "Why are you telling me", "vo/npc/female01/answer24.wav")
Clockwork.voices:Add("Human_Female", "WHY GO ON", "Why go on", "vo/npc/female01/gordead_ans13.wav")
Clockwork.voices:Add("Human_Female", "WISH I HAD A DIME", "I wish I had a dime for every time somebody said that", "vo/npc/female01/answer28.wav")
Clockwork.voices:Add("Human_Female", "WITH YOU", "I'm with you", "vo/npc/female01/answer13.wav")
Clockwork.voices:Add("Human_Female", "WORD TO THE WISE", "Word to the wise, keep it to yourself", "vo/trainyard/female01/cit_pedestrian02.wav")
Clockwork.voices:Add("Human_Female", "WORSE NOT BETTER", "Looks to me like things are getting worse, not better", "vo/npc/female01/question12.wav")
Clockwork.voices:Add("Human_Female", "YEAH", "Yeah", "vo/npc/female01/yeah02.wav")
Clockwork.voices:Add("Human_Female", "YOU ALL OVER", "That's you all over", "vo/npc/female01/answer01.wav")
Clockwork.voices:Add("Human_Female", "YOU AND ME BOTH", "Hah, you and me both", "vo/npc/female01/answer14.wav")
Clockwork.voices:Add("Human_Female", "YOU NEVER KNOW", "You never know", "vo/npc/female01/answer22.wav")
Clockwork.voices:Add("Human_Female", "YOU TALKING TO ME", "You talking to me", "vo/npc/female01/answer30.wav")
Clockwork.voices:Add("Human_Female", "ZOMBIES", "Zombies", "vo/npc/female01/zombies02.wav")
Clockwork.voices:Add("Human_Female", "ZOMBIES SCARED", "Zooombies", "vo/npc/female01/zombies01.wav")


Clockwork.voices:Add("Human_Male", "ALMOST MADE SENSE", "That... almost made sense", "vo/npc/male01/vanswer09.wav")
Clockwork.voices:Add("Human_Male", "ATE SOMETHING BAD", "I think I ate something bad", "vo/npc/male01/question27.wav")
Clockwork.voices:Add("Human_Male", "BAD MEMORY", "Someday, this will all be a bad memory", "vo/npc/male01/question20.wav")
Clockwork.voices:Add("Human_Male", "BEHIND YOU", "Behind you", {"vo/npc/male01/behindyou01.wav", "vo/npc/female01/behindyou01.wav"})
Clockwork.voices:Add("Human_Male", "BETTER MYSELF", "Couldn't have put it better myself", "vo/npc/male01/vanswer08.wav")
Clockwork.voices:Add("Human_Male", "BETTING MAN", "I'm not a betting man... but the odds are not good", "vo/npc/male01/question21.wav")
Clockwork.voices:Add("Human_Male", "BULLSHIT", "This is bullshit", "vo/npc/male01/question26.wav")
Clockwork.voices:Add("Human_Male", "CHANGE IS IN THE AIR", "Finally change is in the air", "vo/npc/male01/question16.wav")
Clockwork.voices:Add("Human_Male", "CIVIL PROTECTION", "Civil Protection", "vo/npc/male01/civilprotection01.wav")
--Clockwork.voices:Add("Human_Male", "COMBINE", "Combine", {"vo/npc/male01/combine01.wav", "vo/npc/female01/combine01.wav"})
Clockwork.voices:Add("Human_Male", "COMING IN HERE", "They're definitely coming in here", "vo/trainyard/male01/cit_window_use02.wav")
Clockwork.voices:Add("Human_Male", "CONCENTRATE ON THE TASK", "L-let's concentrate on the task at hand", "vo/npc/male01/answer18.wav")
Clockwork.voices:Add("Human_Male", "CPS", "CP's", "vo/npc/male01/cps01.wav")
Clockwork.voices:Add("Human_Male", "DARE SAY", "If you dare say - that's gotta hurt - I'll kill you", "vo/npc/male01/gordead_ans07.wav")
Clockwork.voices:Add("Human_Male", "DECENT MEAL", "I don't know about you, but I'm ready to join Civil Protection just to get a decent meal", "vo/trainyard/male01/cit_foodline04.wav")
Clockwork.voices:Add("Human_Male", "DEJA VU", "Woah, Déjà vu", "vo/npc/male01/question05.wav")
Clockwork.voices:Add("Human_Male", "DESERVE THIS", "What did I do to deserve this", "vo/npc/male01/vanswer14.wav")
Clockwork.voices:Add("Human_Male", "DO NICELY", "This'll do nicely", "vo/npc/male01/thislldonicely01.wav")
Clockwork.voices:Add("Human_Male", "DOESN'T LOOK GOOD", "This doesn't look good", "vo/trainyard/male01/cit_window_use01.wav")
Clockwork.voices:Add("Human_Male", "DOING SOMETHING", "Shouldn't we be... doing something", "vo/npc/male01/doingsomething.wav")
Clockwork.voices:Add("Human_Male", "DON'T BE SO SURE", "Don't be so sure of that", "vo/npc/male01/answer21.wav")
Clockwork.voices:Add("Human_Male", "DON'T DREAM", "I don't dream anymore", "vo/npc/male01/question03.wav")
Clockwork.voices:Add("Human_Male", "DON'T FEEL ANYTHING", "I don't feel anything, anymore", "vo/npc/male01/question18.wav")
Clockwork.voices:Add("Human_Male", "DON'T TELL ME", "Don't tell me", "vo/npc/male01/gordead_ans03.wav")
Clockwork.voices:Add("Human_Male", "DONE FOR", "We're done for", "vo/npc/male01/gordead_ans14.wav")
Clockwork.voices:Add("Human_Male", "DONE THIS BEFORE", "He's done this before, he'll be okay", "vo/npc/male01/gordead_ans18.wav")
Clockwork.voices:Add("Human_Male", "DWELL ON IT", "Try not to dwell on it", "vo/npc/male01/answer04.wav")
Clockwork.voices:Add("Human_Male", "EAT A HORSE", "I could eat a horse, hooves and all", "vo/npc/male01/question09.wav")
Clockwork.voices:Add("Human_Male", "END LIKE THIS", "It's not supposed to end like this", "vo/npc/male01/gordead_ques14.wav")
Clockwork.voices:Add("Human_Male", "ENDED UP WITH YOU", "Sometimes, I wonder how I ended up with you", "vo/npc/male01/vquestion04.wav")
Clockwork.voices:Add("Human_Male", "EXCUSE ME", "Excuse me", "vo/npc/male01/excuseme02.wav")
Clockwork.voices:Add("Human_Male", "FANTASTIC", "Fan-tastic", "vo/npc/male01/fantastic01.wav")
Clockwork.voices:Add("Human_Male", "FEEL IT", "Do you feel it? I feel it", "vo/npc/male01/question17.wav")
Clockwork.voices:Add("Human_Male", "FIGURES", "Figures", "vo/npc/male01/answer03.wav")
Clockwork.voices:Add("Human_Male", "FINALLY", "Finally", "vo/npc/male01/finally.wav")
Clockwork.voices:Add("Human_Male", "FINALLY COME", "I can't believe this day has finally come", "vo/npc/male01/question10.wav")
Clockwork.voices:Add("Human_Male", "FIRST TIME", "Wouldn't be the first time", "vo/npc/male01/answer36.wav")
Clockwork.voices:Add("Human_Male", "FIRST TIME FOR EVERYTHING", "There's a first time for everything", "vo/npc/male01/answer40.wav")
Clockwork.voices:Add("Human_Male", "FREEDOM", "You smell that? It's freedom", "vo/npc/male01/question07.wav")
Clockwork.voices:Add("Human_Male", "GET DOWN", "Get down", "vo/npc/male01/getdown02.wav")
Clockwork.voices:Add("Human_Male", "GET GOING", "Are we gonna get going, soon", "vo/npc/male01/getgoingsoon.wav")
Clockwork.voices:Add("Human_Male", "GET TO YOU", "Try not to let it get to you", "vo/npc/male01/answer35.wav")
Clockwork.voices:Add("Human_Male", "GET USED TO", "Some things I just... never get used to", "vo/npc/male01/vquestion02.wav")
Clockwork.voices:Add("Human_Male", "GOING SO WELL", "Things were going so well", "vo/npc/male01/gordead_ans02.wav")
Clockwork.voices:Add("Human_Male", "GONNA BE SICK", "I'm gonna be sick", "vo/npc/male01/gordead_ans19.wav")
Clockwork.voices:Add("Human_Male", "GONNA GET IT", "Oh no, now we're really gonna get it", "vo/trainyard/male01/cit_tvbust05.wav")
Clockwork.voices:Add("Human_Male", "GONNA MATE", "When this is all over, I'm gonna mate", "vo/npc/male01/question29.wav")
Clockwork.voices:Add("Human_Male", "GOOD GOD", "Good God", "vo/npc/male01/goodgod.wav")
Clockwork.voices:Add("Human_Male", "GOT IT", "You got it", "vo/npc/male01/yougotit02.wav")
Clockwork.voices:Add("Human_Male", "GOT ONE", "I Got one", "vo/npc/male01/gotone02.wav")
Clockwork.voices:Add("Human_Male", "GOT THAT FROM ME", "You got that from me", "vo/npc/male01/vanswer06.wav")
Clockwork.voices:Add("Human_Male", "GOTTA RELOAD", "Gotta reload", "vo/npc/male01/gottareload01.wav")
Clockwork.voices:Add("Human_Male", "GUNSHIP", "Gunship", "vo/npc/male01/gunship02.wav")
Clockwork.voices:Add("Human_Male", "GUT", "Pain Hit in the gut", "vo/npc/male01/hitingut01.wav")
Clockwork.voices:Add("Human_Male", "GUTTER", "Your mind is in the gutter", "vo/npc/male01/answer20.wav")
Clockwork.voices:Add("Human_Male", "HAWAII", "Don't forget Hawaii", "vo/npc/male01/answer34.wav")
Clockwork.voices:Add("Human_Male", "HEADCRABS", "Headcrabs", "vo/npc/male01/headcrabs01.wav")
Clockwork.voices:Add("Human_Male", "HEADS UP", "Heads up!", "vo/npc/male01/headsup02.wav")
Clockwork.voices:Add("Human_Male", "HELL OUT", "Get the hell, outta here", "vo/npc/male01/gethellout.wav")
Clockwork.voices:Add("Human_Male", "HELP YOU", "I'd like to help you, but it's out of the question", "vo/trainyard/male01/cit_pedestrian05.wav")
Clockwork.voices:Add("Human_Male", "HELP", "Help", "vo/npc/male01/help01.wav")
Clockwork.voices:Add("Human_Male", "HERE AMMO", "Here! Ammo", "vo/npc/male01/ammo03.wav")
Clockwork.voices:Add("Human_Male", "HERE COME THE HACKS", "Here come the hacks", "vo/npc/male01/herecomehacks01.wav")
Clockwork.voices:Add("Human_Male", "HERE THEY COME", "Here they come", "vo/npc/male01/heretheycome01.wav")
Clockwork.voices:Add("Human_Male", "HI", "Hi", "vo/npc/male01/hi01.wav")
Clockwork.voices:Add("Human_Male", "HOLD AGAINST", "I won't hold it against you", "vo/npc/male01/answer02.wav")
Clockwork.voices:Add("Human_Male", "HOW ABOUT THAT", "How 'bout that", "vo/npc/male01/answer25.wav")
Clockwork.voices:Add("Human_Male", "HUNGRY", "God, I'm hungry", "vo/npc/male01/question28.wav")
Clockwork.voices:Add("Human_Male", "I'M READY", "Okay, I'm ready", "vo/npc/male01/okimready01.wav")
Clockwork.voices:Add("Human_Male", "IM BUSY", "Can't you see I'm busy", "vo/npc/male01/busy02.wav")
Clockwork.voices:Add("Human_Male", "IM HURT", "I'm hurt", "vo/npc/male01/imhurt01.wav")
Clockwork.voices:Add("Human_Male", "INCOMING", "Incoming", "vo/npc/male01/incoming02.wav")
Clockwork.voices:Add("Human_Male", "KILLING ME", "Stop, you're killing me", "vo/npc/male01/vanswer13.wav")
Clockwork.voices:Add("Human_Male", "KNOW WHAT", "'Know what you mean", "vo/npc/male01/answer08.wav")
Clockwork.voices:Add("Human_Male", "LEAD THE WAY", "You lead the way", "vo/npc/male01/leadtheway01.wav")
Clockwork.voices:Add("Human_Male", "LEAVE IT ALONE", "Leave it alone", "vo/npc/male01/answer38.wav")
Clockwork.voices:Add("Human_Male", "LIKE THAT", "Hah, like that?", "vo/npc/male01/likethat.wav")
Clockwork.voices:Add("Human_Male", "LITTLE CORNER", "I've got my little corner and I'm sticking to it", "vo/npc/male01/littlecorner01.wav")
Clockwork.voices:Add("Human_Male", "LIVE MY LIFE", "If I could live my life over again...", "vo/npc/male01/question13.wav")
Clockwork.voices:Add("Human_Male", "LOOK OUT BELOW", "Look out below", "vo/npc/male01/cit_dropper04.wav")
Clockwork.voices:Add("Human_Male", "LOOK SUSPICIOUS", "Don't sit near me, it'll look suspicious", "vo/trainyard/male01/cit_bench03.wav")
Clockwork.voices:Add("Human_Male", "MATTER OF TIME", "It was just a matter of time", "vo/trainyard/male01/cit_window_use03.wav")
Clockwork.voices:Add("Human_Male", "MIND ON YOUR WORK", "Keep your mind on your work", "vo/npc/male01/answer19.wav")
Clockwork.voices:Add("Human_Male", "MOAN1", "Ugh... agh", "vo/npc/male01/moan01.wav")
Clockwork.voices:Add("Human_Male", "MOAN2", "Ugh... agh-hgh", "vo/npc/male01/moan02.wav")
Clockwork.voices:Add("Human_Male", "MOAN3", "Ugh...", "vo/npc/male01/moan03.wav")
Clockwork.voices:Add("Human_Male", "MOAN4", "Oghhh", "vo/npc/male01/moan04.wav")
Clockwork.voices:Add("Human_Male", "MOAN5", "Aaagh", "vo/npc/male01/moan05.wav")
Clockwork.voices:Add("Human_Male", "MORE INFORMATION", "That's more information than I require", "vo/npc/male01/answer26.wav")
Clockwork.voices:Add("Human_Male", "MUMBO JUMBO", "Enough of your mumbo-jumbo", "vo/npc/male01/vanswer01.wav")
Clockwork.voices:Add("Human_Male", "MY ARM", "Gagh, my arm", "vo/npc/male01/myarm02.wav")
Clockwork.voices:Add("Human_Male", "MY GUT", "Hgh, my gut", "vo/npc/male01/mygut02.wav")
Clockwork.voices:Add("Human_Male", "MY LEG", "Agh, my leg", "vo/npc/male01/myleg01.wav")
Clockwork.voices:Add("Human_Male", "NEIGHBOURHOOD", "Here goes the rest of the neighbourhood", "vo/trainyard/male01/cit_window_use04.wav")
Clockwork.voices:Add("Human_Male", "NEVER CAN TELL", "Never can tell", "vo/npc/male01/answer23.wav")
Clockwork.voices:Add("Human_Male", "NEVER GOING TO MAKE", "They're never going to make a stalker out of me", "vo/npc/male01/question15.wav")
Clockwork.voices:Add("Human_Male", "NEW IN TOWN", "New in town, aren't you", "vo/trainyard/male01/cit_pedestrian01.wav")
Clockwork.voices:Add("Human_Male", "NICE", "Nice", "vo/npc/male01/nice01.wav")
Clockwork.voices:Add("Human_Male", "NIP THAT KINDA TALK", "You should nip that kinda talk in the bud", "vo/npc/male01/answer31.wav")
Clockwork.voices:Add("Human_Male", "NO ARGUMENT", "No argument there", "vo/npc/male01/answer33.wav")
Clockwork.voices:Add("Human_Male", "NO KIDS", "I'm glad there's no kids around to see this", "vo/npc/male01/question30.wav")
Clockwork.voices:Add("Human_Male", "NOT GOING TO TELL", "I'm not even going to tell you what that reminds me of", "vo/npc/male01/question14.wav")
Clockwork.voices:Add("Human_Male", "NOT OUT HERE", "I can't be seen talking to you, not out here", "vo/trainyard/male01/cit_bench02.wav")
Clockwork.voices:Add("Human_Male", "NOT SURE", "I'm not sure how to take that", "vo/npc/male01/vanswer03.wav")
Clockwork.voices:Add("Human_Male", "NOT THE MAN I THOUGHT", "You're not the man I thought you were", "vo/npc/male01/notthemanithought01.wav")
Clockwork.voices:Add("Human_Male", "NOW WHAT", "Now what?", "vo/npc/male01/gordead_ans01.wav")
Clockwork.voices:Add("Human_Male", "OH GOD", "Oh god", "vo/npc/male01/gordead_ans04.wav")
Clockwork.voices:Add("Human_Male", "OH NO", "Oh no", "vo/npc/male01/gordead_ans05.wav")
Clockwork.voices:Add("Human_Male", "OKAY", "Okay", "vo/npc/male01/ok01.wav")
Clockwork.voices:Add("Human_Male", "ONE OF THOSE DAYS", "I just knew it was going to be one of those days", "vo/npc/male01/question25.wav")
Clockwork.voices:Add("Human_Male", "ONE WAY", "That's... one way of looking at it", "vo/npc/male01/answer15.wav")
Clockwork.voices:Add("Human_Male", "ORIGINAL THOUGHT", "Have you ever had an original thought", "vo/npc/male01/answer16.wav")
Clockwork.voices:Add("Human_Male", "OUT OF YOUR WAY", "Lemme get out of your way", "vo/npc/male01/outofyourway02.wav")
Clockwork.voices:Add("Human_Male", "OVER HERE", "Over here", "vo/npc/male01/overhere01.wav")
Clockwork.voices:Add("Human_Male", "OVER THERE", "Over there", "vo/npc/male01/overthere01.wav")
Clockwork.voices:Add("Human_Male", "PAIN1", "Ow", "vo/npc/male01/ow01.wav")
Clockwork.voices:Add("Human_Male", "PAIN10", "Agh", "vo/npc/male01/pain09.wav")
Clockwork.voices:Add("Human_Male", "PAIN2", "Ugh", "vo/npc/male01/pain01.wav")
Clockwork.voices:Add("Human_Male", "PAIN3", "Ugh", "vo/npc/male01/pain02.wav")
Clockwork.voices:Add("Human_Male", "PAIN4", "Agh", "vo/npc/male01/pain03.wav")
Clockwork.voices:Add("Human_Male", "PAIN5", "Ugh", "vo/npc/male01/pain04.wav")
Clockwork.voices:Add("Human_Male", "PAIN6", "Hugh", "vo/npc/male01/pain05.wav")
Clockwork.voices:Add("Human_Male", "PAIN7", "Augh", "vo/npc/male01/pain06.wav")
Clockwork.voices:Add("Human_Male", "PAIN8", "Ugh", "vo/npc/male01/pain07.wav")
Clockwork.voices:Add("Human_Male", "PAIN9", "Ugh", "vo/npc/male01/pain08.wav")
Clockwork.voices:Add("Human_Male", "PARDON ME", "Pardon me", "vo/npc/male01/pardonme01.wav")
Clockwork.voices:Add("Human_Male", "PERSONALLY", "Should I take that personally", "vo/npc/male01/vanswer04.wav")
Clockwork.voices:Add("Human_Male", "PLEASE NO", "Please no", "vo/npc/male01/gordead_ans06.wav")
Clockwork.voices:Add("Human_Male", "PUT UP WITH YOU", "That's why we put up with you", "vo/npc/male01/vanswer07.wav")
Clockwork.voices:Add("Human_Male", "READY WHEN YOU ARE", "Ready when you are", "vo/npc/male01/readywhenyouare01.wav")
Clockwork.voices:Add("Human_Male", "RELOAD", "Cover me while I reload", "vo/npc/male01/coverwhilereload01.wav")
Clockwork.voices:Add("Human_Male", "RIGHT ON", "Right on", "vo/npc/male01/answer32.wav")
Clockwork.voices:Add("Human_Male", "RUN", "Run", "vo/npc/male01/strider_run.wav")
Clockwork.voices:Add("Human_Male", "RUN LIFE", "Run for your life", "vo/npc/male01/runforyourlife01.wav")
Clockwork.voices:Add("Human_Male", "SAME HERE", "Same here", "vo/npc/male01/answer07.wav")
Clockwork.voices:Add("Human_Male", "SCANNERS", "Scanners", "vo/npc/male01/scanners01.wav")
Clockwork.voices:Add("Human_Male", "SCARING THE PIDGEONS", "You're scaring off the pidgeons", "vo/trainyard/male01/cit_bench04.wav")
Clockwork.voices:Add("Human_Male", "SELL INSURANCE", "To think all I used to ever want to do was sell insurance", "vo/npc/male01/question02.wav")
Clockwork.voices:Add("Human_Male", "SHELLING", "They're shelling us", "vo/canals/male01/stn6_shellingus.wav")
Clockwork.voices:Add("Human_Male", "SHOWER", "I can't remember the last time I had a shower", "vo/npc/male01/question19.wav")
Clockwork.voices:Add("Human_Male", "SHUT UP2", "I'm not even going to tell you to shut up", "vo/npc/male01/answer17.wav")
Clockwork.voices:Add("Human_Male", "SORRY", "Sorry", "vo/npc/male01/sorry01.wav")
Clockwork.voices:Add("Human_Male", "SPEAK ENGLISH", "Speak English", "vo/npc/male01/vanswer05.wav")
Clockwork.voices:Add("Human_Male", "SPREAD THE WORD", "Spread the word", "vo/npc/male01/gordead_ans10.wav")
Clockwork.voices:Add("Human_Male", "STAY HERE", "I'll stay here", "vo/npc/male01/illstayhere01.wav")
Clockwork.voices:Add("Human_Male", "STICKING HERE", "I'm sticking here", "vo/npc/male01/imstickinghere01.wav")
Clockwork.voices:Add("Human_Male", "STOP LOOKING", "Stop looking at me like that", "vo/npc/male01/vquestion01.wav")
Clockwork.voices:Add("Human_Male", "STRIDER", "Strider", "vo/npc/male01/strider.wav")
Clockwork.voices:Add("Human_Male", "SUPPLIES", "Hey down there! Supplies", "vo/npc/male01/cit_dropper01.wav")
Clockwork.voices:Add("Human_Male", "SURE ABOUT THAT", "You sure about that", "vo/npc/male01/answer37.wav")
Clockwork.voices:Add("Human_Male", "TAKE COVER", "Take cover", "vo/npc/male01/takecover02.wav")
Clockwork.voices:Add("Human_Male", "TAKE MEDKIT", "Take this medkit", "vo/npc/male01/health03.wav")
Clockwork.voices:Add("Human_Male", "TALK ABOUT IT LATER", "Can't we talk about this later", "vo/npc/male01/answer05.wav")
Clockwork.voices:Add("Human_Male", "TALKING TO YOURSELF", "You're talking to yourself again", "vo/npc/male01/answer09.wav")
Clockwork.voices:Add("Human_Male", "THE POINT", "What's the point", "vo/npc/male01/gordead_ans12.wav")
Clockwork.voices:Add("Human_Male", "THE USE", "What's the use?", "vo/npc/male01/gordead_ans11.wav")
Clockwork.voices:Add("Human_Male", "THINKING ABOUT", "Doesn't bare thinking about", "vo/npc/male01/answer12.wav")
Clockwork.voices:Add("Human_Male", "THIS CAN'T BE", "This can't be", "vo/npc/male01/gordead_ques06.wav")
Clockwork.voices:Add("Human_Male", "THIS IS BAD", "This is bad", "vo/npc/male01/gordead_ques10.wav")
Clockwork.voices:Add("Human_Male", "THIS WAR", "I don't think this war is ever gonna end", "vo/npc/male01/question01.wav")
Clockwork.voices:Add("Human_Male", "THOUGHT ANGRY", "We thought you were here to help", "vo/npc/male01/heretohelp01.wav")
Clockwork.voices:Add("Human_Male", "THOUGHT SAD", "We thought you were here to help", "vo/npc/male01/heretohelp02.wav")
Clockwork.voices:Add("Human_Male", "TOMBSTONE", "I'll put it on your tombstone", "vo/npc/male01/answer11.wav")
Clockwork.voices:Add("Human_Male", "TOO LOUD", "I wouldn't say that too loud...", "vo/npc/male01/answer10.wav")
Clockwork.voices:Add("Human_Male", "TRUSTED", "We trusted you", "vo/npc/male01/wetrustedyou02.wav")
Clockwork.voices:Add("Human_Male", "TUNE", "I can't get this tune out of my head... Whistling", "vo/npc/male01/question23.wav")
Clockwork.voices:Add("Human_Male", "UNWANTED ATTENTION", "Stay back, you'll attract unwanted attention", "vo/trainyard/male01/cit_bench01.wav")
Clockwork.voices:Add("Human_Male", "WAIT IN LINE", "You gotta be damn hungry to wait in line for this crap", "vo/trainyard/male01/cit_foodline03.wav")
Clockwork.voices:Add("Human_Male", "WAITING FOR SOMEBODY", "You waiting for somebody", "vo/npc/male01/waitingsomebody.wav")
Clockwork.voices:Add("Human_Male", "WANNA BET", "Wanna bet", "vo/npc/male01/answer27.wav")
Clockwork.voices:Add("Human_Male", "WASN'T PART OF THE PLAN", "I'm pretty sure this wasn't part of the plan", "vo/npc/male01/question11.wav")
Clockwork.voices:Add("Human_Male", "WATCH OUT", "Watch out!", "vo/npc/male01/watchout.wav")
Clockwork.voices:Add("Human_Male", "WELL NOW WHAT", "Well... now what", "vo/npc/male01/gordead_ans15.wav")
Clockwork.voices:Add("Human_Male", "WHAT AM I SUPPOSED TO DO ABOUT IT", "What am I suppose to do about it", "vo/npc/male01/answer29.wav")
Clockwork.voices:Add("Human_Male", "WHAT I THINK", "Doesn't anyone care what I think", "vo/npc/male01/question22.wav")
Clockwork.voices:Add("Human_Male", "WHAT YOU'RE DOING", "Watch what you're doing", "vo/npc/male01/watchwhat.wav")
Clockwork.voices:Add("Human_Male", "WHO AM I KIDDING", "When this is all over... Who am I kidding", "vo/npc/male01/question04.wav")
Clockwork.voices:Add("Human_Male", "WHOOPS", "Whoops", "vo/npc/male01/whoops01.wav")
Clockwork.voices:Add("Human_Male", "WHY ARE YOU TELLING ME", "Why are you telling me", "vo/npc/male01/answer24.wav")
Clockwork.voices:Add("Human_Male", "WHY GO ON", "Why go on", "vo/npc/male01/gordead_ans13.wav")
Clockwork.voices:Add("Human_Male", "WISH I HAD A DIME", "I wish I had a dime for every time somebody said that", "vo/npc/male01/answer28.wav")
Clockwork.voices:Add("Human_Male", "WITH YOU", "I'm with you", "vo/npc/male01/answer13.wav")
Clockwork.voices:Add("Human_Male", "WORD TO THE WISE", "Word to the wise, keep it to yourself", "vo/trainyard/male01/cit_pedestrian02.wav")
Clockwork.voices:Add("Human_Male", "WORSE NOT BETTER", "Looks to me like things are getting worse, not better", "vo/npc/male01/question12.wav")
Clockwork.voices:Add("Human_Male", "YEAH", "Yeah", "vo/npc/male01/yeah02.wav")
Clockwork.voices:Add("Human_Male", "YOU ALL OVER", "That's you all over", "vo/npc/male01/answer01.wav")
Clockwork.voices:Add("Human_Male", "YOU AND ME BOTH", "Hah, you and me both", "vo/npc/male01/answer14.wav")
Clockwork.voices:Add("Human_Male", "YOU NEVER KNOW", "You never know", "vo/npc/male01/answer22.wav")
Clockwork.voices:Add("Human_Male", "YOU TALKING TO ME", "You talking to me", "vo/npc/male01/answer30.wav")
Clockwork.voices:Add("Human_Male", "ZOMBIES", "Zombies", "vo/npc/male01/zombies02.wav")
Clockwork.voices:Add("Human_Male", "ZOMBIES SCARED", "Zooombies", "vo/npc/male01/zombies01.wav")