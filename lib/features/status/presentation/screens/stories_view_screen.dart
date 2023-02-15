import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';
import 'package:whatsapp_clone/features/status/data/model/status_model.dart';

class StoriesViewScreen extends StatelessWidget {
  const StoriesViewScreen({super.key, required this.statusModel});
  static const routeName = '/storeies-view-screen';
  final StatusModel statusModel;

  @override
  Widget build(BuildContext context) {
    StoryController storyController = StoryController();

    return Scaffold(
      body: StoryView(
          onVerticalSwipeComplete: (direction) {
            if (direction == Direction.down) {
              Navigator.pop(context);
            }
          },
          storyItems: statusModel.photoUrl
              .map((e) => StoryItem.pageImage(
                    url: e,
                    controller: storyController,
                  ))
              .toList(),
          controller: storyController),
    );
  }
}
