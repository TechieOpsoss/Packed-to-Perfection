extends Node

var OccupiedCells: Array[Vector2i] = []

func CellViable(cell: Vector2i) -> bool:
	return OccupiedCells.find(cell) == -1
