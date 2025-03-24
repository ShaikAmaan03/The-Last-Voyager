extends CharacterBody2D

@export var acceleration: float = 10.0  
@export var base_speed: float = 300.0  
@export var boost_multiplier: float = 2.0  
@export var score_label: RichTextLabel  
@export var highscore_label: RichTextLabel  
@export var highscore_label2:RichTextLabel
@onready var booster_sprite: Sprite2D = $Booster  
@onready var player_sprites: Array = [$p1, $p2, $p3, $p4, $p5, $p6, $p7]  

var is_boosting: bool = false  
var last_direction: Vector2 = Vector2.RIGHT  
var score: int = 0  
var high_score: int = 0  
var max_speed: float  
var boost_score: int = 20  

func _ready():
	$CanvasLayer/LooseScreen.hide()
	booster_sprite.modulate.a = 0.0  
	max_speed = base_speed  
	load_high_score()  
	start_score_timer()  
	update_player_sprite()  

func start_score_timer():
	var timer = Timer.new()
	timer.wait_time = 1.0  
	timer.autostart = true
	timer.timeout.connect(_increase_score)
	add_child(timer)

func _increase_score():
	if is_boosting:
		score += boost_score  
	else:
		score += 10  

	update_difficulty()
	update_score_display()
	update_player_sprite()  

	if score > high_score:
		high_score = score  
		save_high_score()  

func update_difficulty():
	max_speed = base_speed + (score / 500) * 70  
	boost_multiplier = 2.0 + (score / 1000) * 0.4  
	boost_score = 20 + (score / 500) * 15  

func update_score_display():
	if score_label:
		if is_boosting:
			score_label.text = "Light Years : " + str(score) + "+" + str(boost_score) + ""
		else:
			score_label.text = "Light Years : " + str(score)

	if highscore_label:
		highscore_label.text = "Highest Years: " + str(high_score)
		highscore_label2.text = "Highest Years: " + str(high_score)
func update_player_sprite():
	var index = min(score / 500, player_sprites.size() - 1)  

	for i in range(player_sprites.size()):
		player_sprites[i].visible = (i == index)  

func save_high_score():
	var file = FileAccess.open("user://highscore.save", FileAccess.WRITE)
	if file:
		file.store_string(str(high_score))
		file.close()

func load_high_score():
	if FileAccess.file_exists("user://highscore.save"):
		var file = FileAccess.open("user://highscore.save", FileAccess.READ)
		if file:
			high_score = int(file.get_as_text().strip_edges())  
			file.close()

func _physics_process(delta):
	boosted()
	var input_direction = Vector2.ZERO

	if Input.is_action_pressed("moveup"):
		input_direction.y -= 1
	if Input.is_action_pressed("movedown"):
		input_direction.y += 1
	if Input.is_action_pressed("moveleft"):
		input_direction.x -= 1
	if Input.is_action_pressed("moveright"):
		input_direction.x += 1

	if input_direction == Vector2.ZERO:
		input_direction = last_direction

	if Input.is_action_pressed("ui_accept"):  
		is_boosting = true
		
		booster_sprite.modulate.a = lerp(booster_sprite.modulate.a, 1.0, 0.2)  
	else:
		is_boosting = false
		booster_sprite.modulate.a = lerp(booster_sprite.modulate.a, 0.0, 0.2)  

	input_direction = input_direction.normalized()  
	var speed = max_speed
	if is_boosting:
		
		speed *= boost_multiplier  
		
	velocity = velocity.lerp(input_direction * speed, acceleration * delta)  

	rotation = velocity.angle() + deg_to_rad(90)

	if input_direction != Vector2.ZERO:
		last_direction = input_direction

	move_and_slide()


func _on_retry_pressed() -> void:
	get_tree().paused=false
	get_tree().reload_current_scene()
	pass 

func livelost():
	Vector2.ZERO
	$".".set_collision_layer_value(10,10)
	$".".set_collision_mask_value(10,10)
	get_tree().paused=true
	$CanvasLayer/LooseScreen.show()
func boosted():
	if Input.is_action_just_pressed("ui_accept"):
		$AudioStreamPlayer2D.play()
	if Input.is_action_just_released("ui_accept"):
		$AudioStreamPlayer2D.playing=false
func _on_exit_pressed() -> void:
	get_tree().paused=false
	get_tree().change_scene_to_file("res://main_menuscene.tscn")
	pass 
