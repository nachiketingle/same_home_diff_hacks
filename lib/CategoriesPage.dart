import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:samehomediffhacks/Services/CategoryService.dart';
import 'package:samehomediffhacks/Wrappers/LobbyToCategory.dart';
import 'package:samehomediffhacks/Wrappers/ToWaiting.dart';
import 'Helpers/AppThemes.dart';
import 'Models/User.dart';
import 'package:like_button/like_button.dart';

class CategoriesPage extends StatefulWidget {
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  Map<String, String> _allCategories = Map();
  List<String> _displayCategories = List<String>();
  Map<String, String> _selectedCategories = Map();
  Map<String, dynamic> emojis = Map();
  TextEditingController _searchController = TextEditingController();
  User _user;
  bool _loaded = false;
  String defaultEmoji = "🍳";

  FocusNode myFocusNode;
  Widget initSearchIcon;
  Widget searchIcon;

  void _submitCategories() {
    CategoryService.setCategories(
            _user.accessCode, _user.name, _selectedCategories.keys.toList())
        .then((value) {
      List<String> remaining = List();
      for (String name in value) {
        remaining.add(name);
      }
      ToWaiting wrapper = ToWaiting(
          _user, 'onCategoryEnd', 'onSwipeStart', '/restaurants', remaining);
      Navigator.pushNamed(context, "/waiting", arguments: wrapper);
    });
  }

  void _updateList(text) {
    // get the new text
    String val = text.trim();
    // clear the current display
    _displayCategories.clear();
    // if search is empty
    if (val.isEmpty) {
      // ready to search
      setState(() {
        searchIcon = initSearchIcon;
        _displayCategories.addAll(_allCategories.keys);
        _displayCategories
            .sort((a, b) => _allCategories[a].compareTo(_allCategories[b]));
      });
      return;
    }

    // update display
    _allCategories.forEach((key, cat) {
      if (cat.toLowerCase().contains(val.toLowerCase())) {
        _displayCategories.add(key);
      }
    });
    _displayCategories
        .sort((a, b) => _allCategories[a].compareTo(_allCategories[b]));

    // change icon to clear
    setState(() {
      searchIcon = IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          _searchController.clear();
          FocusScope.of(context).unfocus();
          _updateList("");
        },
      );
    });
  }

  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    initSearchIcon = IconButton(
      icon: Icon(Icons.search),
      onPressed: () {
        myFocusNode.requestFocus();
      },
    );
    searchIcon = initSearchIcon;
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    if (!_loaded) {
      CategoryService.getEmojis().then((map) => setState(() {
            map.forEach((key, value) {
              emojis[key] = value;
            });
          }));
      LobbyToCategory wrapper = ModalRoute.of(context).settings.arguments;
      wrapper.categories.forEach((key, value) {
        _allCategories[key] = value;
      });
      _user = wrapper.user;
      _displayCategories.addAll(_allCategories.keys);
      _loaded = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Select Your Categories"),
      ),
      body: Stack(children: <Widget>[
        Opacity(
          opacity: .6,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topLeft,
                  colors: [Colors.blue, Colors.purple]),
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // Search Bar
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Row(
                  children: <Widget>[
                    searchIcon,
                    SizedBox.fromSize(
                      size: Size(20, 0),
                    ),
                    Expanded(
                      child: TextField(
                        focusNode: myFocusNode,
                        controller: _searchController,
                        decoration: InputDecoration(hintText: "Search"),
                        onChanged: _updateList,
                      ),
                    ),
                  ],
                ),
              ),

              // List of Categories
              Expanded(
                child: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _displayCategories.length,
                    itemBuilder: (context, index) {
                      String key = _displayCategories.elementAt(index);
                      String cat = _allCategories[key];
                      Future<bool> onLikeButtonTapped(bool isLiked) async {
                        if (isLiked) {
                          _selectedCategories.remove(key);
                        } else {
                          _selectedCategories[key] = cat;
                        }
                        return !isLiked;
                      }

                      Widget like = LikeButton(
                        size: 30,
                        circleColor: CircleColor(
                            start: Color(0xff00ddff), end: Color(0xff0099cc)),
                        bubblesColor: BubblesColor(
                          dotPrimaryColor: Color(0xff33b5e5),
                          dotSecondaryColor: Color(0xff0099cc),
                        ),
                        likeBuilder: (bool isLiked) {
                          return Icon(
                            Icons.favorite,
                            color:
                                isLiked ? Colors.deepPurpleAccent : Colors.grey,
                            size: 30,
                          );
                        },
                        onTap: onLikeButtonTapped,
                      );
                      return ListTileTheme(
                        child: ListTile(
                          leading: Text(
                              emojis.containsKey(key)
                                  ? emojis[key]
                                  : defaultEmoji,
                              style: TextStyle(fontSize: 30)),
                          title: Text(cat),
                          trailing: SizedBox(
                              width: 60,
                              height: 30,
                              child: Padding(
                                  padding: EdgeInsets.only(right: 20),
                                  child: like)),
                        ),
                      );
                    }),
              )
            ],
          ),
        )
      ]),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: _submitCategories,
          label: Text(
            "Submit!",
            style: TextStyle(color: AppThemes.buttonTextColor),
          )),
    );
  }
}
