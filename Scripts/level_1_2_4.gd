extends Level
@onready var mario=$Mario
var castle_x=944
var palette="overworld"
var is_plant_added:=false
var transition_coordx:=0
var next_level={
	"1-2":"1-3",
	"2-2":"2-3",
	"4-2":"4-3"
}
var invisible_blocks=[]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	mario.block_layer=$ForegroundTile
	mario.global_position=Vector2(160,352+mario.collision.shape.extents.y)
	mario.set_physics_process(false)
	var transition=AudioStreamPlayer2D.new()
	transition.stream=load("res://files/sounds/pipe.wav")
	mario.add_child(transition)
	transition.play()
	var tween=get_tree().create_tween()
	tween.tween_property(mario,"position:y",-$Mario/CollisionShape2D.shape.extents.y*2,0.72).as_relative()
	await tween.finished
	tween.kill()
	transition.queue_free()
	mario.set_physics_process(true)
	mario.animation.z_index=0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("select"):
		Global.pause_game(self)
	if mario:
		if $CameraFollower.position.x<=$Mario.global_position.x:
			$CameraFollower.position.x=$Mario.global_position.x
	if abs(mario.global_position.x-160)>64:
		if !is_plant_added:
			is_plant_added=true
			var plant=load("res://Scenes/plant.tscn").instantiate()
			self.add_child(plant)
			plant.global_position=Vector2(144,380)
		

func _on_level_timer_timeout() -> void:
	Global.check_time(next_level[Global.currentlevel])
