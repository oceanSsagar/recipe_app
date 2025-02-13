import 'package:flutter/material.dart';
import 'package:recipe_app/screens/categories.dart';
import 'package:recipe_app/screens/filters.dart';
import 'package:recipe_app/screens/meals.dart';
// import 'package:recipe_app/models/meal.dart';
import 'package:recipe_app/widgets/main_drawer.dart';
// import 'package:recipe_app/data/dummy_data.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:recipe_app/provider/meals_provider.dart";
import 'package:recipe_app/provider/favorites_provider.dart';
import 'package:recipe_app/provider/filters_provider.dart';

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false,
};

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});
  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  // final List<Meal> _favoriteMeals = [];
  // Map<Filter, bool> _selectedFilters = {...kInitialFilters};
  int _selectedPageIndex = 0;

  // void _toggleMealFavoriteStatus(Meal meal) {
  //   final isExisting = _favoriteMeals.contains(meal);
  //   setState(() {
  //     if (isExisting) {
  //       _favoriteMeals.remove(meal);
  //     } else {
  //       _favoriteMeals.add(meal);
  //     }
  //   });
  // }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();

    if (identifier == "filters") {
      await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => FiltersScreen(),
        ),
      );
    }
  }

  // List<Meal> get _filteredMeals {
  //   return dummyMeals.where((meal) {
  //     if (_selectedFilters[Filter.glutenFree]! && !meal.isGlutenFree) return false;
  //     if (_selectedFilters[Filter.lactoseFree]! && !meal.isLactoseFree) return false;
  //     if (_selectedFilters[Filter.vegan]! && !meal.isVegan) return false;
  //     if (_selectedFilters[Filter.vegetarian]! && !meal.isVegetarian) return false;
  //     return true;
  //   }).toList();
  // }

  @override
  Widget build(BuildContext context) {
    // final meals = ref.watch(mealsProvider);

    // final filteredFavoriteMeals = _favoriteMeals.where((meal) {
    //   return _filteredMeals.contains(meal);
    // }).toList();

    // final activeFilters = ref.watch(filteredMealsProvider);
    final availableMeals = ref.watch(filteredMealsProvider);
    Widget activePage = CategoriesScreen(
      availableMeals: availableMeals,
    );
    var activePageTitle = "Categories";

    if (_selectedPageIndex == 1) {
      final favoriteMeals = ref.watch(favoriteMealsProvider);
      activePage = MealsScreen(
        meals: favoriteMeals,
      );
      activePageTitle = "Your Favorites";
    }

    return Scaffold(
      appBar: AppBar(title: Text(activePageTitle)),
      drawer: MainDrawer(onSelectScreen: _setScreen),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPageIndex,
        onTap: (index) => setState(() => _selectedPageIndex = index),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.set_meal), label: "Categories"),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: "Favorites"),
        ],
      ),
    );
  }
}
