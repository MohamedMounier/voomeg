import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:voomeg/core/enums/enums.dart';
import 'package:voomeg/core/utils/services/app_prefrences.dart';
import 'package:voomeg/features/auth/domain/entities/login.dart';
import 'package:voomeg/features/auth/domain/usecases/log_user_in_use_case.dart';
import 'package:voomeg/features/auth/domain/usecases/register_user_use_case.dart';
import 'package:voomeg/features/bids/domain/usecases/get_user_use_case.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final RegisterUserUseCase registerUserUseCase;
  final LogUserInUseCase logUserInUseCase;
  final GetUserUseCase getUserUseCase;
  final AppPreferences appPrefrences;

  LoginBloc(this.registerUserUseCase,this.logUserInUseCase,this.appPrefrences,this.getUserUseCase) : super(LoginState()) {
    on<LoginEventLogUserIn>(onLogin);
    on<LoginSaveUserCheck>(onSaveLogin);
    on<SaveUserUidEvent>(onSaveUserUid);
    on<RememberMeEvent>(onChangeRememberMe);
    on<ShowPasswordEvent>(onShowPassword);
    on<ChangeUserTypeEvent>(onChangeUserType);
    on<SaveUserTypeEvent>(onSaveUSerType);
    on<CheckUserTypeFromFireEvent>(onCheckUserTypeFromFire);

  }



  FutureOr<void> onLogin(LoginEventLogUserIn event, Emitter<LoginState> emit)async {

    emit(state.copyWith(requestState: RequestState.isLoading,loginSteps: LoginSteps.isLoginUserIn));
    final result = await logUserInUseCase(event.loginEntity);
    result.fold(
            (l) => emit(state.copyWith(
            loginErrorMessage: l.errorMessage,requestState: RequestState.isError,loginSteps: LoginSteps.isLoginUserInError)),

            (r) {

              emit(state.copyWith(user: r,requestState: RequestState.isSucc,userUid: r.user!.uid,loginSteps: LoginSteps.isLoginUserInSuccess));

            });


  }



  FutureOr<void> onSaveLogin(LoginSaveUserCheck event, Emitter<LoginState> emit)async {
    emit(state.copyWith(loginSteps: LoginSteps.isNone));
    var result = await appPrefrences.saveLogin(event.checkSearch!);
    result.fold((l) {
      emit(state.copyWith(requestState:RequestState.isError,loginErrorMessage: l.errorMessage));
    }, (r) {
      emit(state.copyWith(isUserSaved: event.checkSearch,requestState: RequestState.isNone));

    });
  }
  FutureOr<void> onSaveUserUid(SaveUserUidEvent event, Emitter<LoginState> emit)async {
    emit(state.copyWith(requestState: RequestState.isLoading,loginSteps: LoginSteps.isSavingUserUid));
    var result = await appPrefrences.saveUserUid(state.user!.user!.uid);
    result.fold((l) {
      emit(state.copyWith(requestState: RequestState.isError,loginSteps: LoginSteps.isSavingUserUidError,loginErrorMessage: l.errorMessage));
    }, (r) {
      if(r){

        emit(state.copyWith(userUid: state.user!.user!.uid,loginSteps: LoginSteps.isSavingUserUidSuccess,requestState: RequestState.isSucc));
        print(' user id sent from login is and saved uid is true ${state.user!.user!.uid}');

      }else{
        emit(state.copyWith(userUid:state.user!.user!.uid,loginSteps: LoginSteps.isSavingUserUidError));
        print(' user id sent from login is saved uid is false ${state.user!.user!.uid}');

      }

    });
  }


  FutureOr<void> onShowPassword(ShowPasswordEvent event, Emitter<LoginState> emit) {
    emit(state.copyWith(isPasswordVisible: event.isPasswordVisible =!event.isPasswordVisible!,requestState: RequestState.isNone));
  }

  FutureOr<void> onChangeRememberMe(RememberMeEvent event, Emitter<LoginState> emit) {
    emit(state.copyWith(isUserSaved: event.isRememberUser,requestState: RequestState.isNone,loginSteps: LoginSteps.isNone,));
  }
  FutureOr<void> onChangeUserType(ChangeUserTypeEvent event, Emitter<LoginState> emit)async {

    emit(state.copyWith(isTrader: event.isTrader,requestState: RequestState.isNone));

  }
  FutureOr<void> onSaveUSerType(SaveUserTypeEvent event, Emitter<LoginState> emit)async {
    var result = await appPrefrences.saveUserType(event.isTrader);
    result.fold((l) {
      emit(state.copyWith(requestState:RequestState.isError,loginErrorMessage: l.errorMessage));
    }, (r) {
      emit(state.copyWith(isTrader: event.isTrader,requestState: RequestState.isNone,loginSteps: LoginSteps.isNone));
    });

  }

  FutureOr<void> onCheckUserTypeFromFire(CheckUserTypeFromFireEvent event, Emitter<LoginState> emit)async {
    emit(state.copyWith(requestState: RequestState.isLoading,loginSteps: LoginSteps.isUserCheckingTypeFire));

    var result = await getUserUseCase(GetUserUseCaseParameters(userId: event.checkedUserId, isTrader: event.isTraderCheck));
    result.fold((l) {
      emit(state.copyWith(requestState:RequestState.isError,loginErrorMessage: l.errorMessage,loginSteps: LoginSteps.isUserCheckingTypeFireError));

    }, (r)  {
    emit(state.copyWith(requestState:RequestState.isSucc,loginSteps: LoginSteps.isUserCheckingTypeFireSuccess));

    });
  }
}



