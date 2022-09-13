extends RichTextLabel


func _ready():
	connect("meta_clicked", self, "meta_clicked")


func meta_clicked(meta: String):
	OS.shell_open(meta.replace("\"", ""))
