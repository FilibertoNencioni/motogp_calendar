import 'dart:async';

class LoaderController {
  static final LoaderController _instance = LoaderController._internal();  
  factory LoaderController() =>_instance;
  LoaderController._internal(); 

  /// Indicates when the controller is ready to be used (The Loader widget is mounted)
  final Completer<void> _readyCompleter = Completer<void>();

  /// The number of loading requests made.
  /// This is used mainly to show the loader for HTTP requests
  int _pendingRequests = 0;

  Function()? _callbackHide;
  Function()? _callbackShow;

  /// Initialize the loader and make it ready to use.
  /// It also register the callbacks.
  void init(Function() onHide, Function() onShow){
    _callbackHide = onHide;
    _callbackShow = onShow;
    if (!_readyCompleter.isCompleted) {
      _readyCompleter.complete();
    }
  }

  void addRequest(){
    if(_pendingRequests == 0){
      _show();
    }
    _pendingRequests++;
  }

  void removeRequest(){
     if (_pendingRequests <= 0) {
      return;
    }

    if (_pendingRequests == 1) {
      _hide();
    }
    _pendingRequests--;
  }

  void show() => addRequest();
  void hide() => removeRequest();

  void _show() async {
    await _readyCompleter.future;
    if (_readyCompleter.isCompleted) {
      _callbackShow?.call();
    }
  }

  void _hide() async {
    await _readyCompleter.future;
    if (_readyCompleter.isCompleted) {
      _callbackHide?.call();
    }
  }
}