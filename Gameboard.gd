extends Node2D


var size : float = 20
var width: float = 20
var height: float = 20
var offset = 50

@export var char : CharacterBody2D

var boardData = []
var floodFill = []
var fillCells = []

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Ready")
	_buildBoard()
	char.set_size(size)
	
func restart():
	_buildBoard()
	queue_redraw()


func _buildBoard():
	boardData = []
	floodFill = []
	fillCells = []
	for x in width:
		var row = []
		for y in height:
			row.append({
				"val": 1 if (x == 0 || x== width-1 || y == 0 || y == height-1) else 0,
				"x" : x*size+offset,
				"y" : y*size+offset
			})
		boardData.append(row)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	var x = int(char.position.x - offset)/size;
	var y = int(char.position.y - offset)/size;
	if(x >= 0 && x < width && y >= 0 && y < height):
		var cell = boardData[x][y]
		if(cell.val == 0):
			var row = boardData[x]
			cell.val = -1
			row[y] = cell
			boardData[x] = row
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
		for cell in fillCells:
			var x = int(cell.x - offset)/size
			var y = int(cell.y - offset)/size
			boardData[x][y].val = 1
		var lastCell = fillCells[fillCells.size()-1]
		fillCells.clear()
		queue_redraw()
		
		flood_fill(lastCell)

func flood_fill(lastCell):
	var x = int(lastCell.x - offset)/size
	var y = int(lastCell.y - offset)/size
	var sides = []
	if((y+1 > 0 && y+1 < height) && boardData[x][y+1].val == 0):
		print("Abajo")
		sides.append(boardData[x][y+1])
	if((y-1 > 0 && y-1 < height) && boardData[x][y-1].val == 0):
		print("Arriba")
		sides.append(boardData[x][y-1])
	if((x-1 > 0 && x-1 < width) && boardData[x-1][y].val == 0):
		print("Izquierda")
		sides.append(boardData[x-1][y])
	if((x+1 > 0 && x+1 < width) && boardData[x+1][y].val == 0):
		print("Derecha")
		sides.append(boardData[x+1][y])
	if(sides.size() == 2):
		print(sides[0])
		print(sides[1])
		var side1 = []
		var side2 = []
		#Aplicar flood_fill a los dos lados
		calculate_area_flood_fill(sides[0], side1)
		calculate_area_flood_fill(sides[1], side2)
		print("------------------------------------------------------")
		print(side1.size())
		print(side2.size())
		print("------------------------------------------------------")
		if(side1.size() <= side2.size()):
			for cell in side1:
				x = int((cell.x - offset)/size)
				y = int((cell.y - offset)/size)
				boardData[x][y].val = 1
			for cell in side2:
				x = int((cell.x - offset)/size)
				y = int((cell.y - offset)/size)
				boardData[x][y].val = 0
		else:
			for cell in side2:
				x = int((cell.x - offset)/size)
				y = int((cell.y - offset)/size)
				boardData[x][y].val = 1
			for cell in side1:
				x = int((cell.x - offset)/size)
				y = int((cell.y - offset)/size)
				boardData[x][y].val = 0
		queue_redraw()
	
func calculate_area_flood_fill(node, arr):
	var floodQ = []
	floodQ.append(node)
	arr.append(node)
	
	for floodCell in floodQ:
		var w = floodCell
		var e = floodCell
		var x = int((floodCell.x-offset)/size)
		var y = int((floodCell.y-offset)/size)
		if(floodCell.val == 0):
			arr.append(floodCell)
			boardData[x][y].val = 2
		var wStop = false
		var eStop = false
		while !wStop:
			x = int((w.x-offset)/size)-1
			y = int((w.y-offset)/size)
			if(x <= 0):
				wStop = true
			else:
				var leftCell = boardData[x][y]
				if(leftCell.val == 0):
					arr.append(leftCell)
					boardData[x][y].val = 2
					if(y-1 >= 0):
						floodQ.append(boardData[x][y-1])
					if(y+1 < height):
						floodQ.append(boardData[x][y+1])
					w = leftCell
				else:
					wStop = true
		
		while !eStop:
			x = int((e.x-offset)/size)+1
			y = int((e.y-offset)/size)
			if(x >= width):
				eStop = true
			else:
				var rightCell = boardData[x][y]
				if(rightCell.val == 0):
					arr.append(rightCell)
					boardData[x][y].val = 2
					if(y-1 >= 0):
						floodQ.append(boardData[x][y-1])
					if(y+1 < height):
						floodQ.append(boardData[x][y+1])
					e = rightCell
				else:
					eStop = true

func _draw():
	for row in boardData:
		for cell in row:
			var color = Color.WHITE
			if(cell.val == -1):
				color = Color.RED
			elif (cell.val== 1):
				color = Color.BLACK
			elif(cell.val == 2):
				color = Color.AQUA
			var rect = Rect2(cell.x, cell.y , size, size)
			draw_rect(rect, color, true)
