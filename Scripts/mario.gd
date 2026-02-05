extends CharacterBody2D

enum States {IDLE,WALK,BRAKE,JUMP,CROUCH,HANG,SWIM}
var state_suffix={
	States.IDLE:"idle",
	States.WALK:"walk",
	States.BRAKE:"brake",
	States.JUMP:"jump",
	States.CROUCH:"crouch",
	States.HANG:"hang",
	States.SWIM:"swim"
}
var size_prefix={
	Global.Size.SMOL:"smol",
	Global.Size.BIG:"big",
	Global.Size.FIERY:"fiery"
}

const MAX_HOLD_TIME=4

var is_sprinting:=false
var is_auto_walking:=false
var is_auto_climbing:=false
var olddir:int
var is_invincible:=false
var is_dead:=false
var can_jump_higher:bool
var jump_time:=0
var brickcoincount:=0
var jump_music_played:=false
var can_walk_to_castle:=false
var can_shoot:=true
var is_underwater:=false
var has_powered_up:=false
var can_swim_up:=true

@export var block_layer:TileMapLayer

@onready var animation=$AnimatedSprite2D
@onready var collision=$CollisionShape2D

var MAX_SPEED := 160.0
var MAX_JUMP_SPEED:=MAX_SPEED
const ACCELERATION:=1500
const FRICTION:=1000
const JUMP_VELOCITY := -512.0
const MAX_FALL_SPEED:=600

var level
var dir:=0
var vdir:=0
var state=States.IDLE
@onready var flag_bottom_y=384-collision.shape.extents.y
@onready var sfx=Configfile.load_music_settings()

func _ready() -> void:
	level=get_tree().current_scene
	$JumpSound.volume_linear=sfx["sfx_volume"]*0.01
	$LevelEnd.volume_linear=sfx["sfx_volume"]*0.01
	$CoinSound.volume_linear=sfx["sfx_volume"]*0.01
	$BlockHit.volume_linear=sfx["sfx_volume"]*0.01
	$BrickBreak.volume_linear=sfx["sfx_volume"]*0.01
	$CollisionShape2D.shape.size=Vector2(30,62) if Global.size!=Global.Size.SMOL else Vector2(24,30)
	$UpCollision/CollisionShape2D.shape.size=Vector2(30,1) if Global.size!=Global.Size.SMOL else Vector2(24,1)
	$UpCollision.position.y=-32.5 if Global.size!=Global.Size.SMOL else -16.5
	await  get_tree().physics_frame
	if is_on_floor():
		state=States.IDLE
	else:
		state=States.JUMP
		
	$BubbleTimer.start(2)
		
func _physics_process(delta: float) -> void:
	move_and_slide()
	if Input.is_action_just_pressed("down"):
		if Global.transitionx.has(Global.currentlevel):
			if abs(self.global_position.x-Global.transitionx[Global.currentlevel])<=16:
				Global.can_transition=false
				await slide_down()
				if Global.is_warped:
					Global.currentlevel=get_tree().current_scene.target
					get_tree().change_scene_to_file("res://Scenes/stage_transition.tscn")
				else:
					get_tree().change_scene_to_packed(Global.transition_level[Global.currentlevel])
		
	
	match state:
		States.IDLE:
			handle_idle_state()
		States.WALK:
			handle_walk_state(delta)
		States.JUMP:
			handle_jump_state(delta)
		States.CROUCH:
			handle_crouch_state()
		States.BRAKE:
			handle_brake_state(delta)
		States.HANG:
			handle_hang_state()
		States.SWIM:
			handle_swim_state(delta)
			
	dir= int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	vdir= int(Input.is_action_pressed("up")) - int(Input.is_action_pressed("down"))
	if dir!=0:
		if !is_auto_walking:
			if state!=States.JUMP and state!=States.HANG:
				animation.flip_h=(dir<0)
		
	if is_auto_walking:
		velocity.x=MAX_SPEED/2
		dir=1
		velocity.y+=Global.GRAVITY*delta
		move_and_slide()
		if can_walk_to_castle:
			if global_position.x>=level.castle_x:
				visible=false
				is_auto_walking=false
				can_walk_to_castle=false
				velocity.x=0
				self.set_physics_process(false)
		
	if global_position.y>480:
		if !is_dead:
			is_dead=true
			Global.size=Global.Size.SMOL
			shrink_or_die()
			

