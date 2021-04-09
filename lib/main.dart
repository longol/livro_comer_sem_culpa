import 'dart:io';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:livro_comer_sem_culpa/helpers/models.dart';
import 'package:livro_comer_sem_culpa/helpers/functions.dart';
import 'package:livro_comer_sem_culpa/recipeView.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseOptions options;

  if (Platform.isIOS) {
    options = FirebaseOptions(
      appId: '1:549560529818:ios:14bba1ba63a0dc795e4023',
      apiKey: 'AIzaSyBqMlyfv62vWcg_LAUHAJ5aUK7VST14c3s',
      projectId: 'comer-sem-culpa-b3939',
      messagingSenderId: '549560529818',
      databaseURL: 'https://comer-sem-culpa-b3939-default-rtdb.firebaseio.com/',
    );
  } else if (Platform.isAndroid) {
    options = FirebaseOptions(
      appId: '1:549560529818:android:8b34341c38b5e5c55e4023',
      apiKey: 'AIzaSyBqMlyfv62vWcg_LAUHAJ5aUK7VST14c3s',
      projectId: 'comer-sem-culpa-b3939',
      messagingSenderId: '549560529818',
      databaseURL: 'https://comer-sem-culpa-b3939-default-rtdb.firebaseio.com/',
    );
  } else {
    options = FirebaseOptions(
      apiKey: "AIzaSyBqMlyfv62vWcg_LAUHAJ5aUK7VST14c3s",
      authDomain: "comer-sem-culpa-b3939.firebaseapp.com",
      databaseURL: "https://comer-sem-culpa-b3939-default-rtdb.firebaseio.com",
      projectId: "comer-sem-culpa-b3939",
      storageBucket: "comer-sem-culpa-b3939.appspot.com",
      messagingSenderId: "549560529818",
      appId: "1:549560529818:web:e1e3f3a6846400a55e4023",
      measurementId: "G-HJTLSN7WE9",
    );
  }

  FirebaseApp app = await Firebase.initializeApp(
    options: options,
  );
  // FirebaseApp app = await Firebase.initializeApp(
  //   name: 'Comer Sem Culpa',
  //   options: options,
  // );

  runApp(MaterialApp(
    home: ComerSemCulpaApp(app: app),
  ));
}

class ComerSemCulpaApp extends StatefulWidget {
  ComerSemCulpaApp({Key key, this.app}) : super(key: key);
  final FirebaseApp app;
  final DatabaseReference databaseReference = FirebaseDatabase.instance
      .reference()
      .child('1r84JHFxkJYz2OGjCbtBgsdx0vfX0_cghhpMS11PJy1Q');

  @override
  _ComerSemCulpaAppState createState() => _ComerSemCulpaAppState();
}

class _ComerSemCulpaAppState extends State<ComerSemCulpaApp> {
  List<Recipe> recipes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Livro Comer Sem Culpa"),
      ),
      body: Column(
        children: [
          buildRecipeListView(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getRecipes,
        tooltip: 'Reload',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget buildRecipeListView() {
    if (recipes.length == 0) {
      getRecipes();
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Expanded(
        child: ListView(
      children: recipes.map((recipe) {
        return recipeListCell(recipe);
        // return ListTile(
        //   title: Text(
        //     '${recipe.id} - ${recipe.title}',
        //   ),
        // );
      }).toList(),
    ));
  }

  Widget recipeListCell(Recipe recipe) {
    String imageUrl = "fotosRecipe/small/${recipe.id}.png";
    return FutureBuilder(
      future: getImage(context, imageUrl, 50),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListTile(
            title: Text(recipe.title),
            leading: Container(
              width: 50.0,
              height: 50.0,
              child: snapshot.data,
            ),
            // trailing: Text(receita.id),
            trailing: Icon(
              Icons.arrow_right_rounded,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeView(
                    recipe: recipe,
                  ),
                ),
              );
            },
          );
        }
        return Text("Sorry an error occured");
      },
    );
  }

  void getRecipes() async {
    recipes = [];
    DataSnapshot data = await this.widget.databaseReference.once();

    Map recipesRaw = data.value['Recipes'];
    recipesRaw.entries.forEach((element) {
      Recipe recipe = Recipe.fromJSON(element.value);
      print("RECIPE:" + recipe.title);

      List utensilsRecipeRaw = data.value['UtensilsRecipe'];

      utensilsRecipeRaw.forEach((element) {
        if (element != null && element['recipeId'] == recipe.id) {
          Utensil utensil = Utensil.fromJSON(element);
          recipe.utensils.add(utensil);
          print(" UTENSIL: ${utensil.name}");
        }
      });

      List stagesRecipeRaw = data.value['StagesRecipe'];

      stagesRecipeRaw.forEach((element) {
        if (element != null && element['recipeId'] == recipe.id) {
          Stage stage = Stage.fromJSON(element);
          print(" STAGE: ${stage.name}");

          List ingredientsStageRaw = data.value['IngredientsStage'];
          ingredientsStageRaw.forEach((element) {
            if (element != null && element['recipeId'] == recipe.id) {
              Ingredient ingredient = Ingredient.fromJSON(element);
              stage.ingredients.add(ingredient);
              print("  INGREDIENT: ${ingredient.name}");
            }
          });

          List stepsStageRaw = data.value['StepsStage'];
          stepsStageRaw.forEach((element) {
            if (element != null && element['recipeId'] == recipe.id) {
              StepStage stepStage = StepStage.fromJSON(element);
              stage.steps.add(stepStage);
              print("  STEP: ${stepStage.description}");
            }
          });

          recipe.stages.add(stage);
        }
      });

      List tipsRecipeRaw = data.value['TipsRecipe'];

      tipsRecipeRaw.forEach((element) {
        if (element != null && element['recipeId'] == recipe.id) {
          Tip tip = Tip.fromJSON(element);
          recipe.tips.add(tip);
          print(" TIP: ${tip.description}");
        }
      });

      recipes.add(recipe);
    });

    setState(() {
      recipes.sort((a, b) => a.id.compareTo(b.id));
    });
  }
}
