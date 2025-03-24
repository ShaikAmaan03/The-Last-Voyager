extends Node2D




func _on_storylore_animation_finished(anim_name: StringName) -> void:
	$"First Anim".show()
	
	pass 


func _on_first_anim_pressed() -> void:
	$Label.hide()
	$"First Anim".hide()
	$Label2.show()
	$Spaceshipinfo.play("new_animation")
	pass 


func _on_second_anim_pressed() -> void:
	get_tree().change_scene_to_file("res://background.tscn")
	Theglobalscene.storylore = 0
	Theglobalscene.save_lore()
	pass 


func _on_spaceshipinfo_animation_finished(anim_name: StringName) -> void:
	$"Second Anim".show()
	pass 


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	$Storylore.play("new_animation")

	$ColorRect.queue_free()
	pass 
