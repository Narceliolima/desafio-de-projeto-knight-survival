extends CanvasLayer

@onready var meat_label = %MeatLabel
@onready var time_label = %TimeLabel

func _ready():
	#Essa linha não é necessária, pode ser feito um refresh a cada quadro na variável
	#Mas o que é melhor? Acionar a função assim que ela ocorre, ou esperar o próximo quadro para acionar?
	Singleton.player.meat_collected.connect(refresh_meat_label)

func _process(delta):
	
	refresh_time_label()
	refresh_meat_label()

func refresh_time_label():
	#ex de formatação godot "%02d:%02d" % [20,30] > 20:30
	time_label.text = Singleton.get_time_elapsed()

func refresh_meat_label():
	
	meat_label.text = str(Singleton.meat_counter)
