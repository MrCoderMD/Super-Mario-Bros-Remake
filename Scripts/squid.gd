extends Area2D

enum States{DIVE,JUMP,DED}
var state:=States.DIVE
var velocity=Vector2(0,50)
var distance:float
var jump_pointx:float
var dive_pointy:float
var dir:int
var initx
var mario
var wait_frames:=0

func _ready() -> void:
	mario=get_tree().current_scene.get_node("Mario")
	dive_pointy=self.global_position.y
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match state:
		States.DIVE:
			handle_dive_state(delta)
		States.JUMP:
			handle_jump_state(delta)
		States.DED:
			handle_ded_state(delta)
			
	if self.global_position.y>=get_viewport().get_visible_rect().size.y:
		self.queue_free()
	
	if self.global_position.y>=get_viewport().get_visible_rect().size.y-96:
		if state==States.DIVE:
			distance=128
			jump_pointx=self.global_position.x
			velocity=Vector2(200,-100)
			$Sprite2D.texture=load("res://files/images/squid0.png")
			state=States.JUMP
		
func handle_dive_state(delta):
	self.global_position.y+=velocity.y*delta
	var dive_dis=16 if mario.global_position.y<self.global_position.y else 32
	if abs(self.global_position.y-dive_pointy)>=dive_dis:
		distance=128
		dir=sign(randf_range(1.0,5.0)-2.5)
		jump_pointx=self.global_position.x
		velocity=Vector2(dir*200,-50)
		$Sprite2D.texture=load("res://files/images/squid0.png")
		state=States.JUMP
		
	
func handle_jump_state(delta):
	self.global_position+=velocity*delta
	if abs(self.global_position.x-jump_pointx)>=distance:
		velocity=Vector2(0,50)
		$Sprite2D.texture=load("res://files/images/squid1.png")
		dive_pointy=self.global_position.y
		state=States.DIVE
		
func handle_ded_state(delta):
	self.global_position.y+=velocity.y*delta
	self.velocity.y+=Global.GRAVITY*delta
	

func _on_body_entered(body) -> void:
	if body.name=="Mario":
		body.shrink_or_die() # Replace with function body.
		
func bounceoff(pos):
	$Sprite2D.flip_v=true
	self.set_collision_layer_value(5,false)
	self.set_collision_mask_value(2,false)
	mario.pop_up_score(200,pos)
	Global.score+=200
	velocity=Vector2(0,0)
	state=States.DED

	
	 # Replace with function body.


func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	if self.velocity.x<0:
		self.queue_free() # Replace with function body.
