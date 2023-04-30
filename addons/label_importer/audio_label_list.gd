class_name AudioLabelList extends Resource

@export var labels: Array[AudioLabel]
@export var audio: AudioStreamWAV

enum Voice {
	ROBOT,
	SAM
}
@export var voice: Voice


func _init(p_audio = null, p_voice = Voice.ROBOT, p_labels: Array[AudioLabel] = []):
	labels = p_labels
	audio = p_audio
	voice = p_voice
