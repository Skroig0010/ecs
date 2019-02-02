package ecs;

class Signal<T>
{
    private var listeners:List<T -> Void> = new List();

    public function new(){}

    public function add(listener:T -> Void):Void
    {
        listeners.add(listener);
    }

    public function remove(listener:T -> Void):Bool
    {
        return listeners.remove(listener);
    }

    public function emit(message:T):Void
    {
        listeners.map((listener) -> listener(message));
    }
}
