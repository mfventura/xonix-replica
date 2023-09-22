extends Node2D


var size : float = 5
var width: float = 200
var height: float = 100
var offset = 50

@export var char : CharacterBody2D

var boardData = []
var floodCells = []

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Ready")
	_buildBoard()


func _buildBoard():
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
	var x = int(char.position.x - offset)/5;
	var y = int(char.position.y - offset)/5;
	if(x >= 0 && x < width && y >= 0 && y < height):
		var cell = boardData[x][y];
		if(cell.val != -1 && cell.val != 1):
			var row = boardData[x]
			cell.val = -1
			row[y] = cell
			boardData[x] = row
			#floodfill array
			floodCells.append(cell)
			queue_redraw()
		elif(cell.val == 1):
			floodfill()
	else:
		floodfill()

func floodfill():
	if(floodCells.size() > 0):
		for cell in floodCells:
			var x = int(cell.x - offset)/5
			var y = int(cell.y - offset)/5
			boardData[x][y].val = 1
		var lastCell = floodCells[floodCells.size()-1]
		print(lastCell)
		floodCells.clear()
		print(lastCell)
		queue_redraw()
		flood_fill(lastCell)

var floodQ = []

func flood_fill_arr(arr):
	pass

func flood_fill(cell):
	if(cell.val != 0):
		pass
	floodQ.append(cell)
	for floodCell in floodQ:
		var w = floodCell
		var e = floodCell
		
		var wStop = false
		var eStop = false
		while !wStop:
			var x = int((w.x-offset)/5)-1
			var y = int((w.y-offset)/5)
			if(x <= 0):
				wStop = true
			else:
				var leftCell = boardData[x][y]
				if(leftCell.val == 0):
					boardData[x][y].val = 2
					if(y-1 >= 0):
						floodQ.append(boardData[x][y-1])
					if(y+1 < height):
						floodQ.append(boardData[x][y+1])
					w = leftCell
				else:
					wStop = true
		while !eStop:
			var x = int((e.x-offset)/5)+1
			var y = int((e.y-offset)/5)
			if(x >= width):
				eStop = true
			else:
				var rightCell = boardData[x][y]
				if(rightCell.val == 0):
					boardData[x][y].val = -2
					if(y-1 >= 0):
						floodQ.append(boardData[x][y-1])
					if(y+1 < height):
						floodQ.append(boardData[x][y+1])
					e = rightCell
				else:
					eStop = true
		queue_redraw()
	
	#    Flood-fill (node, target-color, replacement-color):
	"""
	1. Asignar Q a una cola vacía.
	2. Si el color de node no es target-color, retornar.
	3. Agregar node a Q.
	4. Para cada elemento n de Q:
	5. Si el color de n es target-color:
	6. Asignar w y e iguales a n.
	7. Mover w a la izquierda hasta que el color del nodo a la izquierda de w ya no coincida con target-color.
	8. Mover e a la derecha hasta que el color del nodo a la derecha de e ya no coincida con target-color.
	9. Asignar el color de los nodos entre w y e a replacement-color.
	
	10. Para cada nodo n entre w y e:
	11. Si el color del nodo arriba de n es target-color, agregar ese nodo a Q.
	Si el color del nodo debajo de n es target-color, agregar ese nodo a Q.
	12. Continuar el bucle hasta que Q quede vacía.
	13. Retornar.
	"""
	pass
	
func _draw():
	for row in boardData:
		for cell in row:
			var color = Color.WHITE
			if(cell.val == -1):
				color = Color.RED
			elif (cell.val== 1):
				color = Color.BLACK
			elif (cell.val == -2):
				color = Color.BLUE
			elif (cell.val == 2):
				color = Color.BLUE_VIOLET
			var rect = Rect2(cell.x, cell.y , size, size)
			draw_rect(rect, color, true)
