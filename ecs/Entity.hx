package ecs;

class Entity
{
    private static var entityId:Int = 0;
    public var id(default, null):EntityId;
    private var components:Map<String, Component> = [];
    public var onComponentAdded:Signal<{entity:Entity, componentName:String}>;
    public var onComponentRemoved:Signal<{entity:Entity, componentName:String, component:Component}>;

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
        components.set("$" + component.name, component);
        onComponentAdded.emit({entity:this, componentName:component.name});
    }

    public function removeComponent(componentName:String):Void
    {
        var removedComponent = components.get("$" + componentName);
        components.remove("$" + componentName);
        onComponentRemoved.emit({entity:this, componentName:componentName, component:removedComponent});
    }

}
