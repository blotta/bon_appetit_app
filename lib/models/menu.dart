class Restaurant {
  const Restaurant(this.name, this.menus, this.address);
  final String name;
  final List<Menu> menus;
  final String address;
}

class Menu {
  const Menu(this.name, this.sections);
  final String name; // Menu Principal
  final List<MenuSection> sections;
}

class MenuSection {
  const MenuSection(this.name, this.items);
  final String name;
  final List<MenuItem> items;
}

class MenuItem {
  const MenuItem(this.name, this.imageUrl, this.price, this.description);

  final String name;
  final String imageUrl;
  final double price;
  final String description;
}

class OrderItem {
  OrderItem(this.item, this.quantity);
  final MenuItem item;
  int quantity;
}