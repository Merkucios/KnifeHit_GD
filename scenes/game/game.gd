extends Node2D

var restart_overlay_scene = preload("res://elements/ui/restart_overlay/restart_overlay.tscn")

@onready var knife_shooter = $KnifeShooter 

func _ready():
	Events.game_over.connect(end_game)

func end_game():
	knife_shooter.is_enabled = false
	Globals.reset_points()
	show_restart_overlay()

func show_restart_overlay():
	add_child(restart_overlay_scene.instantiate())
	Hud.update_hud_restart()
