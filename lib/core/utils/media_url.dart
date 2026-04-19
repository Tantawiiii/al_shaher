import '../network/api_constants.dart';

/// Collapses duplicate slashes in the URL path (e.g. `/storage//images/...`).
String? normalizeMediaUrl(String? raw) {
  if (raw == null) return null;
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return null;
  final schemeIdx = trimmed.indexOf('://');
  if (schemeIdx == -1) return trimmed.replaceAll(RegExp(r'/+'), '/');
  final beforePath = trimmed.substring(0, schemeIdx + 3);
  var rest = trimmed.substring(schemeIdx + 3);
  final slash = rest.indexOf('/');
  if (slash == -1) return trimmed;
  final authority = rest.substring(0, slash);
  var path = rest.substring(slash);
  while (path.contains('//')) {
    path = path.replaceAll('//', '/');
  }
  return '$beforePath$authority$path';
}

String _apiOrigin() {
  final u = Uri.parse(ApiConstants.baseUrl);
  return u.origin;
}

/// Prefer [fullUrl]; otherwise resolve [previewUrl] (absolute or relative to API host).
String? galleryImageUrl(String? fullUrl, String? previewUrl) {
  final normalizedFull = normalizeMediaUrl(fullUrl?.trim());
  if (normalizedFull != null && normalizedFull.isNotEmpty) {
    return normalizedFull;
  }
  final prev = previewUrl?.trim();
  if (prev == null || prev.isEmpty) return null;
  if (prev.startsWith('http://') || prev.startsWith('https://')) {
    return normalizeMediaUrl(prev);
  }
  final origin = _apiOrigin();
  final path = prev.startsWith('/') ? prev : '/$prev';
  return normalizeMediaUrl('$origin$path');
}
