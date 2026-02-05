extends Area2D

var target_y:int
var velocity_y:=60
var is_top:=false
var top_palette={
	"overworld":load("res://files/images/vine_top.png"),
	"underground":load("res://files/images/vine1_top.png")
}
var palette={
	"overworld":load("res://files/images/vine.png"),
	"underground":load("res://files/images/vine1.png")
}

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_top:
		$Sprite2D.texture=self.top_palette[get_tree().current_scene.palette]
	else:
		$Sprite2D.texture=self.palette[get_tree().current_scene.palette]
		
	global_position.y-=velocity_y*delta
	if global_position.y<=target_y:
		velocity_y=0


func _on_body_entered(body):
	if body.name=="Mario":
		if !body.is_auto_climbing:
			body.animation.play(body.size_prefix[Global.size]+"_hang")
			body.velocity=Vector2(0,0)
			body.state=body.States.HANG


func _on_body_exited(body: Node2D) -> void:
	if body.name=="Mario":
		if $Sprite2D.texture==top_palette[get_tree().current_scene.palette]:
			body.animation.play(body.size_prefix[Global.size]+"_jump")
			body.velocity=Vector2(100,-400)
			body.state=body.States.JUMP
