extends CharacterBody2D

enum States{IDLE,COMP,RETR}
var state=States.IDLE

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var Jumped_body

var idle_texture={
	"overworld":load("res://files/images/spring_0.png"),
	"castle":load("res://files/images/spring1_0.png")
}

var comp1_texture={
	"overworld":load("res://files/images/spring_1.png"),
	"castle":load("res://files/images/spring1_1.png")
}

var comp2_texture={
	"overworld":load("res://files/images/spring_2.png"),
	"castle":load("res://files/images/spring1_2.png")
}


func _physics_process(_delta: float) -> void:
	match state:
		States.COMP:
			compress()
		States.RETR:
			retract()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name=="Mario":
		Jumped_body=body
		state=States.COMP
		$Sprite2D.texture=comp1_texture[get_tree().current_scene.palette] # Replace with function body.

func compress():
	var tween=get_tree().create_tween()
	tween.tween_property($CollisionShape2D,"shape:size:y",31,0.0625)
	await tween.finished
	tween.kill()
	$Sprite2D.texture=comp2_texture[get_tree().current_scene.palette] # Replace with function body.
	state=States.RETR
	
func retract():
	var tween=get_tree().create_tween()
	tween.tween_property($CollisionShape2D,"shape:size:y",46.5,0.03125)
	await tween.finished
	tween.stop()
	$Sprite2D.texture=comp1_texture[get_tree().current_scene.palette] # Replace with function body.
	tween.play()
	tween.tween_property($CollisionShape2D,"shape:size:y",62,0.03125)
	await tween.finished
	tween.kill()
	if Input.is_action_pressed("jump"):
		Jumped_body.velocity.y=-600
	else:
		Jumped_body.velocity.y=-300
	$Sprite2D.texture=idle_texture[get_tree().current_scene.palette] # Replace with function body.
	state=States.IDLE
