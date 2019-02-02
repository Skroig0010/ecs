package ecs;

interface System
{
    public var world(default, default):World;

    public function update(dt:Float):Void;
}