func handle_idle_state():
		if dir!=0:
			olddir=dir
			state=States.WALK
			animation.play(size_prefix[Global.size]+"_"+state_suffix[state])
			
		if Input.is_action_just_pressed("jump"):
			if !is_underwater:
				$UpCollision/CollisionShape2D.disabled=false
				velocity.y=JUMP_VELOCITY
				$JumpSound.stream=load("res://files/sounds/jump.wav")
				can_jump_higher=true
				state=States.JUMP
				animation.play(size_prefix[Global.size]+"_"+state_suffix[state])
			else:
				$JumpSound.stream=load("res://files/sounds/shot.wav")
				$JumpSound.play()
				velocity.y=JUMP_VELOCITY/2
				state=States.SWIM
				animation.play(size_prefix[Global.size]+"_"+state_suffix[state])
				dir=olddir
			
		if not is_on_floor():
			if !is_underwater:
				state=States.JUMP
				animation.play(size_prefix[Global.size]+"_"+state_suffix[state])
			else:
				state=States.SWIM
				animation.speed_scale=1.0
				animation.play(size_prefix[Global.size]+"_"+state_suffix[state])
				
		
		if Input.is_action_pressed("down"):
			if Global.size!=Global.Size.SMOL:
				$CollisionShape2D.shape.size=Vector2(32,44)
				state=States.CROUCH
				animation.play(size_prefix[Global.size]+"_"+state_suffix[state])
				
		elif Input.is_action_just_pressed("sprint"):
			shoot()
			
func handle_walk_state(delta):
	velocity.x+=dir*ACCELERATION*delta
	if !is_underwater:
		velocity.x=clamp(velocity.x,-MAX_SPEED,MAX_SPEED)
	else:
		animation.speed_scale=0.5
		velocity.x=clamp(velocity.x,-MAX_SPEED/2,MAX_SPEED/2)
	
	if dir!=sign(velocity.x):
		olddir=sign(velocity.x)
		state=States.BRAKE
	
	if not is_on_floor():
		if !is_underwater:
			state=States.JUMP
			animation.play(size_prefix[Global.size]+"_"+state_suffix[state])
		else:
			state=States.SWIM
			animation.speed_scale=1.0
			animation.play(size_prefix[Global.size]+"_"+state_suffix[state])
				
	if Input.is_action_just_pressed("jump"):
		if !is_auto_walking:
			if !animation.animation==size_prefix[Global.size]+"_brake":
				if !is_underwater:
					$UpCollision/CollisionShape2D.disabled=false
					MAX_JUMP_SPEED=MAX_SPEED
					velocity.y=JUMP_VELOCITY
					$JumpSound.stream=load("res://files/sounds/jump.wav")
					can_jump_higher=true
					state=States.JUMP
					animation.play(size_prefix[Global.size]+"_"+state_suffix[state])
				
				else:
					$UpCollision/CollisionShape2D.disabled=false
					velocity.y=JUMP_VELOCITY/2
					$JumpSound.stream=load("res://files/sounds/shot.wav")
					$JumpSound.play()
					state=States.SWIM
					animation.play(size_prefix[Global.size]+"_"+state_suffix[state])
	
	if Input.is_action_just_pressed("sprint"):
		if !Global.is_completed:
			shoot()
	
	if Input.is_action_pressed("sprint"):
		if !is_sprinting:
			animation.speed_scale=1.5
			MAX_SPEED*=1.5
			is_sprinting=true
	else:
		if is_sprinting:
			animation.speed_scale=1.0
			MAX_SPEED/=1.5
			is_sprinting=false
			
		
	if Input.is_action_pressed("down"):
		if Global.size!=Global.Size.SMOL:
			state=States.CROUCH
	
