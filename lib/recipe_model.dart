
class RecipeModel{
  late String label;
  late String imgUrl;
  late double calories;
  late String url;

  RecipeModel({this.label = "",this.imgUrl = "",this.calories = 0.0,this.url = ""});

   factory RecipeModel.fromMap(Map recipe){
    return RecipeModel(
      label:recipe["label"],
        imgUrl:recipe["image"],
        calories:recipe["calories"],
        url:recipe["url"],
    );
  }
}