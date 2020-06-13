import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Helpers/AppThemes.dart';

class CategoriesPage extends StatefulWidget {
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {

  List<String> _allCategories = List<String>();
  List<String> _displayCategories = List<String>();
  List<String> _selectedCategories = List<String>();

  TextEditingController _searchController = TextEditingController();

  bool isSearching = false;

  Widget searchIcon = Icon(Icons.search);

  void _submitCategories() {
    Navigator.pushNamed(context, "/restaurants");
  }

  void _getCategories() {
    // Ping server for all the categories
    _allCategories.add("Thai");
    _allCategories.add("Chinese");
    _allCategories.add("Indian");
    _allCategories.add("Pizza");
    _allCategories.add("Ice Cream");
    _displayCategories.addAll(_allCategories);
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

    for (String cat in _allCategories) {
      if(cat.toLowerCase().contains(val.toLowerCase())) {
        _displayCategories.add(cat);
      }
    }

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
    _getCategories();
  }

  Widget build(BuildContext context) {
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
                    String cat = _displayCategories[index];
                    return ListTileTheme(
                      selectedColor: Colors.purple,
                      child: ListTile(
                        selected: _selectedCategories.contains(cat),
                        title: Text(cat),
                        onTap: () {
                          setState(() {
                            if(_selectedCategories.contains(cat)) {
                              _selectedCategories.remove(cat);
                            }
                            else{
                              _selectedCategories.add(cat);
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