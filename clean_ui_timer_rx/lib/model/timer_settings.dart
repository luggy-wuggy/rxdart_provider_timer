//List<String> setsList = List<String>.generate(50, (i) => "$i");

List<String> setsList = [for (var i = 1; i <= 50; i++) "$i"];

List<String> warningList = [
  "OFF",
  for (var i = 1; i <= 11; i++) "0:${(i * 5).toString().padLeft(2, '0')}",
  "1:00"
];
