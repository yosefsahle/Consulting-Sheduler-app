import 'package:flutter/material.dart';
import 'package:my_assignment/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostCard extends StatefulWidget {
  const PostCard({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.id,
    required this.profile,
    required this.name,
    required this.date,
    required this.posterId,
    required this.onDelet,
  });

  final String image;
  final String title;
  final String description;
  final int id;
  final String profile;
  final String name;
  final String date;
  final int posterId;
  final Function onDelet;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late String userId;
  late String userRole;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('user_id') ?? '0';
      userRole = prefs.getString('user_role') ?? 'User';
      _isLoading = false;
    });
  }

  bool isSuper(String role) {
    if (role == 'Super Admin') {
      return true;
    } else {
      return false;
    }
  }

  bool isPoster(int posterId, int userId) {
    if (posterId == userId) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screensize = MediaQuery.of(context).size;
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            padding: const EdgeInsets.all(5),
            width: screensize.width * 0.98,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: AppColors.secondary),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    CircleAvatar(
                      foregroundImage: NetworkImage(
                          'https://yosefsahle.gospelinacts.org/api/registeruser/${widget.profile}'),
                      radius: 25,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        Text(
                          widget.name,
                          style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 19,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.date,
                          style: TextStyle(color: AppColors.grey),
                        )
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Image.network(
                    'https://yosefsahle.gospelinacts.org/api/createpost/${widget.image}'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Visibility(
                        visible: isSuper(userRole),
                        child: IconButton(
                            onPressed: () {
                              widget.onDelet();
                            },
                            icon: Icon(
                              Icons.delete_forever_rounded,
                              color: AppColors.primary,
                            )))
                  ],
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: screensize.width * 0.8,
                    height: 1,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  widget.title,
                  style: const TextStyle(fontSize: 20),
                ),
                Text(widget.description),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          );
  }
}
