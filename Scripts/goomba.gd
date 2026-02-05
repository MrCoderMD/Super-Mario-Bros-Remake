extends CharacterBody2D

const points=100
const type="Goomba"
@onready var animation=$AnimatedSprite2D
@onready var sfx=Configfile.load_music_settings()
@export var palette:String

var SPEED = 0.0

var direction:=-1
var has_powered_up:=false
var bounce_dir:String
var is_dead:=false

func _ready():
	if palette=="":
		$AnimatedSprite2D.play(get_tree().current_scene.palette+"_walk")

func _process(delta):
	if not is_on_floor():
		velocity.y += Global.GRAVITY * delta

	velocity.x+=direction*SPEED*delta
	velocity.x=clamp(velocity.x,-SPEED,SPEED)
	if is_on_wall():
		direction*=-1
		velocity.x*=-1
	if global_position.y>496:
		self.queue_free()
	move_and_slide()
	
func _on_up_collision_body_entered(body):
	if body.name=="Mario":
		var stomp=AudioStreamPlayer2D.new()
		stomp.volume_linear=sfx["sfx_volume"]*0.01
		stomp.stream=load("res://files/sounds/stomp.wav")
		self.add_child(stomp)
		stomp.play()
		body.velocity.y=-200
		SPEED=0
		Global.score+=points
		body.pop_up_score(points,body.global_position)
		animation.play(get_tree().current_scene.palette+"_ded")
		set_collision_layer_value(2,false)
		$UpCollision.set_collision_mask_value(3,false)
		$LeftCollision.set_collision_mask_value(2,false)
		$RightCollision.set_collision_mask_value(2,false)
		$DownCollision.set_collision_mask_value(2,false)
		await get_tree().create_timer(0.25).timeout
		self.queue_free()

func _on_left_collision_body_entered(body):
	if body.name=="Mario":
		if body.is_invincible:
			bounceoff(self.global_position)
		else:
			body.shrink_or_die()

func _on_right_collision_body_entered(body):
	if body.name=="Mario":
		if body.is_invincible:
			bounceoff(self.global_position)
		else:
			body.shrink_or_die()

func _on_down_collision_body_entered(body):
	if body.name=="Mario":
		body.shrink_or_die() # Replace with function body.
		
func _on_visible_on_screen_enabler_2d_screen_entered():
	SPEED=50.0 # Replace with function body.


func _on_visible_on_screen_enabler_2d_screen_exited():
	self.queue_free() # Replace with function body.


func bounceoff(pos):
	var body=get_tree().current_scene.get_node("Mario")
	body.pop_up_score(200,pos)
	Global.score+=200
	var bounce=AudioStreamPlayer2D.new()
	bounce.volume_linear=sfx["sfx_volume"]*0.01
	bounce.stream=load("res://files/sounds/shot.wav")
	self.add_child(bounce)
	bounce.play()
	animation.speed_scale=0
	animation.flip_v=true
	velocity.y=-200
	collision_layer=0
	collision_mask=0
	$UpCollision.collision_mask=0
	$DownCollision.collision_mask=0
	$LeftCollision.collision_mask=0
	$RightCollision.collision_mask=0
