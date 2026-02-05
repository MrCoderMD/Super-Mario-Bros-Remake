extends Level

@onready var mario=$Mario

const powerupcoords=[Vector2i(28,9),Vector2i(55,8),Vector2i(120,5),Vector2(161,9)]
const coinbrickcoords=[Vector2i(43,4),Vector2i(77,9)]
const starcoords=[Vector2i(81,9)]
const lifeupcoords=[]
const invisible_blocks=[Vector2i(63,8),Vector2i(64,7),Vector2i(65,8),Vector2i(66,9)]
const QUESTION_BLOCK_ID=19
const BRICK_BLOCK_ID=20
const USED_BLOCK_ID=22
const INVISIBLE_BLOCK_ID=12
var BRICK_TEXTURE=load("res://files/images/brick1.bmp")
var DEBRIS_TEXTURE=load("res://files/images/block_debris1.png")
const palette="underground"
var is_wine_added:=false
var target:String
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	mario.animation.play(mario.size_prefix[Global.size]+"_jump")
	if !Global.can_transition:
		mario.z_index=$ForegroundTile.z_index-1
		mario.global_position=self.to_global($ForegroundTile.map_to_local(Global.spawn[Global.currentlevel]))+Vector2(-16,mario.collision.shape.extents.y-16)
		print(mario.global_position)
		await mario.slide_up()
		mario.z_index=$ForegroundTile.z_index+1
	else:
		Global.time=399


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("select"):
		Global.pause_game(self)
	if mario:
		if $CameraFollower.position.x<=$Mario.global_position.x:
			$CameraFollower.position.x=$Mario.global_position.x
		if abs(mario.global_position.x-2064)<32:
			if mario.global_position.y<256:
				if mario.velocity.y<0:
					if !is_wine_added:
						is_wine_added=true
						await create_vine()


func _on_transition_body_entered(body: Node2D) -> void:
	if body==mario:
		await mario.slide_right() # Replace with function body.
		get_tree().change_scene_to_file("res://Scenes/level_1-2-4.tscn")


func _on_level_timer_timeout() -> void:
	Global.check_time() # Replace with function body.


func _on_bg_music_finished() -> void:
	$CameraFollower/BgMusic.play() # Replace with function body.


func _on_transition_51_body_entered(body: Node2D) -> void:
	if body==mario:
		target="5-1"
		Global.can_transition=true
		Global.transitionx["4-2"]=6880
		Global.is_warped=true
	

func create_vine():
	var vine_appear=AudioStreamPlayer2D.new()
	vine_appear.stream=load("res://files/sounds/mushroomappear.wav")
	$CameraFollower.add_child(vine_appear)
	vine_appear.play()
	var vine_count=7
	$ForegroundTile.set_cell(Vector2i(64,5),USED_BLOCK_ID,Vector2i(0,0))
	for i in vine_count:
		var vine=load("res://Scenes/vine.tscn").instantiate()
		if i==0:
			vine.is_top=true
		var initial= self.to_global($ForegroundTile.map_to_local(Vector2i(64,5)))
		vine.global_position=initial
		vine.target_y=initial.y-32*(vine_count-i-1)
		vine.z_index=$ForegroundTile.z_index-1
		self.add_child(vine)
		await get_tree().create_timer(0.533).timeout


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body==mario:
		get_tree().change_scene_to_file("res://Scenes/level_4_2_3.tscn") # Replace with function body.
