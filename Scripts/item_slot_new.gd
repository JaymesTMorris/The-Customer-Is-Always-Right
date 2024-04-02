extends TextureRect

func _get_drag_data(at_position):
	var item_slot = get_parent().get_name()
	var item_slot_type = item_slot.left(item_slot.length() - 1)
	if item_slot_type != "Plate":
		var data = {} 
		data["origin_node"] = self
		data["origin_slot"] = item_slot
		data["origin_texture"] = texture

		#print(texture.resource_path.get_file().get_basename())
		var drag_texture = TextureRect.new()
		drag_texture.expand_mode = 1
		drag_texture.texture = texture
		drag_texture.size = Vector2(100, 100)
		
		var control = Control.new()
		control.add_child(drag_texture)
		drag_texture.position = -0.5 * drag_texture.size
		set_drag_preview(control)
		return data
	else:
		texture = null
		global.map_data[item_slot] = []
		for n in get_children():
			remove_child(n)
			n.queue_free()
		print("- - - - - _get_drag_data  - - - - -")
		print("Cleared Plate")
		print("map_data: ",global.map_data)
		print("- - - - - - - - - - - - - - - - - -")

func _can_drop_data(at_position, data):
	var target_item_slot = get_parent().get_name()
	var item_slot_type = target_item_slot.left(target_item_slot.length() - 1)

	if (item_slot_type == "Grill") and global.map_data[target_item_slot] == [] \
	or (item_slot_type == "Plate") and global.map_data[target_item_slot].size() < 6 \
	or target_item_slot == "Trash":
		return true
	else:
		return false

func _drop_data(at_position, data):
	print("- - - - - - _drop_data  - - - - - -")
	#var target_item_slot = get_parent()
	var target_item_slot_name = get_parent().get_name()
	var origin_node_name = data["origin_node"].get_parent().get_name()
	var origin_node_type = data["origin_node"].get_parent().get_name().left(origin_node_name.length() - 1)
	var item_slot_type = target_item_slot_name.left(target_item_slot_name.length() - 1)
	
	# TRASH ITEMS
	if target_item_slot_name == "Trash":
		if origin_node_type == "Plate":
			data["origin_node"].texture = null
			for n in data["origin_node"].get_children():
				data["origin_node"].remove_child(n)
				n.queue_free()
			print("Trashed items and textures on plate.")
		elif data["origin_slot"].left(2) != "O_": # If origin slot is not a origin item
			data["origin_node"].texture = null
			print("Trashed item.")
			if origin_node_type == "Grill":
				get_tree().get_root().find_child("CookingManager", true, false).emit_signal("grill_item_removed", origin_node_name)
		else:
			print("Trashed item in hand; Kept origin item.")
		global.map_data[origin_node_name] = []
	# HANDLE ITEM MOVEMENT
	else:
		# REMOVE ITEMS FROM PREVIOUS SLOT
		if data["origin_slot"].left(2) != "O_": # If origin slot is not a origin item
			data["origin_node"].texture = null
			global.map_data[origin_node_name] = []
			print("Removed item(s) from previous location.")
			if origin_node_type == "Plate":
				for n in data["origin_node"].get_children():
					data["origin_node"].remove_child(n)
					n.queue_free()
				print("Removed item textures from plate.")
			elif origin_node_type == "Grill":
				get_tree().get_root().find_child("CookingManager", true, false).emit_signal("grill_item_removed", origin_node_name)
		else:
			print("Copying item to new location...")
		
		# MOVE ITEMS TO NEW SLOT
		if item_slot_type == "Grill":
			texture = data["origin_texture"]
			get_tree().get_root().find_child("CookingManager", true, false).emit_signal("new_grill_item", target_item_slot_name)
		elif item_slot_type == "Plate":
			var new_texture_node = TextureRect.new()
			new_texture_node.texture = data["origin_texture"]
			texture = data["origin_texture"]
			
			add_child(new_texture_node)
			new_texture_node.position.y -= (250 * global.map_data[target_item_slot_name].size())
		
		global.map_data[target_item_slot_name].append(data["origin_texture"].resource_path.get_file().get_basename())
		print("Item moved to new location.")
		
	print("map_data: ",global.map_data)
	print("- - - - - - - - - - - - - - - - - -")

func clear_plate(): # Called by burger_order_generator_new.gd
	texture = null
	for n in get_children():
		remove_child(n)
		n.queue_free()
	global.map_data[get_parent().get_name()] = []




