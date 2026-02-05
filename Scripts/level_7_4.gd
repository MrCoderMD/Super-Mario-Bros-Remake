extends Level

@onready var mario=$Mario

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

var final:Node2D

func _ready() -> void:
	super()
	if Global.checkpoint:
		mario.global_position=Vector2(2336,288)
	Global.time=399

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("select"):
		Global.pause_game(self)
	if mario:
		if final:
			if mario.global_position.x<final.get_node("End").global_position.x-get_viewport().get_visible_rect().size.x/2.0:
				if $CameraFollower.position.x<=$Mario.global_position.x:
					$CameraFollower.position.x=$Mario.global_position.x
		else:
			if $CameraFollower.position.x<=$Mario.global_position.x:
				$CameraFollower.position.x=$Mario.global_position.x

func _on_bg_music_finished() -> void:
	$CameraFollower/BgMusic.play() # Replace with function body.


func _on_level_timer_timeout() -> void:
	Global.check_time() # Replace with function body.

func finish_castle():
	get_node("LevelTimer").stop()
	mario.set_physics_process(false)
	$CameraFollower/BgMusic.stop()
	var bridgebreak=AudioStreamPlayer2D.new()
	bridgebreak.stream=load("res://files/sounds/bridgebreak.wav")
	get_node("CameraFollower").add_child(bridgebreak)
	final.get_node("ForegroundTile").set_cell(final.get_node("ForegroundTile").get_used_cells_by_id(10)[0],-1)
	var positions=final.get_node("ForegroundTile").get_used_cells_by_id(7)
	positions.reverse()
	for cell in positions:
		final.get_node("ForegroundTile").set_cell(cell,-1)
		bridgebreak.play()
		await get_tree().create_timer(0.1).timeout
	mario.set_physics_process(true)
	mario.is_auto_walking=true
	var castleend=AudioStreamPlayer2D.new()
	castleend.stream=load("res://files/sounds/castleend.wav")
	get_node("CameraFollower").add_child(castleend)
	castleend.play()
	await castleend.finished
	Global.checkpoint=false
	Global.currentlevel=str(int(Global.currentlevel[0])+1)+"-1"
	get_tree().change_scene_to_file("res://Scenes/stage_transition.tscn")
