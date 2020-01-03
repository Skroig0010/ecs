package ecs;

class Family
{
    private var componentNames:Array<String>;
    private var entities = new EntityList();
    public var entityAdded = new Signal<Entity>();
    public var entityRemoved = new Signal<Entity>();

    public function new(componentNames:Array<String>)
    {
        this.componentNames = componentNames;
    }

    public function getEntities():Array<Entity>
    {
        return entities.toArray();
    }

    public function addEntityIfMatch(entity:Entity):Void
    {
        if(!entities.has(entity) && matchEntity(entity))
        {
            entities.add(entity);
            entityAdded.emit(entity);
        }
    }

    public function removeEntity(entity:Entity):Void
    {
        if(entities.has(entity))
        {
            entities.remove(entity);
            entityRemoved.emit(entity);
        }
    }

    public function onComponentAdded(msg:{entity:Entity, componentName:String, component:Component}):Void
    {
        this.addEntityIfMatch(msg.entity);
    }

    public function onComponentRemoved(msg:{entity:Entity, componentName:String, component:Component}):Void
    {
        if(!entities.has(msg.entity))
        {
            return;
        }

        for(componentName in componentNames)
        {
            if(componentName == msg.componentName)
            {
                entities.remove(msg.entity);
                entityRemoved.emit(msg.entity);
            };
        }
    }

    private function matchEntity(entity):Bool
    {
        for(name in componentNames)
        {
            if(!entity.hasComponent(name))
            {
                return false;
            }
        }
        return true;
    }
}
