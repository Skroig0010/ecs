package ecs;

abstract FamilyId(String) to String{
    public inline function new(id:String)
    {
        this = id;
    }
}
