extends CanvasLayer

@onready var sizeslider=$MarginContainer/VBoxContainer/SizeHBox/SizeSlider
@onready var sizevalue=$MarginContainer/VBoxContainer/SizeHBox/SizeValue
@onready var visibleslider=$MarginContainer/VBoxContainer/VisibleHBox/VisibleSlider
@onready var visiblevalue=$MarginContainer/VBoxContainer/VisibleHBox/VisibleValue

var pressed:TouchScreenButton
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Controls.is_customizable=true
	
func _process(delta: float) -> void:
		if pressed == $MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Control/LeftButton:
			move_left()
		elif pressed == $MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Control2/RightButton:
			move_right()
		elif pressed == $MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Control3/UpButton:
			move_up()
		elif pressed == $MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Control4/DownButton:
			move_down()
		else:
			pass

func _on_size_slider_value_changed(value: float) -> void:
	sizevalue.text=str(int(sizeslider.value))
	var scaled=$Controls.scale_button.default_scale*float(sizeslider.value/100)
	$Controls.scale_button.scale=Vector2(scaled,scaled)


func _on_visible_slider_value_changed(value: float) -> void:
	visiblevalue.text=str(int(visibleslider.value)) # Replace with function body.
	$Controls.scale_button.modulate.a=visibleslider.value/100
	


func _on_left_button_pressed() -> void:
	pressed=$MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Control/LeftButton

func _on_right_button_pressed() -> void:
	pressed=$MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Control2/RightButton

func _on_up_button_pressed() -> void:
	pressed=$MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Control3/UpButton

func _on_down_button_pressed() -> void:
	pressed=$MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Control4/DownButton
	
func move_left():
	$Controls.scale_button.global_position.x-=1 # Replace with function body.
func move_right():
	$Controls.scale_button.global_position.x+=1 # Replace with function body.
func move_up():
	$Controls.scale_button.global_position.y-=1 # Replace with function body.
func move_down():
	$Controls.scale_button.global_position.y+=1 # Replace with function body.

func _on_left_button_released() -> void:
	pressed=TouchScreenButton.new() # Replace with function body.


func _on_right_button_released() -> void:
	pressed=TouchScreenButton.new() # Replace with function body.\


func _on_up_button_released() -> void:
	pressed=TouchScreenButton.new() # Replace with function body.


func _on_down_button_released() -> void:
	pressed=TouchScreenButton.new() # Replace with function body.


func _on_save_pressed() -> void:
	await Configfile.save_control_settings()
	$Controls.is_customizable=false
	if self!=get_tree().current_scene:
		self.queue_free()
	else:
		get_tree().change_scene_to_file("res://Scenes/options.tscn") # Replace with function body.


func _on_default_pressed() -> void:
	for button in $Controls.get_children():
		button.global_position=button.default_pos # Replace with function body.
		var scaled=button.default_scale
		button.scale=Vector2(scaled,scaled)
		button.modulate.a=1
		sizeslider.value=100
		visibleslider.value=100


func _on_cancel_pressed() -> void:
	if self!=get_tree().current_scene:
		self.queue_free()
	else:
		get_tree().change_scene_to_file("res://Scenes/options.tscn") # Replace with function body.
