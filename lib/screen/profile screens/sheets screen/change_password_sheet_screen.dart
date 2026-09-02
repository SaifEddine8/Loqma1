import 'package:flutter/material.dart';
import 'package:loqma/constant/constant_colors.dart';
import 'package:loqma/constant/constant_style.dart';
import 'package:loqma/custom_widget/text_from_field_class.dart';
import 'package:loqma/db/user_db.dart';
import 'package:loqma/models/user_model.dart';
import 'package:loqma/provider/update_user_provider.dart';
import 'package:loqma/utils.dart';
import 'package:provider/provider.dart';

class ChangePasswordSheetScreen extends StatefulWidget {
  const ChangePasswordSheetScreen({super.key});

  @override
  State<ChangePasswordSheetScreen> createState() => _ChangePasswordSheetScreenState();
}

class _ChangePasswordSheetScreenState extends State<ChangePasswordSheetScreen> {
  bool passScure=true;
  final _formkey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    TextEditingController oldPasswordController=TextEditingController();
    TextEditingController newPasswordController=TextEditingController();
    final userProvider=context.read<UpdateUserProvider>();
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          height: MediaQuery.of(context).size.height/2,
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: .spaceEvenly,
            children: [
              Text('Change Password',style: ConstantStyle.titeStyle,),
              TextFromFieldClass(controller: oldPasswordController, hint: 'Old Password', obScure: passScure,lable: 'Old Password',
              validator: (value) {
                if(value==null||value.isEmpty)
                {
                  return 'Please enter your old password';
                }
                if(value!=userProvider.currentUser!.password)
                {
                  return 'Incorrect old password';
                }
                return null;
              },
              preIcon: Icons.password,
              sufIcon: InkWell(
                      onTap: ()=>setState(() {
                        passScure=!passScure;
                      }),
                      child: passScure?Icon(Icons.visibility):Icon(Icons.visibility_off)),
        
              ),
        
              
              TextFromFieldClass(controller: newPasswordController, hint: 'New Password', obScure: passScure,lable: 'New Password',
              validator: (value) {
                if(Utils.checkPassword(value!))
                        {
                          return null;
                        }
                        else
                        {return 'Incorrect password'; }
              },
              preIcon: Icons.password,
              sufIcon: InkWell(
                      onTap: ()=>setState(() {
                        passScure=!passScure;
                      }),
                      child: passScure?Icon(Icons.visibility):Icon(Icons.visibility_off)),
        
              ),
              SizedBox(
                width: .infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ConstantColors.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  
                  
                  onPressed: (){
                  if(_formkey.currentState!.validate())
                  {
                    UserModel updatedUser=UserModel(
                      
                      fullName: userProvider.currentUser!.fullName,
                      email: userProvider.currentUser!.email,
                      password: newPasswordController.text,
                      phone: userProvider.currentUser!.phone,
                      profileImage: userProvider.currentUser!.profileImage,
                      location: userProvider.currentUser!.location
                    );
                    int userIndex = users.indexWhere((user) => user.id == userProvider.currentUser!.id);
                    userProvider.updateUser(updatedUser);
                    users[userIndex] = userProvider.currentUser!;
                    Navigator.pop(context);
                  }
                }, child: Text('Change Password',style: ConstantStyle.titeStyle.copyWith(color: Colors.white),)),
              )
            ],
          )
          )
        ),
      ),
    );
  }
}