extends CharacterBody2D

enum States{WALK,DED,SLIDE}
var state:States
var palette:String
var mario
var dir:=-1

const SPEED:=75
@onready var animation:=$AnimatedSprite2D

func _ready() -> void:
	palette=get_tree().current_scene.palette
	mario=get_tree().current_scene.get_node("Mario")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	move_and_slide()
	if !is_on_floor():
		velocity.y+=Global.GRAVITY*delta
	if is_on_wall():
		dir*=-1
		velocity.x=dir*SPEED if state==States.WALK else dir*SPEED*4
		animation.flip_h=!(dir<0)

func check_collision(body):
	if body is CharacterBody2D:
		if body != self:
			if body==mario:
				if state!=States.DED:
					body.shrink_or_die()
				else:
					velocity.x=mario.dir*SPEED*4
					state=States.SLIDE
					self.set_collision_mask_value(2,false)
					self.set_collision_layer_value(2,false)
					self.set_collision_mask_value(1,true)
					self.set_collision_layer_value(1,true)
			else:
				if state==States.SLIDE:
					body.bounceoff(self.global_position)

func _on_up_collision_body_entered(body: Node2D) -> void:
	body.velocity.y=-200
	match state:
		States.WALK:
			velocity.x=0
			animation.play(palette+"_ded") # Replace with function body.
			state=States.DED
		States.DED:
			dir=sign(self.global_position.x-mario.global_position.x)
			velocity.x=mario.dir*SPEED*4
			self.set_collision_mask_value(2,false)
			self.set_collision_layer_value(2,false)
			self.set_collision_mask_value(1,true)
			self.set_collision_layer_value(1,true)
			state=States.SLIDE
		States.SLIDE:
			velocity.x=0
			state=States.DED
			


func _on_left_collision_body_entered(body) -> void:
	check_collision(body) # Replace with function body.


func _on_right_collision_body_entered(body) -> void:
	check_collision(body) # Replace with function body.


func _on_visible_on_screen_enabler_2d_screen_entered() -> void:
	animation.play(palette+"_walk")
	velocity.x=dir*SPEED
	state=States.WALK


func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	self.queue_free() # Replace with function body.


func _on_down_collision_body_entered(body: Node2D) -> void:
	check_collision(body) # Replace with function body.
