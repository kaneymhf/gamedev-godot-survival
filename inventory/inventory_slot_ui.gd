extends Panel

@onready var item_sprite: Sprite2D = $CenterContainer/Panel/item_display

func update(item: InventoryItem):
	if !item:
		item_sprite.visible = false
	else:
		item_sprite.visible = true
		item_sprite.texture = item.texture
