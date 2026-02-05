extends Area2D

var is_ded:=false
var mario
const SPEED:=150
var velocity:Vector2
var palette={
	"overworld":load("res://files/images/bulletbill.png"),
	"castle":load("res://files/images/bulletbill1.png")
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	$Sprite2D.texture=palette[get_tree().current_scene.palette]
	mario=get_tree().current_scene.get_node("Mario") # Replace with function body.
	$Sprite2D.flip_h=(velocity.x<0)
	$InitSound.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position+=velocity*delta
	if is_ded:
		velocity.y+=Global.GRAVITY*delta

func _on_up_collision_body_entered(body: Node2D) -> void:
	if body==mario:
		self.set_collision_mask_value(2,false)
		body.velocity.y=-200
		bounceoff()
		 # Replace with function body.

func bounceoff():
	is_ded=true
	$DedSound.play()
	mario.pop_up_score(200,self.global_position)
	self.set_collision_mask_value(2,false)
	$UpCollision.set_collision_mask_value(3,false)


func _on_body_entered(body) -> void:
	if body==mario:
		if !is_ded:
			if !body.is_invincible:
				body.shrink_or_die()
			else:
				bounceoff()
