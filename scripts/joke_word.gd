class_name JokeWord extends Control


var controller: JokeController
var label: AudioLabel

var highlighted = false
var row = 0
var string_size
var hit = false
var missed = false
# Called when the node enters the scene tree for the first time.
func _ready():
	var l = get_child(0)
	string_size = l.get_theme_font("font").get_string_size(label.label_clean, HORIZONTAL_ALIGNMENT_LEFT, -1, l.get_theme_font_size("font_size"))
#	var initial_size = anchor_right - anchor_left
#	var min_size = (string_size.x + 16) / controller.get_rect().size.x
#	if min_size > initial_size:
#		anchor_right = anchor_left + min_size
		
	default_text()
	
func default_text():
	var text = label.label_clean # "[color=red]" + label.label[0] + "[/color]" + label.label.substr(1)
	get_child(0).text = "[center]" + text + "[/center]"
	
func highlight_text():
	var text = "[center][color=yellow]" + label.label_clean + "[/color][/center]"
	get_child(0).text = text

const SLOP = 0.005
func _input(event):
	if get_viewport().is_input_handled():
		return
	# input handler for hitting the right key
	if controller.get_progress() > anchor_left - SLOP && controller.get_progress() < anchor_right + SLOP:
		if event.is_action_pressed("row" + str(row)) && !hit && !missed:
			get_viewport().set_input_as_handled()
			hit = true
			theme_type_variation = "HitJoke"
			controller.score(label, true)
			controller.flub(false)
			return
	
	if controller.get_progress() > anchor_left + SLOP && controller.get_progress() < anchor_right - SLOP:
		# Check if the wrong key was hit; this overrides a success
		if event.is_action_pressed("row" + str((row + 1) % 2)) || (event.is_action_pressed("row" + str(row)) && hit) && !missed:
			hit = false
			missed = true
			theme_type_variation = "MissedJoke"
			controller.score(label, false)
			controller.flub(true)
			
func _process(delta):
	if controller.get_progress() > anchor_left && controller.get_progress() < anchor_right:
		# Highlight when cursor over
		if !highlighted && !hit:
			highlighted = true
			highlight_text()
	
	# unhighlight after cursor leaves
	if controller.get_progress() > anchor_right && highlighted:
		if !hit:
			theme_type_variation = "MissedJoke"
			controller.score(label, false)
			controller.flub(true)
		highlighted = false
		default_text() 