func handle_brake_state(delta):
	if velocity.x!=0.0:
		velocity.x-=sign(velocity.x)*(ACCELERATION/2.0)*delta
		if sign(velocity.x)!=sign(velocity.x-sign(velocity.x)*(ACCELERATION/2.0)*delta):
			velocity.x=0.0
			state=States.IDLE
			animation.play(size_prefix[Global.size]+"_"+state_suffix[state])
		elif dir!=0:
			if sign(dir)!=sign(velocity.x):
				animation.flip_h=(dir<0)
				animation.play(size_prefix[Global.size]+"_brake")
				if sign(velocity.x)==1.0:
					if velocity.x<=0.0:
						animation.play(size_prefix[Global.size]+"_walk")
						state=States.WALK
				elif sign(velocity.x)==-1.0:
					if velocity.x>=0.0:
						animation.play(size_prefix[Global.size]+"_walk")
						state=States.WALK
	else:
		state=States.IDLE
		animation.play(size_prefix[Global.size]+"_"+state_suffix[state])
					
	if Input.is_action_just_pressed("jump"):
		velocity.y=JUMP_VELOCITY
		state=States.JUMP
		animation.play(size_prefix[Global.size]+"_"+state_suffix[state])

func handle_jump_state(delta):
	if not is_on_floor():
		if velocity.y<0:
			var tile_pos=block_layer.local_to_map(block_layer.to_local($UpCollision.global_position))
			if tile_pos in level.invisible_blocks:
				block_layer.set_cell(tile_pos,level.INVISIBLE_BLOCK_ID,Vector2i.ZERO)
			if can_jump_higher and Input.is_action_just_released("jump"):
				can_jump_higher=false
				velocity.y=JUMP_VELOCITY/2
				jump_time=0
				if !jump_music_played:
					$JumpSound.play()
					jump_music_played=true
			if can_jump_higher and Input.is_action_pressed("jump"):
				if jump_time>MAX_HOLD_TIME:
					can_jump_higher=false
					$JumpSound.stream=load("res://files/sounds/jumpbig.wav")
					if !jump_music_played:
						$JumpSound.play()
						jump_music_played=true
					jump_time=0
				else:
					jump_time+=1
		if is_underwater:
			state=States.SWIM
			animation.play(size_prefix[Global.size]+"_"+state_suffix[state])
		velocity.y+=Global.GRAVITY*delta
		velocity.x+=dir*ACCELERATION*delta
		velocity.x=clamp(velocity.x,-MAX_JUMP_SPEED,MAX_JUMP_SPEED)
		if dir!=0:
			olddir=dir
			animation.flip_h=(dir<0)
		else:
			animation.flip_h=(olddir<0)
			
		
	else:
		if dir==0:
			if velocity.x==0:
				animation.play(size_prefix[Global.size]+"_idle")
				state=States.IDLE
			else:
				animation.play(size_prefix[Global.size]+"_walk")
				state=States.BRAKE
		else:
			animation.play(size_prefix[Global.size]+"_walk")
			state=States.WALK
		$UpCollision/CollisionShape2D.disabled=true
		jump_music_played=false
		
	if velocity.y>=0:
		can_jump_higher=false
		
	if Input.is_action_just_pressed("sprint"):
		shoot()
	
func handle_crouch_state():
	velocity.x=0
	position.y+=4
	if Input.is_action_just_released("down"):
		animation.play(size_prefix[Global.size]+"_idle")
		$CollisionShape2D.shape.size=Vector2(32,64)
		state=States.IDLE

