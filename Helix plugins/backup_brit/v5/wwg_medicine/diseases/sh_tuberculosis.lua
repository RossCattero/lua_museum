DISEASE.name = "Tuberculosis"
DISEASE.chance = 0.1
DISEASE.time = 600

DISEASE.reactionSound = "ambient/voices/cough3.wav"
DISEASE.reactionDelay = 12
DISEASE.reactionStage = 3

DISEASE.spreadChance = 5;

DISEASE.stages = {
	{
		min = 0,
		max = 30,
		text = "Your temperature rises slightly as your hands start to feel clammy.",
	},
	{
		min = 30,
		max = 60,
		text = "It feels as though your head is throbbing slightly.",
	},
	{
		min = 60,
		max = 90,
		text = "Your throat feels somewhat coarse and itchy. In an attempt to tackle it, you swallow a couple of times, but it appears to be futile. You start coughing.",
	},
	{
		min = 90,
		max = 120,
		text = "A crushing feeling starts storming your chest, making your lungs and heart feel as heavy as stone. The pain is horrendous.",
	},
	{
		min = 120,
		max = 150,
		text = "It feels as though a net of needles is piercing into your scalp from all sides. The pain is almost making it impossible for you to keep your eyes open.",
	},
	{
		min = 150,
		max = 180,
		text = "Your temperature rises above your threshold. You feel like you’re cooking from the inside and you’re sweating like a pig.",
	},
	{
		min = 180,
		max = 600,
		text = "Your energy is draining by the minute. It becomes more exhausting to move.",
	},
	{
		death = true,
		min = 600,
		text = "A feeling of heaviness rapidly presses onto your chest. Shredding pain takes the stage. You can’t breathe. Your lungs are burning and you begin to feel weak. Suddenly, it stops. All tension fades away from your face. A feeling of peace falls over you and silence prevails.",
	},
}