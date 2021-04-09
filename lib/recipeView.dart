import 'dart:core';
import 'package:flutter/material.dart';
import 'helpers/functions.dart';
import 'helpers/models.dart';

class RecipeView extends StatefulWidget {
  final Recipe recipe;

  @override
  RecipeViewState createState() {
    return RecipeViewState();
  }

  RecipeView({this.recipe});
}

class RecipeViewState extends State<RecipeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.widget.recipe.title),
      ),
      body: updateInterface(),
    );
  }

  Widget updateInterface() {
    List<Widget> widgets = [];

    widgets.add(_imageRow());
    widgets
        .add(_headerRow("Protein | Energy: ${this.widget.recipe.peRatio()}"));
    widgets.add(_nutritionalInfoTable());
    widgets.add(
        _generalInfoRow("Prep Time", "${this.widget.recipe.prepTime} minutes"));
    if (this.widget.recipe.cookTime != 0) {
      widgets.add(_generalInfoRow(
          "Cooking Time", "${this.widget.recipe.cookTime} minutes"));
    }
    if (this.widget.recipe.coolingTime != 0) {
      widgets.add(_generalInfoRow(
          "Cooling Time", "${this.widget.recipe.coolingTime} minutes"));
    }
    widgets.add(_headerRow("Utensils"));
    this.widget.recipe.utensils.forEach((utensil) {
      widgets.add(_bulletRow(utensil.name));
    });

    this.widget.recipe.stages.forEach((stage) {
      if (this.widget.recipe.stages.length > 1) {
        widgets.add(_stageHeaderRow(stage.name));
      }
      widgets.add(_headerRow("Ingredients"));
      stage.ingredients.forEach((ingredient) {
        widgets.add(_bulletRow(ingredient.name));
      });

      widgets.add(_headerRow("Steps"));
      stage.steps.forEach((step) {
        widgets.add(_bulletRow(step.description));
      });
    });

    if (this.widget.recipe.tips.length > 0) {
      widgets.add(_headerRow("Tips"));
      this.widget.recipe.tips.forEach((tip) {
        widgets.add(_bulletRow(tip.description));
      });
    }

    widgets.add(
      SizedBox(
        height: 100,
      ),
    );

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: widgets,
        ),
      ),
    );
  }

  Widget _imageRow() {
    var imageUrl = "fotosRecipe/large/${this.widget.recipe.id}.png";

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width / 1.5,
      child: FutureBuilder(
        future: getImage(context, imageUrl, 200),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done)
            return Center(
              heightFactor: 1,
              child: snapshot.data,
            );

          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.active)
            return Column(
              children: [
                CircularProgressIndicator(),
                Text("Loading"),
              ],
            );

          if (snapshot.hasError) {
            return Text("Sorry an error occured");
          }
          return Center();
        },
      ),
    );
  }

  Widget _nutritionalInfoTable() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(10),
            child: Table(
              border: TableBorder.all(),
              children: [
                TableRow(children: [
                  Text("Recipe"),
                  Text(
                      "${this.widget.recipe.recipeQuantity} ${this.widget.recipe.recipeQuantityMeasure}s"),
                ]),
                TableRow(children: [
                  Text("Calories"),
                  Text("${this.widget.recipe.calories}"),
                ]),
                TableRow(children: [
                  Text("Carbohydrates"),
                  Text("${this.widget.recipe.carbohydrates} grams"),
                ]),
                TableRow(children: [
                  Text("Proteins"),
                  Text("${this.widget.recipe.proteins} grams"),
                ]),
                TableRow(children: [
                  Text("Fats"),
                  Text("${this.widget.recipe.fats} grams"),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _generalInfoRow(String title, String text) {
    final double _width = MediaQuery.of(context).size.width * 0.95;

    return Container(
      width: _width,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Text(
              title + ": ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontSize: 20,
              ),
            ),
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerRow(String text) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  Widget _bulletRow(String text) {
    final _width = MediaQuery.of(context).size.width * 0.95;

    return Container(
      width: _width,
      child: Text(
        "• " + text,
        style: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 18,
        ),
      ),
    );
  }

  // ignore: unused_element
  Widget _stageHeaderRow(String text) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          direction: Axis.vertical,
          children: [
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            )
          ],
        ),
      ),
    );
  }
}
