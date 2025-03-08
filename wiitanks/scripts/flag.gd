extends Node2D

@export var team: int
@export var color: Color

func _ready():
	$Polygon2D.color = color 
