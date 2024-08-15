extends CharacterBody2D

class_name Player

@onready var cooldown_timer = $CooldownTimer
@onready var ability_container = $AbilityContainer
@onready var ability_box = $AbilityBox
@onready var animated_sprite = $AnimatedSprite2D
@onready var sweat_particles = $SweatParticles
#@onready var player_jump_noise = $PlayerJumpNoise

@onready var light_orb_scene = preload("res://scenes/light_orb_ability.tscn")
@onready var clock_scene = preload("res://scenes/clock_ability.tscn")

@export var gravity = 400
@export var speed = 150
@export var jump_force = 225

var facing_direction = "right"
var is_active = true

func _process(delta):
	if Input.is_action_just_pressed("cast_ability") && cooldown_timer.is_stopped():
		cast_ability()

func _physics_process(delta):
	if is_active == true:
		if is_on_floor() == false:
			velocity.y += gravity * delta
			
			if Input.is_action_pressed("dive_down"):
				velocity.y += gravity * delta * 3
				print(gravity * delta * 2)
				print("y velocity: " + str(velocity.y))
				#cap for dive speed
				if velocity.y > 600:
					velocity.y = 600
			
			if velocity.y > 200 && !Input.is_action_pressed("dive_down"):
				velocity.y = 200
		
		if Input.is_action_just_pressed("jump") && is_on_floor() == true:
			#player_jump_noise.play()
			jump(jump_force)
		
		var direction = Input.get_axis("move_left", "move_right")
		velocity.x += direction * speed
		
		if Input.is_action_pressed("sprint") && is_on_floor() == true:
			print("we are inside")
			velocity.x += direction * speed * 2
			if velocity.x > 300:
					velocity.x = 300
			
			if velocity.x < -300:
					velocity.x = -300
		
		if direction == 0:
			velocity.x = 0
		
		if direction == 1:
			facing_direction = "right"
		
		if direction == -1:
			facing_direction = "left"
		
		if direction != 0:
			animated_sprite.flip_h = direction == -1
		
		if Input.is_action_just_released("move_left") || Input.is_action_just_released("move_right"):
			velocity.x = 0
		
		if velocity.x > 200 && !Input.is_action_pressed("sprint"):
			velocity.x = 200
		
		if velocity.x > 200 && is_on_floor() == false:
			velocity.x = 200
		
		if velocity.x < -200 && !Input.is_action_pressed("sprint"):
			velocity.x = -200
		
		if velocity.x < -200 && is_on_floor() == false:
			velocity.x = -200
		
		move_and_slide()
		
		print("x velocity: " + str(velocity.x))
		
		update_animations(direction)

func jump(force):
	velocity.y = -force

#func to determine which ability instance to create & return to cast_ability
func determine_ability():
	#get ability via the string value in ability box child node
	var current_ability = ability_box.current_ability
	
	if(current_ability == "lightorb"):
		var light_orb_instance = light_orb_scene.instantiate()
		return light_orb_instance
	
	if(current_ability == "clock"):
		var clock_instance = clock_scene.instantiate()
		return clock_instance

func cast_ability():
	var ability_instance = determine_ability()
	
	cooldown_timer.start()
	
	ability_container.add_child(ability_instance)
	
	ability_instance.global_position = global_position
	
	if facing_direction == "right":
		ability_instance.direction = "right"
		ability_instance.global_position.x += 30
	
	if facing_direction == "left":
		ability_instance.sprite_texture.flip_h = true
		ability_instance.direction = "left"
		ability_instance.global_position.x += -30


func update_animations(direction):
	if is_active == true:
		if is_on_floor():
			if direction == 0:
				animated_sprite.play("idle")
				sweat_particles.emitting = false
			elif Input.is_action_pressed("sprint"):
				animated_sprite.play("sprint")
				sweat_particles.emitting = true
			else:
				animated_sprite.play("run")
				sweat_particles.emitting = false
		else:
			if velocity.y < 0:
				animated_sprite.play("jump")
				sweat_particles.emitting = false
			else:
				animated_sprite.play("fall")
				sweat_particles.emitting = false
