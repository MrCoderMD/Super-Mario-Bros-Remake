extends CharacterBody2D

signal death

var mario:Node
enum States{IDLE,ACTIVE,REVOLVE,SPRINT,DED}
var state:=States.ACTIVE
const SPEED:=100

func _ready() -> void:
	mario=get_tree().current_scene.get_node("Mario")
	velocity.x=-SPEED


func _physics_process(delta: float) -> void:
	move_and_slide()
	match state:
		States.IDLE:
			velocity.x=-100
		States.ACTIVE:
			handle_active_state()
		States.REVOLVE:
			handle_revolve_state()
		States.SPRINT:
			handle_sprint_state()
		States.DED:
			handle_ded_state(delta)
			
	if self.global_position.y>500:
		self.queue_free()
	
func handle_active_state():
	if mario.velocity.x==0:
		if self.global_position.x-mario.global_position.x<=128:
			velocity.x=-2*SPEED
			state=States.REVOLVE
	else:
		state=States.SPRINT
		
func handle_revolve_state():
	if mario.velocity.x==0:
		if self.global_position.x-mario.global_position.x>=128:
			velocity.x=-SPEED
		elif mario.global_position.x-self.global_position.x>=128:
			velocity.x=SPEED
	else:
		state=States.SPRINT
		
func handle_sprint_state():
	if mario.velocity.x!=0:
		if self.global_position.x-mario.global_position.x>=128:
			velocity.x=-SPEED
		elif mario.global_position.x-self.global_position.x>=128:
			self.velocity.x=2*mario.velocity.x
		elif self.global_position.x-mario.global_position.x>0 and self.global_position.x-mario.global_position.x<128:
			self.velocity.x=1.25*mario.velocity.x
	else:
		state=States.ACTIVE

func handle_ded_state(delta):
	velocity.y+=Global.GRAVITY*delta

func _on_spikey_throw_timeout() -> void:
	$Sprite2D.texture=load("res://files/images/lakito_1.png") # Replace with function body.
	var egg=load("res://Scenes/spikey_egg.tscn").instantiate()
	egg.global_position=$Marker2D.global_position
	get_tree().current_scene.add_child(egg)
	await get_tree().create_timer(0.5).timeout
	$Sprite2D.texture=load("res://files/images/lakito_0.png") # Replace with function body.
	


func _on_up_collision_body_entered(body: Node2D) -> void:
	if body.name=="Mario":
		self.bounceoff(self.global_position)
		body.velocity.y=-200 # Replace with function body.
		
func bounceoff(pos):
	death.emit()
	self.set_collision_layer_value(2,false)
	self.set_collision_mask_value(2,false)
	$UpCollision.set_collision_mask_value(2,false)
	$LeftCollision.set_collision_mask_value(2,false)
	$RightCollision.set_collision_mask_value(2,false)
	$DownCollision.set_collision_mask_value(2,false)
	$Sprite2D.flip_v=true
	state=States.DED
	mario.pop_up_score(200,pos)
	Global.score+=200
	
func check_collision(body):
	if body.name=="Mario":
		body.shrink_or_die()


func _on_left_collision_body_entered(body: Node2D) -> void:
	check_collision(body) # Replace with function body.


func _on_right_collision_body_entered(body: Node2D) -> void:
	check_collision(body) # Replace with function body.


func _on_down_collision_body_entered(body: Node2D) -> void:
	check_collision(body) # Replace with function body.
