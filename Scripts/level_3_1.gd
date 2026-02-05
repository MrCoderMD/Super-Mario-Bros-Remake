extends Level

@onready var mario=$Mario

const powerupcoords=[Vector2i(22,8),Vector2i(117,5),Vector2i(156,9)]
const coinbrickcoords=[Vector2i(167,9)]
const starcoords=[Vector2i(90,5)]
const lifeupcoords=[Vector2i(82,5)]
const invisible_blocks=[Vector2i(82,5)]
const QUESTION_BLOCK_ID=14
const BRICK_BLOCK_ID=15
const USED_BLOCK_ID=26
const INVISIBLE_BLOCK_ID=23
var BRICK_TEXTURE=load("res://files/images/brickred.bmp")
var DEBRIS_TEXTURE=load("res://files/images/block_debris0.png")
const palette="overworld"
var is_vine_added:=false
var castle_x:=6608

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	if !Global.can_transition:
		mario.z_index=$ForegroundTile.z_index-1
		mario.global_position=self.to_global($ForegroundTile.map_to_local(Global.spawn[Global.currentlevel]))+Vector2(-16,mario.collision.shape.extents.y-16)
		print(mario.global_position)
		await mario.slide_up()
		mario.z_index=$ForegroundTile.z_index+1
	else:
		if Global.checkpoint:
			mario.global_position=Vector2(2912,400)
		Global.time=399
	await get_tree().process_frame
	var hop_koopa=[Vector2i(25,12),Vector2i(28,11),Vector2i(165,12),Vector2i(168,11),Vector2i(171,12)]
	var noray_koopa=[Vector2i(188,6),Vector2i(191,4)]
	for enemy in $Enemies.get_children():
		var cell_pos=$Enemies.local_to_map($Enemies.to_local(enemy.global_position))
		if cell_pos in hop_koopa:
			enemy.direction=-1
			enemy.state=enemy.States.HOP
		elif cell_pos in noray_koopa:
			enemy.get_node("RayCast2D").enabled=false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("select"):
		Global.pause_game(self)
	if mario:
		if $CameraFollower.position.x<=$Mario.global_position.x:
			$CameraFollower.position.x=$Mario.global_position.x
		if mario.global_position.y<0:
			$CameraFollower.position.y=-240
		else:
			$CameraFollower.position.y=240
			
	if abs(mario.global_position.x-4208)<=16:
		if abs(mario.get_node("UpCollision").global_position.y-192)<=2 and mario.state==mario.States.JUMP:
			if !is_vine_added:
				is_vine_added=true
				await create_vine()
				
	if mario.global_position.x>castle_x and mario.global_position.y>-48 and !Global.is_completed:
		mario.global_position=Vector2(5616,32)
		$CameraFollower.position.x=$Mario.global_position.x

func _on_level_timer_timeout() -> void:
	Global.check_time("3-2") # Replace with function body.


func _on_bg_music_finished() -> void:
	$CameraFollower/BgMusic.play() # Replace with function body.

func create_vine():
	var vine_appear=AudioStreamPlayer2D.new()
	vine_appear.stream=load("res://files/sounds/mushroomappear.wav")
	$CameraFollower.add_child(vine_appear)
	vine_appear.play()
	var vine_count=12
	$ForegroundTile.set_cell(Vector2i(131,5),USED_BLOCK_ID,Vector2i(0,0))
	for i in vine_count:
		var vine=load("res://Scenes/vine.tscn").instantiate()
		if i==0:
			vine.is_top=true
		vine.global_position=self.to_global($ForegroundTile.map_to_local(Vector2i(131,5)))
		vine.target_y=-128+32*i
		vine.z_index=$ForegroundTile.z_index-1
		self.add_child(vine)
		await get_tree().create_timer(0.533).timeout


func _on_checkpoint_body_entered(body: Node2D) -> void:
	if body==mario:
		Global.checkpoint=true # Replace with function body.
