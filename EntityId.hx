package ecs;

abstract EntityId(Int) to Int{
    public inline function new(id:Int)
    {
        this = id;
    }
}
