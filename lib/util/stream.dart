import 'package:rxdart/rxdart.dart';

extension PublishSubjectExtension<T> on PublishSubject<T> {
  PublishSubject<T> pipeAndFilter(bool filter(T value)) {
    final PublishSubject<T> subject = PublishSubject<T>();
    listen(
      (T value) {
        if (filter(value)) {
          subject.add(value);
        }
      },
      onError: (Object error, StackTrace stackTrace) =>
          subject.addError(error, stackTrace),
      onDone: () {
        if (!subject.isClosed) {
          subject.close();
        }
      },
    );
    subject.doOnDone(() {
      if (!isClosed) {
        close();
      }
    });
    return subject;
  }
}
