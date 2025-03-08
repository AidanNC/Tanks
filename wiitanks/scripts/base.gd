extends Node2D

@export var team: int
@export var color: Color

func _ready():
	$Polygon2D.color = color 
	


func _on_area_2d_area_entered(area: Area2D) -> void:
	print(area)
	if area.get_name() == "flag_hitbox":
		if area.get_parent().team != team:
			print("flag captured")
