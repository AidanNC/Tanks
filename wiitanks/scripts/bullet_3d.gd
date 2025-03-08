extends CharacterBody3D

var speed = 10
var collisions = 3
var bulletID = -1

func _physics_process(delta: float) -> void:
	
	var col = move_and_collide(Vector3(velocity.x, velocity.y, velocity.z) * speed * delta)

	if(col != null):
		collisions -= 1
		if(collisions < 0):
			
			queue_free()
		var angle = col.get_normal()
		print(angle)
		#for now we will only use walls along right angles
		if abs(angle.x) > 0.5:
			velocity.x *= -1
			rotation = -rotation
			# rotation.y -= 90
			
		if abs(angle.z) > 0.5:
			velocity.z *= -1
			rotation = -rotation
			

			
		
			
		
