import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_manage_state_basic/components/appbar_general.dart';
import 'package:flutter_manage_state_basic/infinite_loadmore_app/bloc_infinite/comment_bloc.dart';
import 'package:flutter_manage_state_basic/infinite_loadmore_app/bloc_infinite/event/comment_event.dart';
import 'package:flutter_manage_state_basic/infinite_loadmore_app/bloc_infinite/state/comment_state.dart';
import 'package:flutter_manage_state_basic/util/const.dart';

class InfiniteAppScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _InfiniteAppScreenState();
}

class _InfiniteAppScreenState extends State<InfiniteAppScreen> {
  final _scrollController = ScrollController();

  //ngưỡng khi cuộn đến thì hiện load more
  final _scrollThreadhold = 250.0;
  CommentBloc _commentBloc;

  @override
  void initState() {
    super.initState();
    //lấy ra comment bloc từ parent
    _commentBloc = BlocProvider.of(context);
    _scrollController.addListener(() {
      //lấy maxcroll từ listview
      final maxScrollExtent = _scrollController.position.maxScrollExtent;
      //lấy current scroll từ listview
      final currentScroll = _scrollController.position.pixels;
      //check max scroll - current scroll <= ngưỡng thì đến cuối của list
      if (maxScrollExtent - currentScroll <= _scrollThreadhold) {
        _commentBloc.add(CommentFetchedEvent());
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BuildAppBar(
        titleApp: 'Infinite & Loadmore List App',
        iconLeft: Icons.arrow_back_ios,
        isShowIconLeft: true,
        onTapLeft: () => Navigator.of(context).pop(),
      ),
      body: BlocBuilder<CommentBloc, CommentState>(builder: (context, state) {
        //hiện ra loading
        if (state is CommentStateInitial) {
          return buildProgressLoading();
        }

        //nếu failure
        if (state is CommentStateFailure) {
          return buildWidgetFailureData();
        }

        //nếu thành công
        if (state is CommentStateSuccess) {
          //get current state in CommentStateSuccess
          if (state.comments.isEmpty) {
            return buildWidgetEmptyList();
          }
          return Container(
            color: colorBackground,
            child: buildListView(state),
          );
        }
        return Center(
          child: Text(
            'Fix bug return null!',
            style: TextStyle(
              color: Colors.red,
              fontSize: 16.0,
              fontWeight: FontWeight.normal,
            ),
          ),
        );
      }),
    );
  }

  Center buildProgressLoading() {
    return Center(
      child: Container(
        width: 30.0,
        height: 30.0,
        child: CircularProgressIndicator(),
      ),
    );
  }

  Center buildWidgetFailureData() {
    return Center(
      child: Column(
        children: [
          Icon(Icons.error_outline),
          Text('Sorry! Failed to load data.',
              style: TextStyle(
                color: Colors.red[400],
                fontSize: 16.0,
                fontWeight: FontWeight.normal,
              )),
        ],
      ),
    );
  }

  Center buildWidgetEmptyList() {
    return Center(
      child: Text(
        'Empty comment!',
        style: TextStyle(
          color: Colors.red[400],
          fontSize: 16.0,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  ListView buildListView(CommentStateSuccess state) {
    return ListView.builder(
      padding: EdgeInsets.all(8.0),
      itemCount: state.hasReachedEnd
          ? state.comments.length
          : state.comments.length + 1,
      //add load more
      scrollDirection: Axis.vertical,
      controller: _scrollController,
      itemBuilder: (context, index) => index >= state.comments.length
          ? buildWidgetLoadMore()
          : buildItemListView(state, index),
    );
  }

  //ITEM LISTVIEW
  Padding buildItemListView(CommentStateSuccess state, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 1.0,
        child: InkWell(
          borderRadius: BorderRadius.circular(
            10.0,
          ),
          onTap: () {},
          child: Container(
            padding: EdgeInsets.all(
              12.0,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue[400],
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: 14.0,
                ),
                Flexible(
                  //sử dụng flexible cho parent gần nhất
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        state.comments[index].email,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Flexible(
                        //sử dụng flexible cho widget cần dùng
                        child: Text(
                          state.comments[index].name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          softWrap: true,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //LOAD MORE
  Container buildWidgetLoadMore() {
    return Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          Text(
            'is loading',
            style: TextStyle(
              color: Colors.blue[400],
              fontSize: 14.0,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
