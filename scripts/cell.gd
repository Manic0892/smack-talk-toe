extends Button

signal cell_clicked(cell_name: String)

func _pressed():
	cell_clicked.emit(name)
