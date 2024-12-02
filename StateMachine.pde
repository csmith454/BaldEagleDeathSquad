import java.util.HashMap;
import java.util.Map;
import java.util.List;
import java.util.function.Supplier;

interface State {
  void tick();
  void onEnter();
  void onExit();
}

class StateMachine {
  State _currentState;
  Map<Class<?>, List<Transition>> _transitions = new HashMap<>();
  List<Transition> _currentTransitions = new ArrayList<>();
  List<Transition> _anyTransitions = new ArrayList<>();
  List<Transition> EmptyTransitions = new ArrayList<>(0);
  
  class Transition {
    Supplier<Boolean> condition;
    State to;
    
    Transition(State to, Supplier<Boolean> condition) {
      this.to = to;
      this.condition = condition;
    }
    
    public Supplier<Boolean> getCondition() {
        return condition;
    }

    public State getTo() {
        return to;
    }
  }

  StateMachine() {

  }
  
  void tick() {
    Transition transition = getTransition();
    if (transition != null) {
      setState(transition.to);
    }
    if (_currentState != null) {
        _currentState.tick();
    }
  }
  
  void at(State from, State to, Supplier<Boolean> condition) {
    this.addTransition(from, to, condition);
  }
  
  void setState(State state) {
    if (state == _currentState) {
      return;
    }
    
    if (_currentState != null) {
        _currentState.onExit();
    }
    _currentState = state;
    
    if (_transitions.containsKey(_currentState.getClass())) {
        _currentTransitions = _transitions.get(_currentState.getClass());
    }
    if (_currentTransitions == null) {
      _currentTransitions = EmptyTransitions;
    }
    _currentState.onEnter();
  }
  
  void addTransition(State from, State to, Supplier<Boolean> predicate) {
    List<Transition> transitions = _transitions.computeIfAbsent(from.getClass(), k -> new ArrayList<>());
    transitions.add(new Transition(to, predicate));
  }
  
  State getCurrentState() {
    return this._currentState;
  }
  
  void addAnyTransition(State state, Supplier<Boolean> predicate) {
    _anyTransitions.add(new Transition(state, predicate));
  }
  
  Transition getTransition() {
    for (Transition transition: _anyTransitions) {
      if (transition.condition.get()) {
        return transition;
      }
    }
    for (Transition transition: _currentTransitions) {
      if (transition.condition.get()) {
        return transition;
      }
    }
    return null;
  }
}
