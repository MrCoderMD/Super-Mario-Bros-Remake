extends CharacterBody2D

@onready var animation=$AnimatedSprite2D
enum States{WALK,AIM}
var state=States.WALK
var mario

const SPEED = 100.0
const JUMP_VELOCITY = -400.0

@export var palette=""

var dir:=0

func _ready() -> void:
	mario=get_tree().current_scene.get_node("Mario")
	if palette=="":
		palette="overworld"
	animation.play(palette+"_walk")

func _physics_process(delta: float) -> void:
	move_and_slide()
	velocity.x=dir*SPEED
	velocity.y+=Global.GRAVITY*delta
	animation.flip_h=(mario.global_position.x-global_position.x<0)
	if global_position.y>480:
		self.queue_free()

func _on_dir_timer_timeout() -> void:
	dir*=-1 # Replace with function body.
	$DirTimer.start(randf_range(0.5,1))
	

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	dir=-1
	$DirTimer.start(randf_range(0.5,1))
	$AimTimer.start(randf_range(1,2))

func _on_aim_timer_timeout() -> void:
	animation.play(palette+"_throw")
	$ThrowTimer.start(1)


func _on_throw_timer_timeout() -> void:
	var hammer=load("res://Scenes/hammer.tscn").instantiate()
	hammer.velocity.y=-400
	var time=(400+pow(160000+2048*(480-hammer.global_position.y),0.5))/Global.GRAVITY
	hammer.global_position=$Marker2D.global_position
	hammer.velocity.x=(mario.global_position.x-hammer.global_position.x)/(time)
	hammer.get_node("AnimatedSprite2D").flip_h=(mario.global_position.x-global_position.x<0)
	get_tree().current_scene.add_child(hammer)
	animation.play(palette+"_walk")
	$AimTimer.start(randf_range(1,2))
	await get_tree().create_timer(0.5).timeout
	if self.global_position.y<416 and self.global_position.y>288:
		self.velocity.y=-512
	elif self.global_position.y>160 and self.global_position.y<288:
		var move=randi_range(0,1)
		if move==0:
			self.velocity.y=-512
	self.set_collision_mask_value(2,false)
	await get_tree().create_timer(0.5).timeout
	self.set_collision_mask_value(2,true)

func bounceoff(pos):
	animation.stop()
	animation.flip_v=true
	self.set_collision_layer_value(2,false)
	self.set_collision_mask_value(2,false)
	$UpCollision.set_collision_mask_value(3,false)
	$LeftCollision.set_collision_mask_value(2,false)
	$RightCollision.set_collision_mask_value(2,false)
	$DownCollision.set_collision_mask_value(2,false)
	mario.pop_up_score(1000,pos)
	Global.score+=1000


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	self.queue_free() # Replace with function body.


func _on_up_collision_body_entered(body: Node2D) -> void:
	if body==mario: # Replace with function body.
		self.bounceoff(body.global_position)

func check_collision(body):
	if body==mario:
		body.shrink_or_die()
		

func _on_left_collision_body_entered(body: Node2D) -> void:
	check_collision(body) # Replace with function body.


func _on_right_collision_body_entered(body: Node2D) -> void:
	check_collision(body) # Replace with function body.


func _on_down_collision_body_entered(body: Node2D) -> void:
	check_collision(body) # Replace with function body.
