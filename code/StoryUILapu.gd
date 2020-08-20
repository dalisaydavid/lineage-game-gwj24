extends MarginContainer

signal text_fully_revealed
var final_text = "Today, Lapu won a war. He fought for the people of his country. And he made history. From this day forward, no one will forget the name Lapu Cruz and the Cruz tribe." 
var text_as_tokens = []
var token_index_bag = []
var revealed_text_as_tokens = []
var puzzle = null
var chain_required_for_word = 10
var total_blocks_deleted_required_for_word = 30
var blocks_deleted_since_last_word = 0
var attack_texts = ["Attack the enemy!", "Take this!", "Send in the troops!", "He's strong, but we're stronger.", "Make him understand our pain!"]

# Called when the node enters the scene tree for the first time.
func _ready():
	text_as_tokens = final_text.split(' ')
	token_index_bag = range(text_as_tokens.size())
	token_index_bag.shuffle()
	
	for token in text_as_tokens:
		revealed_text_as_tokens.append(" ")
	
	puzzle = get_parent().get_node('Puzzle')
	puzzle.connect('delete_block', self, 'count_deleted_blocks')
	puzzle.connect('delete_block', self, 'update_story_label')
	
	$HBoxContainer/VBoxContainer/StoryContainer/VBoxContainer/DialogLabel.text = "Manny: Where am I? I don't feel like myself..."
	
func move_story_title_label():
	var tween = get_node("HBoxContainer/VBoxContainer/StoryContainer/VBoxContainer/StoryTitleLabel/Tween")
	tween.interpolate_property(
		get_node("HBoxContainer/VBoxContainer/StoryContainer/VBoxContainer/StoryTitleLabel"), 
		'rect_scale',
		Vector2(1, 1), 
		Vector2(1.15, 1.15), 
		1,
		Tween.TRANS_QUART, 
		Tween.EASE_OUT
	)
	tween.start()

func _process(delta):
	#if $HBoxContainer/AttackTimer.time_left / float(floor($HBoxContainer/AttackTimer.time_left)) == 1:
	if puzzle != null:
		if not puzzle.end_puzzle and puzzle.start_puzzle:
			$HBoxContainer/VBoxContainer/AbilityLabel.set_text(str(floor($HBoxContainer/AttackTimer.time_left)))

func is_text_fully_revealed():
	var text_so_far = PoolStringArray(revealed_text_as_tokens).join(" ")
	return text_so_far == final_text

func count_deleted_blocks():
	blocks_deleted_since_last_word += 1
	
func reveal_word():
	if is_text_fully_revealed():
		return
	
	var token_index = token_index_bag.pop_back()
	var word = text_as_tokens[token_index]
	revealed_text_as_tokens[token_index] = word

func update_story_label():
	if puzzle.current_chain < chain_required_for_word:
		return
		
	reveal_word()
	var revealed_text = PoolStringArray(revealed_text_as_tokens).join(" ")
	$HBoxContainer/VBoxContainer/StoryContainer/VBoxContainer/StoryLabel.text = revealed_text

func update_dialog_label():
	randomize()
	var random_attack_text = attack_texts[randi()%attack_texts.size()]
	$HBoxContainer/VBoxContainer/StoryContainer/VBoxContainer/DialogLabel.set_text("\"" + random_attack_text + "\"")

func _on_AttackTimer_timeout():
	if puzzle != null:
		if puzzle.end_puzzle:
			return

		puzzle.add_row_of_blocks(5)
		
		update_dialog_label()

func _on_Tween_tween_all_completed():
	var tween = get_node("HBoxContainer/VBoxContainer/StoryContainer/VBoxContainer/StoryTitleLabel/ShrinkTween")
	tween.interpolate_property(
		get_node("HBoxContainer/VBoxContainer/StoryContainer/VBoxContainer/StoryTitleLabel"), 
		'rect_scale',
		Vector2(1.15, 1.15), 
		Vector2(1, 1),
		1,
		Tween.TRANS_QUART, 
		Tween.EASE_OUT
	)
	tween.start()


func _on_ShrinkTween_tween_all_completed():
	move_story_title_label()
