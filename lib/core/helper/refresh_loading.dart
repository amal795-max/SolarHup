/// Whether to show skeleton/shimmer placeholders.
/// During pull-to-refresh, keep showing cached content instead.
bool showInitialLoadingSkeleton({
  required bool isLoading,
  required bool hasCachedData,
}) =>
    isLoading && !hasCachedData;
