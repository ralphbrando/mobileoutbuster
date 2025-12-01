import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class BookmarkRecord extends FirestoreRecord {
  BookmarkRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "userId" field.
  String? _userId;
  String get userId => _userId ?? '';
  bool hasUserId() => _userId != null;

  // "movieId" field.
  int? _movieId;
  int get movieId => _movieId ?? 0;
  bool hasMovieId() => _movieId != null;

  // "isMovie" field.
  bool? _isMovie;
  bool get isMovie => _isMovie ?? false;
  bool hasIsMovie() => _isMovie != null;

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  bool hasTitle() => _title != null;

  // "voteAverage" field.
  double? _voteAverage;
  double get voteAverage => _voteAverage ?? 0.0;
  bool hasVoteAverage() => _voteAverage != null;

  // "poster" field.
  String? _poster;
  String get poster => _poster ?? '';
  bool hasPoster() => _poster != null;

  // "lastEpisode" field.
  String? _lastEpisode;
  String get lastEpisode => _lastEpisode ?? '';
  bool hasLastEpisode() => _lastEpisode != null;

  void _initializeFields() {
    _userId = snapshotData['userId'] as String?;
    _movieId = castToType<int>(snapshotData['movieId']);
    _isMovie = snapshotData['isMovie'] as bool?;
    _title = snapshotData['title'] as String?;
    _voteAverage = castToType<double>(snapshotData['voteAverage']);
    _poster = snapshotData['poster'] as String?;
    _lastEpisode = snapshotData['lastEpisode'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('bookmark');

  static Stream<BookmarkRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => BookmarkRecord.fromSnapshot(s));

  static Future<BookmarkRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => BookmarkRecord.fromSnapshot(s));

  static BookmarkRecord fromSnapshot(DocumentSnapshot snapshot) =>
      BookmarkRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static BookmarkRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      BookmarkRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'BookmarkRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is BookmarkRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createBookmarkRecordData({
  String? userId,
  int? movieId,
  bool? isMovie,
  String? title,
  double? voteAverage,
  String? poster,
  String? lastEpisode,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'userId': userId,
      'movieId': movieId,
      'isMovie': isMovie,
      'title': title,
      'voteAverage': voteAverage,
      'poster': poster,
      'lastEpisode': lastEpisode,
    }.withoutNulls,
  );

  return firestoreData;
}

class BookmarkRecordDocumentEquality implements Equality<BookmarkRecord> {
  const BookmarkRecordDocumentEquality();

  @override
  bool equals(BookmarkRecord? e1, BookmarkRecord? e2) {
    return e1?.userId == e2?.userId &&
        e1?.movieId == e2?.movieId &&
        e1?.isMovie == e2?.isMovie &&
        e1?.title == e2?.title &&
        e1?.voteAverage == e2?.voteAverage &&
        e1?.poster == e2?.poster &&
        e1?.lastEpisode == e2?.lastEpisode;
  }

  @override
  int hash(BookmarkRecord? e) => const ListEquality().hash([
        e?.userId,
        e?.movieId,
        e?.isMovie,
        e?.title,
        e?.voteAverage,
        e?.poster,
        e?.lastEpisode
      ]);

  @override
  bool isValidKey(Object? o) => o is BookmarkRecord;
}
