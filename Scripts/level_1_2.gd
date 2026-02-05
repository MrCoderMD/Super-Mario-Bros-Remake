extends Level

@onready var mario=$Mario

const powerupcoords=[Vector2i(10,9),Vector2i(69,8),Vector2i(150,8)]
const coinbrickcoords=[Vector2i(29,8)]
const starcoords=[Vector2i(46,7)]
const lifeupcoords=[Vector2i(89,2)]
const invisible_blocks=[]
const QUESTION_BLOCK_ID=19
const BRICK_BLOCK_ID=20
const USED_BLOCK_ID=22
const INVISIBLE_BLOCK_ID=12
var BRICK_TEXTURE=load("res://files/images/brick1.bmp")
var DEBRIS_TEXTURE=load("res://files/images/block_debris1.png")
const palette="underground"
var is_pipe_entered=false
var target
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	if !Global.can_transition:
		mario.z_index=$ForegroundTile.z_index-1
		mario.global_position=self.to_global($ForegroundTile.map_to_local(Global.spawn[Global.currentlevel]))+Vector2(-16,mario.collision.shape.extents.y-16)
		print(mario.global_position)
		await mario.slide_up()
		mario.z_index=$ForegroundTile.z_index+1
		
	elif Global.checkpoint:
		mario.global_position.x=71*32+16
		
	else:
		Global.time=399

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("select"):
		Global.pause_game(self)
	if mario:
		if $CameraFollower.position.x<=$Mario.global_position.x:
			if mario.global_position.x<6144-get_viewport().get_visible_rect().size.x/2:
				$CameraFollower.position.x=$Mario.global_position.x


func _on_bg_music_finished() -> void:
	$CameraFollower/BgMusic.play() # Replace with function body.


func _on_level_timer_timeout() -> void:
	Global.check_time()



func _on_transition_body_entered(body: Node2D) -> void:
	if body==mario:
		await mario.slide_right()
		get_tree().change_scene_to_packed(load("res://Scenes/level_1-2-4.tscn"))
		 # Replace with function body.


func _on_transition_21_body_entered(body: Node2D) -> void:
	if body==mario:
		Global.transitionx["1-2"]=5728
		Global.is_warped=true
		Global.can_transition=true
		target="2-1"


func _on_transition_31_body_entered(body: Node2D) -> void:
	if body==mario:
		Global.transitionx["1-2"]=5888
		Global.is_warped=true
		Global.can_transition=true
		target="3-1"

func _on_transition_41_body_entered(body: Node2D) -> void:
	if body==mario:
		Global.transitionx["1-2"]=5984
		Global.is_warped=true
		Global.can_transition=true
		target="4-1"
