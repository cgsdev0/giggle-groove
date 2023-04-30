extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var score = 0
var displayed_score = 0

func report_score(tallies, summary):
	$RichTextLabel.clear()
	var pending_score = 0
	await get_tree().create_timer(0.25).timeout
	for tally in tallies:
		var text = tally['label'].format(tally)
		$RichTextLabel.append_text("[center]" + text + "[/center]\n")
		$Slap.play_random()
		await get_tree().create_timer(0.38).timeout
		pending_score += tally['score']
	await get_tree().create_timer(1.0).timeout
	score += max(0, pending_score)
	$RichTextLabel.append_text("\n[center]" + summary + "[/center]\n")
	
func _process(delta):
	var incr =  min(500, score - displayed_score)
	displayed_score += incr
	if incr > 0:
		$Score.modulate = Color.GREEN
	else:
		$Score.modulate = Color.WHITE
	$Score.text = str(displayed_score)
