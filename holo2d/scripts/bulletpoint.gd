extends Node2D

@export var speed = 100
@export var bullet_speed = 800
@export var fire_rate = 0.08

var bullet = preload("res://payman2/models/props/bullet.tscn")
var can_fire = true
var running = false
var shootingnetwork
var mouseposition
var secondaryweapon

@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")
@onready var animationPlayer2 = $AnimationPlayer2
@onready var animationTree2 = $AnimationTree2
@onready var animationState2 = animationTree2.get("parameters/playback")

func _ready():
	shootingnetwork = get_parent().state
	animationState2.travel("GunPistolAim")
	animationState.travel("PistolAim")

func direction():
	animationTree.set("parameters/PistolAim/blend_position", mouseposition - get_parent().position)
	animationTree.set("parameters/PistolShot/blend_position", mouseposition - get_parent().position)
	animationTree2.set("parameters/GunPistolAim/blend_position", mouseposition - get_parent().position)
	animationTree2.set("parameters/GunPistolShot/blend_position", mouseposition - get_parent().position)

func _physics_process(delta):
	mouseposition = get_global_mouse_position()
	direction()
	shoot()

func shoot():
	look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("Fire") and can_fire and running == false:
		get_parent().shooting = true
		var bullet_instance = bullet.instantiate()
		bullet_instance.position = $point.get_global_position()
		bullet_instance.rotation_degrees = rotation_degrees
		bullet_instance.apply_impulse(Vector2(bullet_speed, 0).rotated(rotation))
		get_tree().get_root().add_child(bullet_instance)
		can_fire = false
		animationState.travel("PistolShot")
		animationState2.travel("GunPistolShot")
		await get_tree().create_timer(fire_rate).timeout
		animationState2.travel("GunPistolAim")
		animationState.travel("PistolAim")
		can_fire = true
		get_parent().get_node("Glock").play()
	else:
		get_parent().shooting = false

func SecondaryWeaponFunc():
	match secondaryweapon:
		"pistol":
			pass
