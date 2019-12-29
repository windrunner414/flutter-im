// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

extension ConversationCopyWithExtension on Conversation {
  Conversation copyWith({
    String avatar,
    String desc,
    String title,
    int titleColor,
    int unreadMsgCount,
    String updateAt,
  }) {
    return Conversation(
      avatar: avatar ?? this.avatar,
      desc: desc ?? this.desc,
      title: title ?? this.title,
      titleColor: titleColor ?? this.titleColor,
      unreadMsgCount: unreadMsgCount ?? this.unreadMsgCount,
      updateAt: updateAt ?? this.updateAt,
    );
  }
}

extension ConversationPageDataCopyWithExtension on ConversationPageData {
  ConversationPageData copyWith({
    List conversations,
  }) {
    return ConversationPageData(
      conversations: conversations ?? this.conversations,
    );
  }
}
