extends KinematicBody2D

enum State { IDLE, WALKING, TALKING, ACTING }
enum Direction { LEFT = 1, RIGHT = -1 }

export(Array, Resource) var actions
export(Resource) var currentState 
export var currentActionIndex = 0
export(bool) var watch_player_on_talk = true

export(Direction) var defaultDirection = Direction.LEFT

onready var waitTimer = $WaitTimer
onready var actTimer = $ActTimer
onready var body = $Body
onready var interactionController = $Body/InteractionController
onready var animationPlayer = $AnimationPlayer
onready var textBoxPopup = $TextBoxPopup

var is_state_new = true

var velocity = Vector2.ZERO
var gravity = 500

var current_animation_name

func _ready():
	if !actions:
		var idleAction = IdleNpcAction.new()
		idleAction.is_infinite = true
		actions = [idleAction]
		
	currentState = actions[currentActionIndex]
	
	interactionController.connect("on_interact", self, "on_npc_interact")
	interactionController.connect("on_leave", self, "finish_talking")
	waitTimer.connect("timeout", self, "wait_timer_timeout")
	actTimer.connect("timeout", self, "act_timer_timeout")
	
	textBoxPopup.connect("dialogueFinished", self, "finish_talking")

func _process(delta): 
	if !animationPlayer.current_animation:
		set_animation_with_state(currentState.state)
	
	match currentState.state:
		State.IDLE:
			process_idle(delta, currentState.wait_time, currentState.is_infinite)
		State.WALKING:
			process_walking(delta, currentState.target_x_position, currentState.move_speed)
		State.TALKING:
			process_talking(delta)
		State.ACTING:
			process_acting(delta)
			
func setupNextAction():
	currentActionIndex += 1
	
	if currentActionIndex >= actions.size() || !actions[currentActionIndex]:
		currentActionIndex = 0
		
	currentState = actions[currentActionIndex]

	set_animation_with_state(currentState.state)
	is_state_new = true

### Walking

func process_walking(delta, targetXPosition, speed):
	if is_state_new:
		set_animation_with_state(currentState.state)
		is_state_new = false
		
	var direction = position.direction_to(Vector2(targetXPosition,0))
	direction.x = sign(direction.x)
	
	body.scale.x = direction.x
	
	velocity.y += gravity * delta	
	velocity.x = (direction * speed).x
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if targetXPosition > position.x - 1 && targetXPosition < position.x + 1:
		setupNextAction()

### Idle

func process_idle(delta, wait_time, is_infinite):
	if is_state_new:
		is_state_new = false
		
		if !is_infinite:
			waitTimer.wait_time = wait_time
			waitTimer.start()
	
	process_still(delta)

func wait_timer_timeout():
	setupNextAction()

### Talking

func process_talking(delta):
	if is_state_new:
		set_animation_with_state(State.TALKING)
		is_state_new = false
		waitTimer.paused = true
	
	process_still(delta)

func finish_talking():
	currentState = actions[currentActionIndex]
	set_animation_with_state(currentState.state)
	waitTimer.paused = false
	body.scale.x = defaultDirection

func on_npc_interact(interactedBody):
	if currentState.state != State.TALKING:
		is_state_new = true
		currentState = TalkNpcAction.new()
		
		if watch_player_on_talk:
			body.scale.x = 1 if interactedBody.position.x > position.x else -1

### Acting

func process_acting(delta):
	if is_state_new:
		is_state_new = false
		actTimer.start()
	
	process_still(delta)

func act_timer_timeout():
	setupNextAction()

### Helpers

func process_still(delta):
	velocity.y += gravity * delta
	velocity.x = 0
	velocity = move_and_slide(velocity, Vector2.UP)
	
func set_animation_with_state(state):	
	match state:
		State.IDLE:
			animationPlayer.play("Idle")
		State.WALKING:
			animationPlayer.play("Walk")
		State.TALKING:
			animationPlayer.play("Idle")
		State.ACTING:
			animationPlayer.play("Act")