enum StorageKeys {
  accessToken('access_token'),
  refreshToken('refresh_token'),
  language('language'),
  theme('theme');

  const StorageKeys(this.key);

  final String key;
}