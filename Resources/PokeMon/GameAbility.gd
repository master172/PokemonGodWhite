extends Node
class_name GameAbility

var Holder :CharacterBody2D = null

func pre_setup():
    if Holder != null:
        Holder.tree_exiting.connect(handle_freeing)
    setup()

func handle_freeing():
    print("removing ability")
    queue_free()

func setup():
    pass