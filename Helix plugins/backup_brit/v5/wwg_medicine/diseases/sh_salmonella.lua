DISEASE.name = "Salmonella"
DISEASE.chance = 0
DISEASE.time = 120
DISEASE.stages = {
	{
		min = 0,
		max = 15,
		text = "Your stomach appears to show some mild discontent. There is a sourness lingering inside.",
	},
	{
		min = 15,
		max = 20,
		emit = false,
		text = "It feels as though your head is throbbing slightly.",
	},
	{
		min = 20,
		max = 35,
		emit = false,
		text = "Your energy is draining by the minute. It becomes more exhausting to move.",
	},
	{
		min = 35,
		max = 45,
		emit = false,
		text = "Your stomach is struggling heavily. It feels like a fire is raging through your intestines, destined to find its end.",
	},
	{
		min = 45,
		max = 60,
		emit = false,
		text = "A sense of unpleasant hollowness rises from your abdomen, disorientating you. As you come to feel out of balance, the lingering sense of a need to throw up quietly emerges.",
	},
	{
		min = 60,
		max = 120,
		emit = false,
		text = "The pain in your abdomen becomes unbearable, your muscles are contracting and you feel like dying. Your throat suddenly opens up and the contents of your stomach empty onto the floor in front of you.",
	},
	{
		chance = 40,
		min = 120,
		emit = false,
		death = true,
		text = "Your organs slowly come to shut down one by one. A feeling of heaviness presses onto you and shredding pain takes the stage. In pure dread, you squeeze your eyes, yet suddenly, it stops. All tension fades away from your face. A welcome feeling of peace falls over you and silence prevails.",
	},
	{
		chance = 60,
		min = 120,
		emit = false,
		text = "A sudden relief washes over you. The vomiting helped clear up whatever was waging war on your intestines.",
	},
}