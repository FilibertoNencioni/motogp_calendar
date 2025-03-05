import 'package:motogp_calendar/models/category.dart';
import 'package:motogp_calendar/utils/http.dart';

class CategoryService{

  static Future<List<Category>> get() async {
    List<Category> categories = [];
    var categoriesResp = await Http().get<List>("/Category");
    
    if (categoriesResp.statusCode == 200) {
      categories = categoriesResp.data!.map((e) => Category.fromJson((e as Map).cast())).toList();
    }

    return categories;
  }
}