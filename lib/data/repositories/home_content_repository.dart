import 'package:max/data/models/home_content_model.dart';

abstract class HomeContentRepository {
  Future<HomeContentModel?> getHomeContent();
}
