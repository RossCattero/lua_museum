DISEASE.name = "Flu"
DISEASE.chance = 1
DISEASE.time = 180

DISEASE.reactionSound = "ambient/voices/cough2.wav"
DISEASE.reactionDelay = 10
DISEASE.reactionStage = 2

DISEASE.spreadChance = 20;

DISEASE.stages = {
	{
		min = 0,
		max = 15,
		text = "Your temperature rises slightly as your hands start to feel clammy.",
	},
	{
		min = 15,
		max = 30,
		text = "Your throat feels somewhat coarse and itchy. In an attempt to tackle it, you swallow a couple of times, but it appears to be futile. You start coughing.",
	},
	{
		min = 30,
		max = 35,
		text = "It feels as though your head is throbbing slightly.",
	},
	{
		min = 35,
		max = 60,
		text = "Your temperature rises above your threshold. You feel like you’re cooking from the inside and you’re sweating like a pig.”",
	},
	{
		min = 60,
		max = 180,
		text = "It feels as though a net of needles is piercing into your scalp from all sides. The pain is almost making it impossible for you to keep your eyes open.",
	},
	{
		chance = 3,
		min = 180,
		death = true,
		text = "A feeling of heaviness rapidly presses onto your chest. Shredding pain takes the stage. You can’t breathe. Your lungs are burning and you begin to feel weak. Suddenly, it stops. All tension fades away from your face. A feeling of peace falls over you and silence prevails.",
	},
	{
		chance = 97,
		min = 180,
		text = "The heat subsides. Slowly but surely, the headache clears up. The pressure falls from your chest and relief prevails.",
	}
}