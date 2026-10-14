import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: const CanteenApp(),
    ),
  );
}

// ============================================================
// MODEL
// ============================================================

class FoodItem {
  final String name;
  final double price;
  final String category;
  final IconData icon;

  FoodItem({
    required this.name,
    required this.price,
    required this.category,
    required this.icon,
  });
}

// ============================================================
// PROVIDER - STATE MANAGEMENT
// ============================================================

class CartProvider extends ChangeNotifier {
  final Map<FoodItem, int> _cart = {};

  Map<FoodItem, int> get cart => _cart;

  void addItem(FoodItem item) {
    if (_cart.containsKey(item)) {
      _cart[item] = _cart[item]! + 1;
    } else {
      _cart[item] = 1;
    }

    notifyListeners();
  }

  void removeItem(FoodItem item) {
    if (_cart.containsKey(item)) {
      if (_cart[item]! > 1) {
        _cart[item] = _cart[item]! - 1;
      } else {
        _cart.remove(item);
      }
    }

    notifyListeners();
  }

  int quantity(FoodItem item) {
    return _cart[item] ?? 0;
  }

  double get total {
    double sum = 0;

    _cart.forEach((item, quantity) {
      sum += item.price * quantity;
    });

    return sum;
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }
}

// ============================================================
// MAIN APP
// ============================================================

class CanteenApp extends StatelessWidget {
  const CanteenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'College Canteen',

      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        scaffoldBackgroundColor: const Color(0xFFFDF8F3),
        useMaterial3: true,
      ),

      // NAMED ROUTES
      initialRoute: '/',

      routes: {
        '/': (context) => const HomeScreen(),
        '/menu': (context) => const MenuScreen(),
        '/summary': (context) => const OrderSummaryScreen(),
      },
    );
  }
}

