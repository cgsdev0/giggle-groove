class_name JokeController extends Control

@export var joke: AudioLabelList

# Called when the node enters the scene tree for the first time.
func _ready():
	start_joke()
	
func start_joke():
	for child in $Words.get_children():
		$Words.remove_child(child)
		child.queue_free()
		
	var shift = 0
	var last_anchor_right = 0.0
	for label in joke.labels:
		var p = Panel.new()
		p.set_script(JokeWord)
		p.controller = self
		p.label = label
		p.anchor_left = label.start / joke.audio.get_length()
		p.anchor_right = label.end / joke.audio.get_length()
		if (p.anchor_left < last_anchor_right || randf_range(1.0, 100.0) < 50.0):
			shift = (shift + 1) % 2
		p.row = shift
		p.anchor_top = 0.1 + shift * 0.3
		p.anchor_bottom = 0.4 + shift * 0.3
		var l = RichTextLabel.new()
		l.autowrap_mode = TextServer.AUTOWRAP_OFF
		l.fit_content = true
		l.scroll_active = false
		l.layout_mode = 1
		l.anchors_preset = Control.LayoutPreset.PRESET_FULL_RECT
		l.bbcode_enabled = true
		p.add_child(l)
		$Words.add_child(p)
		last_anchor_right = p.anchor_right
	$AudioStreamPlayer.stream = joke.audio
	await get_tree().create_timer(1.0).timeout
	$AudioStreamPlayer.play()

func _unhandled_key_input(event):
	if event.is_action_pressed("row0"):
		print("MISCLICK")
	if event.is_action_pressed("row1"):
		print("MISCLICK")
		
func get_progress():
	return $AudioStreamPlayer.get_playback_position() / joke.audio.get_length()
	
func _process(delta):
	if OS.is_debug_build() and Input.is_action_just_pressed("ui_accept"):
		$AudioStreamPlayer.stop()
		start_joke()
		
	if $AudioStreamPlayer.playing:
		$Cursor.anchor_left = $AudioStreamPlayer.get_playback_position() / joke.audio.get_length()
