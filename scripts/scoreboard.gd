extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func report_score(tallies, summary):
	$RichTextLabel.clear()
	for tally in tallies:
		var text = tally['label'].format(tally)
		$RichTextLabel.append_text("[center]" + text + "[/center]\n")
		$Slap.play_random()
		await get_tree().create_timer(0.38).timeout
	await get_tree().create_timer(1.0).timeout
	$RichTextLabel.append_text("\n[center]" + summary + "[/center]\n")
	
func _process(delta):
	pass
