extends Node2D


var size : float = 10
var width: float = 100
var height: float = 100
var offset = 0

@export var char : CharacterBody2D

var fillCells = []

# Called when the node enters the scene tree for the first time.
func _ready():
	_buildBoard()
	char.set_size(size)

func restart():
	char.stop_movement()
	char.position = Vector2.ZERO
	_buildBoard()
	queue_redraw()


func _buildBoard():
	Globals.boardData = []
	fillCells = []
	for x in width:
		var row = []
		for y in height:
			row.append({
				"val": 1 if (x == 0 || x== width-1 || y == 0 || y == height-1) else 0,
				"x" : x,
				"y" : y
			})
		Globals.boardData.append(row)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	var x = int(char.position.x - offset)/size;
	var y = int(char.position.y - offset)/size;
	if(x >= 0 && x < width && y >= 0 && y < height):
		var cell = Globals.boardData[x][y]
		if(cell.val == 0):
			var row = Globals.boardData[x]
			cell.val = -1
			row[y] = cell
			Globals.boardData[x] = row
			fillCells.append(cell)
			queue_redraw()
		elif(cell.val == 1):
			floodfill()
		elif(cell.val == -1):
			var lastCell = fillCells.back()
			if(lastCell.x != cell.x || cell.y != lastCell.y):
				restart()
	else:
		floodfill()

func floodfill():
	if(fillCells.size() > 0):
		char.stop_movement()
		for cell in fillCells:
			Globals.boardData[cell.x][cell.y].val = 1
		var lastCell = fillCells[fillCells.size()-1]
		fillCells.clear()
		queue_redraw()
		
		flood_fill(lastCell)

func flood_fill(lastCell):
	var sides = []
	if((lastCell.y+1 > 0 && lastCell.y+1 < height) && Globals.boardData[lastCell.x][lastCell.y+1].val == 0):
		sides.append(Globals.boardData[lastCell.x][lastCell.y+1])
	if((lastCell.y-1 > 0 && lastCell.y-1 < height) && Globals.boardData[lastCell.x][lastCell.y-1].val == 0):
		sides.append(Globals.boardData[lastCell.x][lastCell.y-1])
	if((lastCell.x-1 > 0 && lastCell.x-1 < width) && Globals.boardData[lastCell.x-1][lastCell.y].val == 0):
		sides.append(Globals.boardData[lastCell.x-1][lastCell.y])
	if((lastCell.x+1 > 0 && lastCell.x+1 < width) && Globals.boardData[lastCell.x+1][lastCell.y].val == 0):
		sides.append(Globals.boardData[lastCell.x+1][lastCell.y])
	if(sides.size() == 2):
		var side1 = []
		var side2 = []
		#Aplicar flood_fill a los dos lados
		print("Area 1")
		calculate_area_flood_fill(sides[0], side1)
		print("Area 2")
		calculate_area_flood_fill(sides[1], side2)
		print("Fill")
		if(side1.size() <= side2.size()):
			for cell in side1:
				Globals.boardData[cell.x][cell.y].val = 1
			for cell in side2:
				Globals.boardData[cell.x][cell.y].val = 0
		else:
			for cell in side2:
				Globals.boardData[cell.x][cell.y].val = 1
			for cell in side1:
				Globals.boardData[cell.x][cell.y].val = 0
		queue_redraw()

func calculate_area_flood_fill(node, arr):
	var floodQ = []
	floodQ.append(node)
	arr.append(node)
	
	for floodCell in floodQ:
		var w = floodCell
		var e = floodCell
		if(floodCell.val == 0):
			arr.append(floodCell)
			Globals.boardData[floodCell.x][floodCell.y].val = 2
		
		fillDirection(-1, Vector2(floodCell.x, floodCell.y), floodQ, arr)
		fillDirection(1, Vector2(floodCell.x, floodCell.y), floodQ, arr)
		
func fillDirection(direction, currentPosition, floodQ, arr):
	var directionStop : bool = false
	while !directionStop:
		var x = currentPosition.x+direction
		var y = currentPosition.y
		if(x <= 0):
			directionStop = true
		else:
			var directionCell = Globals.boardData[x][y]
			if(directionCell.val == 0):
				arr.append(directionCell)
				Globals.boardData[x][y].val = 2
				if(y-1 >= 0):
					floodQ.append(Globals.boardData[x][y-1])
				if(y+1 < height):
					floodQ.append(Globals.boardData[x][y+1])
				currentPosition = Vector2(x, y)
			else:
				directionStop = true

func _draw():
	for row in Globals.boardData:
		for cell in row:
			var color = Color.WHITE
			if(cell.val == -1):
				color = Color.RED
			elif (cell.val== 1):
				color = Color.BLACK
			elif(cell.val == 2):
				color = Color.AQUA
			var rect = Rect2(cell.x*size+offset, cell.y*size+offset, size, size)
			draw_rect(rect, color, true)
