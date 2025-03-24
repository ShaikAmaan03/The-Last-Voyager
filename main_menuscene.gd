extends Node2D


func _on_start_pressed() -> void:
	if Theglobalscene.storylore==0:
		get_tree().change_scene_to_file("res://background.tscn")
	else:
		get_tree().change_scene_to_file("res://intro_scene.tscn")
	 


func _on_exit_pressed() -> void:
	get_tree().quit()
	pass 


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	$AnimationPlayer/ColorRect.queue_free()
	pass 


func _on_lorebtn_pressed() -> void:
	get_tree().change_scene_to_file("res://intro_scene.tscn")
	pass
