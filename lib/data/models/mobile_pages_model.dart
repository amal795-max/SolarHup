class MobilePagesModel {
  PrivacyModel? privacyAndPolicy;
  PrivacyModel? terms;
  AboutUs? aboutUs;
  ContactUs? contactUs;

  MobilePagesModel({
    this.privacyAndPolicy,
    this.terms,
    this.aboutUs,
    this.contactUs,
  });

  MobilePagesModel.fromJson(Map<String, dynamic> json) {
    privacyAndPolicy =
        json["privacy_and_policy"] != null
            ? PrivacyModel.fromJson(json["privacy_and_policy"])
            : null;
    terms = json["terms"] != null ? PrivacyModel.fromJson(json["terms"]) : null;
    aboutUs =
        json["about_us"] != null ? AboutUs.fromJson(json["about_us"]) : null;
    contactUs =
        json["contact_us"] != null
            ? ContactUs.fromJson(json["contact_us"])
            : null;
  }
}

class PrivacyModel {
  String? customHtml;

  PrivacyModel({this.customHtml});

  PrivacyModel.fromJson(Map<String, dynamic> json) {
    customHtml = json["custom_html"];
  }
}

class AboutUs {
  String? mainTitle;
  FirstSection? firstSection;
  SecondSection? secondSection;
  ThirdSection? thirdSection;

  AboutUs({
    this.mainTitle,
    this.firstSection,
    this.secondSection,
    this.thirdSection,
  });

  AboutUs.fromJson(Map<String, dynamic> json) {
    mainTitle = json["main_title"];
    firstSection =
        json["first_section"] != null
            ? FirstSection.fromJson(json["first_section"])
            : null;
    secondSection =
        json["second_section"] != null
            ? SecondSection.fromJson(json["second_section"])
            : null;
    thirdSection =
        json["third_section"] != null
            ? ThirdSection.fromJson(json["third_section"])
            : null;
  }
}

class FirstSection {
  String? title;
  String? description;

  FirstSection({this.title, this.description});

  FirstSection.fromJson(Map<String, dynamic> json) {
    title = json["title"];
    description = json["description"];
  }

  static List<FirstSection> fromJsonList(List<dynamic> data) {
    return List<FirstSection>.from(
      data.map((e) => FirstSection.fromJson(e)).toList(),
    );
  }
}

class SecondSection {
  String? title;
  List<FirstSection>? cards;

  SecondSection({this.title, this.cards});

  SecondSection.fromJson(Map<String, dynamic> json) {
    title = json["title"];
    if (json["cards"] != null) {
      cards = FirstSection.fromJsonList(json["cards"]);
    }
  }
}

class ThirdSection {
  String? title;
  String? subTitle;
  String? email;
  String? phone;

  ThirdSection({this.title, this.subTitle, this.email, this.phone});

  ThirdSection.fromJson(Map<String, dynamic> json) {
    title = json["title"];
    subTitle = json["sub_title"];
    email = json["email"];
    phone = json["phone"];
  }
}

class ContactUs {
  String? contactUsTitle;
  String? contactUsDescription;
  String? facebook;
  String? instagram;
  String? linkedin;

  ContactUs({
    this.contactUsTitle,
    this.contactUsDescription,
    this.facebook,
    this.instagram,
    this.linkedin,
  });

  ContactUs.fromJson(Map<String, dynamic> json) {
    contactUsTitle = json["contact_us_title"];
    contactUsDescription = json["contact_us_description"];
    facebook = json["facebook"];
    instagram = json["instagram"];
    linkedin = json["linkedin"];
  }
}
