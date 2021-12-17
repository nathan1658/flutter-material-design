import 'package:flutter/material.dart';
import 'package:shrine/colors.dart';
import 'package:shrine/model/product.dart';

class CategoryMenuPage extends StatelessWidget {
  final Category currentCategory;
  final ValueChanged<Category> onCategoryTap;
  final List<Category> _categories = Category.values;

  const CategoryMenuPage({
    required this.currentCategory,
    required this.onCategoryTap,
    Key? key,
  }) : super(key: key);

  Widget _buildCategory(Category category, BuildContext context) {
    final categoryString =
        category.toString().replaceAll('Category.', '').toUpperCase();
    final ThemeData theme = Theme.of(context);

    return GestureDetector(
      onTap: () => onCategoryTap(category),
      child: category == currentCategory
          ? Column(
              children: [
                const SizedBox(
                  height: 16,
                ),
                Text(
                  categoryString,
                  style: theme.textTheme.bodyText1,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 14),
                Container(width: 70, height: 2, color: kShrinePink400),
              ],
            )
          : Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                categoryString,
                style: theme.textTheme.bodyText1!.copyWith(
                  color: kShrineBrown900.withAlpha(153),
                ),
                textAlign: TextAlign.center,
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.only(top: 40),
        color: kShrinePink100,
        child: ListView(
            children:
                _categories.map((e) => _buildCategory(e, context)).toList()),
      ),
    );
  }
}
