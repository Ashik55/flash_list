# README.md

# FlashList

A high-performance Flutter ListView widget with pagination, pull-to-refresh, and header features inspired by React Native's FlashList.

## Features

- Optimized performance with minimal rebuilds
- Pull-to-refresh functionality
- Infinite scrolling with load more
- Header support
- Empty state handling
- Loading indicators
- Generic type support
- Customizable styling

## Installation

```yaml
dependencies:
  flash_list: ^0.0.1
```

## Usage

```dart
FlashList<String>(
  data: items,
  isLoading: isLoading,
  hasMore: hasMore,
  headerTitle: 'My List',
  onLoadMore: () async {
    // Load more items
  },
  onRefresh: () async {
    // Refresh items
  },
  itemBuilder: (context, item, index) => ListTile(
    title: Text(item),
  ),
)
```

## Documentation

[Full documentation and examples](link-to-your-documentation)

## License

MIT License - see the [LICENSE](LICENSE) file for details

# CHANGELOG.md

## 0.0.1

- Initial release
- Basic FlashList implementation
- Pull-to-refresh support
- Infinite scrolling
- Header support
- Loading and empty states
