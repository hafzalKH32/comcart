import 'package:com_cart/features/products/data/product_repository.dart';
import 'package:com_cart/features/products/logic/product_detail/bloc/product_detail_bloc.dart';
import 'package:com_cart/features/products/logic/product_list/bloc/product_list_bloc.dart';
import 'package:com_cart/features/products/presentaton/product_list/product_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final repository = ProductRepository();
  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final ProductRepository repository;
  const MyApp({super.key, required this.repository});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ProductListBloc(repository: repository)
            ..add(const ProductListFetched(1)), // << REQUIRED
        ),

        BlocProvider(
          create: (context) => ProductDetailBloc(repository: repository),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ECOM CART',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.deepPurple,
          scaffoldBackgroundColor: Colors.white
        ),
        home: ProductListPage(repository: repository,),
      ),
    );
  }
}
