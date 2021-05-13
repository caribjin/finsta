import 'dart:io';

import 'package:finsta/helpers/image_helper.dart';
import 'package:finsta/screens/create_post/cubit/create_post_cubit.dart';
import 'package:finsta/widgets/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';

class CreatePostScreen extends StatelessWidget {
  static const String routeName = '/createPost';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _selectPostImage(BuildContext context) async {
    final pickedFile =
        await ImageHelper.getImageFromGallery(context: context, cropStyle: CropStyle.rectangle, title: 'Create Post');

    if (pickedFile != null) {
      context.read<CreatePostCubit>().postImageChanged(pickedFile);
    }
  }

  void _submitForm(BuildContext context, File? postImage, bool isSubmitting) {
    if (_formKey.currentState != null && _formKey.currentState!.validate() && postImage != null && !isSubmitting) {
      context.read<CreatePostCubit>().submit();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('New Post')),
        body: BlocConsumer<CreatePostCubit, CreatePostState>(
          listener: (context, state) {
            if (state.status == CreatePostStatus.success) {
              if (_formKey.currentState != null) {
                _formKey.currentState!.reset();
              }
              context.read<CreatePostCubit>().reset();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 3),
                  content: Text('Post Created'),
                ),
              );
            }
            if (state.status == CreatePostStatus.error) {
              showDialog(context: context, builder: (context) => ErrorDialog(content: state.error.message ?? ''));
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => _selectPostImage(context),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 2,
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: state.postImage != null
                          ? Image.file(
                              state.postImage!,
                              fit: BoxFit.cover,
                            )
                          : Icon(
                              Icons.image,
                              size: 120,
                              color: Colors.grey,
                            ),
                    ),
                  ),
                  if (state.status == CreatePostStatus.submitting) const LinearProgressIndicator(),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(hintText: 'Caption'),
                            onChanged: (value) => context.read<CreatePostCubit>().captionChanged(value),
                            validator: (value) =>
                                (value == null || value.trim().isEmpty) ? 'Caption cannot be empty.' : null,
                          ),
                          const SizedBox(height: 28),
                          ElevatedButton(
                            child: Text('Post'),
                            onPressed: () => _submitForm(
                              context,
                              state.postImage,
                              state.status == CreatePostStatus.submitting,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
