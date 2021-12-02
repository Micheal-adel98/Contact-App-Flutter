class Employee{
  int id ;
  String name , groupName , address , landPhone, mobile1 , mobile2, birthDate;

Employee(this.name,this.address,this.landPhone,this.mobile1,this.mobile2,this.groupName, this.birthDate );

Map<String, dynamic> toMap(){
  var map = <String, dynamic>{

    'landPhone': landPhone,
    'mobile1': mobile1,
    'mobile2': mobile2,
    'name': name,
    'groupName': groupName,
    'address': address,
    'birthDate' : birthDate

  };
  return map;
}
Employee.fromMap(Map<String, dynamic>map){
  id = map['id'];
  landPhone = map['landPhone'];
  mobile1 = map['mobile1'];
  mobile2 = map['mobile2'];
  name = map['name'];
  groupName = map['groupName'];
  address = map['address'];
  birthDate = map['birthDate'];
}


}