class Restaurant {
  const Restaurant(this.name, this.menus);
  final String name;
  final List<Menu> menus;
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