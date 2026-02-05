extends Node

enum Size{SMOL,BIG,FIERY}
var size=Size.SMOL
const GRAVITY:=1024
var PowerUpMushroom:=load("res://Scenes/power_up_mushroom.tscn")
var Flower:=load("res://Scenes/fire_flower.tscn")
var Mushroom1Up:=load("res://Scenes/mushroom_1_up.tscn")
var CoinPopped:=load("res://Scenes/coin_popped.tscn")
var controls=load("res://Scenes/controls.tscn")
var score:=0
var lives:=3
var coins:=0
var time:=399
var is_completed:=false
var level:Node2D

var brick_break=AudioStreamPlayer2D.new()
var blockhit=AudioStreamPlayer2D.new()
var stomp=AudioStreamPlayer2D.new()
var lowtime=AudioStreamPlayer2D.new()
var lifeup=AudioStreamPlayer2D.new()
var can_transition:=true
var is_warped:=false
var checkpoint:=false

var currentlevel="1-1"

var ug_lvl=["1-2","4-2","5-2"]

var used_block={
	"overworld":load("res://files/images/blockq_used.png"),
	"castle":load("res://files/images/blockq_used.png"),
	"underground":load("res://files/images/blockq1_used.png")
}

var transitionx={
	"1-1":1856,"1-2":3328,"2-1":3328,"3-1":1248,"4-1":4256,"4-2":2720,"5-1":5024,"5-2":1792,"6-2":640,"7-1":3008,
	"8-1":2656,"8-3":5024,"8-4":0
}

var transition_level={
	"1-1":load("res://Scenes/level_1_1_1.tscn"),
	"1-2":load("res://Scenes/level_1-2-3.tscn"),
	"2-1":load("res://Scenes/level_1_1_1.tscn"),
	"3-1":load("res://Scenes/level_3-1-1.tscn"),
	"4-1":load("res://Scenes/level_4_1_1.tscn"),
	"4-2":load("res://Scenes/level_4_2_2.tscn"),
	"5-1":load("res://Scenes/level_4_2_2.tscn"),
	"5-2":load("res://Scenes/level_5_2_2.tscn"),
	"6-2":load("res://Scenes/level_4_2_2.tscn"),
	"7-1":load("res://Scenes/level_1_1_1.tscn"),
	"8-1":load("res://Scenes/level_1-2-3.tscn"),
	"8-2":load("res://Scenes/level_4_2_2.tscn"),
	"8-4":load("res://Scenes/level_8-4.tscn")
}

var spawn={
	"1-1":Vector2i(164,11),"1-2":Vector2i(116,11),"2-1":Vector2i(177,10),"3-1":Vector2i(63,11),"4-1":Vector2i(328,11),
	"4-2":Vector2i(132,11),"5-1":Vector2i(164,11),"5-2":Vector2i(116,11),"6-2":Vector2i(36,11),"7-1":Vector2i(116,11),
	"8-1":Vector2i(116,11),"8-2":Vector2i(164,11),"8-4":Vector2i.ZERO
}

func _ready() -> void:
	brick_break.stream=load("res://files/sounds/blockbreak.wav")
	blockhit.stream=load("res://files/sounds/blockhit.wav")
	lowtime.stream=load("res://files/sounds/lowtime.wav")
	lifeup.stream=load("res://files/sounds/oneup.wav")
	

func pause_game(lvl:Node2D):
	get_tree().paused=true
	var pausemenu=load("res://Scenes/pause.tscn").instantiate()
	if lvl.has_node("CameraFollower"):
		pausemenu.global_position=lvl.get_node("CameraFollower").global_position-Vector2(426.5,240)
	else:
		pausemenu.global_position=Vector2.ZERO
	lvl.add_child(pausemenu)


func check_time(next_level=""):
	if time==0:
		if !is_completed:
			level.get_node("LevelTimer").autostart=false
			size=Size.SMOL
			level.mario.shrink_or_die()
	else:
		time-=1
		if !is_completed:
			if time<100:
				if lowtime not in level.get_node("CameraFollower").get_children():
					level.get_node("CameraFollower").add_child(lowtime)
					level.get_node("CameraFollower/BgMusic").stop()
					lowtime.play()
					await lowtime.finished
					level.get_node("CameraFollower/BgMusic").stream=load("res://files/sounds/"+level.palette+"-fast.wav")
					level.get_node("CameraFollower/BgMusic").play()
		else:
			score+=50
			if time==0:
				await level.mario.get_node("LevelEndMusic").finished
				currentlevel=next_level
				Global.checkpoint=false
				get_tree().change_scene_to_file("res://Scenes/stage_transition.tscn")
			else:
				level.get_node("LevelTimer").start(0.005)

func reset_status():
	lives=3
	coins=0
