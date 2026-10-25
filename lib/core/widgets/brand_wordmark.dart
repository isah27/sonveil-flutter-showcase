import 'package:flutter/widgets.dart';

import '../constants/app_strings.dart';
import 'app_text.dart';

class BrandWordmark extends StatelessWidget {
  const BrandWordmark({super.key});

  @override
  Widget build(BuildContext context) =>
      const AppText(AppStrings.brand, variant: AppTextVariant.wordmark);
}
