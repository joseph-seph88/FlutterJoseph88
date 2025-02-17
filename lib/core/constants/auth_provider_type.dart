enum AuthProviderType {
  email("password"),
  google("google.com"),
  facebook("facebook.com"),
  naver("naver.com"),
  kakao("oidc.kakao_o2");

  final String providerId;
  const AuthProviderType(this.providerId);

  factory AuthProviderType.getByProviderId(String providerId) {
    return AuthProviderType.values.firstWhere(
      (value) => value.providerId == providerId,
      orElse: () => AuthProviderType.email,
    );
  }
}
