extends TouchScreenButton
class_name UI_Buttons

var is_touched:=false

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if self.get_parent().is_customizable:
			if self.get_node("Sprite2D").get_rect().has_point(self.get_node("Sprite2D").to_local(event.position)):
				if event.pressed:
					if !self.get_parent().drag_button:
						self.get_parent().drag_button=self
						self.get_parent().scale_button=self
						self.modulate=Color(1,0.5,0.25,self.modulate.a)
						is_touched=true
						self.get_parent().get_parent().get_node("MarginContainer/VBoxContainer/SizeHBox/SizeSlider").value=self.scale.x*100/self.default_scale
						self.get_parent().get_parent().get_node("MarginContainer/VBoxContainer/VisibleHBox/VisibleSlider").value=self.modulate.a*100
				else:
					self.get_parent().drag_button=null
					is_touched=false
			else:
				if self.get_parent().scale_button!=self:
					self.modulate=Color(1,1,1,self.modulate.a)
		
	elif event is InputEventScreenDrag:
		if self.get_parent().is_customizable:
			if self.get_node("Sprite2D").get_rect().has_point(self.get_node("Sprite2D").to_local(event.position)):
				if is_touched:
					self.global_position=event.position
