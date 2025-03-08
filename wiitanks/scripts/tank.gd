extends CharacterBody2D

var player_direction = null
@export var bullet: PackedScene
@export var bluewin: PackedScene
@export var redwin: PackedScene
@export var team: int = -1
var can_shoot = true
@onready var original_position = global_position
@onready var timer = $Timer
@onready var respawn_timer = $RespawnTimer
@onready var scene_root = get_tree().root.get_children()[0]
var og_color = null
var respawning = false
var carrying_flag = false
var carry_flag = null
var carrying_team = -1


var bulletID = RandomNumberGenerator.new().randi_range(0, 1000000)

func _ready() -> void:
	$Flag.get_node("flag_hitbox").get_node("CollisionShape2D").disabled = true

func _process(delta: float) -> void:
	if player_direction != null and (not respawning or respawn_timer.time_left < 2):
		var speed = 300 
		velocity.x = cos(player_direction) * speed
		velocity.y = sin(player_direction) * speed
		
		rotation = player_direction

func _physics_process(delta: float) -> void:
	if respawning:
		$Countdown.text = str(round(respawn_timer.time_left))
	if player_direction != null and (not respawning or respawn_timer.time_left < 2):
		move_and_slide()

func setPlayerDirection(direction):
	player_direction = direction
	return

func shoot(direction):
	if direction == null or not can_shoot or respawning:
		return
	print("shooting")
	var bullet_instance = bullet.instantiate()
	var loc = Vector2(global_position.x, global_position.y)
	bullet_instance.global_position = loc
	bullet_instance.velocity = Vector2(cos(direction), sin(direction)) 
	bullet_instance.rotation = direction
	bullet_instance.bulletID = bulletID
	scene_root.add_child(bullet_instance)
	can_shoot = false
	timer.start()
	print("bullet added")
	print(Vector2(cos(direction) * 200, sin(direction) * 200) )


func _on_timer_timeout() -> void:
	can_shoot = true
	pass # Replace with function body.


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.get_name() == "bullet_hurtbox" and not respawning:
		var b = area.get_parent()
		if b.collisions < 3 or b.bulletID != bulletID:
			drop_flag()
			position = original_position
			respawning = true
			respawn_timer.wait_time = Time.get_ticks_msec()/15000 + 2 
			respawn_timer.start()
			$Countdown.text = str(round(respawn_timer.time_left))
			$Polygon2D.color = Color(0, 0, 0)
			
			b.queue_free()
			print("bullet hit")
			
	if area.get_name() == "flag_hitbox" and !carrying_flag and area.get_parent() != $Flag:
		pickup_flag(area)
	
	if area.get_name() == "base_hitbox" and carrying_flag:
		if area.get_parent().team != carrying_team:
			print("flag captured")
			if area.get_parent().team == 0:
				get_tree().root.add_child(bluewin.instantiate())
			else:
				get_tree().root.add_child(redwin.instantiate())


func pickup_flag(area):
	if respawning:
		return
	carrying_flag = true
	area.get_parent().visible = false
	$Flag.visible = true
	$Flag.get_node("Polygon2D").color = area.get_parent().get_node("Polygon2D").color
	carry_flag = area.get_parent()
	carrying_team = area.get_parent().team
		
func drop_flag():
	if !carrying_flag:
		return
	carrying_flag = false
	carry_flag.visible = true
	carry_flag.global_position = global_position
	$Flag.visible = false
	carry_flag = null
	carrying_team = -1


func _on_respawn_timer_timeout() -> void:
	respawning = false
	$Polygon2D.color = og_color
	$Countdown.text = ""
	
	
	
