local PLUGIN = PLUGIN;

function BANKING_LOGS:AddLog(who, text, tp)
		BANKING_LOGS.logs[#BANKING_LOGS.logs + 1] = {
			text = text,
			tp = tp,
			time = os.date( "%H:%M:%S, %d/%m/%y", os.time() ),
			who = who,
		}
end;