class_name JokeController extends Control

@export var joke: AudioLabelList

# Called when the node enters the scene tree for the first time.
func _ready():
	start_joke()
	
func start_joke():
	for child in $Words.get_children():
		$Words.remove_child(child)
		child.queue_free()
		
	for label in joke.labels:
		var p = Panel.new()
		p.set_script(JokeWord)
		p.controller = self
		p.anchor_left = label.start / joke.audio.get_length()
		p.anchor_right = 1 # label.end / joke.audio.get_length()
		var l = RichTextLabel.new()
		l.fit_content = true
		l.scroll_active = false
		l.layout_mode = 1
		l.anchors_preset = Control.LayoutPreset.PRESET_FULL_RECT
		l.bbcode_enabled = true
		var text = "[color=red]" + label.label[0] + "[/color]" + label.label.substr(1)
		l.text = text
		p.add_child(l)
		$Words.add_child(p)
	$AudioStreamPlayer.stream = joke.audio
	$AudioStreamPlayer.play()


func get_progress():
	return $AudioStreamPlayer.get_playback_position() / joke.audio.get_length()
	
func _process(delta):
	if OS.is_debug_build() and Input.is_action_just_pressed("ui_accept"):
		$AudioStreamPlayer.stop()
		start_joke()
		
	if $AudioStreamPlayer.playing:
		$Cursor.anchor_left = $AudioStreamPlayer.get_playback_position() / joke.audio.get_length()
