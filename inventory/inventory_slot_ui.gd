extends Panel

@onready var item_sprite: Sprite2D = $CenterContainer/Panel/item_display
@onready var ammount_label: Label = $CenterContainer/Panel/Label

func update(slot: InventorySlot):
	if !slot.item:
		item_sprite.visible = false
		ammount_label.visible = false			
	else:
		item_sprite.visible = true
		item_sprite.texture = slot.item.texture
		if slot.ammount > 1:
			ammount_label.visible = true
			ammount_label.text = str(slot.ammount)
