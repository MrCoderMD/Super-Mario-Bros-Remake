extends CharacterBody2D
@onready var animation=$AnimatedSprite2D
@onready var sfx=Configfile.load_music_settings()
@export var palette:String
@export var state=States.WALK

enum States{FLY,HOP,WALK,SHELL,SLIDE}
var state_suffix={
	States.FLY:"fly",
	States.HOP:"hop",
	States.WALK:"walk",
	States.SHELL:"shell",
	States.SLIDE:"slide"
}
var start_pos:Vector2
var SPEED =Vector2(50,200)
var direction=1
var vdir=1
var is_dead:=false
var scores=[500,800,1000,2000,4000,5000,8000]
var bounce_off_multiplier:=-1
var dir_changed:=false
var fly_steps:=0

func _ready() -> void:
	await get_tree().process_frame
	$CollisionShape2D.shape=$CollisionShape2D.shape.duplicate()
	$LeftCollision/CollisionShape2D.shape=$LeftCollision/CollisionShape2D.shape.duplicate()
	$RightCollision/CollisionShape2D.shape=$RightCollision/CollisionShape2D.shape.duplicate()
	start_pos=global_position
	if palette=="":
		palette=get_tree().current_scene.palette
	if state!=States.HOP:
		animation.play(palette+"_"+state_suffix[state])
	else:
		animation.play(palette+"_fly")
	if state in [States.FLY,States.HOP]:
		direction=-1
		$RayCast2D.enabled=false

func _physics_process(delta: float) -> void:
	move_and_slide()
	match state:
		States.FLY:
			handle_fly_state()
		States.WALK:
			handle_walk_state()
		States.SHELL:
			handle_shell_state()
		States.SLIDE:
			handle_slide_state()
		States.HOP:
			handle_hop_state()
	# Add the gravity.
	if not is_on_floor():
		if state!=States.FLY or is_dead:
			velocity.y += Global.GRAVITY * delta

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	self.queue_free() # Replace with function body.
	
func bounceoff(pos):
	is_dead=true
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
	Global.score+=200
	get_tree().current_scene.get_node("Mario").pop_up_score(200,pos)

func _on_up_collision_body_entered(body):
	if body.name=="Mario":
		var stomp=AudioStreamPlayer2D.new()
		stomp.stream=load("res://files/sounds/stomp.wav")
		self.add_child(stomp)
		stomp.play()
		body.velocity.y=-200
		if state==States.FLY or state==States.HOP:
			velocity.y=0
			state=States.WALK
			animation.play(palette+"_walk")
			$RayCast2D.enabled=true
				
		elif state==States.WALK:
			Global.score+=100
			body.velocity.y=-200
			body.pop_up_score(100,self.global_position)
			animation.play(palette+"_ded") # Replace with function body.
			state=States.SHELL
			SPEED.x=0
			velocity.x=0
			$RayCast2D.enabled=false
			$CollisionShape2D.shape.size.y=32
			$UpCollision.position.y+=7
			$DownCollision.position.y-=7
			$LeftCollision/CollisionShape2D.shape.size=Vector2(1,32)
			$RightCollision/CollisionShape2D.shape.size=Vector2(1,32)
			self.set_collision_mask_value(2,false)
			self.set_collision_mask_value(1,true)
				
		elif state==States.SHELL:
			Global.score+=400
			body.pop_up_score(400,body.global_position)
			direction=-1 if body.animation.flip_h else -1
			SPEED.x=400.0
			self.set_collision_layer_value(1,true)
			self.set_collision_layer_value(2,false)
			self.set_collision_mask_value(1,true)
			self.set_collision_mask_value(2,false)
			state=States.SLIDE
			velocity.x=direction*SPEED.x
				
		elif state==States.SLIDE:
			state=States.SHELL


func _on_left_collision_body_entered(body):
	check_collision(body) # Replace with function body.


func _on_right_collision_body_entered(body):
	check_collision(body)

func _on_down_collision_body_entered(body):
	if body.name=="Mario":
		if body.is_dead:
			body.shrink_or_die() # Replace with function body.

func check_collision(body):
	if body!=self and body is not TileMapLayer:
		if body.name=="Mario":
			if body.is_invincible:
				bounceoff(self.global_position)
			elif state==States.WALK or state==States.SLIDE or state==States.HOP or state==States.FLY:
				if !body.is_dead:
					body.is_dead=true
					body.shrink_or_die()
			else:
				direction=body.dir
				SPEED.x=400
				velocity.x=direction*SPEED.x
				state=States.SLIDE
				Global.score+=400
				body.pop_up_score(400,body.global_position)
				
		else:
			if state==States.SLIDE:
				body.bounceoff(self.global_position)
				bounce_off_multiplier+=1
				var timer=get_tree().create_timer(2.0)
				timer.timeout.connect(func():
					bounce_off_multiplier=-1)
				var tween=get_tree().create_tween()
				if bounce_off_multiplier<8:
					var score=Label.new()
					score.label_settings=load("res://score.tres")
					score.text=str(scores[bounce_off_multiplier])
					score.global_position=body.global_position
					get_tree().current_scene.add_child(score)
					tween.tween_property(score,"position:y",-16,0.5).as_relative()
					await tween.finished
					tween.kill()
					score.queue_free()
				else:
					Global.lives+=1
					if Global.lifeup in self.get_children():
						self.add_child(Global.lifeup)
					Global.lifeup.play()

func handle_fly_state():
	if !is_dead:
		if abs(global_position.y-start_pos.y)>=48:
			if !dir_changed:
				dir_changed=true
				velocity.y=0
				await get_tree().create_timer(2.0).timeout
				vdir*=-1
				velocity.y=vdir*SPEED.y
		else:
			velocity.y=vdir*SPEED.y
			dir_changed=false
	
func handle_walk_state():
	velocity.x=direction*SPEED.x
	animation.flip_h=(direction>0)
	if $RayCast2D.enabled and !$RayCast2D.is_colliding():
		if velocity.y==0:
			direction*=-1
			$RayCast2D.target_position.x=direction*32
			velocity.x=direction*SPEED.x
	if is_on_wall():
		direction*=-1
		$RayCast2D.target_position.x=direction*32
		velocity.x=direction*SPEED.x
	
func handle_shell_state():
	velocity.x=0.0
	
func handle_slide_state():
	if is_on_wall():
		direction*=-1
		velocity.x=direction*SPEED.x

func handle_hop_state():
	if is_on_floor():
		velocity.y=-400
	if is_on_wall():
		direction*=-1
		animation.flip_h=(direction>0)
	velocity.x=direction*SPEED.x
