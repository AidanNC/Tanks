extends CharacterBody3D

@export var bullet: PackedScene
@export var max_lives = 3
@onready var scene_root = get_tree().root.get_children()[0]
@onready var timer = $Timer
@onready var cannon = $Cannon
@onready var lives_display = $LivesDisplay

var current_lives = max_lives
var can_shoot = true
var bulletID = RandomNumberGenerator.new().randi_range(0, 1000000)
var player_direction = null
var speed = 5.0


func _ready() -> void:
	current_lives = max_lives
	update_hearts_display()

	var hitbox = $HitBox
	hitbox.connect("body_entered", Callable(self, "_on_hit_box_body_entered"))
	return

func _on_hit_box_body_entered(body):
	if body.is_in_group("bullets") and body.bulletID != bulletID:
		print("HIT BOX ENTERED")
		take_damage()
		body.queue_free()

func _physics_process(_delta: float) -> void:
	if player_direction != null:
		velocity.x = cos(player_direction) * speed
		velocity.z = sin(player_direction) * speed
		move_and_slide()

func update_hearts_display() -> void:
	for i in range(1, max_lives + 1):
		var heart = lives_display.get_node("Heart" + str(i))
		heart.visible = i <= current_lives




func take_damage() -> void:
	current_lives -= 1
	update_hearts_display()
	if current_lives <= 0:
		on_death()

func on_death():
	queue_free()




func setPlayerDirection(direction):
	player_direction = direction
	if player_direction != null:
		rotation = Vector3(0,-player_direction, 0) 
		

func shoot(direction):
	
	if direction == null:
		return
	print("shoot " , direction)
	#cannon.rotation = Vector3(0,-direction, 0)
	#+90 because its rotate by 90 in the original scene
	cannon.global_rotation = Vector3(0,-direction+ PI/2, 0)
	if !can_shoot:
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
