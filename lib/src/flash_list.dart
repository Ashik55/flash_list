import 'package:flutter/material.dart';

// Type definitions
typedef ItemBuilder<T> = Widget Function(BuildContext context, T item, int index);
typedef OnLoadMore = Future<void> Function();
typedef OnRefresh = Future<void> Function();

class FlashList<T> extends StatefulWidget {
  const FlashList({
    Key? key,
    required this.data,
    required this.itemBuilder,
    this.onLoadMore,
    this.onRefresh,
    this.header,
    this.loadingIndicator,
    this.emptyWidget,
    this.headerStyle,
    this.isLoading = false,
    this.hasMore = false,
    this.scrollController,
    this.loadMoreThreshold = 200,
    this.itemHeight,
    this.padding = const EdgeInsets.all(0),
    this.centerLoadingView,
    this.bottomLoadingIndicator,
  }) : super(key: key);

  /// The data to be displayed in the list
  final List<T> data;

  /// Builder function to create list items
  final ItemBuilder<T> itemBuilder;

  /// Callback function when load more is triggered
  final OnLoadMore? onLoadMore;

  /// Callback function when refresh is triggered
  final OnRefresh? onRefresh;

  /// Optional header widget for the list
  final Widget? header;

  /// Custom loading indicator widget
  final Widget? loadingIndicator;

  /// Widget to show when the list is empty
  final Widget? emptyWidget;

  /// Style for the header title (only applicable if header is a text widget)
  final TextStyle? headerStyle;

  /// Loading state of the list
  final bool isLoading;

  /// Whether there are more items to load
  final bool hasMore;

  /// Optional scroll controller
  final ScrollController? scrollController;

  /// Threshold in pixels before reaching the bottom to trigger load more
  final double loadMoreThreshold;

  /// Fixed height for list items (optional)
  final double? itemHeight;

  /// Padding for the list
  final EdgeInsetsGeometry padding;

  /// Custom center loading view when data is empty
  final Widget? centerLoadingView;

  /// Custom bottom loading indicator when loading more items
  final Widget? bottomLoadingIndicator;

  @override
  State<FlashList<T>> createState() => _FlashListState<T>();
}

class _FlashListState<T> extends State<FlashList<T>> {
  late ScrollController _scrollController;
  bool _isFetchingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients || _isFetchingMore) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;

    if (currentScroll >= (maxScroll - widget.loadMoreThreshold)) {
      if (!widget.isLoading && widget.hasMore && widget.onLoadMore != null) {
        _isFetchingMore = true;
        widget.onLoadMore!().then((_) {
          setState(() {
            _isFetchingMore = false;
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading && widget.data.isEmpty) {
      return Center(child: widget.centerLoadingView ?? const CircularProgressIndicator());
    }

    if (!widget.isLoading && widget.data.isEmpty) {
      return widget.emptyWidget ?? const Center(child: Text('No data found'));
    }

    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: widget.onRefresh ?? () async {},
          child: ListView.builder(
            controller: _scrollController,
            padding: widget.padding,
            itemCount: widget.data.length + (widget.header != null ? 2 : 1), // +1 for bottom loader
            itemBuilder: (context, index) {
              if (widget.header != null && index == 0) {
                return widget.header!;
              }

              final itemIndex = widget.header != null ? index - 1 : index;

              // Bottom loading indicator
              if (itemIndex == widget.data.length) {
                return widget.hasMore
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: widget.bottomLoadingIndicator ??
                              const CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : const SizedBox.shrink();
              }

              return widget.itemBuilder(context, widget.data[itemIndex], itemIndex);
            },
          ),
        ),
      ],
    );
  }
}