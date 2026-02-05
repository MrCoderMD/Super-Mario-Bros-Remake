extends Node2D

var valx:=120
var valy:=-512
var dir:int

func _process(delta):
	global_position.x+=dir*valx*delta
	global_position.y+=valy*delta-0.5*Global.GRAVITY*pow(delta,2.0)
	valy+=Global.GRAVITY*delta
	if global_position.y>=488:
		self.queue_free()
