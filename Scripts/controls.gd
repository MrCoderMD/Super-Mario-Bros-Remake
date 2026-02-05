extends Node2D

var drag_button:TouchScreenButton
var scale_button:TouchScreenButton
var is_customizable:=false

func _ready() -> void:
	z_index=50
	var layout=Configfile.load_control_settings()
	var scaled
	for button in self.get_children():
		button.position=layout[button.pos_key]
		scaled=layout[button.scale_key]
		button.scale=Vector2(scaled,scaled)
		button.modulate.a=layout[button.opacity_key]

func _on_left_button_pressed() -> void:
	$LeftButton/Sprite2D.modulate=Color(1,1,1,0.5) # Replace with function body.

func _on_left_button_released() -> void:
	$LeftButton/Sprite2D.modulate=Color(1,1,1,1) # Replace with function body.


func _on_right_button_pressed() -> void:
	$RightButton/Sprite2D.modulate=Color(1,1,1,0.5) # Replace with function body.


func _on_right_button_released() -> void:
	$RightButton/Sprite2D.modulate=Color(1,1,1,1) # Replace with function body.


func _on_up_button_pressed() -> void:
	$UpButton/Sprite2D.modulate=Color(1,1,1,0.5) # Replace with function body.


func _on_up_button_released() -> void:
	$UpButton/Sprite2D.modulate=Color(1,1,1,1) # Replace with function body.


func _on_down_button_pressed() -> void:
	$DownButton/Sprite2D.modulate=Color(1,1,1,0.5) # Replace with function body.


func _on_down_button_released() -> void:
	$DownButton/Sprite2D.modulate=Color(1,1,1,1) # Replace with function body.


func _on_jump_button_pressed() -> void:
	$JumpButton/Sprite2D.modulate=Color(1,1,1,0.5) # Replace with function body.


func _on_jump_button_released() -> void:
	$JumpButton/Sprite2D.modulate=Color(1,1,1,1) # Replace with function body.


func _on_sprint_button_pressed() -> void:
	$SprintButton.modulate=Color(1,1,1,0.5) # Replace with function body.


func _on_sprint_button_released() -> void:
	$SprintButton.modulate=Color(1,1,1,1) # Replace with function body.
