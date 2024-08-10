extends PanelContainer

signal pressed

func _on_button_pressed():
	if Globals.apples >= Globals.UNLOCK_COST:
		pressed.emit()
