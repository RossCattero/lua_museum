DISEASE.name = "Alcohol Poisoning"
DISEASE.chance = 0
DISEASE.time = 180
DISEASE.stages = {
	{
		min = 0,
		max = 30,
		text = "A sense of unpleasant hollowness rises from your abdomen, disorientating you. As you come to feel out of balance, the lingering sense of a need to throw up quietly emerges.",
	},
	{
		min = 30,
		max = 45,
		text = "Your energy is draining by the minute. It becomes more exhausting to move.",
	},
	{
		min = 45,
		max = 60,
		text = "Your stomach is struggling heavily. It feels like a fire is raging through your intestines, destined to find its end.",
	},
	{
		emit = true,
		min = 60,
		max = 120,
		text = "The pain in [name]’s abdomen becomes unbearable, their muscles are contracting and they feel like dying. Their throat suddenly opens up and the contents of their stomach empty onto the floor.",
	},
	{
		emit = true,
		min = 120,
		max = 170,
		text = "[name] quickly loses control of their body, dropping on the ground. They effortlessly try to grasp control. They start violently shaking on the ground, contorting each extremity to the absolute maximum, causing them immaculate pain.",
	},
	{
		min = 170,
		max = 180,
		text = "A lightness suddenly takes over and in mere seconds [name]’s body drops down to the floor. No movement is shown.",
	},
	{
		min = 180,
		death = true,
		text = "Your organs slowly come to shut down one by one. A feeling of heaviness presses onto you and shredding pain takes the stage. In pure dread, you squeeze your eyes, yet suddenly, it stops. All tension fades away from your face. A welcome feeling of peace falls over you and silence.",
	},
}