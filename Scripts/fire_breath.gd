extends Area2D

var dir:int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	$AnimatedSprite2D.flip_h=(dir>0)
	var tween=get_tree().create_tween()
	tween.tween_property(self,"global_position:y",16*randi_range(-1,1),0.75).as_relative()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position.x+=dir*delta*150


func _on_body_entered(body):
	if body.name=="Mario":
		body.shrink_or_die() # Replace with function body.
