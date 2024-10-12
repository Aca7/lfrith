extends Node

var mob_data = {}
var mob_data_path = "res://Asset/data/mob.json"

var wave_data = []
var wave_data_path = "res://Asset/data/wave.json"

func _ready():
	mob_data = load_json_file(mob_data_path)
	wave_data = load_json_file(wave_data_path)

func load_json_file(filePath : String):
	if FileAccess.file_exists(filePath):
		var dataFile = FileAccess.open(filePath, FileAccess.READ)
		var parseResult = JSON.parse_string(dataFile.get_as_text())
		
		return parseResult
	else:
		print("ERROR :: " + filePath + " dosen't exist")
	
