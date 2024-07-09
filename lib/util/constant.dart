
enum Filter{
  DATE_ASC("날짜 오름차순"),
  DATE_DESC("날짜 내림차순"),
  MODEL("모델별"),
  FOCAL_LENGTH("초점거리별");

  final String value;

  const Filter(this.value);
}

const FOCAL_LENGTH_MAX = '10000';

enum Exif_Key{
  MAKE('make'),
  MODEL('image model'),
  ISO('isospeedratings'),
  SHUTTER_SPEED('exposuretime'),
  FNUMBER('fnumber'),
  FOCAL_LENGTH('focallength');

  final String value;

  const Exif_Key(this.value);
}