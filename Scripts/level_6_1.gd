extends Level

@onready var mario=$Mario

const powerupcoords=[Vector2i(36,5),Vector2i(130,8)]
const lifeupcoords=[Vector2i(90,8)]
const coinbrickcoords=[Vector2i(43,9),Vector2i(152,9)]
const starcoords=[]
const invisible_blocks=[Vector2i(90,8),Vector2i(113,5),Vector2i(113,9)]
const QUESTION_BLOCK_ID:=19
const BRICK_BLOCK_ID:=20
const USED_BLOCK_ID:=22
const INVISIBLE_BLOCK_ID:=9
var BRICK_TEXTURE=load("res://files/images/brickred.bmp")
var DEBRIS_TEXTURE=load("res://files/images/block_debris0.png")
const palette="overworld"
var transition_coordx=-1
var transition_level
const castle_x:=6224
var is_lakitu_active:=true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	if Global.checkpoint:
		mario.global_position=Vector2(2592,400)
	Global.time=399
	$Lakitu.connect("death",on_lakitu_death)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("select"):
		Global.pause_game(self)
		#$CameraFollower/Controls.process_mode=Node.PROCESS_MODE_ALWAYS
	if mario:
		if $CameraFollower.position.x<=$Mario.global_position.x:
			$CameraFollower.position.x=$Mario.global_position.x


func _on_level_timer_timeout() -> void:
	Global.check_time("6-2")


func _on_bg_music_finished() -> void:
	$CameraFollower/BgMusic.play() # Replace with function body.


func _on_checkpoint_body_entered(body: Node2D) -> void:
	if body==mario:
		Global.checkpoint=true # Replace with function body.

func on_lakitu_death():
	is_lakitu_active=false
	


func _on_lakitu_spawn_body_entered(body: Node2D) -> void:
	if body==mario:
		if !is_lakitu_active:
			var lakitu=load("res://Scenes/lakitu.tscn").instantiate()
			lakitu.name="Lakitu"
			lakitu.global_position=Vector2(4000,96) # Replace with function body.
			get_tree().current_scene.add_child(lakitu)


func _on_lakitu_end_body_entered(body: Node2D) -> void:
	var lakitu=self.get_node("Lakitu")
	lakitu.state=lakitu.States.IDLE # Replace with function body.
	lakitu.get_node("SpikeyThrow").stop()
	
	
