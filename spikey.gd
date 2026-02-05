extends CharacterBody2D

@onready var animation=$AnimatedSprite2D
const SPEED = 75.0
var dir_changed:=false
var dir:int
var mario

func _ready() -> void:
	mario=get_tree().current_scene.get_node("Mario")
	dir=sign(mario.global_position.x-self.global_position.x)
	if dir==0:
		dir=1
	velocity.x=dir*SPEED
	animation.flip_h=(dir>0)

func _physics_process(delta: float) -> void:
	move_and_slide()
	if global_position.y>500:
		self.queue_free()
	if is_on_wall():
		if !dir_changed:
			dir_changed=true
			dir*=-1
			velocity.x=dir*SPEED
			animation.flip_h=(dir>0)
			await get_tree().create_timer(0.5).timeout
			dir_changed=false
		
	if !is_on_floor():
		velocity.y+=Global.GRAVITY*delta

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name=="Mario":
		body.shrink_or_die() # Replace with function body.
		
func bounceoff(pos):
	velocity.y=-200
	self.set_collision_layer_value(2,false)
	self.set_collision_mask_value(2,false)
	$Area2D.set_collision_mask_value(2,false)
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.flip_v=true
	Global.score+=200
	mario.pop_up_score(200,self.global_position)
