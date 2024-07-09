
String getExifValueDiv(String input){
  final split = input.split('/');

  if(split.isNotEmpty){
    final a = double.parse(split[0]);
    final b = double.parse(split[1]);

    return (a/b).toStringAsFixed(2);
  }else{
    return split.first;
  }
}