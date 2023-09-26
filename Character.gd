extends CharacterBody2D


@export var speed = 60
var size  : int = 2
var player : int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_input():
	var remX =  int(position.x) % size
	var remY =  int(position.y) % size
	if Input.is_action_pressed('right_p'+str(player)):
		velocity.x = 1
		velocity.y = 0
		position.y -= remY
	elif Input.is_action_pressed('left_p'+str(player)):
		velocity.x = -1
		velocity.y = 0
		position.y -= remY
	elif Input.is_action_pressed('down_p'+str(player)):
		velocity.y = 1
		velocity.x = 0
		position.x -= remX
	elif Input.is_action_pressed('up_p'+str(player)):
		velocity.y = -1
		velocity.x = 0
		position.x -= remX
	velocity = (velocity.normalized() * speed)

func _physics_process(delta):
	get_input()
	move_and_slide()

func set_size(new_size):
	size = new_size

func _draw():
	draw_rect(Rect2(position, Vector2(size,size)), Color.AQUA)
	
func stop_movement():
	velocity = Vector2.ZERO
