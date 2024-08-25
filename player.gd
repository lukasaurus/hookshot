extends RigidBody2D
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var speed = 10
@export var hook: StaticBody2D
@export var pinjoint : PinJoint2D
@onready var line = $Line2D
var hooked = false
@onready var line_end = hook.get_node("Marker2D")

func _process(delta: float) -> void:
	print(rad_to_deg(get_angle_to(get_global_mouse_position())))
	if Input.is_action_just_pressed("shoot") and not hooked:
		
		hooked = true
		ray_cast_2d.target_position = to_local(get_global_mouse_position())
		ray_cast_2d.force_raycast_update()
		if ray_cast_2d.is_colliding():
			#get values from raycast
			var hook_pos = ray_cast_2d.get_collision_point()
			var collider = ray_cast_2d.get_collider()
			
			#if the ray collides with a hookable object, move pinjoint and hook to it
			if collider.is_in_group("Hookable"):
				pinjoint.global_position = hook_pos
				hook.global_position = hook_pos
				pinjoint.node_b = get_path_to(hook)
				#rotate the hook so it is the right angle
				var direction = hook_pos - global_position
				hook.rotation = direction.angle()

	elif Input.is_action_just_released("shoot") and hooked:
		hooked = false	
		pinjoint.node_b = NodePath("")	

	
	if hooked:
		line.clear_points()
		line.add_point(Vector2.ZERO)
		line.add_point(to_local(line_end.global_position))
	else:
		line.clear_points()
		
	var grounded = get_contact_count()>0
	
	#if Input.is_action_pressed("retract") and hooked:
		#retract code here
		
	#basic platformer code below
	if Input.is_action_pressed("right") and (grounded or hooked):
		apply_central_impulse(Vector2.RIGHT)
	if Input.is_action_pressed("left") and (grounded or hooked):
		apply_central_impulse(Vector2.LEFT)
	if Input.is_action_just_pressed("jump") and grounded:
		apply_central_impulse(Vector2.UP * 100)
		
					
		
