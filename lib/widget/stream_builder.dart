import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class IStreamBuilder<T> extends StatefulWidget {
  const IStreamBuilder({
    Key key,
    this.initialData,
    this.stream,
    this.builder,
  }) : super(key: key);

  final T initialData;
  final Stream<T> stream;
  final AsyncWidgetBuilder<T> builder;

  @override
  _IStreamBuilderState<T> createState() => _IStreamBuilderState<T>();

  AsyncSnapshot<T> initial() =>
      AsyncSnapshot<T>.withData(ConnectionState.none, initialData);

  AsyncSnapshot<T> afterConnected(AsyncSnapshot<T> current) {
    if (stream is BehaviorSubject) {
      final BehaviorSubject<T> subject = stream as BehaviorSubject<T>;
      if (subject.hasValue) {
        return AsyncSnapshot<T>.withData(ConnectionState.active, subject.value);
      }
    }
    return current.inState(ConnectionState.waiting);
  }

  AsyncSnapshot<T> afterData(AsyncSnapshot<T> current, T data) =>
      AsyncSnapshot<T>.withData(ConnectionState.active, data);

  AsyncSnapshot<T> afterError(AsyncSnapshot<T> current, Object error) =>
      AsyncSnapshot<T>.withError(ConnectionState.active, error);

  AsyncSnapshot<T> afterDone(AsyncSnapshot<T> current) =>
      current.inState(ConnectionState.done);

  AsyncSnapshot<T> afterDisconnected(AsyncSnapshot<T> current) =>
      current.inState(ConnectionState.none);

  Widget build(BuildContext context, AsyncSnapshot<T> currentSummary) =>
      builder(context, currentSummary);
}

class _IStreamBuilderState<T> extends State<IStreamBuilder<T>> {
  StreamSubscription<T> _subscription;
  AsyncSnapshot<T> _summary;

  @override
  Widget build(BuildContext context) => widget.build(context, _summary);

  @override
  void initState() {
    super.initState();
    _summary = widget.initial();
    _subscribe();
  }

  @override
  void dispose() {
    super.dispose();
    _unsubscribe();
  }

  @override
  void didUpdateWidget(IStreamBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stream != widget.stream) {
      if (_subscription != null) {
        _unsubscribe();
        _summary = widget.afterDisconnected(_summary);
      }
      _subscribe();
    }
  }

  void _subscribe() {
    if (widget.stream != null) {
      bool discardValue = false;
      _subscription = widget.stream.skipWhile((_) {
        if (discardValue) {
          discardValue = false;
          return true;
        } else {
          return false;
        }
      }).listen((T data) {
        setState(() {
          _summary = widget.afterData(_summary, data);
        });
      }, onError: (Object error) {
        setState(() {
          _summary = widget.afterError(_summary, error);
        });
      }, onDone: () {
        setState(() {
          _summary = widget.afterDone(_summary);
        });
      });
      if (_summary.connectionState != ConnectionState.none) {
        return;
      }
      _summary = widget.afterConnected(_summary);
      if (_summary.connectionState == ConnectionState.active) {
        discardValue = true;
      }
    }
  }

  void _unsubscribe() {
    if (_subscription != null) {
      _subscription.cancel();
      _subscription = null;
    }
  }
}