func handle_hang_state():
	if !is_auto_climbing:
		vdir=int(Input.is_action_pressed("down"))-int(Input.is_action_pressed("up"))
		if Input.is_action_just_pressed("left"):
			if animation.flip_h:
				animation.flip_h=false
				global_position.x-=collision.shape.extents.x*2
			else:
				animation.play(size_prefix[Global.size]+"_idle")
				state=States.IDLE
				
		elif Input.is_action_just_pressed("right"):
			if animation.flip_h:
				animation.play(size_prefix[Global.size]+"_idle")
				state=States.IDLE
			else:
				animation.flip_h=true
				global_position.x+=collision.shape.extents.x*2
				
		if vdir==0:
			animation.stop()
		else:
			animation.play(size_prefix[Global.size]+"_hang")
			velocity.y+=vdir*MAX_SPEED/3
	
func handle_swim_state(delta):
	velocity.x=dir*MAX_SPEED/2
	velocity.y+=Global.GRAVITY*delta
	velocity.y=clamp(velocity.y,JUMP_VELOCITY/2.0,MAX_FALL_SPEED/2.0)
	if is_on_floor():
		animation.play(size_prefix[Global.size]+"_idle")
		state=States.IDLE
		
	if Input.is_action_just_pressed("sprint"):
		shoot()
		
	if Input.is_action_just_pressed("jump"):
		if can_swim_up:
			$JumpSound.play()
			velocity.y=JUMP_VELOCITY/2
		
	if velocity.x==0:
		animation.speed_scale=0
	else:
		animation.speed_scale=1.0
		
func start_flag_sequence():
	set_physics_process(false)
	self.z_index=1
	var levelendmusic=AudioStreamPlayer2D.new()
	levelendmusic.volume_linear=sfx["sfx_volume"]*0.01
	levelendmusic.stream=load("res://files/sounds/levelend.wav")
	levelendmusic.name="LevelEndMusic"
	self.add_child(levelendmusic)
	level.get_node("CameraFollower/BgMusic").stop()
	levelendmusic.play()
	animation.play(size_prefix[Global.size]+"_hang")
	animation.speed_scale=0
	var tween=get_tree().create_tween()
	tween.tween_property(self,"position:y",flag_bottom_y,1.1)
	await tween.finished
	self.global_position.x+=collision.shape.extents.x
	animation.flip_h=true
	await get_tree().create_timer(0.5).timeout
	self.global_position.x+=collision.shape.extents.x*2
	animation.flip_h=false
	walk_to_castle()
	
func walk_to_castle():
	animation.speed_scale=1.0
	set_physics_process(true)
	is_auto_walking=true
	animation.play(size_prefix[Global.size]+"_walk")
	can_walk_to_castle=true

