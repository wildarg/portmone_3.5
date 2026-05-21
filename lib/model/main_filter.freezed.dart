// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'main_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MainFilter {

 int get id; Nullable<DateTime> get startDate; Nullable<DateTime> get endDate; bool get plannedInclude; Nullable<Account> get account; Nullable<TransactionType> get transactionType; String get text;
/// Create a copy of MainFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MainFilterCopyWith<MainFilter> get copyWith => _$MainFilterCopyWithImpl<MainFilter>(this as MainFilter, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MainFilter&&(identical(other.id, id) || other.id == id)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.plannedInclude, plannedInclude) || other.plannedInclude == plannedInclude)&&(identical(other.account, account) || other.account == account)&&(identical(other.transactionType, transactionType) || other.transactionType == transactionType)&&(identical(other.text, text) || other.text == text));
}


@override
int get hashCode => Object.hash(runtimeType,id,startDate,endDate,plannedInclude,account,transactionType,text);

@override
String toString() {
  return 'MainFilter(id: $id, startDate: $startDate, endDate: $endDate, plannedInclude: $plannedInclude, account: $account, transactionType: $transactionType, text: $text)';
}


}

/// @nodoc
abstract mixin class $MainFilterCopyWith<$Res>  {
  factory $MainFilterCopyWith(MainFilter value, $Res Function(MainFilter) _then) = _$MainFilterCopyWithImpl;
@useResult
$Res call({
 int id, Nullable<DateTime> startDate, Nullable<DateTime> endDate, bool plannedInclude, Nullable<Account> account, Nullable<TransactionType> transactionType, String text
});




}
/// @nodoc
class _$MainFilterCopyWithImpl<$Res>
    implements $MainFilterCopyWith<$Res> {
  _$MainFilterCopyWithImpl(this._self, this._then);

  final MainFilter _self;
  final $Res Function(MainFilter) _then;

/// Create a copy of MainFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? startDate = null,Object? endDate = null,Object? plannedInclude = null,Object? account = null,Object? transactionType = null,Object? text = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as Nullable<DateTime>,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as Nullable<DateTime>,plannedInclude: null == plannedInclude ? _self.plannedInclude : plannedInclude // ignore: cast_nullable_to_non_nullable
as bool,account: null == account ? _self.account : account // ignore: cast_nullable_to_non_nullable
as Nullable<Account>,transactionType: null == transactionType ? _self.transactionType : transactionType // ignore: cast_nullable_to_non_nullable
as Nullable<TransactionType>,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MainFilter].
extension MainFilterPatterns on MainFilter {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MainFilter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MainFilter() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MainFilter value)  $default,){
final _that = this;
switch (_that) {
case _MainFilter():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MainFilter value)?  $default,){
final _that = this;
switch (_that) {
case _MainFilter() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  Nullable<DateTime> startDate,  Nullable<DateTime> endDate,  bool plannedInclude,  Nullable<Account> account,  Nullable<TransactionType> transactionType,  String text)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MainFilter() when $default != null:
return $default(_that.id,_that.startDate,_that.endDate,_that.plannedInclude,_that.account,_that.transactionType,_that.text);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  Nullable<DateTime> startDate,  Nullable<DateTime> endDate,  bool plannedInclude,  Nullable<Account> account,  Nullable<TransactionType> transactionType,  String text)  $default,) {final _that = this;
switch (_that) {
case _MainFilter():
return $default(_that.id,_that.startDate,_that.endDate,_that.plannedInclude,_that.account,_that.transactionType,_that.text);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  Nullable<DateTime> startDate,  Nullable<DateTime> endDate,  bool plannedInclude,  Nullable<Account> account,  Nullable<TransactionType> transactionType,  String text)?  $default,) {final _that = this;
switch (_that) {
case _MainFilter() when $default != null:
return $default(_that.id,_that.startDate,_that.endDate,_that.plannedInclude,_that.account,_that.transactionType,_that.text);case _:
  return null;

}
}

}

/// @nodoc


class _MainFilter implements MainFilter {
  const _MainFilter({required this.id, required this.startDate, required this.endDate, required this.plannedInclude, required this.account, required this.transactionType, required this.text});
  

@override final  int id;
@override final  Nullable<DateTime> startDate;
@override final  Nullable<DateTime> endDate;
@override final  bool plannedInclude;
@override final  Nullable<Account> account;
@override final  Nullable<TransactionType> transactionType;
@override final  String text;

/// Create a copy of MainFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MainFilterCopyWith<_MainFilter> get copyWith => __$MainFilterCopyWithImpl<_MainFilter>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MainFilter&&(identical(other.id, id) || other.id == id)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.plannedInclude, plannedInclude) || other.plannedInclude == plannedInclude)&&(identical(other.account, account) || other.account == account)&&(identical(other.transactionType, transactionType) || other.transactionType == transactionType)&&(identical(other.text, text) || other.text == text));
}


@override
int get hashCode => Object.hash(runtimeType,id,startDate,endDate,plannedInclude,account,transactionType,text);

@override
String toString() {
  return 'MainFilter(id: $id, startDate: $startDate, endDate: $endDate, plannedInclude: $plannedInclude, account: $account, transactionType: $transactionType, text: $text)';
}


}

/// @nodoc
abstract mixin class _$MainFilterCopyWith<$Res> implements $MainFilterCopyWith<$Res> {
  factory _$MainFilterCopyWith(_MainFilter value, $Res Function(_MainFilter) _then) = __$MainFilterCopyWithImpl;
@override @useResult
$Res call({
 int id, Nullable<DateTime> startDate, Nullable<DateTime> endDate, bool plannedInclude, Nullable<Account> account, Nullable<TransactionType> transactionType, String text
});




}
/// @nodoc
class __$MainFilterCopyWithImpl<$Res>
    implements _$MainFilterCopyWith<$Res> {
  __$MainFilterCopyWithImpl(this._self, this._then);

  final _MainFilter _self;
  final $Res Function(_MainFilter) _then;

/// Create a copy of MainFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? startDate = null,Object? endDate = null,Object? plannedInclude = null,Object? account = null,Object? transactionType = null,Object? text = null,}) {
  return _then(_MainFilter(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as Nullable<DateTime>,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as Nullable<DateTime>,plannedInclude: null == plannedInclude ? _self.plannedInclude : plannedInclude // ignore: cast_nullable_to_non_nullable
as bool,account: null == account ? _self.account : account // ignore: cast_nullable_to_non_nullable
as Nullable<Account>,transactionType: null == transactionType ? _self.transactionType : transactionType // ignore: cast_nullable_to_non_nullable
as Nullable<TransactionType>,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
