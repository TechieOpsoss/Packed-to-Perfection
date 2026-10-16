extends Node2D

@onready var sprite: Sprite2D = $AlienSprite
var alien_data: Alien 

func setup(data: Alien) -> void:
	alien_data = data
	sprite.texture = data.texture
