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

var can_exit:=false

func _ready() -> void:
	super()
	if !Global.can_transition:
		mario.z_index=$ForegroundTile.z_index-1
		mario.global_position=self.to_global($ForegroundTile.map_to_local(Global.spawn[Global.currentlevel]))+Vector2(-16,mario.collision.shape.extents.y-16)
		await mario.slide_up()
		mario.z_index=$ForegroundTile.z_index+1

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("select"):
		Global.pause_game(self)
		#$CameraFollower/Controls.process_mode=Node.PROCESS_MODE_ALWAYS
	if mario:
		if mario.global_position.x<1621.5:
			if $CameraFollower.position.x<=$Mario.global_position.x:
				$CameraFollower.position.x=$Mario.global_position.x
				
		if mario.global_position.x>1760:
			mario.is_auto_walking=false
			await get_tree().create_timer(0.5).timeout
			mario.set_physics_process(false)
			$Label.visible=true
			
				
func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if can_exit:
			Global.resetstatus()
			get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

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
	$CameraFollower.add_child(bridgebreak)
	$ForegroundTile.set_cell($ForegroundTile.get_used_cells_by_id(10)[0],-1)
	var positions=$ForegroundTile.get_used_cells_by_id(7)
	positions.reverse()
	for cell in positions:
		$ForegroundTile.set_cell(cell,-1)
		bridgebreak.play()
		await get_tree().create_timer(0.1).timeout
	mario.set_physics_process(true)
	mario.is_auto_walking=true
	var castleend=AudioStreamPlayer2D.new()
	castleend.stream=load("res://files/sounds/castleend.wav")
	$CameraFollower.add_child(castleend)
	castleend.play()
	await castleend.finished
	castleend.stream=load("res://files/sounds/princessmusic.wav")
	castleend.play()
	await get_tree().create_timer(1).timeout
	$Label2.visible=true # Replace with function body.
	await get_tree().create_timer(1).timeout
	$Label3.visible=true # Replace with function body.
	can_exit=true
