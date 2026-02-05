extends CharacterBody2D

var dir:=-1
var can_attack:=false
@onready var health:=7+int(Global.currentlevel[0])
@onready var sfx=Configfile.load_music_settings()
var is_hit:=false

const SPEED = 100.0
const JUMP_VELOCITY = -256.0

func _ready() -> void:
	$FireTimer.start(randf_range(3,5))
	$JumpTimer.start(randf_range(3,5))
	$WalkTimer.start(randf_range(3,4))

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += Global.GRAVITY * delta
	dir=-1 if global_position.x>get_tree().current_scene.get_node("Mario").global_position.x else 1
	$AnimatedSprite2D.flip_h=(dir>0)
	$Marker2D.position.x=-32 if dir==-1 else 32
	move_and_slide()
				
	if global_position.y>512:
		self.queue_free()
		
	if abs(get_tree().current_scene.get_node("Bound").global_position.x-global_position.x)<=32:
		velocity.x=10.0
		

func _on_fire_timer_timeout() -> void:
	if can_attack:
		var fire=load("res://Scenes/fire_breath.tscn").instantiate() # Replace with function body.
		fire.global_position=$Marker2D.global_position
		fire.dir=dir
		get_tree().current_scene.add_child(fire)
		$FireSound.play()
		$FireTimer.start(randf_range(3,4))


func _on_jump_timer_timeout() -> void:
	velocity.y=JUMP_VELOCITY-16*int(Global.currentlevel[0]) # Replace with function body.
	$JumpTimer.start(randf_range(3,5))
	if int(Global.currentlevel[0])>4:
		for i in int(Global.currentlevel[0]):
			var hammer=load("res://Scenes/hammer.tscn").instantiate()
			hammer.dir=dir
			hammer.velocity=Vector2(dir*128,-512)
			hammer.global_position=$HammerMark.global_position
			get_tree().current_scene.add_child(hammer)
			await get_tree().create_timer(0.125).timeout

func _on_walk_timer_timeout() -> void:
	velocity.x=randi_range(-1,1)*SPEED/randi_range(1,3)
	$WalkTimer.start(randf_range(3,5))


func _on_detect_area_body_entered(body: Node2D) -> void:
	if body.name=="Mario":
		can_attack=true # Replace with function body.

func bounceoff(pos):
	if !is_hit:
		is_hit=true
		if health==0:
			for i in self.get_children():
				if i is Timer:
					i.stop()
			$AnimatedSprite2D.play(Global.currentlevel)
			$AnimatedSprite2D.flip_v=true
			set_collision_mask_value(2,false)
			set_collision_layer_value(2,false)
			$HitBox.set_collision_mask_value(2,false)
			var fall=AudioStreamPlayer2D.new()
			fall.volume_linear=sfx["sfx_volume"]*0.01
			fall.stream=load("res://files/sounds/bowserfall.wav")
			self.add_child(fall)
			fall.play()
			Global.score+=5000
			get_tree().current_scene.get_node("Mario").pop_up_score(5000,pos)
		else:
			health-=1
			print(health)
		await get_tree().create_timer(0.2).timeout
		is_hit=false


func _on_hit_box_body_entered(body):
	if body.name=="Mario":
		body.shrink_or_die()
