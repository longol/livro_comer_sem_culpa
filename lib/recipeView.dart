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
    // widgets.add(_generalInfoRow("Preparo", this.widget.recipe.preparo));
    // widgets.add(_generalInfoRow("Porção", this.widget.recipe.porcao));
    // widgets.add(_generalInfoRow("Material", this.widget.recipe.material));
    // widgets.add(_generalInfoRow("Validade", this.widget.recipe.validade));

    // if (this.widget.recipe.ingredients.length > 0) {
    //   widgets.add(_headerRow("INGREDIENTES"));
    //   widgets.addAll(_bulletList(this.widget.recipe.ingredientes));

    //   widgets.add(_headerRow("MODO DE PREPARO"));
    //   widgets.addAll(_bulletList(this.widget.recipe.modoPreparo));
    // } else if (this.widget.recipe.etapas.length > 0) {
    //   widgets.addAll(_etapasReceita());
    // }
    // widgets.add(
    //   SizedBox(
    //     height: 100,
    //   ),
    // );

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: widgets,
        ),
      ),
    );
  }

  Container _imageRow() {
    var imageUrl = "fotosRecipe/large/${this.widget.recipe.id}.png";

    return Container(
        child: FutureBuilder(
      future: getImage(context, imageUrl, 200),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done)
          return Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.width * 0.4,
                child: snapshot.data,
              )
            ],
          );

        if (snapshot.connectionState == ConnectionState.waiting)
          return Column(
            children: [CircularProgressIndicator()],
          );

        if (snapshot.hasError) {
          return Column(
            children: [
              Text("Sorry an error occured"),
            ],
          );
        }
        return Column();
      },
    ));
  }

  // ignore: unused_element
  Container _generalInfoRow(String title, String text) {
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
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
  Container _headerRow(String text) {
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

  // ignore: unused_element
  List<Widget> _bulletList(List<dynamic> list) {
    List<Widget> widgets = [];

    for (String line in list) {
      widgets.add(_bulletRow(line));
    }
    return widgets;
  }

  Container _bulletRow(String text) {
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

  // List<Widget> _etapasReceita() {
  //   List<Widget> widgets = [];

  //   int i = 1;
  //   for (Etapa etapa in this.widget.recipe.etapas) {
  //     widgets.add(_etapaNameRow("Etapa $i: ${etapa.nome}"));
  //     i++;

  //     widgets.add(_headerRow("INGREDIENTES"));
  //     widgets.addAll(_bulletList(etapa.ingredientes));

  //     widgets.add(_headerRow("MODO DE PREPARO"));
  //     widgets.addAll(_bulletList(etapa.modoPreparo));
  //   }
  //   return widgets;
  // }

  // ignore: unused_element
  Container _etapaNameRow(String text) {
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
