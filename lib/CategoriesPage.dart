import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:samehomediffhacks/Services/CategoryService.dart';
import 'package:samehomediffhacks/Wrappers/LobbyToCategory.dart';
import 'package:samehomediffhacks/Wrappers/ToWaiting.dart';
import 'Helpers/AppThemes.dart';
import 'Models/User.dart';

class CategoriesPage extends StatefulWidget {
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {

  Map<String, String> _allCategories = Map();
  Map<String, String> _displayCategories = Map();
  Map<String, String> _selectedCategories = Map();
  TextEditingController _searchController = TextEditingController();
  User _user;
  bool _loaded = false;
  bool isSearching = false;

  Widget searchIcon = Icon(Icons.search);

  void _submitCategories() {
    CategoryService.setCategories(_user.accessCode, _user.name, _selectedCategories.keys.toList()).then((value) {
      List<String> remaining = List();
      for(String name in value) {
        remaining.add(name);
      }
      ToWaiting wrapper = ToWaiting(_user, 'onCategoryEnd', 'onSwipeStart', '/restaurants', remaining);
      Navigator.pushNamed(context, "/waiting", arguments: wrapper);
    });

  }

  void _updateList(){
    String val = _searchController.text.trim();
    _displayCategories.clear();
    if(val.isEmpty) {
      setState(() {
        searchIcon = Icon(Icons.search);
        _displayCategories.addAll(_allCategories);
      });

      return;
    }

    _allCategories.forEach((key, cat) {
      if(cat.toLowerCase().contains(val.toLowerCase())) {
        _displayCategories[key] = cat;
      }
    });

    searchIcon = IconButton(
      icon: Icon(Icons.clear),
      onPressed: () {
        _searchController.clear();
        FocusScope.of(context).unfocus();
        _updateList();
      },
    );

    setState(() {

    });
  }

  void initState() {
    super.initState();

  }

  Widget build(BuildContext context) {

    if(!_loaded) {
      LobbyToCategory wrapper = ModalRoute.of(context).settings.arguments;
      wrapper.categories.forEach((key, value) {
        _allCategories[key] = value;
      });
      _user = wrapper.user;
      _displayCategories.addAll(_allCategories);
      _loaded = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Select Your Categories"),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // Search Bar
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Row(
                children: <Widget>[
                  searchIcon,
                  SizedBox.fromSize(size: Size(20, 0),),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                          hintText: "Search"
                      ),
                      onEditingComplete: _updateList,
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
                    String key = _displayCategories.keys.elementAt(index);
                    String cat = _displayCategories[key];
                    return ListTileTheme(
                      selectedColor: Colors.purple,
                      child: ListTile(
                        selected: _selectedCategories[key] != null,
                        title: Text(cat),
                        onTap: () {
                          setState(() {
                            if(_selectedCategories[key] != null) {
                              _selectedCategories.remove(key);
                            }
                            else{
                              _selectedCategories[key] = _displayCategories[key];
                            }
                          });
                        },
                      ),
                    );
                  }
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: _submitCategories,
          label: Text("Submit Categories", style: TextStyle(color: AppThemes.buttonTextColor),)
      ),
    );
  }

}