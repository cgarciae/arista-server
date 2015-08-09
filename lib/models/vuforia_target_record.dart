part of arista_server.models;

class VuforiaTargetRecordSchema {
  @Field() String target_id;
  @Field() bool active_flag;
  @Field() String name;
  @Field() String image;
  @Field() num width;
  @Field() int tracking_rating;
  @Field() String reco_rating;
  @Field() String application_metadata;
}

class VuforiaTargetRecord extends VuforiaTargetRecordSchema {
  @Field() String href;
}

class VuforiaResponse {
  @Field() String target_id;
  @Field() String result_code;
  @Field() VuforiaTargetRecord target_record;
  @Field() String transaction_id;
  @Field() List<String> similar_targets;
  @Field() List<String> results;

  @Field() bool get success => result_code == VuforiaResultCode.Success;
}

abstract class VuforiaResultCode {
  static const Success = "Success";
  static const TargetCreated = "TargetCreated";
  static const AuthenticationFailure = "AuthenticationFailure";
  static const RequestTimeTooSkewed = "RequestTimeTooSkewed";
  static const TargetNameExist = "TargetNameExist";
  static const UnknownTarget = "UnknownTarget";
  static const BadImage = "BadImage";
  static const ImageTooLarge = "ImageTooLarge";
  static const MetadataTooLarge = "MetadataTooLarge";
  static const DateRangeError = "DateRangeError";
  static const Fail = "Fail";
}
