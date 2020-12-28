import 'package:equatable/equatable.dart';

//Viết abstract để truyền param vào class
abstract class CommentEvent extends Equatable{
  const CommentEvent();


  //SO SÁNH ATTRIBUTE OBJECT
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class CommentFetchedEvent extends CommentEvent{}
