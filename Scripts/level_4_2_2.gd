extends Level

@onready var mario=$Mario

const powerupcoords=[]
const coinbrickcoords=[Vector2i(24,7)]
const starcoords=[]
const lifeupcoords=[]
const invisible_blocks=[]
const QUESTION_BLOCK_ID=19
const BRICK_BLOCK_ID=20
const USED_BLOCK_ID=22
const INVISIBLE_BLOCK_ID=12
var BRICK_TEXTURE=load("res://files/images/brick1.bmp")
var DEBRIS_TEXTURE=load("res://files/images/block_debris1.png")
const palette="underground"
var transition_level=load("res://Scenes/level_1-2-3.tscn")
var transition_coordx=2720
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	Global.can_transition=false
	$Mario.animation.play($Mario.size_prefix[Global.size]+"_jump") # Replace with function body.
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("select"):
		Global.pause_game(self)


func _on_level_timer_timeout() -> void:
	Global.check_time() # Replace with function body.


func _on_transition_body_entered(body: Node2D) -> void:
	if body==mario:
		await mario.slide_right()# Replace with function body.
		get_tree().change_scene_to_file("res://Scenes/level_"+Global.currentlevel+".tscn")
