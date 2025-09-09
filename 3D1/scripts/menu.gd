extends Control

@onready var play = $Play

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if(play.button_pressed): get_tree().change_scene_to_file("res://scenes/Level1.tscn")
