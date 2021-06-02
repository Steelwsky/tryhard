import 'package:flutter_test/flutter_test.dart';
import 'package:tryhard/controller/user_controller.dart';
import 'package:tryhard/models/user.dart';

void main() {
  group('UserController, log in function', () {
    test('retrieving user from login provider, error', () async {
      final FakeLoginProviderError fakeLoginProviderError =
          FakeLoginProviderError();
      Future<void> _persistUser({required User? user}) {
        print(user!.uid);
        return Future.value(null);
      }

      final userController = UserController(
        persistUser: _persistUser,
        loginProvider: fakeLoginProviderError,
        userLoggedInState: UserLoggedInState(),
      );

      expect(userController.userProfile.value, null);
      await userController.onSignIn();
      expect(
        userController.userProfile.value!.data,
        null,
      );
    });

    test('retrieving user from login provider, successful', () async {
      final FakeLoginProviderSuccessful fakeLoginProviderSuccess =
          FakeLoginProviderSuccessful();

      Future<void> _persistUser({required User? user}) {
        print(user!.uid);
        return Future.value(null);
      }

      final userController = UserController(
        persistUser: _persistUser,
        loginProvider: fakeLoginProviderSuccess,
        userLoggedInState: UserLoggedInState(),
      );

      expect(userController.userProfile.value, null);
      await userController.onSignIn();
      expect(
        userController.userProfile.value!.data!.uid,
        'testUser',
      );
    });
  });
}

class FakeLoginProviderSuccessful implements LoginProvider {
  @override
  Future<bool> isSignIn() {
    print('fake isSignIn');
    return Future.value(true);
  }

  @override
  Future<User> signIn() {
    print('fake signIn');
    return Future.value(User(uid: 'testUser'));
  }
}

class FakeLoginProviderError implements LoginProvider {
  @override
  Future<bool> isSignIn() {
    return Future.value(false);
  }

  @override
  Future<User> signIn() {
    return Future.value(null);
  }
}
