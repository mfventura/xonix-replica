extends Node2D


var offset = 0

@export var char : CharacterBody2D
@export var ui : CanvasLayer

var fillCells = []
var emptyCells : int = 0
var filledCels : int = 0

func resize():
	var viewport = get_viewport_rect()
	var size1 = viewport.size.x / Globals.boardData.size()
	var size2 = viewport.size.y / Globals.boardData[0].size()
	Globals.size = min(size1, size2)
	char.speed = char.speedFactor * Globals.size

func _ready():
	get_tree().get_root().connect("size_changed", resize)
	var viewport = get_viewport_rect()
	Globals.width = viewport.size.x / Globals.size
	Globals.height = viewport.size.y / Globals.size
	_buildBoard()

func restart():
	#char.stop_movement()
	#char.position = Vector2.ZERO
	#_buildBoard()
	pass
	
func _process(delta):
	queue_redraw()
	check_score()
	draw_UI()

func draw_UI():
	var percentage : Label = ui.get_child(0)
	percentage.text = str(100 * filledCels / emptyCells)

func check_score():
	if(emptyCells != 0 && filledCels >= 0.7 * emptyCells):
		restart()

func _buildBoard():
	Globals.boardData = []
	fillCells = []
	for x in Globals.width:
		var row = []
		for y in Globals.height:
			row.append({
				"val": 1 if (x == 0 || x== Globals.width-1 || y == 0 || y == Globals.height-1) else 0,
				"x" : x,
				"y" : y
			})
		Globals.boardData.append(row)
	var emptyRows = Globals.boardData.size() - 2
	var emptyColumns = Globals.boardData[0].size()-2
	emptyCells = (emptyRows*emptyColumns)
	filledCels = 0
	

func _physics_process(delta):
	var x = int(char.position.x)/Globals.size;
	var y = int(char.position.y)/Globals.size;
	if(x >= 0 && x < Globals.width && y >= 0 && y < Globals.height):
		var cell = Globals.boardData[x][y]
		if(cell.val == 0):
			var row = Globals.boardData[x]
			cell.val = -1
			row[y] = cell
			Globals.boardData[x] = row
			fillCells.append(cell)
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
		
		flood_fill(lastCell)

func flood_fill(lastCell):
	var sides = []
	if((lastCell.y+1 > 0 && lastCell.y+1 < Globals.height) && Globals.boardData[lastCell.x][lastCell.y+1].val == 0):
		sides.append(Globals.boardData[lastCell.x][lastCell.y+1])
	if((lastCell.y-1 > 0 && lastCell.y-1 < Globals.height) && Globals.boardData[lastCell.x][lastCell.y-1].val == 0):
		sides.append(Globals.boardData[lastCell.x][lastCell.y-1])
	if((lastCell.x-1 > 0 && lastCell.x-1 < Globals.width) && Globals.boardData[lastCell.x-1][lastCell.y].val == 0):
		sides.append(Globals.boardData[lastCell.x-1][lastCell.y])
	if((lastCell.x+1 > 0 && lastCell.x+1 < Globals.width) && Globals.boardData[lastCell.x+1][lastCell.y].val == 0):
		sides.append(Globals.boardData[lastCell.x+1][lastCell.y])
	
	
	
	if(sides.size() == 2):
		var side1 = []
		var side2 = []
		calculate_area_flood_fill(sides[0], side1)
		calculate_area_flood_fill(sides[1], side2)
		if(side1.size() <= side2.size()):
			for cell in side1:
				Globals.boardData[cell.x][cell.y].val = 1
				filledCels += 1
			for cell in side2:
				Globals.boardData[cell.x][cell.y].val = 0
		else:
			for cell in side2:
				Globals.boardData[cell.x][cell.y].val = 1
				filledCels += 1
			for cell in side1:
				Globals.boardData[cell.x][cell.y].val = 0

func calculate_area_flood_fill(node, arr):
	var floodQ = []
	floodQ.append(node)
	arr.append(node)
	
	while floodQ:
		#for floodCell in floodQ:
		var floodCell = floodQ.pop_front()
		fillDirection(-1, Vector2(floodCell.x - 1, floodCell.y), floodQ, arr)
		fillDirection(1, Vector2(floodCell.x, floodCell.y), floodQ, arr)

func fillDirection(direction, currentPosition, floodQ, arr):
	var directionStop : bool = false
	var x = currentPosition.x
	var y = currentPosition.y
	while !directionStop:
		if(x <= 0):
			directionStop = true
		else:
			var directionCell = Globals.boardData[x][y]
			if(directionCell.val == 0):
				arr.append(directionCell)
				Globals.boardData[x][y].val = 2
				if(y-1 >= 0):
					floodQ.append(Globals.boardData[x][y-1])
				if(y+1 < Globals.height):
					floodQ.append(Globals.boardData[x][y+1])
			else:
				directionStop = true
		x += direction

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
			var rect = Rect2(cell.x*Globals.size, cell.y*Globals.size, Globals.size, Globals.size)
			draw_rect(rect, color, true)
			var charRect = Rect2(char.currentPositionInBoard.x*Globals.size, char.currentPositionInBoard.y*Globals.size, Globals.size, Globals.size)
			draw_rect(charRect, Color.AQUA)
