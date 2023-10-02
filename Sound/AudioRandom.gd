extends AudioStreamPlayer2D

func play_rand():
	self.pitch_scale = randf_range(0.8, 1.2)
	self.play()
