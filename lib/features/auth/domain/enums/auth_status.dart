enum AuthStatus {
  /// Initial state when the app starts
  initial,

  /// User is authenticated and profile is complete
  authenticated,

  /// User is not authenticated
  unauthenticated,

  /// User is authenticated but profile is incomplete
  profileIncomplete
}
