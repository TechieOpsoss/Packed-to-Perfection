class_name TriGridUtils extends Node

static func make_meshes(gridSpaceCellPositions: Array[Vector2i], triangle_width: float, spacing: float) -> Array[PackedVector2Array]:
	# Grid measurements
	var triangle_height: float = triangle_width * sin(deg_to_rad(60))
	var triangle_circumradius: float = triangle_width / sqrt(3)
	var triangle_grid_size: Vector2 = Vector2(triangle_width / 2, triangle_height)
	var spacing_width: float = triangle_width - spacing
	var spacing_height: float = spacing_width * sin(deg_to_rad(60))
	var spacing_circumradius: float = spacing_width / sqrt(3)
	# Return value
	var meshes: Array[PackedVector2Array] = []
	for gridSpaceCellPosition: Vector2i in gridSpaceCellPositions:
		# Upward facing
		if ((gridSpaceCellPosition.x % 2) == (gridSpaceCellPosition.y % 2)):
			meshes.append(PackedVector2Array(
			[
				Vector2(gridSpaceCellPosition) * triangle_grid_size + Vector2(-spacing_width/2,spacing_height-spacing_circumradius),
				Vector2(gridSpaceCellPosition) * triangle_grid_size + Vector2(0,-spacing_circumradius),
				Vector2(gridSpaceCellPosition) * triangle_grid_size + Vector2(spacing_width/2,spacing_height-spacing_circumradius)
			]))
		# Downward facing
		else:
			var verticalOffset: float = triangle_circumradius - triangle_height / 2
			meshes.append(PackedVector2Array(
			[
				Vector2(gridSpaceCellPosition) * triangle_grid_size + Vector2(-spacing_width/2,spacing_circumradius-spacing_height) - Vector2(0, verticalOffset*2),
				Vector2(gridSpaceCellPosition) * triangle_grid_size + Vector2(0,spacing_circumradius) - Vector2(0, verticalOffset*2),
				Vector2(gridSpaceCellPosition) * triangle_grid_size + Vector2(spacing_width/2,spacing_circumradius-spacing_height) - Vector2(0, verticalOffset*2)
			]))
	return meshes

# Works for meshes beyond just triangular
static func combine_meshes(meshes: Array[PackedVector2Array]) -> Array:
	# Return values
	var combinedMeshes: PackedVector2Array = []
	var combinedIndices: Array[PackedInt32Array] = []
	# Population loop
	var index: int = 0
	for mesh: PackedVector2Array in meshes:
		var meshIndices: PackedInt32Array = PackedInt32Array()
		for __ in mesh:
			meshIndices.append(index)
			index += 1
		combinedIndices.append(meshIndices)
		combinedMeshes.append_array(mesh)
	return [combinedMeshes, combinedIndices]

static func screen_to_grid(screenSpace: Vector2, pointsDown: bool, triangle_width: float) -> Vector2i:
	# Grid measurements
	var triangle_height: float = triangle_width * sin(deg_to_rad(60))
	var triangle_grid_size: Vector2 = Vector2(triangle_width / 2, triangle_height)
	# Find nearest cell (centroid)
	var cellY: int = round(screenSpace.y / triangle_grid_size.y)
	# Horizontally offset grid snap if on an odd row, or upside down
	var horizontalOffset: int = (1 if ((cellY % 2 == 0) != pointsDown) else 0)
	var cellX: int = round((float(screenSpace.x)/triangle_grid_size.x + horizontalOffset)/2.0)*2 - horizontalOffset
	return Vector2i(cellX, cellY)

static func grid_to_screen(gridSpace: Vector2i, triangle_width: float) -> Vector2:
	# Grid measurements
	var triangle_height: float = triangle_width * sin(deg_to_rad(60))
	var triangle_circumradius: float = triangle_width / sqrt(3)
	var triangle_grid_size: Vector2 = Vector2(triangle_width / 2, triangle_height)
	# Offset to be vertically centered based on height rather than centroid
	var verticalOffset: float = triangle_circumradius - triangle_height / 2
	if ((gridSpace.x % 2) == (gridSpace.y % 2)):
		return Vector2(gridSpace) * triangle_grid_size - Vector2(0, verticalOffset)
	else:
		return Vector2(gridSpace) * triangle_grid_size + Vector2(0, verticalOffset)