func _on_up_collision_body_entered(body):
		if body is TileMapLayer:
			var hit_position=$UpCollision.global_position-Vector2(0,2)
			var localpos=block_layer.to_local(hit_position)
			var tile_coords=block_layer.local_to_map(localpos)
			var tile_id=block_layer.get_cell_source_id(tile_coords)
			if tile_id!=level.USED_BLOCK_ID:
				check_enemy(tile_coords)
				if tile_coords in level.starcoords:
					appear_star(tile_coords)
					block_layer.set_cell(tile_coords,level.USED_BLOCK_ID,Vector2i(0,0))
						
				elif tile_coords in level.powerupcoords:
					play_powerup_mushroom_animation(tile_coords)
					block_layer.set_cell(tile_coords,level.USED_BLOCK_ID,Vector2i(0,0))
					
				elif tile_coords in level.lifeupcoords:
					play_1up_mushroom_animation(tile_coords)
					block_layer.set_cell(tile_coords,level.USED_BLOCK_ID,Vector2i(0,0))
					
				elif tile_id == level.QUESTION_BLOCK_ID or tile_id == level.INVISIBLE_BLOCK_ID:
					block_layer.set_cell(tile_coords,level.INVISIBLE_BLOCK_ID,Vector2i(0,0))
					var block_sprite=Sprite2D.new()
					block_sprite.texture=Global.used_block[level.palette]
					block_sprite.centered=true
					block_sprite.global_position=block_layer.to_global(block_layer.map_to_local(tile_coords))
					level.add_child(block_sprite)
					spawn_coin(block_layer.to_global(block_layer.map_to_local(tile_coords)))
					
					var tween=get_tree().create_tween()
					tween.tween_property(block_sprite,"position:y",block_sprite.position.y-8,0.1)
					tween.tween_property(block_sprite,"position:y",block_sprite.position.y,0.1)
					await tween.finished
					block_layer.set_cell(tile_coords,level.USED_BLOCK_ID,Vector2i(0,0))
					block_sprite.queue_free()
					
				elif tile_id==level.BRICK_BLOCK_ID:
					block_layer.set_cell(tile_coords,level.INVISIBLE_BLOCK_ID,Vector2i(0,0))
					if tile_coords in level.coinbrickcoords:
						spawn_coin(level.to_global(block_layer.map_to_local(tile_coords)))
						var block_sprite=Sprite2D.new()
						block_sprite.texture=level.BRICK_TEXTURE
						block_sprite.centered=true
						block_sprite.global_position=block_layer.map_to_local(tile_coords)
						level.add_child(block_sprite)
						var tween=get_tree().create_tween()
						tween.tween_property(block_sprite,"position:y",block_sprite.position.y-8,0.1)
						tween.tween_property(block_sprite,"position:y",block_sprite.position.y,0.1)
						await tween.finished
						brickcoincount+=1
						Global.score+=200
						pop_up_score(200,self.global_position)
						if tile_coords not in level.coinbrickcoords or brickcoincount<7:
							block_layer.set_cell(tile_coords,level.BRICK_BLOCK_ID,Vector2i(0,0))
						else:
							block_layer.set_cell(tile_coords,level.USED_BLOCK_ID,Vector2i(0,0))
						block_sprite.queue_free()
						
					else:						
						if Global.size==Global.Size.SMOL:
							$BlockHit.play()
							var block_sprite=Sprite2D.new()
							block_sprite.texture=level.BRICK_TEXTURE
							block_sprite.centered=true
							block_sprite.global_position=block_layer.map_to_local(tile_coords)
							level.add_child(block_sprite)
							var tween=get_tree().create_tween()
							tween.tween_property(block_sprite,"position:y",block_sprite.position.y-8,0.05)
							tween.tween_property(block_sprite,"position:y",block_sprite.position.y,0.05)
							tween.tween_callback(func():
								if tile_coords not in level.coinbrickcoords or brickcoincount<7:
									block_layer.set_cell(tile_coords,level.BRICK_BLOCK_ID,Vector2i(0,0))
								block_sprite.queue_free()
							)
						else:
							if tile_coords not in level.coinbrickcoords:
								var base_pos=block_layer.map_to_local(tile_coords)
								var dirs=[-1,1,-1,1]
								var pos=[base_pos+Vector2(-8,-8),base_pos+Vector2(8,-8),base_pos+Vector2(-8,8),base_pos+Vector2(8,8)]
								$BrickBreak.play()
								for i in 4:
									var debris=load("res://Scenes/brick_debris_0.tscn").instantiate()
									debris.get_node("Sprite2D").texture=level.DEBRIS_TEXTURE
									debris.dir=dirs[i]
									level.add_child(debris)
									debris.global_position=pos[i]
								block_layer.set_cell(tile_coords,-1,Vector2i(0,0))
		
func play_powerup_mushroom_animation(tile_coords):
	play_appear_music()
	if Global.size==Global.Size.SMOL:
		var mushroom=Sprite2D.new()
		mushroom.texture=load("res://files/images/mushroom.png")
		mushroom.global_position=level.to_global(block_layer.map_to_local(tile_coords))
		level.add_child(mushroom)
		var tween=get_tree().create_tween()
		tween.tween_property(mushroom,"global_position:y",-32,1.0).as_relative()
		tween.tween_callback(func():
			var mushrooms=Global.PowerUpMushroom.instantiate()
			mushrooms.connect("powerup",mushroom_collected)
			mushrooms.global_position=mushroom.global_position-Vector2(0,16)
			level.add_child(mushrooms)
			mushroom.queue_free()
			)
	else:
		var flowersprite=Sprite2D.new()
		flowersprite.texture=load("res://files/images/flower0.png")
		flowersprite.global_position=level.to_global(block_layer.map_to_local(tile_coords))
		level.add_child(flowersprite)
		var tween=create_tween()
		tween.tween_property(flowersprite,"global_position:y",-32,1.0).as_relative()
		await tween.finished
		tween.kill()
		var flower=Global.Flower.instantiate()
		flower.connect("firepowerup",mario_fire_power_up)
		flower.global_position=flowersprite.global_position
		level.add_child(flower)
		flowersprite.queue_free()
			
