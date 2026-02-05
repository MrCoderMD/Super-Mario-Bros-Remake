extends Level

@onready var mario=$Mario
@onready var level=$Node2D

const QUESTION_BLOCK_ID=9
const BRICK_BLOCK_ID=0
const USED_BLOCK_ID=6
const INVISIBLE_BLOCK_ID=8
const COIN_BRICK_ID=0
const invisible_blocks=[]
const powerupcoords=[]
const lifeupcoords=[]
const coinbrickcoords=[]
const starcoords=[]
const palette:="castle"

func _ready() -> void:
	super()
	if !Global.can_transition:
		mario.z_index=level.get_node("ForegroundTile").z_index-1
		mario.global_position=self.to_global(level.get_node("ForegroundTile").map_to_local(Global.spawn[Global.currentlevel]))+Vector2(-16,mario.collision.shape.extents.y-16)
		await mario.slide_up()
		mario.z_index=level.get_node("ForegroundTile").z_index+1

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("select"):
		Global.pause_game(self)
		#$CameraFollower/Controls.process_mode=Node.PROCESS_MODE_ALWAYS
	if mario:
		if $CameraFollower.position.x<=$Mario.global_position.x:
			$CameraFollower.position.x=$Mario.global_position.x

func _on_bg_music_finished() -> void:
	$CameraFollower/BgMusic.play() # Replace with function body.


func _on_level_timer_timeout() -> void:
	Global.check_time() # Replace with function body.

			
func _on_end_screen_entered() -> void:
	level=level.duplicate()
	level.global_position.x=level.get_node("End").global_position.x
	mario.block_layer=level.get_node("ForegroundTile")
	get_tree().current_scene.add_child(level)


func _on_wrong_transition_body_entered(body: Node2D) -> void:
	if body==mario:
		Global.can_transition=true
		Global.transitionx["8-4"]=level.get_node("WrongTransition").global_position.x# Replace with function body.\
		Global.transition_level["8-4"]=load("res://Scenes/level_8-4.tscn")
		Global.spawn["8-4"]=Vector2i(20,11)


func _on_right_transition_body_entered(body: Node2D) -> void:
	if body==mario:
		Global.can_transition=true
		Global.transitionx["8-4"]=level.get_node("RightTransition").global_position.x
		Global.transition_level["8-4"]=load("res://Scenes/level_8_4_5.tscn")
		Global.spawn["8-4"]=Vector2i(4,11)
		
func _on_cheep_timer_timeout() -> void:
	var cheep=load("res://Scenes/cheep.tscn").instantiate()
	cheep.palette="red" # Replace with function body.
	cheep.state=cheep.States.FLY
	cheep.dir=[1,-1][randi_range(0,1)]
	cheep.velocity.x=cheep.dir*randi_range(1,3)*100
	cheep.global_position=Vector2(randi_range(mario.global_position.x-get_viewport().get_visible_rect().size.x/2,mario.global_position.x+get_viewport().get_visible_rect().size.x/2),get_viewport().get_visible_rect().size.y)
	self.add_child(cheep)
	$CheepTimer.start(randf_range(0.5,1.5)) # Replace with function body.


func _on_cheep_spawner_body_entered(body) -> void:
	if body.name=="Mario":
		$CheepTimer.start(randf_range(0.5,1.5)) # Replace with function body.
