extends StaticBody2D

var _type = Climb.ObjectType.PLATFORM
var _subtype = Climb.PlatformType.STANDARD
var _id = 0
var center = Vector2(0, 0)
var segments = 50  
var polygon_node = null 

func set_id(id):
	_id = id

func get_id():
	return _id

func get_type():
	return _type

func get_subtype():
	return _subtype

func display_zone(theta_1, theta_2, r_1, r_2):
	polygon_node = Polygon2D.new()
	add_child(polygon_node)
	polygon_node.position = center
	polygon_node.polygon = _calculate_annulus_vertices(center, r_1, r_2, theta_1, theta_2, segments)
	polygon_node.color = Color(0.7, 0.8, 1, 0.0)
	polygon_node.scale.x = 0.5

func remove_polygon():
	remove_child(polygon_node)


func resize_zone(theta_1, theta_2, r_1, r_2):
	if polygon_node:
		polygon_node.polygon = _calculate_annulus_vertices(center, r_1, r_2, theta_1, theta_2, segments)

func _calculate_annulus_vertices(center, r_1, r_2, theta_1, theta_2, segments):
	var vertices = []
	var angle_step = (theta_2 - theta_1) / segments

	# Add the outer arc vertices
	for i in range(segments + 1):
		var angle = theta_1 + i * angle_step
		var x = r_2 * cos(angle)
		var y = r_2 * sin(angle)
		vertices.append(Vector2(x, y))

	# Add the inner arc vertices (in reverse order to close the loop)
	for i in range(segments, -1, -1):
		var angle = theta_1 + i * angle_step
		var x = r_1 * cos(angle)
		var y = r_1 * sin(angle)
		vertices.append(Vector2(x, y))

	return vertices
