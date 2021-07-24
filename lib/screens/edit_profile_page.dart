import 'dart:async';
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'dart:io';

import 'package:test_app/screens/home_page.dart';
import 'package:test_app/screens/view_profile.dart';
import 'package:test_app/size_config.dart';
import 'package:test_app/userSimplePreferences.dart';

import '../api.dart';
import '../background.dart';
import '../check_connectivity.dart';

class EditProfilePage extends StatefulWidget {

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  StreamSubscription internetSubscription;
  bool hasInternet = false;
  String userName;
  String firstName;
  String lastName;
  String address;

  File _imageFile;
  final ImagePicker _picker = ImagePicker();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();

    internetSubscription = InternetConnectionChecker().onStatusChange.listen((event){
      final hasInternet = event == InternetConnectionStatus.connected;
      print(hasInternet);
      if(!hasInternet){
        CheckConnectivity().showConnectivityBottomSheet(context);
      }

      setState(() {
        this.hasInternet = hasInternet;
      });
    });

    userNameController.text = UserSimplePreferences.getUserName() ?? '';
    firstNameController.text = UserSimplePreferences.getFirstName() ?? '';
    lastNameController.text = UserSimplePreferences.getLastName() ?? '';
    addressController.text = UserSimplePreferences.getAddress() ?? '';

