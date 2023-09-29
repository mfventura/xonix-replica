extends CharacterBody2D


@export var speedFactor = 20
@export var speed = 200
var player : int = 1
var currentPositionInBoard = Vector2.ZERO

func _ready():
	speed = Globals.size * speedFactor
	get_tree().get_root().connect("size_changed", resize)

func resize():
	position = currentPositionInBoard * Globals.size

func get_input():
	"""
	var remX =  int(position.x) % Globals.size
	var remY =  int(position.y) % Globals.size
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
	"""
	var input_direction = Input.get_vector('left_p'+str(player), 'right_p'+str(player), 'up_p'+str(player), 'down_p'+str(player))
	velocity = input_direction * speed

func _physics_process(delta):
	get_input()
	move_and_slide()
	var x = int(position.x / Globals.size)
	var y = int(position.y / Globals.size)
	if (x<0) :
		position.x = 0
		stop_movement()
	if (y<0) :
		position.y = 0
		stop_movement()
	if(x>Globals.width):
		position.x = (Globals.width*Globals.size)-(Globals.size)
		stop_movement()
	if(y>Globals.height):
		position.y = (Globals.height*Globals.size)-Globals.size
		stop_movement()
		
	x = int(position.x / Globals.size)
	y = int(position.y / Globals.size)
	currentPositionInBoard = Vector2(x,y)

func stop_movement():
	velocity = Vector2.ZERO
	position.y -= int(position.y) % Globals.size
	position.x -= int(position.x) % Globals.size
	
