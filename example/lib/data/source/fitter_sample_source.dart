import 'package:flutter/material.dart';

import '../../../core/network/fit_urls.dart';
import '../repo/fitter_sample_repo.dart';

class SampleFittorSource extends FitUrls implements FitterSampleRepo {
  @override
  Future<bool> sendOtp({required String number}) {
    String url = sendOtpUrl;
    debugPrint(url);
    throw UnimplementedError();
  }

  @override
  Future<void> verifyOtp({required String number, required String otp}) {
    String url = verifyOtpUrl;
    debugPrint(url);
    throw UnimplementedError();
  }
}
