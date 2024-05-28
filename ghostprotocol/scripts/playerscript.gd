extends CharacterBody2D

var ACCELERATION = 2000
var MAX_SPEED = 120
const FRICTION = 800

var lookat = "mouse"
var playerstate
var shooting
var action = "gunsout"

@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")

@rpc func _set_position(pos):
	global_transform.origin = pos

func movementype(delta):
	move(delta)
	move_and_slide()
					
func move(delta):
	$Camera2D.enabled = true
	var mouseposition = get_global_mouse_position()
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	input_vector.y = Input.get_action_strength("Down") - Input.get_action_strength("Up")
	input_vector = input_vector.normalized()
	match action:
		"gunsout":
			if input_vector != Vector2.ZERO:
				if Input.is_action_pressed("Shift"):
					lookat = "direction"
					playerstate = "running"
					animationState.travel("Run")
					playerstatefunc()
				else:
					lookat = "mouse"
					playerstate = "shooting"
					animationState.travel("RunShoot")
					playerstatefunc()
				lookatfunc(input_vector, mouseposition)
				velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
			else:
				lookat = "mouse"
				playerstate = "shooting"
				playerstatefunc()
				lookatfunc(input_vector, mouseposition)
				animationState.travel("IdleShoot")
				velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
		"casing":
			if input_vector != Vector2.ZERO:
				if Input.is_action_pressed("Shift"):
					lookat = "direction"
					playerstate = "running"
					animationState.travel("Run")
					playerstatefunc()
				else:
					lookat = "direction"
					playerstate = "walk"
					animationState.travel("Run")
					playerstatefunc()
				lookatfunc(input_vector, mouseposition)
				velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
			else:
				lookat = "direction"
				playerstate = "walk"
				animationState.travel("Idle")
				playerstatefunc()
				velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
					
func lookatfunc(input_vector, mouseposition):
	match lookat:
		"mouse":
			animationTree.set("parameters/Idle/blend_position", mouseposition - position)
			animationTree.set("parameters/Run/blend_position", mouseposition - position)
			animationTree.set("parameters/IdleShoot/blend_position", mouseposition - position)
			animationTree.set("parameters/RunShoot/blend_position", mouseposition - position)
		"direction":
			animationTree.set("parameters/Idle/blend_position", input_vector)
			animationTree.set("parameters/Run/blend_position", input_vector)
			animationTree.set("parameters/IdleShoot/blend_position", input_vector)
			animationTree.set("parameters/RunShoot/blend_position", input_vector)
			
func playerstatefunc():
	match playerstate:
		"running":
			$Hands.hide()
			$bulletpoint.hide()
			$Gun.hide()
			$bulletpoint.aimingstate = true
			ACCELERATION = 2300
			MAX_SPEED = 200
			
		"walk":
			$Hands.hide()
			$bulletpoint.hide()
			$Gun.hide()
			$bulletpoint.aimingstate = true
			ACCELERATION = 20000
			MAX_SPEED = 120
			
		"shooting":
			$Gun.show()
			$Hands.show()
			$Gun.look_at(get_global_mouse_position())
			$Head.look_at(get_global_mouse_position())
			$Hands.look_at(get_global_mouse_position())
			$bulletpoint.show()
			$bulletpoint.aimingstate = false
			ACCELERATION = 2000
			MAX_SPEED = 120

func _physics_process(delta):
	movementype(delta)
	

