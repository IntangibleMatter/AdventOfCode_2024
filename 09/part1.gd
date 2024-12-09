#!/usr/bin/env -S godot --headless -s
extends SceneTree

var disk_items: Array[int]


func _init() -> void:
	#var f := FileAccess.open("./input.txt", FileAccess.READ)
	var f := FileAccess.open("./input.txt", FileAccess.READ)
	generate_disk(f.get_as_text())
	print(disk_items)
	prints("\n\ncompact\n")
	compact_disk()
	print(disk_items)
	print("\n------\nChecksum:")
	print(checksum(disk_items))
	quit()


func generate_disk(from: String) -> void:
	var fid: int = 0
	for i in from.length():
		if i & 0x01 == 1:  # empty block
			for j in int(from[i]):
				disk_items.append(-1)
		else:  # file block
			for j in int(from[i]):
				disk_items.append(fid)
			fid += 1
		i += 1


func compact_disk() -> void:
	var i := 0
	while i < disk_items.size():
		#prints("aksjdhksajd", i)
		if disk_items[i] >= 0:
			#prints("skipping", i)
			i += 1
			continue
		var new_num: int = disk_items.pop_back()
		while new_num < 0:
			new_num = disk_items.pop_back()
			#prints("nn", new_num)
		disk_items[i] = new_num
	prints("compacted")


func checksum(arr: Array) -> int:
	var sum := 0
	# todo: add up result of multiplying each block position with file ID
	for i in arr.size():
		sum += i * arr[i]
		prints("checsum", i, arr[i], i * arr[i], sum)
	return sum
