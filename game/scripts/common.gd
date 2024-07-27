extends Node

func get_cell_common_name(x: int, y: int):
	if (x == 1 and y == 1):
		return "middle"
	else:
		var x_description: String
		var y_description: String
		
		match(y):
			0:
				y_description = "top"
			1:
				y_description = "center"
			2:
				y_description = "bottom"
		
		match(x):
			0:
				x_description = "left"
			1:
				x_description = "middle"
			2:
				x_description = "right"

		return(y_description + " " + x_description)

func get_cell_coordinates_by_name(name: String):
	match(name):
		"cell1_1":
			return Vector2i(0,0)
		"cell1_2":
			return Vector2i(1,0)
		"cell1_3":
			return Vector2i(2,0)
		"cell2_1":
			return Vector2i(0,1)
		"cell2_2":
			return Vector2i(1,1)
		"cell2_3":
			return Vector2i(2,1)
		"cell3_1":
			return Vector2i(0,2)
		"cell3_2":
			return Vector2i(1,2)
		"cell3_3":
			return Vector2i(2,2)

func get_cell_name_by_coordinates(coords: Vector2i):
	return "cell" + str(coords.y + 1)  + "_" + str(coords.x + 1)
