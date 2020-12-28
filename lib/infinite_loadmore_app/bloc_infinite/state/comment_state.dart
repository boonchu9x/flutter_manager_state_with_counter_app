

import 'package:equatable/equatable.dart';
import 'package:flutter_manage_state_basic/infinite_loadmore_app/model/comment_data.dart';

abstract class CommentState extends Equatable {
  const CommentState();

//SO SÁNH ATTRIBUTE OBJECT
  @override
// TODO: implement props
  List<Object> get props => [];
}

class CommentStateInitial extends CommentState {}

class CommentStateFailure extends CommentState {}

class CommentStateSuccess extends CommentState {
  final List<Comment> comments;
  final bool hasReachedEnd;

  const CommentStateSuccess({this.comments, this.hasReachedEnd});

  @override
  // TODO: implement props
  List<Object> get props => [comments, hasReachedEnd];

  //Nhân bản đối tượng (clone object) CommentStateSuccess
  CommentStateSuccess cloneWith({
    List<Comment> comments,
    bool hasReachedEnd,
  }) {
    return CommentStateSuccess(
      comments: comments ?? this.comments, //nếu comments null thì lấy giá trị cũ this.comment
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd, //tương tự comment ở trên
    );
  }
}
