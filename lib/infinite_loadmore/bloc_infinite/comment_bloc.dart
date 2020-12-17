import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_manage_state_basic/infinite_loadmore/bloc_infinite/event/comment_event.dart';
import 'package:flutter_manage_state_basic/infinite_loadmore/bloc_infinite/state/comment_state.dart';
import 'package:flutter_manage_state_basic/infinite_loadmore/model/comment_data.dart';
import 'package:flutter_manage_state_basic/infinite_loadmore/service/api_services.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final NUMBER_OF_COMMENT_PER_PAGE = 20; //limit item in one page
  CommentBloc() : super(CommentStateInitial());

  //async* là hàm async stream
  @override
  Stream<CommentState> mapEventToState(CommentEvent event) async* {
    // TODO: implement mapEventToState
    try{
      //khi cuộn xuống cuối của 1 page
      final hasReachedEndOfOnePage = (state is CommentStateSuccess &&
          (state as CommentStateSuccess).hasReachedEnd);

      //là event và chưa đến phần tử cuối cùng
      if (event is CommentFetchedEvent && !hasReachedEndOfOnePage) {
        if (state is CommentStateInitial) {
          //lần đầu tiên load page
          //1. get data from api
          //2.trả về CommentStateSuccess
          final comments = await getDataFromApi(0, NUMBER_OF_COMMENT_PER_PAGE);
          yield CommentStateSuccess(
            comments: comments,
            hasReachedEnd: false,
          );
        } else if (state is CommentStateSuccess) {
          //load page tiếp theo
          //nếu page tiếp theo rỗng thì => trả về (yield) "CommentStateSuccess" với hasReachedEnd = true;
          final currentState = state as CommentStateSuccess;
          final finalIndexOfCurrentPage =
              currentState.comments.length;
          final comments = await getDataFromApi(finalIndexOfCurrentPage, NUMBER_OF_COMMENT_PER_PAGE);
          if (comments.isEmpty) {
            //phải clone object CommentStateSuccess và thay đổi hasReachedEnd
            yield currentState.cloneWith(hasReachedEnd: true);
          } else {
            //nếu không trống (not reached end) yiel ra object CommentStateSuccess
            yield CommentStateSuccess(
              comments: currentState.comments + comments, //nối 2 mảng (merge 2 arrays)
              hasReachedEnd: false,
            );
          }
        }
      }
    }catch(exception){
      yield CommentStateFailure();
    }
  }
}
