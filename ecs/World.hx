package ecs;

class World
{
    private var families = new Map<FamilyId, Family>();
    private var systems = new Array<System>();
    private var entities = new EntityList();

    public function addSystem(system:System):World
    {
        systems.push(system);
        system.world = this;
        return this;
    }

    public function removeSystem(system:System):Void
    {
        systems = systems.filter((sys) -> sys == system);
    }

    public function addEntity(entity:Entity):Void
    {
        Lambda.iter(families, (family) -> family.addEntityIfMatch(entity));

        entity.onComponentAdded.add(onComponentAdded);
        entity.onComponentRemoved.add(onComponentRemoved);
        entities.add(entity);
    }

    public function removeEntity(entity:Entity):Void
    {
        Lambda.iter(families, (family) -> family.removeEntity(entity));
        entities.remove(entity);
    }

    public function getEntities(componentNames:Array<String>):Array<Entity>
    {
        var familyId = getFamilyId(componentNames);
        ensureFamilyExists(componentNames);

        return families.get(familyId).getEntities();
    }

    public function update(dt:Float):Void
    {
        Lambda.iter(systems, (system) -> system.update(dt));
    }

    public function entityAdded(componentNames:Array<String>):Signal<Entity>
    {
        var familyId = getFamilyId(componentNames);
        ensureFamilyExists(componentNames);

        return families.get(familyId).entityAdded;
    }

    public function entityRemoved(componentNames:Array<String>):Signal<Entity>
    {
        var familyId = getFamilyId(componentNames);
        ensureFamilyExists(componentNames);

        return families.get(familyId).entityRemoved;
    }

    private function ensureFamilyExists(componentNames:Array<String>):Void
    {
        var familyId = getFamilyId(componentNames);

        if(!families.exists(familyId))
        {
            families.set(familyId, new Family(componentNames.slice(0)));
            Lambda.iter(entities, (entity) -> 
                    Lambda.iter(families, (family) -> 
                        family.addEntityIfMatch(entity)));
        }
    }

    private function getFamilyId(componentNames:Array<String>):FamilyId
    {
        return new FamilyId("$" + componentNames.join(","));
    }

    private function onComponentAdded(msg:{entity:Entity, componentName:String}):Void
    {
        Lambda.iter(families, (family) -> family.onComponentAdded(msg));
    }

    private function onComponentRemoved(msg:{entity:Entity, componentName:String, component:Component}):Void
    {
        Lambda.iter(families, (family) -> family.onComponentRemoved(msg));
    }
}
