extends Area2D

class_name Clock

@export var travel_speed = 500

@onready var on_screen_notifier = $VisibleOnScreenNotifier2D
@onready var sprite_texture = $Sprite2D

var direction

func _ready():
	on_screen_notifier.connect("screen_exited", on_screen_exited)

func _physics_process(delta):
	if direction == "left":
		global_position.x += -travel_speed * delta
	
	if direction == "right":
		global_position.x += travel_speed * delta

func on_screen_exited():
	queue_free()
