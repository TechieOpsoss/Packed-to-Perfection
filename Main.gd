extends Control

@export var lightsOff: Texture2D
@export var lightsFlicker: Array[Texture2D]
@export var lightsOn: Texture2D

func _ready():
	$Background.texture = lightsOff

func flicker_on():
	for i in range(1, 10):
		$Background.texture = lightsFlicker[i % lightsFlicker.size()]
		await get_tree().create_timer(0.1 / sqrt(i)).timeout
	$Background.texture = lightsOn

func up2():
	while position.y > -149:
		position.y = lerp(position.y, -150.0, 0.05)
		await get_tree().create_timer(0.01).timeout
	position.y = -150

func up():
	while position.y > -120:
		position.y = lerp(position.y, -150.0, 0.05)
		await get_tree().create_timer(0.01).timeout
	up2()

func down():
	while position.y < -1:
		position.y = lerp(position.y, 0.0, 0.05)
		await get_tree().create_timer(0.01).timeout
	position.y = 0
