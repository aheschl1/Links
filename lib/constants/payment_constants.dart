import 'package:flutter/cupertino.dart';

class BraintreeConstants{

  static final _live = false;

  static final _tokenizationKeySandbox = 'sandbox_q7zgyn9g_fr7wvkwvcn3mw39z';
  static final _tokenizationKeyLive = 'sandbox_q7zgyn9g_fr7wvkwvcn3mw39z';


  static getTokenizationKey(){
    if(!_live){
      return _tokenizationKeySandbox;
    }
    return _tokenizationKeyLive;
  }

}