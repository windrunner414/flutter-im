import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:wechat/model/base.dart';

part 'contacts.g.dart';

@CopyWith()
class Contact extends BaseModel {
  const Contact({
    this.avatar,
    this.name,
    this.nameIndex,
    this.id,
  });

  final String avatar;
  final String name;
  final String nameIndex;
  final int id;
}