    if(UserSimplePreferences.getProfilePicture() != null){
      _imageFile = File(UserSimplePreferences.getProfilePicture());
    }

  }

  @override
  void dispose() {
    print('disposeUpdate');
    internetSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isKeyBoard = MediaQuery.of(context).viewInsets.bottom != 0;
    SizedConfig().init(context);
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: Color(0xff232323),
        body: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            if(MediaQuery.of(context).size.width < 650 && Orientation.portrait == MediaQuery.of(context).orientation) Background().backgroundSmall(),
            if(650 <= MediaQuery.of(context).size.width && MediaQuery.of(context).size.width < 1100 && Orientation.portrait == MediaQuery.of(context).orientation) Background().backgroundLarge(),
            if(1000 < MediaQuery.of(context).size.width && Orientation.landscape == MediaQuery.of(context).orientation) Background().backgroundUltraLarge(),
            AppBar(
              title: Text("Profile", style: TextStyle(fontSize: 3.5*SizedConfig.heightMultiplier)),
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_sharp,
                  color: Colors.grey[300],
                  size: 3.5*SizedConfig.heightMultiplier,
                ),
                onPressed: (){
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context){
                            return HomePage();
                          }
                      )
                  );
                },
               )
            ),

            //BigContainer
            Positioned(
              top:11.5*SizedConfig.heightMultiplier,
              bottom: 10.5*SizedConfig.heightMultiplier,
              right: 6*SizedConfig.widthMultiplier,
              left: 6*SizedConfig.widthMultiplier,
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: [
                      if(!isKeyBoard)imageProfile(context),
                      Form(
                        key: _formKey,
                        child: Container(
                            child:Column(
                              children: [
                                textFormFields("Username",FontAwesomeIcons.userAlt,setUsername,userNameController),
                                textFormFields("First Name",FontAwesomeIcons.addressBook,setFirstName,firstNameController),
                                textFormFields("Last Name",FontAwesomeIcons.solidAddressBook,setLastName,lastNameController),
                                textFormFields("Address",FontAwesomeIcons.addressCard,setAddress,addressController),
                              ],
                            )
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ),

            //UpdateButton
            Positioned(
              bottom:1.5*SizedConfig.heightMultiplier,
              right: 6*SizedConfig.widthMultiplier,
              left: 6*SizedConfig.widthMultiplier,
              child: InkWell(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 1.5*SizedConfig.heightMultiplier),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1.5*SizedConfig.heightMultiplier),
                      color: Color(0xff336BFF)
                  ),
                  child:Center(
                    child: Text(
                      "Update",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 4*SizedConfig.heightMultiplier,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                  ),
                ),
                onTap: () async{
                  if(_formKey.currentState.validate()) {
                    _formKey.currentState.save();

                    await UserSimplePreferences.setUserName(this.userName);
                    await UserSimplePreferences.setFirstName(this.firstName);
                    await UserSimplePreferences.setLastName(this.lastName);
                    await UserSimplePreferences.setAddress(this.address);

                    /*if(_imageFile != null){
                      await UserSimplePreferences.setProfilePicture(_imageFile.path);
                    }*/

                    viewProfileState.setState(() {
                      viewProfileState.resetVariables(this.userName, this.firstName, this.lastName, this.address,this._imageFile);
                    });

                    //print(_imageFile.path);
                    homePageState.setName(this.firstName);

                    updateProfile();
                  }
                },
              ),
            )
          ]
        ),
      ),
    );
  }

  Future<void> updateProfile() async{
    var data = {
      'username': this.userName,
      'first_name': this.firstName,
      'last_name': this.lastName,
      'address': this.address
    };

    int id = UserSimplePreferences.getId();
    var res = await NetworkRequest().postRequest(data,'/api/v1/profile/$id');
    var body = jsonDecode(res.body);
    if(body['status']){
      showModalBottomSheet(
        context: context,
        builder: (builder) => bottomSuccessSheet(context),
      );
    }else{
      showModalBottomSheet(
        context: context,
        builder: (builder) => bottomFailSheet(context),
      );
    }
  }
  void setUsername(String text){
    this.userName = text;
  }
  void setFirstName(String text){
    this.firstName = text;
  }
  void setLastName(String text){
    this.lastName = text;
  }
  void setAddress(String text){
    this.address = text;
  }

  Widget imageProfile(BuildContext context){
    return Center(
      child: Stack(
        children: [
          hasInternet
            ? CircleAvatar(
              backgroundColor: Colors.black12,
              radius: 11.5*SizedConfig.heightMultiplier,
            /*backgroundImage: _imageFile == null
                            ? AssetImage("assets/images/profile_image.jpg")
                            : FileImage(_imageFile),*/
              backgroundImage: AssetImage("assets/images/profile_image.jpg")
              )
            : CircleAvatar(
                backgroundColor: Colors.black12,
                child: CircularProgressIndicator(),
                radius: 11.5*SizedConfig.heightMultiplier,
              ),
          /*Positioned(
            bottom:SizedConfig.heightMultiplier-3.0,
            right: SizedConfig.widthMultiplier/2,
            child: InkWell(
              onTap:(){
                showModalBottomSheet(
                  context: context,
                  builder: ((builder) => bottomSheet(context)),
                );
              },
              child: ClipOval(
                child: Container(
                  color: Colors.grey[600],
                  padding: EdgeInsets.all(1.5*SizedConfig.heightMultiplier),
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 3.5*SizedConfig.heightMultiplier,
                  ),
                ),
              ),
            ),
          )*/
        ],
      ),
    );
  }

  Widget bottomSheet(BuildContext context) {
    return Container(
      color: Colors.black,
      height: 24*SizedConfig.heightMultiplier,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Choose Profile photo",
            style: TextStyle(fontSize: 3.5*SizedConfig.heightMultiplier,color: Colors.white),
          ),
          SizedBox(
            height: 2*SizedConfig.heightMultiplier,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton.icon(
                  onPressed: () {
                    takePhoto(ImageSource.camera);
                  },
                  icon: Icon(Icons.camera,size: 3.8*SizedConfig.heightMultiplier,),
                  label: Text("Camera",style: TextStyle(fontSize:2.5*SizedConfig.heightMultiplier,),)
              ),
              SizedBox(width: 2.5*SizedConfig.widthMultiplier,),
              TextButton.icon(
                  onPressed: () {
                    takePhoto(ImageSource.gallery);
                  },
                  icon: Icon(Icons.image,size: 3.8*SizedConfig.heightMultiplier,),
                  label: Text("Gallery",style: TextStyle(fontSize:2.5*SizedConfig.heightMultiplier,),)
              ),

            ],
          ),
          SizedBox(height: SizedConfig.heightMultiplier/2.0,),
          TextButton.icon(
              onPressed: () {
                setState(() {
                  _imageFile = null;
                });
                Navigator.pop(context);
              },
              icon: Icon(FontAwesomeIcons.trash,size: 3.2*SizedConfig.heightMultiplier,),
              label: Text("Remove photo",style: TextStyle(fontSize:2.5*SizedConfig.heightMultiplier,),)
          ),
        ],
      ),
    );
  }

  Future<void> takePhoto(ImageSource source) async{
    final pickedFile = await _picker.getImage(
        source: source
    );

    if(pickedFile == null) {
      Navigator.pop(context);
      return null;
    }

    final croppedFile = await ImageCropper.cropImage(
      sourcePath: File(pickedFile.path).path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      aspectRatioPresets: [CropAspectRatioPreset.square],
      androidUiSettings: androidUiSettings(),
      iosUiSettings: iosUiSettings()
    );

    if(croppedFile == null){
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }else{
      setState(() {
        _imageFile = croppedFile;
      });
    }

    Navigator.pop(context);
  }

  Widget textFormFields(String hintText,IconData icon,Function function,TextEditingController controller){
    return Container(
      height: 9*SizedConfig.heightMultiplier,
      padding: EdgeInsets.symmetric(horizontal: 4*SizedConfig.widthMultiplier),
      margin: EdgeInsets.symmetric(vertical: 3*SizedConfig.heightMultiplier),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topRight: Radius.circular(1.5*SizedConfig.heightMultiplier),topLeft:Radius.circular(1.5*SizedConfig.heightMultiplier) ),
        color: Colors.grey,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children:[
          Padding(
            padding:EdgeInsets.only(right: 4*SizedConfig.widthMultiplier),
            child: Icon(icon,size: 4*SizedConfig.heightMultiplier,color: Colors.white),
          ),
          Expanded(
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(fontSize: 3.2*SizedConfig.heightMultiplier,color: Colors.white),
                border: InputBorder.none,
                errorStyle: TextStyle(fontSize: 2*SizedConfig.heightMultiplier),
              ),
              style: TextStyle(fontSize: 3.2*SizedConfig.heightMultiplier,color: Colors.white),
              onSaved: function,
              cursorColor: Colors.white,
              validator: (text){
                if(text.isEmpty){
                  return "$hintText cannot be null";
                }else{
                  return null;
                }
              },
            ),
          )
        ]
      ),
    );
  }

  AndroidUiSettings androidUiSettings() => AndroidUiSettings(
    toolbarTitle: 'Crop Image',
    toolbarColor: Colors.red,
    toolbarWidgetColor: Colors.white,
    hideBottomControls: true,
    lockAspectRatio: false
  );

  IOSUiSettings iosUiSettings() => IOSUiSettings(
    rotateButtonsHidden: false,
    rotateClockwiseButtonHidden: false,
    aspectRatioLockEnabled: false
  );

  Widget bottomSuccessSheet(BuildContext context){
    return Container(
      height: 50*SizedConfig.heightMultiplier,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topRight: Radius.circular(3*SizedConfig.heightMultiplier),topLeft: Radius.circular(3*SizedConfig.heightMultiplier)),
          color: Colors.white
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/well_done.png'),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 1.5*SizedConfig.heightMultiplier,bottom: 1.5*SizedConfig.heightMultiplier),
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                AutoSizeText(
                  'Updated Successfully',
                  style: TextStyle(
                      fontSize: 3.8*SizedConfig.heightMultiplier,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                  ),
                  maxLines: 1,
                ),
                SizedBox(height: 1.5*SizedConfig.heightMultiplier,),
                InkWell(
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: 8*SizedConfig.widthMultiplier),
                    padding: EdgeInsets.symmetric(vertical: 1.5*SizedConfig.heightMultiplier),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(SizedConfig.heightMultiplier),
                      color: Color(0xff336BFF),
                    ),
                    child: Text("Okay",style: TextStyle(fontSize: 3*SizedConfig.heightMultiplier,fontWeight: FontWeight.w800,color: Colors.white)),
                  ),
                  onTap: (){
                    Navigator.pop(context);
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomFailSheet(BuildContext context){
    return Container(
      height: 50*SizedConfig.heightMultiplier,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topRight: Radius.circular(3*SizedConfig.heightMultiplier),topLeft: Radius.circular(3*SizedConfig.heightMultiplier)),
          color: Colors.white
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/fail.png'),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 1.5*SizedConfig.heightMultiplier,bottom: 1.5*SizedConfig.heightMultiplier),
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                AutoSizeText(
                  'Failed to update',
                  style: TextStyle(
                      fontSize: 3.8*SizedConfig.heightMultiplier,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                  ),
                  maxLines: 1,
                ),
                AutoSizeText(
                  'Try again',
                  style: TextStyle(
                      fontSize: 3.8*SizedConfig.heightMultiplier,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                  ),
                  maxLines: 1,
                ),
                SizedBox(height: 1.5*SizedConfig.heightMultiplier,),
                InkWell(
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: 8*SizedConfig.widthMultiplier),
                    padding: EdgeInsets.symmetric(vertical: 1.5*SizedConfig.heightMultiplier),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(SizedConfig.heightMultiplier),
                      color: Color(0xff336BFF),
                    ),
                    child: Text("Okay",style: TextStyle(fontSize: 3*SizedConfig.heightMultiplier,fontWeight: FontWeight.w800,color: Colors.white)),
                  ),
                  onTap: (){
                    Navigator.pop(context);
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}





