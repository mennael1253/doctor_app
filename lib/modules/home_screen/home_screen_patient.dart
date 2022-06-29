import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctorapp/modeles/patient_user_model.dart';
import 'package:doctorapp/modeles/post_model/post_model.dart';
import 'package:doctorapp/shared/constant/constant.dart';
import 'package:doctorapp/shared/cubit/app_cubit/app%20cubit.dart';
import 'package:doctorapp/shared/cubit/patient_cubit/patient_cubit.dart';
import 'package:doctorapp/shared/cubit/patient_cubit/patient_states.dart';
import 'package:doctorapp/shared/styles/colors/color.dart';
import 'package:doctorapp/shared/styles/styles/icon_broken.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

var commentController = TextEditingController();

class HomeScreenPatient extends StatelessWidget {
  const HomeScreenPatient({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PatientCubit, PatientStates>(
        builder: (context, state) {
          var patModel = PatientCubit
              .get(context)
              .patientUserModel;
          var PostsModel = PatientCubit
              .get(context)
              .getPosts;
          CollectionReference postRef =
          FirebaseFirestore.instance.collection('post');
          // var PostId = PatientCubit
          //     .get(context)
          //     .postId;
          // var PostCommentId = PatientCubit
          //     .get(context)
          //     .postCommentId;
          return Scaffold(
            body: patModel==null ?Center(child: CircularProgressIndicator(),):SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(children: [
                  //this widget belong to the first card in the page
                  Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      const Card(
                        child: Image(
                          image: NetworkImage(
                              'https://img.freepik.com/free-vector/mobile-doctor-concept_46706-883.jpg?size=626&ext=jpg'),
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                        elevation: 5,
                        margin: EdgeInsets.all(8),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          'Community Healthcare Express Visit App  ',
                          style: Theme
                              .of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                  //________________________________________

                  Conditional.single(
                      fallbackBuilder: (BuildContext context) =>
                       Center(
                        child:

                        Row(

                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('No posts yet '),
                            SizedBox(width: 5,),
                            Icon(Icons.sentiment_dissatisfied
)
                          ],
                        ),
                      ),
                      context: context,
                      conditionBuilder: (BuildContext context) =>
                      PostsModel.isNotEmpty,
                      widgetBuilder: (BuildContext context) {
                        return SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            children: [

                              StreamBuilder(
                                  stream: postRef.snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    if (snapshot.hasData) {
                                      return ListView.separated(
                                        physics:
                                        NeverScrollableScrollPhysics(),
                                        itemCount:
                                        snapshot.data.docs.length,
                                        shrinkWrap: true,
                                        itemBuilder: (BuildContext context,
                                            int index) {
                                          return   snapshot.data.docs.isNotEmpty
                                              ? pageBuilder(
                                            // formKey:
                                            //     formKeyList[index],
                                              model: patModel,
                                              dateTime: snapshot
                                                  .data.docs[index]
                                                  .data()['dateTime'],
                                              context: context,
                                              // postID: PostId[index],
                                              index: index,
                                              // postCommentID:
                                              //     PostCommentId[index],
                                              name: snapshot
                                                  .data.docs[index]
                                                  .data()['name'],
                                              postImage: snapshot
                                                  .data.docs[index]
                                                  .data()['postImage'],
                                              postText: snapshot
                                                  .data.docs[index]
                                                  .data()['postText'],
                                              userImage: snapshot
                                                  .data.docs[index]
                                                  .data()['userImage'])
                                              : SizedBox.shrink();
                                        },
                                        separatorBuilder:
                                            (BuildContext context,
                                            int index) =>
                                            Container(
                                              width: double.infinity,
                                              child: SizedBox(
                                                height: 5,
                                              ),
                                            ),
                                      );
                                    } else if (snapshot.hasError) {
                                      return Icon(Icons.error_outline);
                                    } else {
                                      return CircularProgressIndicator();
                                    }
                                  })
                                ],
                          ),
                        );
                      })
                ])),
          );
        },
        listener: (context, state) {});
  }
}

// widget of page builder

Widget pageBuilder({required context,
  required PatientUserModel model,
  required dateTime,
  //required PostModel postModel,
  //required String postID,
  required index,
  required name
  ,
  required postImage,
  required userImage,
  required postText,

  //required String postCommentID
}) =>
    Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(horizontal: 8),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5,),
            Row(
              children: [
                //widget of circle picture
                CircleAvatar(
                  radius: 27,
                  backgroundColor: defaultColor,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      // 'https://img.freepik.com/free-photo/man-tries-be-speechless-cons-mouth-with-hands-checks-out-big-new-wears-round-spectacles-jumper-poses-brown-witnesses-disaster-frightened-make-sound_273609-56296.jpg?size=626&ext=jpg'
                        userImage!
                    ),


                    radius: 25,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        //row of name
                        Row(
                          children: [
                            Text(
                             name,
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(height: 1.4),
                            ),
                            SizedBox(
                              width: 5,
                            ),

                          ],
                        ),

                        Text(
                         dateTime,
                          style: Theme
                              .of(context)
                              .textTheme
                              .caption!
                              .copyWith(height: 1.4),
                        ),

                        SizedBox(
                          height: 10,
                        ),
                      ],
                    )),

              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                // 'orem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.'
               postText,
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(height: 1.2),
              ),
            ),


            //containe of image in post
            if (postImage.isNotEmpty)
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(image: NetworkImage(
                      //'https://img.freepik.com/free-photo/embarrassed-shocked-european-man-points-index-finger-copy-space-recommends-service-shows-new-product-keeps-mouth-widely-opened-from-surprisement_273609-38455.jpg?w=740'
                      //
                       postImage), fit: BoxFit.cover)),
              ),
            SizedBox(
              height: 10,
            ),

            //divider
            Container(
              width: double.infinity,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Container(
                  height: 20,
                  child: InkWell(
                    onTap: () {
                      PatientCubit.get(context).updatePostLikes(
                          PatientCubit.get(context).postsList[index]);
                    },
                    child: Row(
                      children: [
                        Icon(
                          PatientCubit.get(context)
                              .postsList[index]
                              .values
                              .single
                              .likes!
                              .any((element) =>
                          element ==
                              FirebaseAuth.instance.currentUser?.uid)
                              ? Icons.thumb_up
                              : Icons.thumb_up_outlined,
                          size: 20.0,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          '${PatientCubit.get(context).postsList[index].values.single.likes?.length} likes',
                          style: Theme.of(context).textTheme.caption,
                        )
                      ],
                    ),
                  ),
                ),

              ],
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
