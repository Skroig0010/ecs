package ecs;

class EntityList
{
    private var entities = new Map<EntityId, Entity>();
    private var entityList = new List<Entity>();

    public function new () { }

    public function add(entity:Entity):Void
    {
        entityList.add(entity);
        entities.set(entity.id, entity);
    }

    public function remove(entity:Entity):Void
    {
        if(entityList.remove(entity))
        {
            entities.remove(entity.id);
            return true;
        }
        return false;
    }

    public function has(entity):Bool
    {
        return entities.exists(entity.id);
    }

    public function clear():Void
    {
        entityList.clear();
        entities = new Map<EntityId, Entity>();
    }

    public function toArray():Array<Entity>
    {
        return Lambda.array(entityList);
    }
}
