extends Level

@onready var mario=$Mario

const powerupcoords=[Vector2i(52,9),Vector2i(130,8)]
const lifeupcoords=[Vector2i(90,8)]
const coinbrickcoords=[Vector2i(24,5),Vector2i(152,9)]
const starcoords=[Vector2i(140,5)]
const invisible_blocks=[Vector2i(24,9),Vector2i(113,5),Vector2i(113,9)]
const QUESTION_BLOCK_ID:=19
const BRICK_BLOCK_ID:=20
const USED_BLOCK_ID:=22
const INVISIBLE_BLOCK_ID:=9
var BRICK_TEXTURE=load("res://files/images/brickred.bmp")
var DEBRIS_TEXTURE=load("res://files/images/block_debris0.png")
const palette="overworld"
const castle_x:=7120

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	await get_tree().process_frame
	if !Global.can_transition:
		mario.z_index=$ForegroundTile.z_index-1
		mario.global_position=self.to_global($ForegroundTile.map_to_local(Global.spawn[Global.currentlevel]))+Vector2(-16,mario.collision.shape.extents.y-16)
		await mario.slide_up()
		mario.z_index=$ForegroundTile.z_index+1
	else:
		Global.time=399
	var hop_koopax=[43,206]
	for enemy in $Enemies.get_children():
		if int((enemy.global_position.x-16)/32) in hop_koopax:
			enemy.state=enemy.States.HOP
	Global.time=399

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("select"):
		Global.pause_game(self)
	if mario:
		if $CameraFollower.position.x<=$Mario.global_position.x:
			$CameraFollower.position.x=$Mario.global_position.x


func _on_level_timer_timeout() -> void:
	Global.check_time("6-3")


func _on_bg_music_finished() -> void:
	$CameraFollower/BgMusic.play() # Replace with function body.


func _on_transition_1_body_entered(body: Node2D) -> void:
	if body==mario:
		Global.can_transition=true
		Global.transitionx["6-2"]=1824 # Replace with function body.
		Global.transition_level["6-2"]=load("res://Scenes/level_5_2_2.tscn")
		Global.spawn["6-2"]=Vector2i(116,11)


func _on_transition_2_body_entered(body: Node2D) -> void:
	if body==mario:
		Global.can_transition=true
		Global.transitionx["6-2"]=4928 # Replace with function body.
		Global.transition_level["6-2"]=load("res://Scenes/level_4_1_1.tscn")
		Global.spawn["6-2"]=Vector2i(180,11)
