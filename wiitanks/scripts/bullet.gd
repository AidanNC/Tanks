extends CharacterBody2D

var speed = 600
var collisions = 3
var bulletID = -1
func _physics_process(delta: float) -> void:
	
	var col = move_and_collide(Vector2(velocity.x, velocity.y) * speed * delta)

	if(col != null):
		collisions -= 1
		if(collisions < 0):
			
			queue_free()
		var angle = col.get_normal()
		print(angle)
		#for now we will only use walls along right angles
		if abs(angle.x) > 0.5:
			velocity.x *= -1
		if abs(angle.y) > 0.5:
			velocity.y *= -1
		rotation = atan2(velocity.y, velocity.x) 
		
