import 'package:flutter/material.dart';
import 'package:mcommerce/state/CategorySearchState.dart';
import 'package:provider/provider.dart';

class Categorysearch extends StatelessWidget {
  const Categorysearch({super.key});

   @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return ChangeNotifierProvider(
      create: (context) {
        final state = CategorysearchState();
        state.setCategory(arguments["id"], arguments["name"]);
        state.fetchItems(state.id, state.currentPage);
        return state;
      },
      child: Consumer<CategorysearchState>(
        builder: (context, categorySearchState, child) {
          ScrollController _controller = ScrollController();
          _controller.addListener(() {
            if (_controller.position.pixels == _controller.position.maxScrollExtent) {
              if (!categorySearchState.isLoading && categorySearchState.productList.length < categorySearchState.count) {
                categorySearchState.fetchItems(categorySearchState.id, categorySearchState.currentPage + 1);
              }
            }
          });

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text("${categorySearchState.name}"),
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back,
                  size: 30,
                  color: Colors.black,
                ),
              ),
            ),
            body: Padding(
              padding: EdgeInsets.all(10),
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Column(
                  children: [
                    if (categorySearchState.productList.isEmpty &&
                        !categorySearchState.isLoading)
                      Center(
                        child: Text(
                          'No data available',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      )
                    else
                      Expanded(
                        child: ListView.separated(
                          controller: _controller,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              width: 250,
                              child: categorySearchState.productList[index],
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(width: 8),
                          itemCount: categorySearchState.productList.length,
                        ),
                      ),
                    if (categorySearchState.isLoading && categorySearchState.productList.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
