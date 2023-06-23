local PLUGIN = PLUGIN;

// Configuration file;

// Data for taxi system.
// Be careful editing everything below.
TAXI_DATA = {
	price = 2.50, // Base price of taxi call; Default: 2
	fee = 50, // Base PERCENT of price that will be a fee; Default: 50(%)
	carName = "simfphys_mafia2_quicksilver_windsor_taxi_pha",
	taxiSpawnPos = Vector(480.601593, -203.643021, -100),
	obbsM = Vector(-45.780407, -119.175377, 0.000000),
	obbsMax = Vector(45.780605, 117.107315, 69.619278),
}

local percent = math.Round(TAXI_DATA.price * (1 - (math.Clamp(TAXI_DATA.fee, 0, 100) / 100)), 2)
TAXI_DATA.rules = [[
	1. You'll pay a fee in amount of ]]..nut.currency.get(percent)..[[ when taxi will accept your request.
	2. If you'll reject to ride in a taxi - the driver receive the ]]..TAXI_DATA.fee..[[% of the fee.
	3. The driver will have a time to drive to you. It depends on how much
	meters you were away from driver. If driver won't arrive in time - the fee will
	return back to you and driver receive a fine.
	4. You'll receive a notification when driver arrives.
	5. If driver has arrived in time - the driver should wait for you for 60 seconds.
	If you're not arrived in time, then driver receives a 100% of your prepaid fee.
	6. The payment for TAXI services includes driving in any place of city.
	7. The application automatically checks your balance. You should have at
	least ]]..nut.currency.get(percent)..[[ to order a taxi and ]]..nut.currency.get(TAXI_DATA.price)..[[ to pay in cash later.
	8. You can pay additional money to attract taxi workers faster.
]] // Rules displayed in taxi app;

TAXI_DATA.rulesForTaxi = [[
		1. You'll receive a taxi car which should not be
		stolen or destroyed. It will be removed when you dismiss.
		2. You will receive an access to taxi database(/taxi),
		where you can see all currently requests.
		3. After you accept a request - you should drive
		to position(will be marked on the map). Once you drive in distance of 10 m. or less - you start wait.
		You will wait for 60 seconds and if the customer won't come - you'll receive a customer fee in amount of ]]..nut.currency.get(percent)..[[.
		4. If customer don't agree to drive with you - he can decline the drive with app and you receive 
		]]..TAXI_DATA.fee..[[% of fee, what is ]]..nut.currency.get(math.Round(percent/2, 2))..[[.
		5. You should ask payment manually from the customer any time you want.
]] // rules displayed in contract;

// Apps for mobile tablet;
APPS = {
	[1] = {
    name = "TAXI",
    open = "APP_taxi",
	}
}

// Talker system;
TALKER = {
	answers = {},
	questions = {},
	defAnswer = 1,
	defQuestions = {1, 2, 3}
};

function PLUGIN:pAnswer(data)
		table.insert(TALKER["answers"], data);
end;

function PLUGIN:pQuestion(data)
		table.insert(TALKER["questions"], data)
end;

PLUGIN:pAnswer({
		answer = "How can I help you?",
})

PLUGIN:pQuestion({
		question = "Nothing (leave)",
		serivce = "quit" // Calls service callback
})
PLUGIN:pQuestion({
		question = "I want to sign up a contract",
		opens = "Taxi_agreement", // Parent panel;
		canSee = function(ply)
				return ply && ply:IsValid() && !ply:IsTaxi()
		end
})
PLUGIN:pQuestion({
		question = "About taxi...",
		opens = "Taxi_about", // Parent panel;
		canSee = function(ply)
				return ply && ply:IsValid() && ply:IsTaxi()
		end
})