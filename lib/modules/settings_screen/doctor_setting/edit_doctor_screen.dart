import 'package:doctorapp/modules/settings_screen/doctor_setting/setting_screen_doctor.dart';
import 'package:doctorapp/modules/sign_up_screen/doctorregister.dart';
import 'package:doctorapp/shared/components/componants.dart';
import 'package:doctorapp/shared/constant/constant.dart';
import 'package:doctorapp/shared/cubit/doctor_cubit/doctor_cubit.dart';
import 'package:doctorapp/shared/cubit/doctor_cubit/doctor_states.dart';
import 'package:doctorapp/shared/styles/colors/color.dart';
import 'package:doctorapp/shared/styles/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
var nameController = TextEditingController();
var bioController = TextEditingController();
var phoneController = TextEditingController();
var clinicControllet = TextEditingController();
class EditProfileScreenDoctor extends StatelessWidget {
  const EditProfileScreenDoctor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DoctorCubit,DoctorStates>(
      listener: (context, state) {
        if(state is GetDoctorDataSuccessState){backTo(context: context, widget: const SettingScreenDoctor());}
      },
      builder: (context, state) {
        // instance of model
        var model = DoctorCubit.get(context).doctorUserModel;
        var cubit = DoctorCubit.get(context);
        var coverImage = DoctorCubit.get(context).coverImage;

        var profileImage = DoctorCubit.get(context).profileImage;
        nameController.text = model!.userName!;
        bioController.text = model.bio!;
        phoneController.text = model.phone!;
        clinicControllet.text = model.clinicLocation!;

        return Scaffold(
          appBar:
          defaultAppBar(context: context, title: "Edit Profile", actions: [
            TextButton(
              onPressed: () {
                cubit.updateProfile(
                    phone: phoneController.text,
                    bio: bioController.text,
                    name: nameController.text, clinicLoc: clinicControllet.text,);
              },
              child: Text(
                'Update',
                style: TextStyle(fontSize: 16),
              ),
            )
          ]),
          body: model != null
              ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    if (state is GetDoctorDataLoadingState)
                      LinearProgressIndicator(),
                    SizedBox(
                      height: 10,
                    ),

                    //container of cover and photo With align
                    SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          //add align to make the cover in the up
                          Align(
                            alignment: AlignmentDirectional.topCenter,
                            child: Stack(
                              alignment: AlignmentDirectional.topEnd,
                              children: [
                                //container of cover
                                Container(
                                  height: 160,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(5),
                                          topRight: Radius.circular(5)),
                                      image: DecorationImage(
                                        // image: NetworkImage(
                                        //     'https://img.freepik.com/free-vector/abstract-colorful-hand-painted-wallpaper_52683-61599.jpg?w=740') ,
                                          image: coverImage == null
                                              ? NetworkImage('${model.cover}')
                                              : FileImage(coverImage)
                                          as ImageProvider,
                                          fit: BoxFit.cover)),
                                ),
                                //widget of edit cover
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {
                                      //get cover method
                                      cubit.getCoverImage();
                                    },
                                    child: CircleAvatar(
                                        radius: 25,
                                        backgroundColor:
                                        defaultColor.withOpacity(.7),
                                        child: Icon(
                                          IconBroken.Camera,
                                          size: 23,
                                          color: Colors.black,
                                        )),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              CircleAvatar(
                                radius: 55,
                                backgroundColor: defaultColor,
                                child: CircleAvatar(
                                  // backgroundImage: NetworkImage(
                                  // 'https://img.freepik.com/free-vector/young-black-girl-avatar_53876-115570.jpg?t=st=1649212806~exp=1649213406~hmac=d4ea9c436ce796f91dae079d8d93dbbd790ef49606427bb1dd387cd7134cebd2&w=740'),
//check in image
                                  backgroundImage: profileImage == null
                                      ? NetworkImage('${model.image}')
                                      : FileImage(profileImage)
                                  as ImageProvider,
                                  radius: 52,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  //get profile image  method

                                  cubit.getProfileImage();
                                },
                                child: CircleAvatar(
                                    radius: 23,
                                    backgroundColor:
                                    defaultColor.withOpacity(.7),
                                    child: Icon(
                                      IconBroken.Camera,
                                      size: 22,
                                      color: Colors.black,
                                    )),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
//row of updating images
                    if (cubit.coverImage != null ||
                        cubit.profileImage != null)
                      Row(
                        children: [
                          if (cubit.profileImage != null)
                            Expanded(
                                child: Column(
                                  children: [
                                    textButton(
                                        text: 'Update profile image',
                                        fun: () {
                                          cubit.updateProfileImage(
                                              phone: phoneController.text,
                                              bio: bioController.text,
                                              name: nameController.text, clinicLoc: clinicControllet.text);
                                        }),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    if (state is UpdateProfileDoctorImageLoadingState)
                                      LinearProgressIndicator(),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                )),
                          SizedBox(
                            width: 5,
                          ),
                          if (cubit.coverImage != null)
                            Expanded(
                                child: Column(
                                  children: [
                                    textButton(
                                        text: 'Update cover image',
                                        fun: () {
                                          cubit.updateCoverImage(
                                              phone: phoneController.text,
                                              bio: bioController.text,
                                              name: nameController.text,  clinicLoc: clinicControllet.text);
                                        }),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    if (state is UpdateCoverDoctorImageLoadingState)
                                      LinearProgressIndicator(),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                )),

                        ],
                      ),
                    SizedBox(
                      height: 15,
                    ),
                    //defaultFormField
                    defaultFormField(
                        textKeyboard: TextInputType.name,
                        prefix: IconBroken.User,
                        validate: (value) {},
                        textLabel: 'Name',
                        controller: nameController),
                    SizedBox(
                      height: 5,
                    ),
                    defaultFormField(
                        textKeyboard: TextInputType.text,
                        prefix: IconBroken.Info_Circle,
                        validate: (value) {},
                        textLabel: 'Bio',
                        controller: bioController),
                    SizedBox(
                      height: 5,
                    ),
                    defaultFormField(
                        textKeyboard: TextInputType.number,
                        prefix: IconBroken.Call,
                        validate: (value) {},
                        textLabel: 'Phone',
                        controller: phoneController) ,
                    //ocation
                    defaultFormField(
                        textKeyboard: TextInputType.text,
                        prefix:       Icons.person_pin_circle,
                        validate: (value) {},
                        textLabel: 'Clinic Location',
                        controller: clinicControllet) ,



                  ],
                ),
              ))
              : Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