func play_1up_mushroom_animation(coords):
	play_appear_music()
	var mushroom=Sprite2D.new()
	mushroom.texture=load("res://files/images/mushroom_1up.png")
	mushroom.global_position=level.to_global(block_layer.map_to_local(coords))
	level.add_child(mushroom)
	var tween=get_tree().create_tween()
	tween.tween_property(mushroom,"global_position:y",-32,1.0).as_relative()
	tween.tween_callback(func():
		var mushrooms=Global.Mushroom1Up.instantiate()
		mushrooms.global_position=block_layer.map_to_local(coords)-Vector2(0,16)
		level.add_child(mushrooms)
		mushroom.queue_free()
		)
		
func mario_death():
	$CameraFollower/BgMusic.playing=false
	var deathtone=AudioStreamPlayer2D.new()
	deathtone.volume_linear=sfx["sfx_volume"]*0.01
	deathtone.stream=load("res://files/sounds/death.wav")
	$CameraFollower.add_child(deathtone)
	deathtone.play()

func mario_power_up(grow):
	process_mode=Node.PROCESS_MODE_ALWAYS
	set_physics_process(false)
	var mario_old_val=velocity
	velocity=Vector2i(0,0)
	get_tree().paused=true
	$CollisionShape2D.shape.size=Vector2(28,62) if grow else Vector2(24,30)
	$UpCollision/CollisionShape2D.shape.size=Vector2(30,1) if grow else Vector2(24,1)
	$UpCollision.position.y=-32.5 if grow else -16.5
	move_and_slide()
	animation.speed_scale= 1 if grow else -1
	$AnimatedSprite2D.play("power_up")
	play_power_up_sound(grow)
	await get_tree().create_timer(1).timeout
	get_tree().paused=false
	animation.play("big_idle" if grow else "smol_idle")
	Global.size=Global.Size.BIG if grow else Global.Size.SMOL
	process_mode=Node.PROCESS_MODE_INHERIT
	animation.play(size_prefix[Global.size]+"_"+state_suffix[state])
	velocity=mario_old_val
	set_physics_process(true)
	if grow:
		Global.score+=1000
		pop_up_score(1000,self.global_position)
	
func mario_fire_power_up():
	process_mode=Node.PROCESS_MODE_ALWAYS
	set_physics_process(false)
	var mario_old_val=velocity
	velocity=Vector2i(0,0)
	get_tree().paused=true
	animation.play("fire_power_up")
	play_power_up_sound(true)
	await get_tree().create_timer(1).timeout
	get_tree().paused=false
	animation.play("fiery_idle")
	Global.size=Global.Size.FIERY
	process_mode=Node.PROCESS_MODE_INHERIT
	animation.play(size_prefix[Global.size]+"_"+state_suffix[state])
	set_physics_process(true)
	velocity=mario_old_val
	Global.score+=1000
	pop_up_score(1000,self.global_position)

	
func mushroom_collected():
	mario_power_up(true)

func spawn_coin(coords):
	var coin=Global.CoinPopped.instantiate()
	coin.global_position=coords-Vector2(0,36)
	level.add_child(coin)
	
