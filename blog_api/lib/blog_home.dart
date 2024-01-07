import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Blog extends StatelessWidget {
  const Blog({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Blog App',
      home: BlogHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class BlogHome extends StatefulWidget {
  const BlogHome({super.key});

  @override
  State<BlogHome> createState() => _BlogHomeState();
}

class _BlogHomeState extends State<BlogHome> {
  List<dynamic> api_data =
      []; // creating a dynamic list to store the data from api

  Future<void> fetchingApi() async {
    String url =
        'https://api.slingacademy.com/v1/sample-data/blog-posts'; //api url
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      var blogs = jsonData['blogs'];
      setState(() {
        api_data = List.from(blogs);
      });
      // print(api_data);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchingApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Blogs',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: ListView.builder(
        itemCount: api_data.length,
        itemBuilder: (context, index) {
          final blogs = api_data[index];
          return Padding(
            padding: const EdgeInsets.all(13.0),
            child: InkWell(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(blogs['photo_url']),   // displaying blog images
                  Column( 
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        blogs['title'],               // displaying blog title
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        blogs['description'],          // displaying blog description
                        style: Theme.of(context).textTheme.titleSmall,
                      )
                    ],
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BlogPage(
                              blog_data: api_data,    // passing blog object
                              selectedBlog: index,    // passing the selected blog's index
                            )));
              },
            ),
          );
        },
      ),
    );
  }
}

class BlogPage extends StatefulWidget {
  List<dynamic> blog_data;
  int selectedBlog;
  BlogPage({Key? key, required this.blog_data, required this.selectedBlog})
      : super(key: key);

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  Widget build(BuildContext context) {
    final blog = widget.blog_data[widget.selectedBlog];
    return Scaffold(
      appBar: AppBar(
        title: Text(blog['title']),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              blog['photo_url'],
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(13.0),
              child: Text(
                blog['content_text'],
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.black, fontWeight: FontWeight.w500),
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
