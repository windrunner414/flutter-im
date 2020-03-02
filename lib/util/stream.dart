import 'package:rxdart/rxdart.dart';

extension PublishSubjectExtension<T> on PublishSubject<T> {
  PublishSubject<T> pipeAndFilter(bool filter(T value)) {
    final PublishSubject<T> subject = PublishSubject<T>();
    listen(
      (T value) {
        if (subject.isClosed) {
          return;
        }
        if (filter(value)) {
          subject.add(value);
        }
      },
      onError: (Object error, StackTrace stackTrace) {
        if (!subject.isClosed) {
          subject.addError(error, stackTrace);
        }
      },
      onDone: () {
        if (!subject.isClosed) {
          subject.close();
        }
      },
    );
    subject.done.then((value) {
      if (!isClosed) {
        close();
      }
    });
    return subject;
  }
}
