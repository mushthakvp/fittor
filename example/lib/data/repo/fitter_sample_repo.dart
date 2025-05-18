abstract class FitterSampleRepo {
  Future<bool> sendOtp({required String number});
  Future<void> verifyOtp({required String number, required String otp});
}
