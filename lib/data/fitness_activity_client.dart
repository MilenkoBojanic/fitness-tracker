const baseUrl = 'fitness-tracker-mb-default-rtdb.firebaseio.com';
final url = Uri.https(baseUrl, 'activities-list.json');
Uri getDeleteUrl(String id) {
  return Uri.https(baseUrl, 'activities-list/$id.json');
}

Uri getPatchUrl(String id) {
  return Uri.https(baseUrl, 'activities-list/$id.json');
}

const headers = {
  'Content-Type': 'application/json',
};
