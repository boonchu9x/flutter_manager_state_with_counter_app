//valid email and pass
class Validator{
  static validEmail(String email){
    //valid dựa vào regex
    final regularExpression = RegExp(r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$');
    return regularExpression.hasMatch(email);
  }

  //one line function
  static validPass(String password) => password.length >= 6;//  valid pass >= 6 character
}