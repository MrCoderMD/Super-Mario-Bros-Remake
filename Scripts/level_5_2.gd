extends Level
@onready var mario=$Mario

const powerupcoords=[Vector2i(34,5),Vector2i(142,11),Vector2i(168,9)]
const coinbrickcoords=[Vector2i(141,11)]
const starcoords=[Vector2i(125,5)]
const lifeupcoords=[Vector2i(148,9)]
const invisible_blocks=[Vector2i(84,9)]
const QUESTION_BLOCK_ID=14
const BRICK_BLOCK_ID=15
const USED_BLOCK_ID=26
const INVISIBLE_BLOCK_ID=23
var BRICK_TEXTURE=load("res://files/images/brickred.bmp")
var DEBRIS_TEXTURE=load("res://files/images/block_debris0.png")
const palette="overworld"
var transition_level=load("res://Scenes/level_5_2_2.tscn")
var castle_x:=6608
var is_vine_added:=false

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
		Global.time=399
	await get_tree().process_frame
	var hop_koopa=[Vector2i(40,10),Vector2i(106,10),Vector2i(163,10),Vector2i(166,11),Vector2i(186,5)]
	for enemy in $Enemies.get_children():
		var cell_pos=$Enemies.local_to_map($Enemies.to_local(enemy.global_position))
		if cell_pos in hop_koopa:
			enemy.direction=-1
			enemy.state=enemy.States.HOP
		if cell_pos==Vector2i(157,4):
			enemy.palette="red"
			

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("select"):
		Global.pause_game(self)
	if mario:
		if $CameraFollower.position.x<=$Mario.global_position.x:
			$CameraFollower.position.x=$Mario.global_position.x
		if mario.global_position.y<-32:
			$CameraFollower.position.y=-240
		else:
			$CameraFollower.position.y=240
			
	if abs(mario.global_position.x-2736)<=16:
		if abs(mario.get_node("UpCollision").global_position.y-192)<=2 and mario.state==mario.States.JUMP:
			if !is_vine_added:
				is_vine_added=true
				await create_vine()
			


func _on_bg_music_finished() -> void:
	$CameraFollower/BgMusic.play() # Replace with function body.


func _on_level_timer_timeout() -> void:
	Global.check_time("5-3") # Replace with function body.

func create_vine():
	var vine_appear=AudioStreamPlayer2D.new()
	vine_appear.stream=load("res://files/sounds/mushroomappear.wav")
	$CameraFollower.add_child(vine_appear)
	vine_appear.play()
	var vine_count=10
	$ForegroundTile.set_cell(Vector2i(85,5),USED_BLOCK_ID,Vector2i(0,0))
	for i in vine_count:
		var vine=load("res://Scenes/vine.tscn").instantiate()
		if i==0:
			vine.is_top=true
		var initial= self.to_global($ForegroundTile.map_to_local(Vector2i(85,5)))
		vine.global_position=initial
		vine.target_y=initial.y-32*(vine_count-i-1)
		vine.z_index=$ForegroundTile.z_index-1
		self.add_child(vine)
		await get_tree().create_timer(0.533).timeout
