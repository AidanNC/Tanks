extends CharacterBody3D

var player_direction = null

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if player_direction != null:
		var speed = 5 
		velocity.x = cos(player_direction) * speed
		velocity.z = sin(player_direction) * speed

		rotation = Vector3(0,player_direction, 0)


func _physics_process(delta: float) -> void:
	if player_direction != null:
		move_and_slide()

func setPlayerDirection(direction):
	player_direction = direction
	print(player_direction)
	return
