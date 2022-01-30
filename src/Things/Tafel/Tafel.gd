extends Node2D
class_name Tafel


onready var _particles: CPUParticles2D = $CPUParticles2D
onready var _famfare_audio: AudioStreamPlayer = $FamfareAudio
onready var _pop_audio: AudioStreamPlayer = $PopAudio
onready var _particle_timer: Timer = $ParticleTimer
onready var _message: Node2D = $Messages


func trigger(num_pieces: int):
	_famfare_audio.play()
	
	_particle_timer.start()
	yield(_particle_timer, "timeout")
	
	_particles.emitting = true
	_pop_audio.play()
	
	_message.get_child(4 - num_pieces).show()
