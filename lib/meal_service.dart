import 'package:cloud_firestore/cloud_firestore.dart';
import 'meal.dart';

class MealService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Meal>> getMeals() {
    return _db.collection('meals').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Meal.fromFirestore(doc)).toList();
    });
  }

  Future<void> addMeal(Meal meal) {
    return _db.collection('meals').add(meal.toMap());
  }

  Future<void> deleteOldMeals() async {
    DateTime oneWeekAgo = DateTime.now().subtract(Duration(days: 7));
    QuerySnapshot oldMealsSnapshot = await _db
        .collection('meals')
        .where('timestamp', isLessThan: Timestamp.fromDate(oneWeekAgo))
        .get();

    for (DocumentSnapshot doc in oldMealsSnapshot.docs) {
      await doc.reference.delete();
    }
  }
}
