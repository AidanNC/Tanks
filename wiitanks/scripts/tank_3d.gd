extends CharacterBody3D

@export var bullet: PackedScene
@onready var scene_root = get_tree().root.get_children()[0]
@onready var timer = $Timer

var can_shoot = true
var bulletID = RandomNumberGenerator.new().randi_range(0, 1000000)
var player_direction = null
var speed = 5.0

func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	if player_direction != null:
		velocity.x = cos(player_direction) * speed
		velocity.z = sin(player_direction) * speed

		move_and_slide()


func setPlayerDirection(direction):
	player_direction = direction
	if player_direction != null:
		rotation = Vector3(0,-player_direction, 0)

func shoot(direction):
	if direction == null || !can_shoot:
		return
	print("shooting")
	var bullet_instance = bullet.instantiate()
	var loc = Vector3(global_position.x, global_position.y, global_position.z)
	bullet_instance.global_position = loc
	bullet_instance.velocity = Vector3(cos(direction),0, sin(direction)) 
	bullet_instance.rotation = Vector3(0,-direction, 0)
	bullet_instance.bulletID = bulletID
	scene_root.add_child(bullet_instance)
	can_shoot = false
	timer.start()


func _on_timer_timeout() -> void:
	can_shoot = true
	pass # Replace with function body.
