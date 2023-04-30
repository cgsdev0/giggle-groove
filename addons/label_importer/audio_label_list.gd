class_name AudioLabelList extends Resource

@export var labels: Array[AudioLabel]
@export var audio: AudioStreamWAV


func _init(p_audio = null, p_labels: Array[AudioLabel] = []):
	labels = p_labels
	audio = p_audio
