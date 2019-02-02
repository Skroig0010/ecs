package ecs;

class Signal
{
    private var listeners:List<SignalArg -> Void> = []; 

    public function add(listener:SignalArg -> Void):Void
    {
        listener.push(listener);
    }

    public function remove(listener:SignalArg -> Void):Bool
    {
        return listenters.remove(listener);
    }

    public function emit(message:SignalArg):Void
    {
        listener.map((listener) -> listener(message));
    }
}
