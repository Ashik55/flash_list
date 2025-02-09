import 'package:flutter/material.dart';

// Type definitions
typedef ItemBuilder<T> = Widget Function(
    BuildContext context, T item, int index);
typedef OnLoadMore = Future<void> Function();
typedef OnRefresh = Future<void> Function();

class FlashList<T> extends StatefulWidget {
  const FlashList({
    Key? key,
    required this.data,
    required this.itemBuilder,
    this.onLoadMore,
    this.onRefresh,
    this.headerTitle,
    this.loadingIndicator,
    this.emptyWidget,
    this.headerStyle,
    this.isLoading = false,
    this.hasMore = false,
    this.scrollController,
    this.loadMoreThreshold = 200,
    this.itemHeight,
    this.padding = const EdgeInsets.all(0),
  }) : super(key: key);

  /// The data to be displayed in the list
  final List<T> data;

  /// Builder function to create list items
  final ItemBuilder<T> itemBuilder;

  /// Callback function when load more is triggered
  final OnLoadMore? onLoadMore;

  /// Callback function when refresh is triggered
  final OnRefresh? onRefresh;

  /// Optional header title for the list
  final String? headerTitle;

  /// Custom loading indicator widget
  final Widget? loadingIndicator;

  /// Widget to show when the list is empty
  final Widget? emptyWidget;

  /// Style for the header title
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

  @override
  State<FlashList<T>> createState() => _FlashListState<T>();
}

class _FlashListState<T> extends State<FlashList<T>> {
  late ScrollController _scrollController;

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
    if (!_scrollController.hasClients) return;
    
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    
    if (currentScroll >= (maxScroll - widget.loadMoreThreshold)) {
      if (!widget.isLoading && widget.hasMore && widget.onLoadMore != null) {
        widget.onLoadMore!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading && widget.data.isEmpty) {
      return Center(
        child: widget.loadingIndicator ?? const CircularProgressIndicator(),
      );
    }

    if (!widget.isLoading && widget.data.isEmpty) {
      return widget.emptyWidget ?? const Center(child: Text('No items'));
    }

    Widget listView = ListView.builder(
      controller: _scrollController,
      padding: widget.padding,
      itemCount: widget.data.length + (widget.headerTitle != null ? 1 : 0),
      itemBuilder: (context, index) {
        if (widget.headerTitle != null && index == 0) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.headerTitle!,
              style: widget.headerStyle ?? Theme.of(context).textTheme.titleLarge,
            ),
          );
        }

        final itemIndex = widget.headerTitle != null ? index - 1 : index;
        return widget.itemBuilder(
          context,
          widget.data[itemIndex],
          itemIndex,
        );
      },
    );

    if (widget.onRefresh != null) {
      listView = RefreshIndicator(
        onRefresh: widget.onRefresh!,
        child: listView,
      );
    }

    return Stack(
      children: [
        listView,
        if (widget.isLoading && widget.data.isNotEmpty)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: widget.loadingIndicator ?? 
                const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            ),
          ),
      ],
    );
  }
}
