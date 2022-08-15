extends Node
var CompileScreenOpen = false
var BinaryPath


func _ready():
	OpenDialog()
	get_tree().get_root().set_transparent_background(true)
	
func OpenDialog():
	OS.window_size = Vector2($Control.rect_size.x, 480)
	OS.center_window()
	yield(get_tree().create_timer(0.01), "timeout")
	$FileDialog.rect_size = Vector2(537, 344)
	$FileDialog.popup_centered()

func OpenCompileScreen():
	OS.set_window_title("Compiling")
	if !CompileScreenOpen:
		CompileScreenOpen = true
		$"SfxPlayer".playing = false
		$"SfxPlayer".stream = load("res://Woo.wav")
		$"SfxPlayer".play()
		$"Compile Screen".visible = true
		yield(get_tree().create_timer(3), "timeout")

func CloseCompileScreen():
	OS.set_window_title("Flim's Dumb Audio Converter")
	if CompileScreenOpen:
		CompileScreenOpen = false
		$"Compile Screen".visible = false
		$"SfxPlayer".stream = load("res://WeeWoo.wav")
		$"SfxPlayer".play()

func _on_FileDialog_file_selected(path):
	BinaryPath = path

func _on_FileDialog_popup_hide():
	OS.window_size = $Control.rect_size
	OS.center_window()


func _on_Close_button_down():
	get_tree().quit()