func play_power_up_sound(grow):
	var powerupsound=AudioStreamPlayer2D.new()
	powerupsound.volume_linear=sfx["sfx_volume"]*0.01
	powerupsound.stream=load("res://files/sounds/mushroomeat.wav") if grow else load("res://files/sounds/shrink.wav")
	add_child(powerupsound)
	powerupsound.play()
	await powerupsound.finished
	powerupsound.queue_free()

func shrink_or_die():
	if Global.size==Global.Size.SMOL:
		$UpCollision.set_collision_mask_value(1,false)
		self.set_collision_layer_value(2,false)
		self.set_collision_layer_value(3,false)
		self.set_collision_mask_value(2,false)
		self.set_collision_mask_value(4,false)
		
		var death_sound=AudioStreamPlayer2D.new()
		death_sound.volume_linear=sfx["sfx_volume"]*0.01
		death_sound.stream=load("res://files/sounds/death.wav")
		if level.has_node("CameraFollower"):
			level.get_node("CameraFollower").add_child(death_sound)
			level.get_node("CameraFollower/BgMusic").stop()
		else:
			level.add_child(death_sound)
			level.get_node("BgMusic").stop()
		death_sound.play()
			
		set_physics_process(false)
		z_index=block_layer.z_index+1 if global_position.y<480 else block_layer.z_index-1
		animation.play("ded")
		await get_tree().create_timer(0.5).timeout
		var tween=get_tree().create_tween()
		tween.tween_property(self,"global_position:y",-96,0.5).as_relative()
		tween.tween_property(self,"global_position:y",512,1.11)
		tween.tween_callback(func():
			await get_tree().create_timer(0.5).timeout
			Global.lives-=1
			if Global.lives==0:
				get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
			else:
				get_tree().change_scene_to_file("res://Scenes/stage_transition.tscn")
			z_index=block_layer.z_index+1)
	else:
		mario_power_up(false)
		has_powered_up=false
		set_collision_layer_value(2,false)
		set_collision_layer_value(1,true)
		set_collision_mask_value(2,false)
		set_collision_mask_value(1,true)
		make_invincible()

func make_invincible():
	var tween=get_tree().create_tween()
	tween.set_loops()
	tween.tween_property(animation,"modulate:a",0.0,0.1)
	tween.tween_property(animation,"modulate:a",1.0,0.1)
	
	await get_tree().create_timer(3.0).timeout
	tween.kill()
	animation.modulate.a=1.0
	set_collision_layer_value(3,true)
	set_collision_layer_value(2,true)
	set_collision_layer_value(1,false)
	set_collision_mask_value(2,true)
	set_collision_mask_value(1,false)
	
func star_invincible():
	var shader=ShaderMaterial.new()
	shader.shader=load("res://Shaders/mario.gdshader")
	animation.material=shader
	is_invincible=true
	var starmusic=AudioStreamPlayer2D.new()
	starmusic.volume_linear=sfx["sfx_volume"]*0.01
	starmusic.stream=load("res://files/sounds/starmusic.wav") if Global.time>100 else load("res://files/sounds/starmusic-fast.wav")
	level.get_node("CameraFollower").add_child(starmusic)
	starmusic.play()
	starmusic.finished.connect(func():
		if level.get_node("CameraFollower/BgMusic"):
			level.get_node("CameraFollower/BgMusic").stop()
		starmusic.play())
	await get_tree().create_timer(10).timeout
	animation.material=null
	is_invincible=false
	level.get_node("CameraFollower/BgMusic").play()
	starmusic.queue_free()

func slide_down():
	animation.play(size_prefix[Global.size]+"_idle")
	self.z_index=block_layer.z_index-1
	set_physics_process(false)
	var transition=AudioStreamPlayer2D.new()
	transition.volume_linear=sfx["sfx_volume"]*0.01
	transition.stream=load("res://files/sounds/pipe.wav")
	self.add_child(transition)
	transition.play()
	var tween=get_tree().create_tween()
	tween.tween_property(self,"global_position:y",collision.shape.size.y,0.72).as_relative()
	await tween.finished
	
