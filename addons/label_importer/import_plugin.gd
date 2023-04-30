# import_plugin.gd
@tool
extends EditorImportPlugin

var a = preload("audio_label.gd")
var b = preload("audio_label_list.gd")

func _get_importer_name():
	return "audio.label_importer"
	
func _get_visible_name():
	return "Audio Label Importer"

func _get_recognized_extensions():
	return ["txt"]

func _get_save_extension():
	return "tres"

func _get_priority():
	return 10.0
	
func _get_resource_type():
	return "AudioLabelList"

func _get_preset_name(preset):
	return "Default"
	
func _get_import_order():
	return 0
	
func _get_preset_count():
	return 1
	
func _get_import_options(preset, _who_cares):
	return []

func _get_option_visibility(option, options, _idk):
	return true

func _import(source_file, save_path, options, r_platform_variants, r_gen_files):
	var file = FileAccess.open(source_file, FileAccess.READ)
	if file == null:
		return FileAccess.get_open_error()

	var line = file.get_line()
	var p = source_file.split('/')
	var basename = p[len(p) - 1].split('.')[0]
	var audio_file = "res://jokes/" + basename + ".wav"
	var voice = AudioLabelList.Voice.SAM
	if basename.begins_with("robot"):
		voice = AudioLabelList.Voice.ROBOT
	var label_list = AudioLabelList.new(load(audio_file), voice)
	var idx = 0
	var idx_minus_pause = 0
	var section = 0
	while line:
		var s = line.split('\t')
		var label = AudioLabel.new(float(s[0]), float(s[1]), s[2])
		label_list.labels.push_back(label)
#		if s[2][0] == '-' && idx > 0:
#			if label_list.labels[idx - 1].label[0] == '-':
#				label_list.labels[idx - 1].label = "[center]" + label_list.labels[idx - 1].label + "[/center]"
#			else:
#				label_list.labels[idx - 1].label = "[right]" + label_list.labels[idx - 1].label + "[/right]"
		line = file.get_line()
		label.index = idx_minus_pause
		label.section = section
		if s[2] != '{PAUSE}':
			idx_minus_pause += 1
		else:
			idx_minus_pause = 0
			section += 1
		idx += 1

	file.close()
	print(save_path)
	return ResourceSaver.save(label_list, "%s.%s" % [save_path, _get_save_extension()])
