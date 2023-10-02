extends Node

var dan_visited = false
var gave_to_dan = false
var dan_got_beat = false

@onready var main1 = Conversation.new()
@onready var sidedan1 = Conversation.new()
@onready var main2 = Conversation.new()
@onready var sidedan2 = Conversation.new()
@onready var main3 = Conversation.new()
@onready var main4 = Conversation.new()
@onready var main5 = Conversation.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	main1.is_triggered = func():
		return Global.day == 0
	main1.script([
		{
			text = "Beautiful view from up here, isn't it.",
			image = "Officer",
			name = "???",
		},
		{
			text = "...",
		},
		{
			text = "Sorry, I'm Senior Community Agriculture Officer Stanfield - you can call me Jon.",
			name = "Jon",
		},
		{
			text = "I hope you settle in quickly here in your new home. We're relying on [b]you[/b] to produce supplies for the [i]incredible[/i] people who live in this neighborhood.",
		},
		{
			text = "It's much more efficient to farm up here since the buildings obstruct all of the sunlight down below.",
		},
		{
			text = "I'll check in with you every week. Please prepare 10 flowers and 5 berries for my collection next week.",
			callback = func():
				Global.set_quota_count(Global.ProduceType.FLOWER, 10)
				Global.set_quota_count(Global.ProduceType.BERRY, 5),
		},
		{
			text = "[u]Berries[/u] will only grow in fertile soil, and [u]flowers[/u] will fertilise all of the soil around them. Unused soil will become less fertile over time.",
		},
		{
			text = "Here are some seeds, Long live The Meritocracy of Lucido!",
			callback = func():
				Global.change_seed_count(Global.PlantType.FLOWER, 15)
				Global.change_seed_count(Global.PlantType.BERRY_VINE, 2),
		},
	])
	main1.choice_text = "Respond with the response: \"Prosperity for all!\"?"
	main1.choice = func(answer: bool):
		if answer:
			Story.bootlicker += 1
	main1.yes_script([
		{
			text = "[i]He nods with a smile, he appreciates your respect[/i]",
		}
	])
	
	sidedan1.is_triggered = func():
		if Global.day == 6 && Global.get_produce_count(Global.ProduceType.FLOWER) >= 2:
			dan_visited = true
			return true
		return false
	sidedan1.script([
		{
			text = "Hey, new farmer, nice to meet you!",
			image = "Daniel",
			name = "???",
		},
		{
			text = "I live downstairs, name's Daniel!",
			name = "Daniel"
		},
		{
			text = "I don't mean to immediately be asking favours from a new neighbour but err... I promised my wife date night tonight.",
		},
		{
			text = "Any chance you could spare a couple of flowers?",
		},
	])
	sidedan1.choice_text = "Give Daniel 2 flowers?"
	sidedan1.choice = func(answer : bool):
		if answer:
			Global.change_produce_count(Global.ProduceType.FLOWER, -2)
			Story.active_set.append(sidedan2)
		gave_to_dan = answer
	sidedan1.yes_script([
		{
			text = "I reeeaally appreciate it man - lifesaver!",
			image = "Daniel",
			name = "Daniel",
			callback = func(): Story.good_neighbor += 1
		}
	])
	sidedan1.no_script([
		{
			text = "Aw damn... no worries, I know you have your officer guy to appease.",
			image = "Daniel",
			name = "Daniel",
		}
	])
	
	main2.is_triggered = func():
		if Global.day == 7:
			if !dan_visited: main2.choice_text = ""
			return true
		return false
	main2.script([
		{
			when = func(): return Story.bootlicker > 0,
			text = "[i]He smiles as he sees you.[/i]",
			image = "Officer",
		},
		{
			when = func(): return Story.bootlicker > 0 && !Global.is_quota_met(),
			text = "[i]But his face drops when he sees you haven't met quota.[/i]",
		},
		{
			when = func(): return !Global.is_quota_met(),
			text = "You missed quota on your first week.",
			name = "Jon"
		},
		{
			when = func(): return !Global.is_quota_met(),
			text = "That one was supposed to be easy...\nI'll just take what you've got.",
			callback = func(): Global.take_quota(),
		},
		{
			when = func(): return !Global.is_quota_met(),
			text = "Do better next time.",
			callback = func(): Story.failure += 1,
		},
		{
			when = func(): return Global.is_quota_met(),
			text = "Ah wonderful, you've met quota.",
			callback = func():
				Story.success += 1
				Global.take_quota(),
		},
		{
			when = func(): return Global.is_quota_met() && Story.bootlicker > 0,
			text = "Polite and effective - we're going to get along fantastically!",
		},
	])
	main2.choice_text = "Tell Jon about Daniel visiting?"
	main2.choice = func(answer: bool):
		if !answer:
			Story.subtle += 1
	main2.yes_script([
		{
			text = "Well, there's no problem helping out a neighbour if they need it.",
			name = "Jon",
			image = "Officer"
		},
		{
			text = "But remember where your priorities lie - the Meritocracy of Lucido, who give you this fantastic life and provide for so many.",
		},
		{
			text = "And be careful to not let those priorities slide, or to attract the attention of... [i]miscreants[/i].",
		},
		{
			when = func(): return Global.is_quota_met() && gave_to_dan,
			text = "Seems to have worked out fine this time!",
			callback = func():
				Story.good_neighbor += 1,
		},
		{
			when = func(): return !Global.is_quota_met() && gave_to_dan,
			text = "This time you made an error of judgement. Making excuses doesn't help the matter.",
			callback = func():
				Story.snitch += 1
				dan_got_beat = true,
		},
		{
			when = func(): return Global.is_quota_met() && !gave_to_dan,
			text = "You prioritised your duty - you made the right decision.",
			callback = func(): Story.bootlicker += 1
		},
		{
			when = func(): return !Global.is_quota_met() && !gave_to_dan,
			text = "No idea how you managed to disappoint everyone. Remember what you're here for.",
			callback = func(): Story.failure += 1
		},
		{
			text = "This week you'll have to cultivate some medicinal [u]Succulents[/u] too. These will only grow in dry soil - wet soil will kill them.",
		},
		{
			text = "Here are your quotas and seeds for the next week.",
		},
	])
	main2.no_script([
		{
			text = "Oh before I go, be careful whose attention you attract up here.",
			image = "Officer",
			name = "Jon"
		},
		{
			text = "The former tenant had some [i]issues[/i] remembering where his priorities lie.",
		},
		{
			text = "This week you'll have to cultivate some medicinal [u]Succulents[/u] too. These will only grow in dry soil - wet soil will kill them.",
		},
		{
			text = "Here are your quotas for the next week.",
		},
	])
	main2.callback = func():
		Global.clear_quota()
		Global.set_quota_count(Global.ProduceType.FLOWER, 10)
		Global.set_quota_count(Global.ProduceType.BERRY, 10)
		Global.set_quota_count(Global.ProduceType.SUCCULENT, 2)
		Global.change_seed_count(Global.PlantType.FLOWER, 20)
		Global.change_seed_count(Global.PlantType.BERRY_VINE, 2)
		Global.change_seed_count(Global.PlantType.SUCCULENT, 4)
	
	sidedan2.is_triggered = func():
		return Global.day == 8
	sidedan2.script([
		{
			when = func(): return !dan_got_beat,
			name = "Daniel",
			image = "Daniel",
			text = "Date night yesterday went great, thanks for your help!"
		},
		{
			when = func(): return dan_got_beat,
			text = "[i]Daniel looks terrible, like he's been hit in the face with a lead pipe.[/i]"
		},
		{
			when = func(): return dan_got_beat,
			text = "No need to snitch like that."
		},
	])
	
	main3.is_triggered = func():
		return Global.day == 14
	main3.script([
		{
			text = "Good evening, I'm back again for the quota.",
			image = "Officer",
			name = "Jon"
		},
		{
			when = func(): return dan_got_beat,
			text = "I hope you learned from your previous mistakes."
		},
		{
			when = func(): return Story.success > 0,
			text = "Let's see if you've kept up the good performance."
		},
		{
			when = func(): return Story.success == 0,
			text = "Let's see if you've turned yourself around."
		},
		{
			when = func(): return Global.is_quota_met(),
			text = "Excellent work.",
			callback = func(): Story.success += 1,
		},
		{
			when = func(): return !Global.is_quota_met(),
			text = "Disappointing. I expect you to [u]make that up on next collection[/u]. If it happens again, I'll have to write you up.",
			callback = func(): Story.failure += 1,
		},
		{
			text = "This week I have something new for you. A very rare [u]Orange Tree[/u]. It's quite slow to grow, and needs a lot of moisture, so plant it quickly and take care of it so that you can meet quota."
		},
		{
			when = func(): return Story.failure > 0,
			text = "Don't repeat your past mistakes with this one.",
		},
		{
			when = func(): return Story.failure == 0,
			text = "With your perfect record, I'm sure you'll be fine.",
		},
		{
			text = "Here are the seeds and quota.",
			callback = func():
				Global.take_quota()
				Global.change_quota_count(Global.ProduceType.FLOWER, 10)
				Global.change_quota_count(Global.ProduceType.BERRY, 40)
				Global.change_quota_count(Global.ProduceType.SUCCULENT, 4)
				Global.change_quota_count(Global.ProduceType.ORANGE, 5)
				Global.change_seed_count(Global.PlantType.FLOWER, 10)
				Global.change_seed_count(Global.PlantType.BERRY_VINE, 1)
				Global.change_seed_count(Global.PlantType.SUCCULENT, 4)
				Global.change_seed_count(Global.PlantType.ORANGE_TREE, 1),
		},
	])
	
	main4.is_triggered = func():
		return Global.day == 21
	main4.script([
		
	])
	
	Story.active_set.push_back(main1)
	Story.active_set.push_back(sidedan1)
	Story.active_set.push_back(main2)
	Story.active_set.push_back(main3)

func take_quota(convo : Conversation):
	pass
