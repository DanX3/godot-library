#@tool
@icon("res://library/assets/smear_icon.png")
class_name Smear extends Node2D

@export var line: Line2D
@export var draw_smear = true
@export var duration_ms := 100
@export var min_distance = 10.0
@export var smoothing_factor: float = 0.5 # Adjust this value (0.0 to 1.0) for more/less smoothing.
@export var subdivision_count: int = 10 # Number of segments to generate between original points. More subdivisions = smoother line.
var points_ts : PackedInt32Array

var original_points: PackedVector2Array

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		queue_redraw()
	
	if line == null:
		return
	
	var removeCount = 0
	var time = Time.get_ticks_msec()
	for i in points_ts:
		if time > i:
			removeCount += 1
	
	if removeCount > 0:
		for i in range(removeCount):
			original_points.remove_at(0)
			points_ts.remove_at(0)
		generate_smoothed_bezier_line()

	if draw_smear:
		if line.get_point_count() == 0 or (line.get_point_position(line.get_point_count() - 1)).distance_squared_to(global_position) > min_distance * min_distance:
			points_ts.append(Time.get_ticks_msec() + duration_ms)
			add_new_original_point(global_position - line.get_parent().global_position)
	else:
		clear_original_points()
		points_ts.clear()
	

func _draw() -> void:
	if line == null:
		return
	var line_width = 0.5 * line.width
	draw_circle(Vector2.ZERO, line_width, Color(0, 1, 1, 0.5), false, 2);
	
	for p in original_points:
		line.draw_circle(p, 5, Color.RED)


func generate_smoothed_bezier_line():
	"""
	Generates a smoother Line2D using cubic Bezier interpolation
	between the original_points.
	"""
	line.clear_points() # Clear any existing points in the Line2D.

	if original_points.size() < 2:
		print("Error: Need at least 2 original points to generate a line.")
		return

	print("Generating smoothed line with %d original points." % original_points.size())

	# Calculate "tangents" for all original points first. These will serve
	# as directions for calculating the Bezier control points (P1 and P2).
	# These tangents are vectors representing the desired direction of the curve
	# at each original point.
	var tangents_in: Array[Vector2] = []
	var tangents_out: Array[Vector2] = []

	for i in range(original_points.size()):
		var current_pos = original_points[i]
		var in_tangent_calc = Vector2.ZERO
		var out_tangent_calc = Vector2.ZERO

		# --- Calculate the 'in-tangent' for the current point ---
		# This tangent points from the current_pos back towards the previous original point,
		# influencing the curve coming *into* current_pos.
		if i > 0:
			var prev_pos = original_points[i-1]
			var dist_prev = current_pos.distance_to(prev_pos)
			in_tangent_calc = (prev_pos - current_pos).normalized() * dist_prev * smoothing_factor
		else:
			# For the very first point, there's no incoming segment, so no in-tangent.
			in_tangent_calc = Vector2.ZERO

		# --- Calculate the 'out-tangent' for the current point ---
		# This tangent points from the current_pos towards the next original point,
		# influencing the curve going *out of* current_pos.
		if i < original_points.size() - 1:
			var next_pos = original_points[i+1]
			var dist_next = current_pos.distance_to(next_pos)
			out_tangent_calc = (next_pos - current_pos).normalized() * dist_next * smoothing_factor
		else:
			# For the very last point, there's no outgoing segment, so no out-tangent.
			out_tangent_calc = Vector2.ZERO

		# --- Adjust tangents for interior points for a smoother overall curve ---
		# For points that are not the first or last, we can average the incoming
		# and outgoing directions to create a smoother tangent that passes through the point.
		if i > 0 and i < original_points.size() - 1:
			var prev_pos = original_points[i-1]
			var next_pos = original_points[i+1]
			var incoming_dir = (current_pos - prev_pos).normalized()
			var outgoing_dir = (next_pos - current_pos).normalized()

			# A simple average of incoming and outgoing direction
			var combined_dir = (incoming_dir + outgoing_dir).normalized()
			var avg_dist = (current_pos.distance_to(prev_pos) + current_pos.distance_to(next_pos)) / 2.0

			# Apply the combined direction to both in and out tangents for symmetry around the point
			out_tangent_calc = combined_dir * avg_dist * smoothing_factor
			in_tangent_calc = -combined_dir * avg_dist * smoothing_factor # In-tangent points in the opposite direction

		# Store the calculated tangents
		tangents_in.append(in_tangent_calc)
		tangents_out.append(out_tangent_calc)

	# --- Generate the Bezier curve segments ---
	# Start by adding the very first original point to the Line2D.
	line.add_point(original_points[0])

	# Iterate through each pair of original points to create cubic Bezier segments
	for i in range(original_points.size() - 1):
		var p0 = original_points[i]   # Start point of the current Bezier segment
		var p3 = original_points[i+1] # End point of the current Bezier segment

		# Control Point 1 (P1): Influences the curve near P0.
		# It's derived from P0 plus its outgoing tangent.
		var p1 = p0 + tangents_out[i]

		# Control Point 2 (P2): Influences the curve near P3.
		# It's derived from P3 plus its incoming tangent.
		# Note: The 'in_tangent_calc' for P3 points from P3 back towards P0.
		# Adding it to P3 positions P2 correctly for the Bezier formula.
		var p2 = p3 + tangents_in[i+1]

		# Generate intermediate points along this cubic Bezier segment
		# We start from j=1 because t=0 (j=0) would yield p0, which is already added
		# (or would be a duplicate if it's not the first segment).
		# We go up to subdivision_count + 1 to include the end point (t=1).
		for j in range(1, subdivision_count + 1):
			var t = float(j) / subdivision_count # Interpolation factor from 0.0 to 1.0
			var interpolated_point = bezier_interp(p0, p1, p2, p3, t)
			line.add_point(interpolated_point)

	print("Line generation complete. Check your Line2D in the editor.")


func bezier_interp(p0: Vector2, p1: Vector2, p2: Vector2, p3: Vector2, t: float) -> Vector2:
	"""
	Calculates a point on a cubic Bezier curve.
	This is the standard mathematical formula for cubic Bezier curves.
	p0: Start point
	p1: Control point 1
	p2: Control point 2
	p3: End point
	t: Interpolation factor (0.0 to 1.0)
	"""
	var omt = (1.0 - t) # One minus t
	var omt2 = omt * omt # (1-t)^2
	var omt3 = omt2 * omt # (1-t)^3

	var t2 = t * t # t^2
	var t3 = t2 * t # t^3

	# The Bezier curve formula: B(t) = (1-t)^3*P0 + 3*(1-t)^2*t*P1 + 3*(1-t)*t^2*P2 + t^3*P3
	return omt3 * p0 + 3.0 * omt2 * t * p1 + 3.0 * omt * t2 * p2 + t3 * p3

func add_new_original_point(point: Vector2):
	original_points.append(point)
	generate_smoothed_bezier_line()

func clear_original_points():
	original_points.clear()
	line.clear_points()
