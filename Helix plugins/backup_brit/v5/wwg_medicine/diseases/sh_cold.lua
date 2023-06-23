DISEASE.name = "Cold"
DISEASE.chance = 1
DISEASE.time = 90

DISEASE.reactionSound = "ambient/voices/cough1.wav"
DISEASE.reactionDelay = 5
DISEASE.reactionStage = 2

DISEASE.spreadChance = 30;

DISEASE.stages = {
	{
		min = 0,
		max = 15,
		text = "Your temperature rises slightly as your hands start to feel clammy.",
	},
	{
		min = 15,
		max = 25,
		text = "Your throat feels somewhat coarse and itchy. In an attempt to tackle it, you swallow a couple of times, but it appears to be futile. You start coughing.",
	},
	{
		min = 25,
		max = 45,
		text = "It feels as though your head is throbbing slightly.",
	},
	{
		min = 45,
		max = 90,
		text = "Your energy is draining by the minute. It becomes more exhausting to move.",
	},
	{
		min = 90,
		text = "The coarseness in your throat slowly subsides. There is a spring in your step as the final shivers of your fever disappear.",
	},
}