import 'dart:convert';
import 'package:api_practice/Models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  Future<List<PostModel>> getApi() async {
    final response = await http.get(Uri.parse('https://fakestoreapi.com/products'));
    print('Status Code: ${response.statusCode}');
    print('Response: ${response.body}');

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => PostModel.fromJson(e as Map<String, dynamic>)).toList();
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        title: const Text(
          'Api Practice',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<PostModel>>(
                future: getApi(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    var posts = snapshot.data!;
                    return ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(posts[index].title),
                          subtitle: Text("Price: \$${posts[index].price} | Rating: ${posts[index].rating}"),
                          leading: Image.network(
                            posts[index].image,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        );

                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
