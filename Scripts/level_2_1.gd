extends Level

@onready var mario=$Mario

const powerupcoords=[Vector2i(16,9),Vector2i(53,9),Vector2i(125,5),Vector2i(172,5)]
const lifeupcoords=[Vector2i(28,5)]
const coinbrickcoords=[Vector2i(161,9)]
const starcoords=[Vector2i(69,5)]
const invisible_blocks=[Vector2i(29,9),Vector2i(186,5)]
const QUESTION_BLOCK_ID=19
const BRICK_BLOCK_ID=20
const USED_BLOCK_ID=22
const INVISIBLE_BLOCK_ID:=9
var BRICK_TEXTURE=load("res://files/images/brickred.bmp")
var DEBRIS_TEXTURE=load("res://files/images/block_debris0.png")
const palette="overworld"
const castle_x:=6608
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
		if Global.checkpoint:
			mario.global_position=Vector2(3168,400)
		Global.time=399


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("select"):
		Global.pause_game(self)
		#$CameraFollower/Controls.process_mode=Node.PROCESS_MODE_ALWAYS
	if mario:
		if $CameraFollower.position.x<=$Mario.global_position.x:
			$CameraFollower.position.x=$Mario.global_position.x
		if mario.global_position.y<-32:
			$CameraFollower.position.y=-240
		else:
			$CameraFollower.position.y=240
			
	if abs(mario.global_position.x-2672)<=16:
		if abs(mario.get_node("UpCollision").global_position.y-192)<=2:
			if !is_vine_added:
				is_vine_added=true
				await create_vine()


func _on_level_timer_timeout() -> void:
	Global.check_time("2-2")

func _on_bg_music_finished() -> void:
	$CameraFollower/BgMusic.play()

func create_vine():
	var vine_count=10
	$ForegroundTile.set_cell(Vector2i(83,5),USED_BLOCK_ID,Vector2i(0,0))
	for i in vine_count:
		var vine=load("res://Scenes/vine.tscn").instantiate()
		if i==0:
			vine.get_node("Sprite2D").texture=vine.top_palette[palette]
			print(vine.top_palette[palette])
		vine.global_position=self.to_global($ForegroundTile.map_to_local(Vector2i(83,5)))
		vine.target_y=-128+32*i
		self.add_child(vine)
		await get_tree().create_timer(0.533).timeout


func _on_checkpoint_body_entered(body: Node2D) -> void:
	if body==mario:
		Global.checkpoint=true # Replace with function body.
