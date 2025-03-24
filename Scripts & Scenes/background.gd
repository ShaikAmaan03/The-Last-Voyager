extends Node2D

@export var player_scene: PackedScene  
@export var enemy_scenes: Array[PackedScene]  
@export var spawn_radius: int = 2500  # Max spawn distance
@export var min_spawn_distance: int = 1000  
@export var respawn_threshold: int = 1000  
@export var enemies_per_wave: int = 15  
@export var max_enemy_distance: int = 1500  # Delete enemies beyond this range
@export var enemy_spacing: int = 200  
 
var player
var last_spawn_position = Vector2.ZERO  
var enemies = []  

func _ready():
	$CanvasLayer/Control/Pause.show()
	$CanvasLayer/Control/Resume.hide()
	$CanvasLayer/Control/Restart.hide()
	$CanvasLayer/Control/Exit.hide()
	player = player_scene.instantiate()
	add_child(player)
	player.global_position = Vector2.ZERO  

	spawn_enemies_outside_viewport()

func _process(_delta):
	if player.global_position.distance_to(last_spawn_position) >= respawn_threshold:
		spawn_enemies_outside_viewport()
		cleanup_far_enemies()

func spawn_enemies_outside_viewport():
	last_spawn_position = player.global_position  
	var viewport_size = get_viewport_rect().size
	var spawn_margin = 400  # Extra distance from viewport

	for i in range(enemies_per_wave):
		var enemy_scene = enemy_scenes.pick_random()
		var enemy = enemy_scene.instantiate()

		
		var spawn_position = Vector2.ZERO
		while true:
			spawn_position = get_spawn_position_outside_viewport(viewport_size, spawn_margin)

			
			if player.global_position.distance_to(spawn_position) > min_spawn_distance and is_position_valid(spawn_position):
				break

		enemy.global_position = spawn_position
		add_child(enemy)
		enemies.append(enemy)

func get_spawn_position_outside_viewport(viewport_size, spawn_margin):
	""" Returns a valid spawn position outside the viewport with random spacing """
	var side = randi() % 4
	var spawn_position = Vector2.ZERO
	var offset = Vector2(randf_range(-enemy_spacing, enemy_spacing), randf_range(-enemy_spacing, enemy_spacing))

	if side == 0:  # Left
		spawn_position = player.global_position + Vector2(-spawn_margin - viewport_size.x / 2, randf_range(-viewport_size.y, viewport_size.y)) + offset
	elif side == 1:  # Right
		spawn_position = player.global_position + Vector2(spawn_margin + viewport_size.x / 2, randf_range(-viewport_size.y, viewport_size.y)) + offset
	elif side == 2:  # Above
		spawn_position = player.global_position + Vector2(randf_range(-viewport_size.x, viewport_size.x), -spawn_margin - viewport_size.y / 2) + offset
	elif side == 3:  # Below
		spawn_position = player.global_position + Vector2(randf_range(-viewport_size.x, viewport_size.x), spawn_margin + viewport_size.y / 2) + offset

	return spawn_position

func is_position_valid(spawn_position):
	""" Ensures the spawn position doesn't overlap with existing enemies """
	for enemy in enemies:
		if enemy.global_position.distance_to(spawn_position) < enemy_spacing:
			return false
	return true

func cleanup_far_enemies():
	""" Deletes enemies that are too far from the player """
	for enemy in enemies.duplicate():
		if player.global_position.distance_to(enemy.global_position) > max_enemy_distance:
			enemy.queue_free()
			enemies.erase(enemy)


func _on_pause_pressed() -> void:
	get_tree().paused=true
	$CanvasLayer/Control/Exit.show()
	$CanvasLayer/Control/Pause.hide()
	$CanvasLayer/Control/Resume.show()
	$CanvasLayer/Control/Restart.show()
	pass # Replace with function body.


func _on_resume_pressed() -> void:
	$CanvasLayer/Control/Exit.hide()
	get_tree().paused=false
	$CanvasLayer/Control/Pause.show()
	$CanvasLayer/Control/Restart.hide()
	$CanvasLayer/Control/Resume.hide()
	pass 


func _on_restart_pressed() -> void:
	$CanvasLayer/Control/Exit.hide()
	get_tree().paused=false
	get_tree().reload_current_scene()
	
	pass 


func _on_exit_pressed() -> void:
	get_tree().paused=false
	get_tree().change_scene_to_file("res://Scripts & Scenes/main_menuscene.tscn")
	pass
