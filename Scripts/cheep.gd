extends Area2D

enum States{SWIM,FLY}
@export var state:=States.SWIM
@export var palette:String="white"
var velocity:=Vector2(0,0)
var dir:=-1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	$AnimatedSprite2D.play(palette)
	match state:
		States.FLY:
			$UpCollision.set_collision_mask_value(3,true)
			velocity.y=-600


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$AnimatedSprite2D.flip_h=(dir>0)
	if global_position.y>get_viewport().get_visible_rect().size.y:
		if velocity.y>0:
			self.queue_free()
			
	match state:
		States.SWIM:
			handle_swim_state(delta)
		States.FLY:
			handle_fly_state(delta)


func handle_swim_state(delta):
	global_position.x+=velocity.x*delta
	
func handle_fly_state(delta):
	velocity.y+=delta*Global.GRAVITY/2
	global_position.y+=velocity.y*delta
	global_position.x+=velocity.x*delta


func _on_visible_on_screen_enabler_2d_screen_entered() -> void:
	if state==States.SWIM:
		velocity.x=-100 # Replace with function body.


func _on_body_entered(body: Node2D) -> void:
	if body.name=="Mario":
		if !body.is_invincible:
			body.shrink_or_die() # Replace with function body.
		else:
			self.bounceoff(self.global_position)

func bounceoff(pos):
	self.global_position.y-=4
	velocity=Vector2(0,100)
	$AnimatedSprite2D.flip_v=true
	$AnimatedSprite2D.speed_scale=0
	self.set_collision_mask_value(2,false)
	self.set_collision_layer_value(5,false)
	$UpCollision.set_collision_mask_value(3,false)
	state=States.FLY
	get_tree().current_scene.get_node("Mario").pop_up_score(200,pos)
	Global.score+=200
	


func _on_up_collision_body_entered(body: Node2D) -> void:
	if body.name=="Mario":
		body.velocity.y=-200
		self.bounceoff(self.global_position)
