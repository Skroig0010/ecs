package ecs;

class Entity
{
    private var static entityId:Int = 0;
    public var id(default, null):EntityId;
    private var components:Map<String, Component> = [];
    private var onComponentAdded:Signal;
    private var onComponentRemoved:Signal;

    public function new()
    {
        id = new EntityId(entityId++);
    }

    public function hasComponent(componentName:String):Bool
    {
        return components.exists("$" + componentName);
    }

    public function addComponent(component:Component):Void
    {
        componsnts.set("$" + component.name, component);
        onComponentAdded.emit(this, component.name);
    }

    public function removeComponent(componentName:String):Void
    {
        var removedComponent = component.get("$" + componentName);
        component.remove("$" + componentName);
        onComponentRemoved.emit(this, componentName, removedComponent);
    }

}
