extends CharacterBody2D


@export var speed = 60
var size  : int = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_input():
	if Input.is_action_pressed('ui_right'):
		velocity.x = 1
		velocity.y = 0
	elif Input.is_action_pressed('ui_left'):
		velocity.x = -1
		velocity.y = 0
	elif Input.is_action_pressed('ui_down'):
		velocity.y = 1
		velocity.x = 0
	elif Input.is_action_pressed('ui_up'):
		velocity.y = -1
		velocity.x = 0
	velocity = (velocity.normalized() * speed)
	print(velocity)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	get_input()
	move_and_slide()

func set_size(new_size):
	size = new_size

func _draw():
	draw_rect(Rect2(position, Vector2(size,size)), Color.AQUA)
	
func stop_movement():
	velocity = Vector2.ZERO
