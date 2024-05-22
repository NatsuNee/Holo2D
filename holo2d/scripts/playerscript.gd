extends CharacterBody2D

var ACCELERATION = 2000
var MAX_SPEED = 120
const FRICTION = 800

var state = "singleplayer"
var mouseposition
var lookat = "mouse"
var running
var shooting

@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")

func _ready():
	var animationPlayer = $AnimationPlayer

@rpc func _set_position(pos):
	global_transform.origin = pos

func movementype(delta):
	match state:
		"singleplayer":
			move(delta)
			move_and_slide()
					
func move(delta):
	$Camera2D.enabled = true
	mouseposition = get_global_mouse_position()
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	input_vector.y = Input.get_action_strength("Down") - Input.get_action_strength("Up")
	input_vector = input_vector.normalized()
	if input_vector != Vector2.ZERO:
		if Input.is_action_pressed("Shift"):
			lookat = "direction"
			running = "true"
			animationState.travel("Run")
			runningfunc()
		else:
			lookat = "mouse"
			running = "false"
			animationState.travel("RunShoot")
			runningfunc()
		lookatfunc(input_vector, mouseposition - position)
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		lookat = "mouse"
		running = "false"
		runningfunc()
		lookatfunc(input_vector, mouseposition - position)
		animationState.travel("IdleShoot")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
					
func lookatfunc(input_vector, mouseposition):
	match lookat:
		"mouse":
			animationTree.set("parameters/Idle/blend_position", mouseposition)
			animationTree.set("parameters/Run/blend_position", mouseposition)
			animationTree.set("parameters/IdleShoot/blend_position", mouseposition)
			animationTree.set("parameters/RunShoot/blend_position", mouseposition)
		"direction":
			animationTree.set("parameters/Idle/blend_position", input_vector)
			animationTree.set("parameters/Run/blend_position", input_vector)
			animationTree.set("parameters/IdleShoot/blend_position", input_vector)
			animationTree.set("parameters/RunShoot/blend_position", input_vector)
			
func runningfunc():
	match running:
		"true":
			$Hands.hide()
			$bulletpoint.hide()
			$Gun.hide()
			$bulletpoint.running = true
			ACCELERATION = 2300
			MAX_SPEED = 200
		"false":
			$Gun.show()
			$Hands.show()
			$Gun.look_at(get_global_mouse_position())
			$Head.look_at(get_global_mouse_position())
			$Hands.look_at(get_global_mouse_position())
			$bulletpoint.show()
			$bulletpoint.running = false
			ACCELERATION = 2000
			MAX_SPEED = 120

func _physics_process(delta):
	movementype(delta)
	

