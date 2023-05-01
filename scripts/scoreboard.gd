extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$Summary.hide()
	Signals.restart.connect(restart)

func restart():
	$RichTextLabel.clear()
	score = 0
	
var score = 0
var displayed_score = 0

func show_summary():
	$Score.hide()
	$Summary.show()
	
func report_score(tallies, summary):
	var game_idx = Signals.game_idx
	$RichTextLabel.clear()
	$AnimationPlayer.play("RESET")
	var pending_score = 0
	await get_tree().create_timer(0.25, false).timeout
	# hacks
	if game_idx != Signals.game_idx:
		return
	for tally in tallies:
		var text = tally['label'].format(tally)
		$RichTextLabel.append_text("[center]" + text + "[/center]\n")
		$Slap.play_random()
		await get_tree().create_timer(0.38, false).timeout
		if game_idx != Signals.game_idx:
			return
		pending_score += tally['score']
	await get_tree().create_timer(1.0, false).timeout
	if game_idx != Signals.game_idx:
		return
	score += max(0, pending_score)
	$RichTextLabel.append_text("\n[center]" + summary + "[/center]\n")
	$AnimationPlayer.play("fade_out")

	
func _process(delta):
	var incr =  min(500, score - displayed_score)
	displayed_score += incr
	if incr > 0:
		$Score.modulate = Color.GREEN
	else:
		$Score.modulate = Color.WHITE
	$Score.text = str(displayed_score)
	%FinalScore.text = str(score)


func _on_button_pressed():
	score = 0
	$Score.show()
	$Summary.hide()
	get_parent().get_parent().show_play_button()
