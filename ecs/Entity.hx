package ecs;
import haxe.macro.Expr;
import haxe.macro.Context;
using haxe.macro.Tools;
using haxe.macro.TypeTools;

class Entity
{
    private static var entityId:Int = 0;
    public var id(default, null):EntityId;
    private var components:Map<String, Component> = [];
    public var onComponentAdded = new Signal<{entity:Entity, componentName:String, component:Component}>();
    public var onComponentRemoved = new Signal<{entity:Entity, componentName:String, component:Component}>();

    public function new(?components:Array<Component>)
    {
        id = new EntityId(entityId++);
        if(components != null)Lambda.iter(components, addComponent);
    }

    public function hasComponent(componentName:String):Bool
    {
        return components.exists("$" + componentName);
    }

    // use getComponent
    public function getComponent2(componentName:String):Component
    {
        return components.get("$" + componentName);
    }

    public macro function getComponent(self:Expr, expr:Expr)
    {
        var type = Context.getType(expr.toString());

        switch(type)
        {
            case TInst(t, param):
                for(staticField in t.get().statics.get())
                {
                    if(staticField.name == "componentName")
                    {
                        var componentName = staticField.name;
                        var compType = type.toComplexType();
                        return macro {
                            cast ($self.getComponent2(($expr.$componentName)), $compType);
                        }
                    }
                }
                return Context.error(type.toString() + " should haxe static field 'componentName'", expr.pos);
            default:
                return Context.error(type.toString() + " should be Component Class", expr.pos);
        }
    }

    public function addComponent(component:Component):Void
    {
        components.set("$" + component.name, component);
        onComponentAdded.emit({entity:this, componentName:component.name, component:component});
    }

    public function removeComponent(componentName:String):Void
    {
        var removedComponent = components.get("$" + componentName);
        components.remove("$" + componentName);
        onComponentRemoved.emit({entity:this, componentName:componentName, component:removedComponent});
    }

}
