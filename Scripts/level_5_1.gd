extends Level
@onready var mario=$Mario

const powerupcoords=[]
const coinbrickcoords=[]
const starcoords=[Vector2i(91,5)]
const lifeupcoords=[Vector2i(148,9)]
const invisible_blocks=[]
const QUESTION_BLOCK_ID=14
const BRICK_BLOCK_ID=15
const USED_BLOCK_ID=26
const INVISIBLE_BLOCK_ID=23
var BRICK_TEXTURE=load("res://files/images/brickred.bmp")
var DEBRIS_TEXTURE=load("res://files/images/block_debris0.png")
const palette="overworld"
var transition_level=load("res://Scenes/level_4_2_2.tscn")
var transition_coordx=5024
var castle_x:=6608

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
		if Global.checkpoint:
			mario.global_position=Vector2(3136,400)
		Global.time=399
	var hop_koopa=[Vector2i(61,9),Vector2i(86,10),Vector2i(178,12),Vector2i(182,8)]
	for enemy in $Enemies.get_children():
		var cell_pos=$Enemies.local_to_map($Enemies.to_local(enemy.global_position))
		if cell_pos in hop_koopa:
			enemy.direction=-1
			enemy.state=enemy.States.HOP

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("select"):
		Global.pause_game(self)
	if mario:
		if $CameraFollower.position.x<=$Mario.global_position.x:
			$CameraFollower.position.x=$Mario.global_position.x


func _on_level_timer_timeout() -> void:
	Global.check_time("5-2") # Replace with function body.


func _on_checkpoint_body_entered(body: Node2D) -> void:
	if body==mario:
		Global.checkpoint=true # Replace with function body.
