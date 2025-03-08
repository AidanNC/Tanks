extends CharacterBody3D

var player_direction = null
var speed = 5.0

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if player_direction != null:
		velocity.x = cos(player_direction) * speed
		velocity.z = sin(player_direction) * speed

		# rotation = Vector3(0, player_direction, 0)

		move_and_slide()


func setPlayerDirection(direction):
	player_direction = direction
	if player_direction != null:
		rotation = Vector3(0,-player_direction, 0)
