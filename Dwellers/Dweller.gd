extends KinematicBody2D

enum State { IDLE, WALKING, TALKING }

export(State) var currentState = State.IDLE
export(Array, int) var moveXPositions
export(int) var wait_time = 0
export(int) var maxSpeed = 25
export var currentMoveIterator = 0

onready var waitTimer = $WaitTimer
onready var body = $Body
onready var interactionController = $Body/InteractionController
onready var animationPlayer = $AnimationPlayer

var is_state_new = true

var velocity = Vector2.ZERO
var direction = Vector2.ZERO
var gravity = 500

var current_animation_name

var startDirection = Vector2.RIGHT

func _ready():
	if moveXPositions.size() <= 0:
		 currentState = State.IDLE
	
	direction = startDirection
	waitTimer.wait_time = wait_time
	
	interactionController.connect("on_interact", self, "on_npc_interact")
	interactionController.connect("on_leave", self, "finish_talking")
	waitTimer.connect("timeout", self, "wait_timer_timeout")
	
func _process(delta): 
	if !animationPlayer.current_animation:
		set_animation_with_state(currentState)
	
	match currentState:
		State.IDLE:
			process_idle(delta)
		State.WALKING:
			process_walking(delta)
		State.TALKING:
			process_talking(delta)

### Walking

func process_walking(delta):
	direction = position.direction_to(Vector2(moveXPositions[currentMoveIterator],0))
	direction.x = sign(direction.x)
	
	body.scale.x = direction.x
	
	velocity.y += gravity * delta	
	velocity.x = (direction * maxSpeed).x
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if moveXPositions[currentMoveIterator] > position.x - 1 && moveXPositions[currentMoveIterator] < position.x + 1:
		currentMoveIterator += 1
		if currentMoveIterator >= moveXPositions.size():
			currentMoveIterator = 0
		
		set_animation_with_state(State.IDLE)

### Idle

func process_idle(_delta):
	if is_state_new:
		is_state_new = false
		waitTimer.start()

func wait_timer_timeout():
	set_animation_with_state(State.WALKING)

### Talking

func on_npc_interact():
	set_animation_with_state(State.IDLE)

func process_talking(_delta):
	if is_state_new:
		set_animation_with_state(State.TALKING)
		waitTimer.paused = true

func finish_talking():
	set_animation_with_state(State.WALKING)
	waitTimer.paused = false

### Helpers

func set_animation_with_state(state):
	is_state_new = true
	
	match state:
		State.IDLE:
			animationPlayer.play("Idle")
			currentState = State.IDLE
		State.WALKING:
			animationPlayer.play("Walk")
			currentState = State.WALKING
		State.TALKING:
			animationPlayer.play("Idle")
			currentState = State.TALKING
