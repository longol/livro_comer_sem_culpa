class Recipe {
  num id;
  String title;
  num prepTime;
  num cookTime;
  num coolingTime;
  String shelfLife;
  num recipeQuantity;
  String recipeQuantityMeasure;
  num calories;
  num carbohydrates;
  num proteins;
  num fats;
  String description;
  List<Utensil> utensils = [];
  List<Stage> stages = [];
  List<Tip> tips = [];

  Recipe(
    this.id,
    this.title,
    this.prepTime,
    this.cookTime,
    this.coolingTime,
    this.shelfLife,
    this.recipeQuantity,
    this.recipeQuantityMeasure,
    this.calories,
    this.carbohydrates,
    this.proteins,
    this.fats,
    this.description,
  );

  factory Recipe.fromJSON(Map<dynamic, dynamic> element) {
    return Recipe(
      element['id'],
      element['title'],
      element['prepTime'],
      element['cookTime'],
      element['coolingTime'],
      element['shelfLife'].toString(),
      element['recipeQuantity'],
      element['recipeQuantityMeasure'],
      element['calories'],
      element['carbohydrates'],
      element['proteins'],
      element['fats'],
      element['description'] == null ? "" : element['description'],
    );
  }
}

class Utensil {
  num id;
  String name;
  String descriptor;

  Utensil(this.id, this.name, this.descriptor);

  factory Utensil.fromJSON(Map<dynamic, dynamic> element) {
    return Utensil(
      element['id'],
      element['name'],
      element['descriptor'],
    );
  }
}

class Stage {
  num id;
  String name;
  List<Ingredient> ingredients = [];
  List<StepStage> steps = [];

  Stage(this.id, this.name);

  factory Stage.fromJSON(Map<dynamic, dynamic> element) {
    return Stage(
      element['id'],
      element['name'],
    );
  }
}

class Ingredient {
  num id;
  num quantity_1;
  String measure_1;
  String name;
  num quantity_2;
  String measure_2;
  String notes;

  Ingredient(
    this.id,
    this.quantity_1,
    this.measure_1,
    this.name,
    this.quantity_2,
    this.measure_2,
    this.notes,
  );

  factory Ingredient.fromJSON(Map<dynamic, dynamic> element) {
    return Ingredient(
      element['id'],
      element['quantity_1'],
      element['measure_1'],
      element['name'],
      element['quantity_2'] == "" ? 0 : element['quantity_2'],
      element['measure_2'],
      element['notes'],
    );
  }
}

class StepStage {
  num id;
  String description;

  StepStage(
    this.id,
    this.description,
  );

  factory StepStage.fromJSON(Map<dynamic, dynamic> element) {
    return StepStage(
      element['id'],
      element['description'],
    );
  }
}

class Tip {
  num id;
  String description;

  Tip(
    this.id,
    this.description,
  );

  factory Tip.fromJSON(Map<dynamic, dynamic> element) {
    return Tip(
      element['id'],
      element['description'],
    );
  }
}
