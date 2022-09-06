import 'package:redux/redux.dart';
import 'package:smart_assistant/model/StoreEntity.dart';
import 'package:smart_assistant/redux/middleware/epic_store.dart';

import 'gsy_state.dart';

/// redux 的 combineReducers, 通过 TypedReducer 将 UpdateUserAction 与 reducers 关联起来
// ignore: non_constant_identifier_names
final StoreReducer= combineReducers<List<StoreEntity>>([
  TypedReducer<List<StoreEntity>, UpdateStoreAction>(_updateLoaded),
]);

List<StoreEntity> _updateLoaded(List<StoreEntity> stores, action) {
  stores = action.storeList;
  return stores;
}

class UpdateStoreAction {
  final List<StoreEntity> storeList;

  UpdateStoreAction(this.storeList);
}

// Stream<dynamic> storeListEpic(
//     Stream<dynamic> actions, EpicStore<GSYState> store) {
//   // Use the async* function to make easier
//   Stream<dynamic> _loadStoreList() async* {
//     var res = await UserDao.getUserInfoLocal();
//     yield UpdateUserAction(res.data);
//   }
//
//   return actions
//   // to UpdateUserAction actions
//       .whereType<FetchUserAction>()
//   // Don't start  until the 10ms
//       .debounce(((_) => TimerStream(true, const Duration(milliseconds: 10))))
//       .switchMap((action) => _loadUserInfo());
// }