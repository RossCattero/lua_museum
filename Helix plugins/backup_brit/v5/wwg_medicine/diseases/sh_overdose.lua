DISEASE.name = "Overdose"
DISEASE.chance = 0
DISEASE.time = 10
DISEASE.stages = {
	{
		min = 0,
		max = 1,
		emit = false,
		text = "Your temperature rises above your threshold. You feel like you’re cooking from the inside and you’re sweating like a pig.",
	},
	{
		min = 1,
		max = 3,
		emit = false,
		text = "Your energy is draining by the minute. It becomes more exhausting to move.",
	},
	{
		min = 3,
		max = 4,
		emit = false,
		text = "It feels as though a net of needles is piercing into your scalp from all sides. The pain is almost making it impossible for you to keep your eyes open.",
	},
	{
		min = 4,
		max = 5,
		emit = false,
		text = "Your vision begins to fade away, leaving you with mere blurred silhouettes.",
	},
	{
		min = 5,
		max = 8,
		emit = false,
		text = "A crushing feeling starts storming your chest, making your lungs and heart feel as heavy as stone. The pain is horrendous.",
	},
	{
		min = 8,
		max = 9,
		emit = true,
		text = "[name] quickly loses control of their body, dropping on the ground. They effortlessly try to grasp control. They start violently shaking on the ground, contorting each extremity to the absolute maximum, causing them immaculate pain.",
	},
	{
		min = 9,
		max = 10,
		emit = true,
		text = "A lightness suddenly takes over and in mere seconds [name]’s body drops down to the floor. No movement is shown.",
	},
	{
		min = 10,
		death = true,
		emit = true,
		text = "Weak iterations of breath escape [name]’s mouth. A final muster of breath, followed by silence.",
	},
}