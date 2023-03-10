
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:voomeg/features/auth/data/datasource/fire_store_consts.dart';
import 'package:voomeg/features/auth/data/models/login_model.dart';
import 'package:voomeg/features/auth/data/models/user_model.dart';

abstract class BaseUserRemoteDataSorce {
  Future<UserModel>getUser({required String userId,required bool isTrader});
  Future<UserCredential>logUserIn({required LoginModel loginModel});
  Future<void> logUserOut();
  Future<UserCredential>createUser({required String email,required String password});
  Future<void>addUser(UserModel userModel);
}

class UserRemoteDataSource implements BaseUserRemoteDataSorce{
 final FirebaseAuth firebaseAuth=FirebaseAuth.instance;
 final FirebaseFirestore firestore=FirebaseFirestore.instance;

  @override
  Future<void> addUser(UserModel userModel) async{
    await firestore.collection(userModel.isTrader?UserFireStoreConsts.tradersCollection:UserFireStoreConsts.usersCollection).doc(userModel.id).set(userModel.toFireBase());
  }

  @override
  Future<UserModel> getUser({required String userId,required bool isTrader}) async{
   var result= await firestore.collection(isTrader?UserFireStoreConsts.tradersCollection:UserFireStoreConsts.usersCollection).doc(userId).get();

   return  UserModel.fromFireBase(result.data());
  }

  @override
  Future<UserCredential> logUserIn({required LoginModel loginModel})async {
  return  await firebaseAuth.signInWithEmailAndPassword(email: loginModel.email, password: loginModel.password);

  }


 @override
 Future<void> logUserOut()async {
   await firebaseAuth.signOut();

 }
  @override
  Future<UserCredential> createUser( {required String email,required String password})async {
    return  await firebaseAuth.createUserWithEmailAndPassword(email:email, password: password);
    //     .onError<FirebaseException>((error, stackTrace) {
    //   print('Error heeere dataSource');
    //
    //   throw FireAuthException(ErrorMessageModel.fromError(message: error.message??'eeeeee', code: error.code??'coode'));
    // });

    // if(userCredential.user?.uid!=null){
    //   return userCredential;
    // }else{
    //   throw Exception();
    // }



  }

}