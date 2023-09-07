import 'package:bon_appetit_app/models/menu.dart';

var dataItems = const [
  // Entradas
  MenuItem(
      "Bruschetta",
      "https://yyejvqdyfvplnjygzgwv.supabase.co/storage/v1/object/public/images/bruschetta.png",
      20.0,
      "Opções de tomate, pepino ou presunto de parma."),
  MenuItem(
      "Ravioli Frito",
      "https://yyejvqdyfvplnjygzgwv.supabase.co/storage/v1/object/public/images/ravioli-frito.png",
      35.0,
      "Recheado com muçarela de bufala. Acompanha molho de tomate."),
  MenuItem(
      "Calamari Frito",
      "https://yyejvqdyfvplnjygzgwv.supabase.co/storage/v1/object/public/images/calamari-frito.png",
      26.0,
      "Nossa famosa lula frita. Acompanha limão siciliano."),

  // principal
  MenuItem(
      "Pizza",
      "https://yyejvqdyfvplnjygzgwv.supabase.co/storage/v1/object/public/images/pizza.png",
      73.0,
      "Massa integral com molho de tomate caseiro, queijo muçarela e pepperoni"),
  MenuItem(
      "Fettuccine Alfredo",
      "https://yyejvqdyfvplnjygzgwv.supabase.co/storage/v1/object/public/images/fettuccine-alfredo.png",
      45.0,
      "Fettuccine ao famoso molho alfredo. Acompanha paillard de carne"),

  // Bebidas
  MenuItem(
      "Refrigerante 355mL",
      "https://yyejvqdyfvplnjygzgwv.supabase.co/storage/v1/object/public/images/refrigerante-lata.png",
      7.0,
      "Coca-Cola (Zero), Guaraná Antartica (Zero)"),
  MenuItem(
      "Suco Natural",
      "https://yyejvqdyfvplnjygzgwv.supabase.co/storage/v1/object/public/images/suco-natural.jpg?t=2023-07-31T05%3A21%3A43.149Z",
      10.0,
      "Laranja, maracujá, uva e limão"),

  // Sobremesas
  MenuItem(
      "Canoli",
      "https://yyejvqdyfvplnjygzgwv.supabase.co/storage/v1/object/public/images/cannoli.jpg?t=2023-07-31T05%3A20%3A17.834Z",
      28.0,
      "Massa doce frita, em formato de tubo, recheada com um creme de ricota"),
  MenuItem(
      "Tiramisu",
      "https://yyejvqdyfvplnjygzgwv.supabase.co/storage/v1/object/public/images/tiramisu.png?t=2023-07-31T05%3A21%3A53.946Z",
      16.0,
      "Biscoitos champanhe embebidos em café, alternados com creme com queijo mascarpone"),


  MenuItem(
      "Tiramisu1",
      "https://yyejvqdyfvplnjygzgwv.supabase.co/storage/v1/object/public/images/tiramisu.png?t=2023-07-31T05%3A21%3A53.946Z",
      16.0,
      "Biscoitos champanhe embebidos em café, alternados com creme com queijo mascarpone"),
  MenuItem(
      "Tiramisu2",
      "https://yyejvqdyfvplnjygzgwv.supabase.co/storage/v1/object/public/images/tiramisu.png?t=2023-07-31T05%3A21%3A53.946Z",
      16.0,
      "Biscoitos champanhe embebidos em café, alternados com creme com queijo mascarpone"),
  MenuItem(
      "Tiramisu3",
      "https://yyejvqdyfvplnjygzgwv.supabase.co/storage/v1/object/public/images/tiramisu.png?t=2023-07-31T05%3A21%3A53.946Z",
      16.0,
      "Biscoitos champanhe embebidos em café, alternados com creme com queijo mascarpone"),
];

var dataMenus = [
  Menu("Menu Principal", [
    MenuSection("Entradas", dataItems.sublist(0, 3)),
    MenuSection("Principal", dataItems.sublist(3, 5)),
    MenuSection("Bebidas", dataItems.sublist(5, 7)),
    MenuSection("Sobremesas", dataItems.sublist(7, 9)),
  ])
];
var dataRestaurants = [Restaurant("Bar do Zé", dataMenus, "Rua Galvão Bueno, 123")];
