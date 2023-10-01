extends Control

signal dialogue_started
signal dialogue_ended

signal _dialogue_next
signal _choice_confirmed(answer : bool)

@export var characters_per_second = 50.0

var _character_tween : Tween
var _current_conversation : Conversation

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("convo_next"):
		if is_instance_valid(_character_tween):
			_character_tween.stop()
			$NinePatchRect/Text.visible_ratio = 1.0
			_character_tween.finished.emit() # Sneaky...
		else:
			_dialogue_next.emit()

func _show_picture(name : String):
	for child in $NinePatchRect/Pictures.get_children():
		child.visible = child.name == name

## Run a conversation to completion
func run_conversation(convo : Conversation):
	dialogue_started.emit()
	# Set up
	_show_picture(convo.dialogue_pages[0].get("image", ""))
	$NinePatchRect/Name.text = convo.dialogue_pages[0].get("name", "")
	$NinePatchRect/Text.text = ""
	
	# Fade in
	var fade_tween = create_tween()
	self.modulate = Color.TRANSPARENT
	self.visible = true
	fade_tween.tween_property(self, "modulate", Color.WHITE, 0.3)
	await fade_tween.finished
	
	# Run the actual conversation
	await _run_conversation_meat(convo)
	
	# Fade out
	fade_tween = create_tween()
	fade_tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.3)
	fade_tween.tween_callback(func(): self.visible = false)
	await fade_tween.finished
	dialogue_ended.emit()

func _run_conversation_meat(convo : Conversation):
	# Go through conversation.
	await _run_dialogue_pages(convo.dialogue_pages)
	
	# Choice?
	if !convo.choice_text.is_empty():
		$QuestionDialog.dialog_text = convo.choice_text
		$QuestionDialog.visible = true
		var answer = await _choice_confirmed
		convo.choice.call(answer)
		if answer: await _run_dialogue_pages(convo.dialogue_pages_choice_yes)
		else: await _run_dialogue_pages(convo.dialogue_pages_choice_no)

	# Is there more?
	if is_instance_valid(convo.next):
		await _run_conversation_meat(convo.next)

func _run_dialogue_pages(pages : Array[Dictionary]):
	var name = ""
	var image = ""
	for page in pages:
		if page.has("when"):
			if !page["when"].call():
				continue
		name = page.get("name", name)
		image = page.get("image", image)
		_show_picture(image)
		$NinePatchRect/Name.text = name
		$NinePatchRect/Text.text = page["text"]
		$NinePatchRect/Text.visible_characters = 0
		_character_tween = create_tween()
		var num_characters = $NinePatchRect/Text.get_total_character_count()
		_character_tween.tween_property($NinePatchRect/Text, "visible_characters", num_characters, num_characters / characters_per_second)
		await _character_tween.finished
		_character_tween = null
		if is_instance_valid(page.get("callback")):
			page["callback"].call()
		await _dialogue_next

func _on_question_dialog_confirmed():
	_choice_confirmed.emit(true)
func _on_question_dialog_denied():
	_choice_confirmed.emit(false)