extends Sprite2D

@onready var current_ability_sprite = $CurrentAbilitySprite
@onready var light_orb_texture = preload("res://assets/sprites/abilities/blueorb.png")
@onready var clock_texture = preload("res://assets/sprites/abilities/clock_ability_sprite.png")

#this variable may need to be passed in from the parent node Player
var current_ability = "lightorb"

func _ready():
	current_ability_sprite.texture = light_orb_texture
	current_ability_sprite.scale = Vector2(0.25, 0.25)

func _process(_delta):
	switch_ability()

func switch_ability():
	if Input.is_action_just_pressed("switch_ability"):
		if current_ability == "lightorb":
			current_ability_sprite.texture = clock_texture
			current_ability_sprite.scale = Vector2(0.16, 0.16)
			current_ability = "clock"
		else:
			current_ability_sprite.texture = light_orb_texture
			current_ability_sprite.scale = Vector2(0.25, 0.25)
			current_ability = "lightorb"
