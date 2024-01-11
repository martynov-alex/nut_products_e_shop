import 'package:flutter/material.dart';
import 'package:nut_products_e_shop/src/localization/string_hardcoded.dart';

/// Search field used to filter products by name
class ProductsSearchTextField extends StatefulWidget {
  const ProductsSearchTextField({super.key});

  @override
  State<ProductsSearchTextField> createState() =>
      _ProductsSearchTextFieldState();
}

class _ProductsSearchTextFieldState extends State<ProductsSearchTextField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    // * TextEditingControllers should be always disposed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // See this article for more info about how to use [ValueListenableBuilder]
    // with TextField:
    // https://codewithandrea.com/articles/flutter-text-field-form-validation/
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: _controller,
      builder: (context, value, _) {
        return TextField(
          controller: _controller,
          style: Theme.of(context).textTheme.titleLarge,
          decoration: InputDecoration(
            hintText: 'Search products'.hardcoded,
            icon: const Icon(Icons.search),
            suffixIcon: value.text.isNotEmpty
                ? IconButton(
                    // TODO(martynov): Clear search state
                    onPressed: _controller.clear,
                    icon: const Icon(Icons.clear),
                  )
                : null,
          ),
          // TODO(martynov): Implement onChanged
          // ignore: avoid_redundant_argument_values
          onChanged: null,
        );
      },
    );
  }
}
