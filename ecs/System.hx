package ecs;

interface System
{
    public var world:World;

    public function update(dt:Float):Void;
}
