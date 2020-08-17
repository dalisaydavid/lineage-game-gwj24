extends MarginContainer


var final_text = "Today, I won a war. I fought for the people of my country. And I made history. From this day forward, no one will forget the name Lapu and the Cruz tribe." 
var text_as_tokens = []
var token_index_bag = []
var revealed_text_as_tokens = []
var puzzle = null
var chain_required_for_word = 10
var total_blocks_deleted_required_for_word = 30
var blocks_deleted_since_last_word = 0

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
