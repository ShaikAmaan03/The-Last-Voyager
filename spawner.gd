extends Area2D

@export var enemy_scenes: Array[PackedScene] 
@export var spawn_points: Array[Vector2]  

var spawned_enemies = []  

func _on_area_entered(_area):
	
	if spawned_enemies.is_empty():
		spawn_enemies()

func spawn_enemies():
	for pos in spawn_points:
		var enemy_scene = enemy_scenes.pick_random() 
		var enemy = enemy_scene.instantiate()
		get_tree().current_scene.add_child(enemy)
		enemy.global_position = global_position + pos 
		spawned_enemies.append(enemy)

func _on_area_exited(body):
	
	if body.is_in_group("enemies"):
		spawned_enemies.erase(body)  
		body.queue_free()
