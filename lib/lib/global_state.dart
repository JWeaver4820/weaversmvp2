class GlobalState {

  static final Map<String, dynamic> state = Map();

  static  set(String key, dynamic val) {
    state[key] = val;
  }

  static get(String key) {
    return state[key];
  }

  static delete(String key) {
    state[key] = null;
  }
}