func slide_right():
	set_physics_process(false)
	self.z_index=block_layer.z_index-1
	var transition=AudioStreamPlayer2D.new()
	transition.volume_linear=sfx["sfx_volume"]*0.01
	transition.stream=load("res://files/sounds/pipe.wav")
	self.add_child(transition)
	transition.play()
	animation.play(size_prefix[Global.size]+"_walk")
	var tween=get_tree().create_tween()
	tween.tween_property(self,"global_position:x",collision.shape.size.y,0.72).as_relative()
	await tween.finished
	
func slide_up():
		self.set_collision_layer_value(2,false)
		self.set_collision_mask_value(2,false)
		self.set_physics_process(false)
		var transition=AudioStreamPlayer2D.new()
		transition.volume_linear=sfx["sfx_volume"]*0.01
		transition.stream=load("res://files/sounds/pipe.wav")
		self.add_child(transition)
		transition.play()
		var tween=get_tree().create_tween()
		tween.tween_property(self,"global_position:y",-self.collision.shape.extents.y*2,0.72).as_relative()
		await tween.finished
		tween.kill()
		transition.queue_free()
		self.set_physics_process(true)
		self.set_collision_layer_value(2,true)
		self.set_collision_mask_value(2,true)

func pop_up_score(point,pos):
	var score=load("res://Scenes/score.tscn").instantiate( )
	score.text=str(point)
	score.global_position=pos-Vector2(0,16)
	level.add_child(score)

func appear_star(tile_coords):
	play_appear_music()
	var starsprite=Sprite2D.new()
	starsprite.z_index=3
	starsprite.texture=load("res://files/images/star_0.png")
	starsprite.global_position=level.to_global(block_layer.map_to_local(tile_coords))
	level.add_child(starsprite)
	var tween=get_tree().create_tween()
	tween.tween_property(starsprite,"position:y",-32,0.5).as_relative()
	await tween.finished
	var star=load("res://Scenes/star.tscn").instantiate()
	star.global_position=starsprite.global_position
	starsprite.queue_free()
	level.add_child(star)

func check_enemy(coords):
	if level.has_node("Enemies"):
		var enemies=level.get_node("Enemies")
		for enemy in enemies.get_children():
			if enemy.global_position.distance_to(block_layer.map_to_local(coords))<=16*pow(5,0.5):
				var bounce=AudioStreamPlayer2D.new()
				bounce.volume_linear=sfx["sfx_volume"]*0.01
				bounce.stream=load("res://files/sounds/shot.wav")
				self.add_child(bounce)
				bounce.play()
				await bounce.finished
				bounce.queue_free()
				enemy.bounceoff(enemy.global_position)

func play_appear_music():
	var appear=AudioStreamPlayer2D.new()
	appear.volume_linear=sfx["sfx_volume"]*0.01
	appear.stream=load("res://files/sounds/mushroomappear.wav")
	if level.has_node("CameraFollower"):
		level.get_node("CameraFollower").add_child(appear)
	else:
		level.add_child(appear)
	appear.play()
	appear.finished.connect(func():
		appear.queue_free())
		
func shoot():
	if Global.size==Global.Size.FIERY:
		if can_shoot:
			can_shoot=false
			var fireball=load("res://Scenes/fire_ball.tscn").instantiate()
			fireball.dir=-1 if animation.flip_h else 1
			fireball.global_position=global_position+Vector2(fireball.dir*25,-16)
			level.add_child(fireball)
			animation.play("run_throw" if state==States.WALK else "idle_throw")
			await get_tree().create_timer(0.15).timeout
			animation.play(size_prefix[Global.size]+"_"+state_suffix[state])
			await get_tree().create_timer(0.05).timeout
			can_shoot=true


func _on_bubble_timer_timeout() -> void:
	if is_underwater:
		var bubble=load("res://Scenes/bubble.tscn").instantiate()
		bubble.global_position=global_position-collision.shape.extents
		level.add_child(bubble)
		$BubbleTimer.start(2)
	 # Replace with function body.
