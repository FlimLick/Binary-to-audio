extends Control

var stream = AudioStreamSample.new()
var file1 = File.new()
var file2 = File.new()
var file3 = File.new()
var repeat = 8
var mix_rate = 48000
onready var Global = get_node("..")

func _ready():
	pass
		
func audioconvert(path):
	if path != null and File.new().file_exists(path):
		Global.OpenCompileScreen()
		file2.open(path, file2.READ)
		file1.open("user://data", file1.WRITE)
		while not file2.eof_reached():
			inttobin(file2.get_8())
		file1.close()
		file2.close()
		setaudio()
		Global.CloseCompileScreen()
		
func setaudio():
	file3.open("user://data", file3.READ)
	var buffer = file3.get_buffer(file3.get_len())
	stream.data = buffer
	stream.format = 0
	stream.mix_rate = mix_rate
	stream.stereo = false
	$BinaryPlayer.stream = stream
	calculatelength()
	file3.close()
		
func inttobin(number):
	var temp 
	var count = 7
	while(count >= 0): 
		temp = number >> count 
		if(temp & 1): 
			for i in repeat:
				file1.store_8(127)
		else: 
			for i in repeat:
				file1.store_8(128)
		count -= 1 
	
func _on_BinaryPlayer_finished():
	$Play.pressed = false

func _on_Repeat_text_changed(new_text):
	repeat = int(new_text)
	
func _on_Hrz_text_changed(new_text):
	mix_rate = int(new_text)
	setaudio()

func _on_Volume_value_changed(value):
	$BinaryPlayer.volume_db = value

func _on_Compile_button_down():
	audioconvert(Global.BinaryPath)

func _on_Play_toggled(button_pressed):
	if button_pressed:
		$BinaryPlayer.playing = true
	if !button_pressed:
		$BinaryPlayer.playing = false
		
func _on_OpenFile_button_down():
	Global.OpenDialog()

func calculatelength():
	$Panel/Label.text = ("Length: " + str(stream.get_length()) + " Seconds\nSize: " + str(file3.get_len()) + " Bytes\nPath: " + Global.BinaryPath)
