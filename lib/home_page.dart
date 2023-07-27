import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:recipe_route/RecipeView.dart';
import 'package:recipe_route/recipe_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  List<RecipeModel> recipeList = <RecipeModel>[];
  TextEditingController searchController = TextEditingController();

  void getRecipe(String name) async {
    recipeList.clear();
    String url =
        "https://api.edamam.com/search?q=$name&app_id=1bcafd50&app_key=0a9b11b924e62e3190510d0fee169c22";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);

    data["hits"].forEach((element) {
      RecipeModel recipeModel = RecipeModel.fromMap(element["recipe"]);
      recipeList.add(recipeModel);
    });
    setState(() {});
  }

  @override
  void initState() {
    getRecipe("Modak");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  // Color(0xff213A50),
                  // Color(0xff071938),
                  Colors.blue.shade50,
                  Colors.blue.shade600,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SafeArea(
                  child: Container(
                    padding: const EdgeInsets.only(left: 18),
                    margin: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                    height: 44,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: Colors.white,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            String name = searchController.text
                                .toString()
                                .replaceAll(" ", "");
                            if (name != "") {
                              setState(() {
                                getRecipe(name);
                              });
                            }
                          },
                          child: const Icon(CupertinoIcons.search,
                              color: Colors.blue),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.text,
                            controller: searchController,
                            textInputAction: TextInputAction.search,
                            onSubmitted: (value) {
                              String name =
                                  searchController.text.replaceAll(" ", "");
                              if (name != "") {
                                setState(() {
                                  getRecipe(name);
                                });
                              }
                            },
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Let's Cook Something!",
                            ),
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "WHAT DO YOU WANT TO COOK TODAY? ",
                        style: TextStyle(color: Colors.white, fontSize: 32),
                      ),
                      SizedBox(height: 12),
                      Text(
                        "Let's Cook Something New!",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: recipeList.isEmpty
                      ? Container(
                          margin: const EdgeInsets.only(top: 200),
                          child: const SpinKitWave(
                            color: Colors.white,
                            size: 50.0,
                          ),
                        )
                      : ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: recipeList.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return RecipeView(recipeList[index].url);
                                    },
                                  ),
                                );
                              },
                              child: Card(
                                margin:
                                    const EdgeInsets.fromLTRB(18, 0, 18, 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Stack(children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Image.network(
                                      recipeList[index].imgUrl,
                                      width: double.infinity,
                                      height: 250,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14, horizontal: 20),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.black12,
                                      ),
                                      child: Text(
                                        recipeList[index].label,
                                        style: const TextStyle(
                                            fontSize: 18, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      height: 40,
                                      width: 105,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(20),
                                        ),
                                        color: CupertinoColors.systemGrey5,
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                              Icons.local_fire_department),
                                          Text(
                                              "${recipeList[index].calories.toString().substring(0, 6)} Cal"),
                                        ],
                                      ),
                                    ),
                                  ),
                                ]),
                              ),
                            );
                          }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
