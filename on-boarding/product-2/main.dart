import 'dart:io';

class Product{
  String name;
  String description;
  double price;
  int id;

  Product(this.name, this.description, this.price, this.id);

  @override
  String toString(){
    return 'ID: $id, Name: $name, Description: $description, Price:\$${price.toStringAsFixed(2)}';
  }
}

class ProductManager{
  List<Product> _product = [];
  int _next = 1;

  void addProduct(String name, String description, double price){
    var newProduct = Product(name, description, price, _next++);
    _product.add(newProduct);
    print('Product Added Successfully');
  }

  void viewAllProducts(){
    for (var product in _product){
      print(product);
    }
  }

  void viewOneProducts(int id){
    for(var product in _product){
      if (product.id == id){
        print(product);
        break;
      }
    }
  }

  bool UpdateProduct( int id, {String? name, String? description, double? price}){
    Product? editProduct;
    for(var product in _product){
      if(product.id == id){
        editProduct = product;
        print("Updated Successflly");
        break;
      }
    }
    if (editProduct == null) {
      print('Product with ID $id not found. Cannot edit.');
      return false;
    }

    if (name != null && name.isNotEmpty) {
      editProduct.name = name;
    }
    if (description != null && description.isNotEmpty) {
      editProduct.description = description;
    }
    if (price != null) {
      editProduct.price = price;
    }

    print('Product ID $id updated successfully.');
    return true;
  }

  void DeleteProduct(int id){
    var initialLength = _product.length;
    _product.removeWhere((product) => product.id == id);

    if (_product.length < initialLength) {
      print('Product deleted successfully.');
    } else {
      print('Product not found. Cannot delete.');
    }
  }
}

  void main(){
    bool running = true;
     var productManager = ProductManager();
    while (running){
      print('Welcome to the ecommerce site.');
      print('What would you like to do?');
      print('1. Add a New Product');
      print('2. Show All Products');
      print('3. Look Up a Single Product by ID');
      print('4. Change Product Details');
      print('5. Remove a Product');
      print('6. Exit the Shop');
      stdout.write("Enter your choice: ");

      var input = stdin.readLineSync();

      switch (input){
        case '1':
        stdout.write("Enter Product Name: ");
        var name = stdin.readLineSync()?? '';
        stdout.write("Enter Product Description: ");
        var description = stdin.readLineSync()?? '';
        stdout.write("Enter Product price: ");
        var price = double.parse(stdin.readLineSync()!);
        productManager.addProduct(name, description, price);
        break;

        case '2':
        productManager.viewAllProducts();
        break;

        case '3':
        stdout.write('Enter id of the product you want to see: ');
        var id = int.tryParse(stdin.readLineSync()??'');

        if (id != null){
          productManager.viewOneProducts(id);
        }
        else{
          print('Invalid ID');
        }
        break;
        
        case '4':
        stdout.write('Enter ID: ');
        var id = int.tryParse(stdin.readLineSync()??'');
        if (id != null){
          stdout.write('Enter new name: ');
          var newName = stdin.readLineSync();
          stdout.write('Enter new name: ');
          var newDescription = stdin.readLineSync();
          stdout.write('Enter new name: ');
          var newPrice = double.parse(stdin.readLineSync()??'');  

          productManager.UpdateProduct(name: newName, description: newDescription, price: newPrice, id);       
        }

        case '5':
        stdout.write('Enter the ID of the product you want to DELETE: ');
        var idInput = stdin.readLineSync();
        var id = int.tryParse(idInput ?? '');
        if (id != null) {
          productManager.DeleteProduct(id);
        } else {
          print('Please enter a valid number for the Product ID.');
        }
        break;

      case '6':
        running = false; 
        print('Thank you for using our site!');
        break;

      default: 
        print('Oops! That was not a valid choice. Please choose a number from 1 to 6.');
      }
    }
  }
