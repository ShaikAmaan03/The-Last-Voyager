extends Node
@export var music: AudioStreamMP3
var storylore = 1
func save_lore():
	var file = FileAccess.open("user://storylore.save", FileAccess.WRITE)
	if file:
		file.store_string(str(storylore))
		file.close()

func load_lore():
	if FileAccess.file_exists("user://storylore.save"):
		var file = FileAccess.open("user://storylore.save", FileAccess.READ)
		if file:
			storylore = int(file.get_as_text().strip_edges())  
			file.close()
func _ready() -> void:
	load_lore()	
