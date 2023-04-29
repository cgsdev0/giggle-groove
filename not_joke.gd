class_name JokeController extends Control

@export var joke: AudioLabelList

# Called when the node enters the scene tree for the first time.
func _ready():
	start_joke()
	
var pause = null
var start = 0
var curr = 0

func start_joke(section: int = 0):
	var should_start = (section == 0)
	for child in $Words.get_children():
		$Words.remove_child(child)
		child.queue_free()
		
	var label_slice = []
	pause = null
	start = 0
	
	for label in joke.labels:
		if label.label == "{PAUSE}":
			if section:
				section -= 1
				start = label.end
				continue
			pause = label
			break
		if !section:
			label_slice.push_back(label)
			
	var shift = 0
	var last_anchor_right = 0.0
	for label in label_slice:
		var p = Panel.new()
		p.set_script(JokeWord)
		p.controller = self
		p.label = label
		p.anchor_left = (label.start - start) / (joke.audio.get_length() - start)
		p.anchor_right = (label.end - start) / (joke.audio.get_length() - start)
		if pause:
			p.anchor_left = (label.start - start) / (pause.start - start)
			p.anchor_right = (label.end - start) / (pause.start - start)
			
		if (randf_range(1.0, 100.0) < 50.0):
			if label.label[0] != '-':
				shift = (shift + 1) % 2
		p.row = shift
		p.anchor_top = 0.1 + shift * 0.5
		p.anchor_bottom = 0.4 + shift * 0.5
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
	if should_start:
		$AudioStreamPlayer.stream = joke.audio
		await get_tree().create_timer(1.0).timeout
		$AudioStreamPlayer.play()

func _unhandled_key_input(event):
	if event.is_action_pressed("row0"):
		print("MISCLICK")
	if event.is_action_pressed("row1"):
		print("MISCLICK")
		
func get_progress():
	if pause:
		return ($AudioStreamPlayer.get_playback_position() - start) / (pause.start - start)
	else:
		return ($AudioStreamPlayer.get_playback_position() - start) / (joke.audio.get_length() - start)
	
func _process(delta):
	if pause:
		if $AudioStreamPlayer.get_playback_position() > pause.start + (pause.end - pause.start) / 4:
			curr += 1
			start_joke(curr)
	if OS.is_debug_build() and Input.is_action_just_pressed("ui_accept"):
		$AudioStreamPlayer.stop()
		curr = 0
		start_joke()
		
	if $AudioStreamPlayer.playing:
		$Cursor.anchor_left = get_progress()
