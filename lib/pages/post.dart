import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:my_assignment/model/postModel.dart';
import 'package:my_assignment/services/postService.dart';
import 'package:my_assignment/widgets/post/postcard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Post extends StatefulWidget {
  const Post({super.key});

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  late Future<List<PostModel>> futurePosts;
  late String userRole;
  late String userId;

  Future<void> _deletePost(int postId) async {
    try {
      await PostService().deletpost(postId: postId);
      setState(() {
        futurePosts = PostService().fetchPosts(); // Refresh the list of posts
      });
    } catch (e) {
      print('Failed to delete post: $e');
      // Optionally, show a snackbar or dialog to notify the user
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserName();
    futurePosts = PostService().fetchPosts();
  }

  _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getString('user_role') ?? 'User';
      userId = prefs.getString('user_id') ?? '0';
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PostModel>>(
      future: futurePosts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No posts available'));
        } else {
          List<PostModel> posts = snapshot.data!;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              PostModel post = posts[index];
              return Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  PostCard(
                    profile: post.profile,
                    name: post.name,
                    date: post.date,
                    image: post.postImage,
                    title: post.title,
                    description: post.description,
                    id: int.parse(post.id),
                    posterId: int.parse(post.posterid),
                    onDelet: () {
                      print(post.id);
                      _deletePost(int.parse(post.id));
                    },
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }
}
