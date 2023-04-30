class_name JokeController extends Control

@export var joke: AudioLabelList

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
var pause = null
var start = 0
var curr = 0

var pretimer = 0.0

var scored = []
var misclicks = 0

var regex = RegEx.new()
var react_at = 10000
var laughing = false
var laugh_streak = 0

func is_whiffed():
	var last_section = scored[len(scored) - 1]
	return !last_section[len(last_section) - 1]
	
func is_laughable():
	return laughability() > 0.68 && !is_whiffed()
	
func get_summary():
	if is_whiffed():
		return [""]
	var l = laughability();
	if l <= 0.15:
		return ["Find a new career", "Go home", "Give up", "Hopeless", "zzZzzzZZzz..."]
	if l <= 0.30:
		return ["???????", "Unintelligble"]
	if l <= 0.45:
		return ["Keep trying!", "Confusing", "Just bad"]
	if l <= 0.68:
		return ["Almost!", "Nearly!", "So close!", "Swing and a miss"]
	if l <= 0.82:
		return ["Solid joke", "Respectable", "Barely got a laugh", "Rocky"]
	if l == 1.0:
		return ["Absolute perfection.", "Perfect!"]
	return ["Excellent!", "Great joke!", "Sensational!", "Wow!", "Hilarious!", "Comic genius"]
	
func laughability():
	var results = []
	for s in scored:
		var hits = 0
		var beats = 0
		for t in s:
			if t:
				hits += 1
			beats += 1
		results.push_back(float(hits) / float(beats))
	return results.min()
		
func tally_score():
	var score_parts = []
	
	var hits = 0
	var beats = 0
	for s in scored:
		for t in s:
			if t:
				hits += 1
			beats += 1
	
	if is_whiffed():
		return [{ "label": 'Whiffed punchline... {score} pts', "score": 0 }]
		
	var hit_rate = round((float(hits) / float(beats)) * 20.0) / 20.0
	score_parts.push_back({ "label": "Base score: {score} pts", "score": 50000 * hit_rate })
	if len(scored) > 1:
		if scored[0].all(func(a): return a):
			score_parts.push_back({ "label": "Flawless setup! +{score} pts", "score": 5000 })
	
	if scored[len(scored) - 1].all(func(a): return a):
		if len(scored) == 1:
			score_parts.push_back({ "label": "Zinger! +{score} pts", "score": 15000 })
		else:
			score_parts.push_back({ "label": "Perfect punchline! +{score} pts", "score": 10000 })
	
	if laugh_streak > 1:
		score_parts.push_back({ "label": str(laugh_streak) + "x Laugh streak! +{score} pts", "score": (laugh_streak - 1) * 500 })
	if misclicks > 0:
		score_parts.push_back({ "label": "Stutters {score} pts", "score": -1000 * misclicks })
		
	return score_parts

func clear():
	for child in $Words.get_children():
		$Words.remove_child(child)
		child.queue_free()
		
func start_joke(section: int = 0):
	mute(false)
	regex.compile("{(\\d+)}")
	pretimer = 0.0
	var should_start = (section == 0)
	
	if should_start: # reset state
		react_at = joke.labels[len(joke.labels) - 1].end
		curr = 0
		laughing = false
		misclicks = 0
		scored.clear()
	scored.push_back([])
	
	clear()
		
	var label_slice = []
	pause = null
	start = 0
	
	var section2 = section
	for label in joke.labels:
		if label.label == "{PAUSE}":
			if section2:
				section2 -= 1
				start = label.end
				continue
			pause = label
			break
		if !section2:
			label_slice.push_back(label)
		
	var shift = 0
	var last_anchor_right = 0.0
	for label in label_slice:
		scored[section].push_back(false)
		var p = Panel.new()
		p.set_script(JokeWord)
		p.controller = self
		p.label = label
		p.anchor_left = (label.start - start) / (joke.audio.get_length() - start) * 0.8 + 0.2
		p.anchor_right = (label.end - start) / (joke.audio.get_length() - start) * 0.8 + 0.2
		if pause:
			p.anchor_left = (label.start - start) / (pause.start - start) * 0.8 + 0.2
			p.anchor_right = (label.end - start) / (pause.start - start) * 0.8 + 0.2
			
		var result = regex.search(label.label)
		if result:
			shift = int(result.get_string(1))
		elif (randf_range(1.0, 100.0) < 50.0):
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
		l.set_anchors_preset(PRESET_FULL_RECT)
		l.anchor_top = 0.1
		l.bbcode_enabled = true
		p.rtl = l
		p.add_child(l)
		$Words.add_child(p)
		last_anchor_right = p.anchor_right
	if should_start:
		$AudioStreamPlayer.stream = joke.audio
		await get_tree().create_timer(1.5).timeout
		$AudioStreamPlayer.play()

func score(label: AudioLabel, val: bool):
	scored[label.section][label.index] = val
	
func _unhandled_key_input(event):
	if event.is_action_pressed("row0"):
		misclicks += 1
		flub()
	if event.is_action_pressed("row1"):
		misclicks += 1
		flub()
		
func adjust_volume(val: float):
	var joke_bus = AudioServer.get_bus_index("Joke")
	AudioServer.set_bus_volume_db(joke_bus, val)
	
func mute(val: bool = true):
	if val:
		adjust_volume(-25.0)
	else:
		adjust_volume(0.0)
		
func flub(val: bool = true):
	if !joke:
		return
	if val:
		match joke.voice:
			AudioLabelList.Voice.ROBOT:
				$FlubRobot.play_random()
			AudioLabelList.Voice.SAM:
				$FlubSam.play_random()
	mute(val)
		
func get_screen_length():
	if !joke:
		return 1
	if pause:
		return (pause.start - start)
	else:
		return (joke.audio.get_length() - start)
		
func get_progress():
	var scr_len = get_screen_length()
	if !$AudioStreamPlayer.playing:
		return (pretimer - 1.5 + 0.2 * scr_len) / scr_len
	return ($AudioStreamPlayer.get_playback_position() - start) /  scr_len * 0.8 + 0.2

var initial_font_size = null
func update_text_size():
	if initial_font_size == null:
		initial_font_size = theme.default_font_size
	var si = get_viewport_rect().size
	var scale_factor = min(si.x / 1920.0, si.y / 1080.0)
	theme.default_font_size = int(initial_font_size * scale_factor)
	
func _process(delta):
	update_text_size()
	if ($AudioStreamPlayer.get_playback_position() > react_at) && !laughing:
		laughing = true
		if is_laughable():
			laugh_streak += 1
		else:
			laugh_streak = 0
		await $%Scoreboard.report_score(tally_score(), get_summary().pick_random())
		if is_laughable():
			$Laughtrack.play_some(3, 5)
		else:
			$Jeers.play_some(1, 1)
		await get_tree().create_timer(3.0).timeout
		Signals.next_joke.emit()
	
	if joke:
		pretimer += delta
	var scr_len = get_screen_length()
	if pause:
		if $AudioStreamPlayer.get_playback_position() > pause.start: # + (pause.end - pause.start) / 4:
			curr += 1
			start_joke(curr)
#	if OS.is_debug_build() and Input.is_action_just_pressed("ui_accept"):
#		$AudioStreamPlayer.stop()
#		curr = 0
#		start_joke()
		
	$Precursor.anchor_left = get_progress() + 0.2
	$Cursor.anchor_right = get_progress()
