extends KinematicBody2D

enum State { IDLE, WALKING, TALKING }

export(State) var currentState = State.IDLE
export(Array, int) var moveXPositions
export(int) var wait_time = 0
export(int) var maxSpeed = 25

onready var waitTimer = $WaitTimer
onready var body = $Body

var is_state_new = true

var currentMoveIterator = 0
var velocity = Vector2.ZERO
var direction = Vector2.ZERO
var gravity = 500

var startDirection = Vector2.RIGHT

func _ready():
	if moveXPositions.size() <= 0:
		 currentState = State.IDLE
	
	direction = startDirection
	waitTimer.wait_time = wait_time
	
	waitTimer.connect("timeout", self, "wait_timer_timeout")
	
func _process(delta): 
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
		
		currentState = State.IDLE
		is_state_new = true

### Idle

func process_idle(_delta):
	if is_state_new:
		is_state_new = false
		waitTimer.start()

func wait_timer_timeout():
	currentState = State.WALKING
	is_state_new = true

### Talking

func process_talking(_delta):
	if is_state_new:
		currentState = State.TALKING
		is_state_new = false
		waitTimer.paused = true

func finish_talking():
	currentState = State.WALKING
	waitTimer.paused = false
	is_state_new = true
