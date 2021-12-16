// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'model/products_repository.dart';
import 'model/product.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  // TODO: Make a collection of cards (102)
  List<Card> _buildGridCards(BuildContext context) {
    List<Product> products = ProductsRepository.loadProducts(Category.all);

    if (products.isEmpty) {
      return const <Card>[];
    }

    final ThemeData theme = Theme.of(context);
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString());

    return products
        .map(
          (e) => Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 18 / 11,
                  child: Image.asset(
                    e.assetName,
                    fit: BoxFit.fitWidth,
                    package: e.assetPackage,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    12,
                    16,
                    8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        e.name,
                        style: theme.textTheme.headline6,
                        maxLines: 1,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        formatter.format(e.price),
                        style: theme.textTheme.subtitle2,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        )
        .toList();
  }

  // TODO: Add a variable for Category (104)
  @override
  Widget build(BuildContext context) {
    // TODO: Return an AsymmetricView (104)
    // TODO: Pass Category variable to AsymmetricView (104)
    return Scaffold(
      // TODO: Add app bar (102)
      appBar: AppBar(
        title: const Text('SHRINE'),
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            semanticLabel: 'menu',
          ),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              print('Search button');
            },
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.tune),
          ),
        ],
      ),
      // TODO: Add a grid view (102)
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        childAspectRatio: 8 / 9,
        children: [..._buildGridCards(context)],
      ),
      resizeToAvoidBottomInset: false,
      // TODO: Set resizeToAvoidBottomInset (101)
    );
  }
}
