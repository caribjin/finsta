import 'dart:io';

import 'package:finsta/models/models.dart';
import 'package:finsta/repositories/repositories.dart';
import 'package:finsta/screens/edit_profile/cubit/edit_profile_cubit.dart';
import 'package:finsta/screens/profile/bloc/profile_bloc.dart';
import 'package:finsta/widgets/error_dialog.dart';
import 'package:finsta/widgets/user_profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finsta/helpers/helpers.dart';
import 'package:image_cropper/image_cropper.dart';

class EditProfileScreenArgs {
  final BuildContext context;

  const EditProfileScreenArgs({required this.context});
}

class EditProfileScreen extends StatelessWidget {
  static const routeName = 'edit-profile';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final User user;

  EditProfileScreen({
    required this.user,
  });

  static Route route({required EditProfileScreenArgs args}) {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) => BlocProvider<EditProfileCubit>(
        create: (_) => EditProfileCubit(
          userRepository: context.read<UserRepository>(),
          storageRepository: context.read<StorageRepository>(),
          profileBloc: args.context.read<ProfileBloc>(),
        ),
        child: EditProfileScreen(
          user: args.context.read<ProfileBloc>().state.user,
        ),
      ),
    );
  }

  void _selectProfileImage(BuildContext context) async {
    final pickedFile = await ImageHelper.getImageFromGallery(context: context, cropStyle: CropStyle.circle, title: 'Profile Image');

    if (pickedFile != null) {
      context.read<EditProfileCubit>().profileImageChanged(File(pickedFile.path));
    }
  }

  void _submitForm(BuildContext context, bool isSubmitting) {
    if (!_formKey.currentState!.validate() || isSubmitting) return;

    context.read<EditProfileCubit>().submit();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: Text('Edit Profile')),
        body: BlocConsumer<EditProfileCubit, EditProfileState>(
          listener: (context, state) {
            if (state.status == EditProfileStatus.success) {
              Navigator.of(context).pop();
            } else if (state.status == EditProfileStatus.error) {
              showDialog(
                context: context,
                builder: (context) => ErrorDialog(content: state.failure.message ?? ''),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  if (state.status == EditProfileStatus.submitting) LinearProgressIndicator(),
                  const SizedBox(height: 32),
                  GestureDetector(
                    onTap: () => _selectProfileImage(context),
                    child: UserProfileImage(
                      radius: 80,
                      profileImageUrl: user.profileImageUrl,
                      profileImage: state.profileImage,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            initialValue: user.username,
                            decoration: InputDecoration(hintText: 'Username'),
                            validator: (value) => value!.trim().isEmpty ? 'Username cannot be empty' : null,
                            onChanged: (value) => context.read<EditProfileCubit>().usernameChanged(value.trim()),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            initialValue: user.bio,
                            decoration: InputDecoration(hintText: 'Bio'),
                            minLines: 3,
                            maxLines: 10,
                            onChanged: (value) => context.read<EditProfileCubit>().bioChanged(value.trim()),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            child: const Text('Update'),
                            onPressed: () => _submitForm(context, state.status == EditProfileStatus.submitting),
                          ),
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