// ============================================================
// HOME SCREEN
// ============================================================

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // MEDIA QUERY
    final screenWidth = MediaQuery.of(context).size.width;

    // BREAKPOINT
    final bool isSmallScreen = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'College Canteen',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(isSmallScreen ? 16 : 30),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            // STACK
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: isSmallScreen ? 180 : 240,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.deepOrange,
                  ),
                ),

                Positioned(
                  left: 25,
                  top: 30,

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        'Welcome to',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isSmallScreen ? 20 : 26,
                        ),
                      ),

                      Text(
                        'College Canteen',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isSmallScreen ? 28 : 38,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        'Fresh • Tasty • Affordable',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),

                const Positioned(
                  right: 25,
                  bottom: 20,
                  child: Icon(
                    Icons.fastfood,
                    color: Colors.white,
                    size: 65,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              'Categories',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            // RESPONSIVE ROW / GRID
            GridView.count(
              crossAxisCount: isSmallScreen ? 2 : 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),

              crossAxisSpacing: 15,
              mainAxisSpacing: 15,

              children: const [
                CategoryCard(
                  title: 'Snacks',
                  icon: Icons.fastfood,
                ),

                CategoryCard(
                  title: 'Meals',
                  icon: Icons.restaurant,
                ),

                CategoryCard(
                  title: 'Beverages',
                  icon: Icons.local_drink,
                ),
              ],
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton.icon(
                onPressed: () {
                  // NAVIGATION USING NAMED ROUTE
                  Navigator.pushNamed(context, '/menu');
                },

                icon: const Icon(Icons.restaurant_menu),

                label: const Text(
                  'View Food Menu',
                  style: TextStyle(fontSize: 18),
                ),

                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// CATEGORY CARD - STATELESS WIDGET
// ============================================================

class CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const CategoryCard({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Icon(
            icon,
            size: 45,
            color: Colors.deepOrange,
          ),

          const SizedBox(height: 10),

          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// FOOD MENU
// ============================================================

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {

  // PREDEFINED MENU
  final List<FoodItem> foodItems = [

    FoodItem(
      name: 'Samosa',
      price: 15,
      category: 'Snacks',
      icon: Icons.fastfood,
    ),

    FoodItem(
      name: 'Veg Puff',
      price: 25,
      category: 'Snacks',
      icon: Icons.bakery_dining,
    ),

    FoodItem(
      name: 'Masala Dosa',
      price: 50,
      category: 'Meals',
      icon: Icons.restaurant,
    ),

    FoodItem(
      name: 'Veg Fried Rice',
      price: 70,
      category: 'Meals',
      icon: Icons.rice_bowl,
    ),

    FoodItem(
      name: 'Tea',
      price: 15,
      category: 'Beverages',
      icon: Icons.coffee,
    ),

    FoodItem(
      name: 'Cold Drink',
      price: 30,
      category: 'Beverages',
      icon: Icons.local_drink,
    ),
  ];

  String selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {

    // MEDIA QUERY
    final width = MediaQuery.of(context).size.width;

    final bool isMobile = width < 600;

    // FILTER FOOD
    final filteredItems = selectedCategory == 'All'
        ? foodItems
        : foodItems
        .where(
          (item) => item.category == selectedCategory,
    )
        .toList();

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          'Food Menu',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        actions: [

          Consumer<CartProvider>(
            builder: (context, cart, child) {

              return Stack(
                children: [

                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/summary',
                      );
                    },

                    icon: const Icon(
                      Icons.shopping_cart,
                    ),
                  ),

                  if (cart.cart.isNotEmpty)
                    Positioned(
                      right: 5,
                      top: 5,

                      child: CircleAvatar(
                        radius: 9,
                        backgroundColor: Colors.red,

                        child: Text(
                          '${cart.cart.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),

      body: Column(
        children: [

          // CATEGORY BUTTONS
          SizedBox(
            height: 65,

            child: ListView(
              scrollDirection: Axis.horizontal,

              padding: const EdgeInsets.all(10),

              children: [

                categoryButton('All'),

                categoryButton('Snacks'),

                categoryButton('Meals'),

                categoryButton('Beverages'),
              ],
            ),
          ),

          // FOOD ITEMS
          Expanded(

            child: GridView.builder(

              padding: EdgeInsets.all(
                isMobile ? 12 : 25,
              ),

              gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(

                crossAxisCount:
                isMobile ? 1 : 2,

                crossAxisSpacing: 15,
                mainAxisSpacing: 15,

                childAspectRatio:
                isMobile ? 2.2 : 2.5,
              ),

              itemCount: filteredItems.length,

              itemBuilder: (context, index) {

                final item = filteredItems[index];

                return FoodCard(item: item);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget categoryButton(String category) {

    final bool selected =
        selectedCategory == category;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
      ),

      child: ChoiceChip(
        label: Text(category),

        selected: selected,

        onSelected: (value) {

          // SETSTATE
          setState(() {
            selectedCategory = category;
          });
        },
      ),
    );
  }
}

// ============================================================
// FOOD CARD
// ============================================================

class FoodCard extends StatelessWidget {

  final FoodItem item;

  const FoodCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {

    return Card(
      elevation: 3,

      child: Padding(
        padding: const EdgeInsets.all(15),

        child: Row(
          children: [

            // ICON
            Container(
              width: 65,
              height: 65,

              decoration: BoxDecoration(
                color: Colors.deepOrange.shade50,
                borderRadius:
                BorderRadius.circular(15),
              ),

              child: Icon(
                item.icon,
                size: 35,
                color: Colors.deepOrange,
              ),
            ),

            const SizedBox(width: 15),

            // COLUMN
            Expanded(
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    '₹${item.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // ADD BUTTON
            Consumer<CartProvider>(
              builder: (context, cart, child) {

                final quantity =
                cart.quantity(item);

                return Row(
                  children: [

                    if (quantity > 0)
                      IconButton(
                        onPressed: () {
                          cart.removeItem(item);
                        },

                        icon: const Icon(
                          Icons.remove_circle_outline,
                        ),
                      ),

                    if (quantity > 0)
                      Text(
                        '$quantity',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    IconButton(
                      onPressed: () {
                        cart.addItem(item);
                      },

                      icon: const Icon(
                        Icons.add_circle,
                        color: Colors.deepOrange,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// ORDER SUMMARY
// ============================================================

class OrderSummaryScreen extends StatelessWidget {

  const OrderSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          'Order Summary',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: Consumer<CartProvider>(

        builder: (context, cart, child) {

          if (cart.cart.isEmpty) {

            return const Center(
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,

                children: [

                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),

                  SizedBox(height: 15),

                  Text(
                    'No items selected',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(
                    'Add some food from the menu.',
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              children: [

                const Text(
                  'Selected Items',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                // LIST OF SELECTED ITEMS
                Expanded(

                  child: ListView.builder(

                    itemCount: cart.cart.length,

                    itemBuilder: (context, index) {

                      final item =
                      cart.cart.keys.elementAt(index);

                      final quantity =
                      cart.cart[item]!;

                      final itemTotal =
                          item.price * quantity;

                      return Card(

                        margin:
                        const EdgeInsets.only(
                          bottom: 12,
                        ),

                        child: ListTile(

                          leading: CircleAvatar(
                            backgroundColor:
                            Colors.deepOrange.shade50,

                            child: Icon(
                              item.icon,
                              color:
                              Colors.deepOrange,
                            ),
                          ),

                          title: Text(
                            item.name,
                            style:
                            const TextStyle(
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),

                          subtitle: Text(
                            '₹${item.price} × $quantity',
                          ),

                          trailing: Text(
                            '₹${itemTotal.toStringAsFixed(0)}',
                            style:
                            const TextStyle(
                              fontWeight:
                              FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // TOTAL SECTION
                Container(
                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    color: Colors.deepOrange.shade50,

                    borderRadius:
                    BorderRadius.circular(20),
                  ),

                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                    children: [

                      const Text(
                        'Estimated Total',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        '₹${cart.total.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                Row(
                  children: [

                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          cart.clearCart();
                        },

                        child: const Text(
                          'Clear',
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {

                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Bill calculated successfully!',
                              ),
                            ),
                          );
                        },

                        child: const Text(
                          'Calculate Bill',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}