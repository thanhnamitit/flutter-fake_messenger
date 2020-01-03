import 'package:conversation_maker/core/helper/UIHelpers.dart';
import 'package:conversation_maker/di/provider/view_model_provider.dart';
import 'package:conversation_maker/domain/entity/story.dart';
import 'package:conversation_maker/page/story/setup/setup_story_view_model.dart';
import 'package:conversation_maker/resource/R.dart';
import 'package:conversation_maker/widget/dialog/text_input_dialog.dart';
import 'package:conversation_maker/widget/item/story/story_item.dart';
import 'package:conversation_maker/widget/story_preview_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class SetupStoryPage extends StatefulWidget {
  final Story story;

  SetupStoryPage(this.story);

  @override
  _SetupStoryPageState createState() => _SetupStoryPageState();
}

class _SetupStoryPageState extends State<SetupStoryPage> {
  Widget _buildAppBar() {
    return AppBar(
      iconTheme: IconThemeData.fallback(),
      backgroundColor: Colors.white,
      title: Text(
        "Story",
        style: R.style.textInAppBar,
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return Consumer<SetupStoryViewModel>(
      builder: (_, viewModel, __) {
        return Visibility(
          visible: viewModel.story.images.isNotEmpty,
          child: FloatingActionButton(
            child: Icon(Icons.done),
            onPressed: () {
              _save(viewModel);
            },
          ),
        );
      },
    );
  }

  Widget _buildPreviewWidget(SetupStoryViewModel viewModel) {
    return Card(
      elevation: 4,
      child: Padding(
        padding:
            const EdgeInsets.only(bottom: 24, left: 18, top: 12, right: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              "Preview",
              style: R.style.textLabelSetupStory,
            ),
            verticalSpaceHuge,
            StoryItem(viewModel.story),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigWidget(SetupStoryViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Card(
            elevation: 4,
            color: Colors.white,
            child: InkWell(
              onTap: () {
                _editName(viewModel);
              },
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 18,
                  top: 12,
                  right: 18,
                  bottom: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Name:",
                      style: R.style.textLabelSetupStory,
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          viewModel.story.name,
                          maxLines: 1,
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        verticalSpaceLarge,
        Expanded(
          flex: 1,
          child: Card(
            elevation: 4,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Seen:",
                    style: R.style.textLabelSetupStory,
                  ),
                  Switch(
                    onChanged: viewModel.updateSeen,
                    value: viewModel.story.seen,
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImages(SetupStoryViewModel viewModel) {
    return Card(
      elevation: 4,
      child: Padding(
        padding:
            const EdgeInsets.only(bottom: 24, left: 18, top: 12, right: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Photos:",
              style: R.style.textLabelSetupStory,
            ),
            verticalSpaceHuge,
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: viewModel.story.images
                    .map(
                      (it) => Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: StoryPreviewImage(
                          storyImage: it,
                          delete: () {
                            viewModel.delete(it);
                          },
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Consumer<SetupStoryViewModel>(
      builder: (_, viewModel, __) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                verticalSpaceHuge,
                IntrinsicHeight(
                  child: Row(
                    children: <Widget>[
                      Expanded(child: _buildPreviewWidget(viewModel)),
                      horizontalSpaceLarge,
                      Expanded(child: _buildConfigWidget(viewModel)),
                    ],
                  ),
                ),
                _buildImages(viewModel),
              ],
            ),
          ),
        );
      },
    );
  }

  Future _editName(SetupStoryViewModel viewModel) async {
    var newName = await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => TextInputDialog(
        viewModel.story.name,
        "Enter new name",
        R.color.defaultConversationColor.value,
      ),
    );
    if (newName != null) {
      viewModel.updateName(newName);
    }
  }

  void _save(SetupStoryViewModel viewModel) {}

  @override
  Widget build(BuildContext context) {
    final viewModel =
        ViewModelProvider.of(context).setupStoryViewModel(widget.story);
    return ChangeNotifierProvider(
      builder: (_) => viewModel,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
        backgroundColor: Colors.white,
        floatingActionButton: _buildFloatingActionButton(),
      ),
    );
  }
}
