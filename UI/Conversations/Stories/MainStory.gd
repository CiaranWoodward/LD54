extends Node

var bootlicker = 0

@onready var main1 = Conversation.new()
@onready var main2 = Conversation.new()

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
		},
		{
			text = "Here are some seeds, Long live the meritocracy!",
			callback = func():
				Global.change_seed_count(Global.PlantType.FLOWER, 10)
				Global.change_seed_count(Global.PlantType.BERRY_VINE, 5)
				,
		},
	])
	main1.choice_text = "Thank him?"
	main1.choice = func(answer: bool):
		if answer:
			bootlicker += 1
	main1.yes_script([
		{
			text = "[i]He nods with a smile, he appreciates your respect of his position[/i]",
		}
	])
	
	main2.is_triggered = func():
		return Global.day == 7
	main2.script([
		{
			when = func(): return bootlicker > 0,
			text = "[i]He smiles as he sees you[/i]",
			image = "Officer",
		},
		{
			when = func(): return bootlicker > 0 && !Global.quota_met(),
			text = "[i]But his face drops when he sees you haven't met quota.[/i]",
			image = "Officer",
		},
		{
			text = "Product please.",
			name = "Jon",
		}
	])
	
	Story.active_set.push_back(main1)
	Story.active_set.push_back(main2)

func take_quota(convo : Conversation):
	pass
