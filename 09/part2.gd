#!/usr/bin/env -S godot --headless -s
extends SceneTree

# [size, id]
var disk_items: Array[PackedInt32Array]


func _init() -> void:
	var f := FileAccess.open("./input.txt", FileAccess.READ)
	generate_disk(f.get_as_text())
	print_disk()
	disk_items.pop_back()
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
			disk_items.append(PackedInt32Array([int(from[i]), -1]))
		else:  # file block
			disk_items.append(PackedInt32Array([int(from[i]), fid]))
			fid += 1
		#i += 1


func compact_disk() -> void:
	var i := 0
	while i < disk_items.size():
		#for i in disk_items.size():
		prints("processing", i)
		#print_disk()
		#prints("aksjdhksajd", i)
		#	prints("ASKJDHKAJ", disk_items.size(), disk_items[i], i)
		if disk_items[i][1] != -1:
			#prints("skipping", i, disk_items[i])
			i += 1
			continue
		var goal_size := disk_items[i][0]
		#prints("goal size:", goal_size)
		var j := disk_items.size() - 1
		while j > i:
			if not disk_items[j].size() > 2:
				if disk_items[j][0] <= goal_size:
					if disk_items[j][1] > 0:
						#prints("FOUND FIT", disk_items[j])
						break
			#prints(
			#	"too large", disk_items[j], disk_items[j].size(), goal_size - disk_items[j].size()
			#)
			j -= 1
		if j != 0:
			disk_items[i][0] = disk_items[j][0]
			disk_items[i][1] = disk_items[j][1]
			disk_items[i].append(-1)
			if disk_items[i][0] < goal_size:
				#prints("SIZE DIFFERENCE", disk_items[i][0], goal_size)
				disk_items.insert(i + 1, PackedInt32Array([goal_size - disk_items[i][0], -1]))
				j += 1
			disk_items[j][1] = -1
			#prints("JSAH JJJJJ", j, disk_items[j])
		else:
			prints("failed to find block of size", goal_size)
		#print("at end")
		#print_disk()
		#print()
		i += 1
		#await process_frame
	#prints("compacted")


func print_disk() -> void:
	var out: String = ""
	for i in disk_items:
		for j in i[0]:
			out += str(i[1]) if i[1] >= 0 else "."
	print(out)
	print(disk_items)


func checksum(arr: Array) -> int:
	var sum := 0
	# todo: add up result of multiplying each block position with file ID
	var curridx := 0
	for item in arr:
		for i in item[0]:
			if item[1] >= 0:
				sum += curridx * item[1]
			curridx += 1
		#sum += i * arr[i]
		#prints("checsum", i, arr[i], i * arr[i], sum)
	return sum
