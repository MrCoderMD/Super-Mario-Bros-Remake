extends Area2D

var points:=100
var can_move_down:=false
var can_move_up:=true
var type:="Plant"

var dir:=-1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play(get_tree().current_scene.palette)
	z_index=get_tree().current_scene.get_node("ForegroundTile").z_index-1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if dir==1:
		if can_move_down:
			can_move_down=false
			await plant_slide(dir)
			dir=-1
			can_move_up=true
	else:
		if can_move_up:
			if abs(get_tree().current_scene.get_node("Mario").global_position.x-global_position.x)>64:
				can_move_up=false
				await plant_slide(dir)
				dir=1
				can_move_down=true

func bounceoff(pos):
	var body=get_tree().current_scene.get_node("Mario")
	body.pop_up_score(100,pos)
	Global.score+=100
	var bounce=AudioStreamPlayer2D.new()
	bounce.stream=load("res://files/sounds/shot.wav")
	get_tree().current_scene.add_child(bounce)
	self.queue_free()


func _on_body_entered(body):
	if body.name=="Mario":
		if !body.is_invincible:
			body.shrink_or_die() # Replace with function body.
		else:
			bounceoff(self.global_position)

func plant_slide(direction):
	var tween=get_tree().create_tween()
	tween.tween_property(self,"global_position:y",direction*45,1.0).as_relative()
	await tween.finished
	tween.kill()
	self.set_collision_mask_value(2,(direction<0))
	#print((direction<0))
	await get_tree().create_timer(3).timeout
			
