///
//  Generated code. Do not modify.
//  source: google_auth.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use migrationPayloadDescriptor instead')
const MigrationPayload$json = const {
  '1': 'MigrationPayload',
  '2': const [
    const {'1': 'otp_parameters', '3': 1, '4': 3, '5': 11, '6': '.com.eloquentiastudios.airauth.MigrationPayload.OtpParameters', '10': 'otpParameters'},
    const {'1': 'version', '3': 2, '4': 1, '5': 5, '10': 'version'},
    const {'1': 'batch_size', '3': 3, '4': 1, '5': 5, '10': 'batchSize'},
    const {'1': 'batch_index', '3': 4, '4': 1, '5': 5, '10': 'batchIndex'},
    const {'1': 'batch_id', '3': 5, '4': 1, '5': 5, '10': 'batchId'},
  ],
  '3': const [MigrationPayload_OtpParameters$json],
  '4': const [MigrationPayload_Algorithm$json, MigrationPayload_DigitCount$json, MigrationPayload_OtpType$json],
};

@$core.Deprecated('Use migrationPayloadDescriptor instead')
const MigrationPayload_OtpParameters$json = const {
  '1': 'OtpParameters',
  '2': const [
    const {'1': 'secret', '3': 1, '4': 1, '5': 12, '10': 'secret'},
    const {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'issuer', '3': 3, '4': 1, '5': 9, '10': 'issuer'},
    const {'1': 'algorithm', '3': 4, '4': 1, '5': 14, '6': '.com.eloquentiastudios.airauth.MigrationPayload.Algorithm', '10': 'algorithm'},
    const {'1': 'digits', '3': 5, '4': 1, '5': 14, '6': '.com.eloquentiastudios.airauth.MigrationPayload.DigitCount', '10': 'digits'},
    const {'1': 'type', '3': 6, '4': 1, '5': 14, '6': '.com.eloquentiastudios.airauth.MigrationPayload.OtpType', '10': 'type'},
    const {'1': 'counter', '3': 7, '4': 1, '5': 3, '10': 'counter'},
  ],
};

@$core.Deprecated('Use migrationPayloadDescriptor instead')
const MigrationPayload_Algorithm$json = const {
  '1': 'Algorithm',
  '2': const [
    const {'1': 'ALGORITHM_UNSPECIFIED', '2': 0},
    const {'1': 'ALGORITHM_SHA1', '2': 1},
    const {'1': 'ALGORITHM_SHA256', '2': 2},
    const {'1': 'ALGORITHM_SHA512', '2': 3},
    const {'1': 'ALGORITHM_MD5', '2': 4},
  ],
};

@$core.Deprecated('Use migrationPayloadDescriptor instead')
const MigrationPayload_DigitCount$json = const {
  '1': 'DigitCount',
  '2': const [
    const {'1': 'DIGIT_COUNT_UNSPECIFIED', '2': 0},
    const {'1': 'DIGIT_COUNT_SIX', '2': 1},
    const {'1': 'DIGIT_COUNT_EIGHT', '2': 2},
  ],
};

@$core.Deprecated('Use migrationPayloadDescriptor instead')
const MigrationPayload_OtpType$json = const {
  '1': 'OtpType',
  '2': const [
    const {'1': 'OTP_TYPE_UNSPECIFIED', '2': 0},
    const {'1': 'OTP_TYPE_HOTP', '2': 1},
    const {'1': 'OTP_TYPE_TOTP', '2': 2},
  ],
};

/// Descriptor for `MigrationPayload`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List migrationPayloadDescriptor = $convert.base64Decode('ChBNaWdyYXRpb25QYXlsb2FkEmQKDm90cF9wYXJhbWV0ZXJzGAEgAygLMj0uY29tLmVsb3F1ZW50aWFzdHVkaW9zLmFpcmF1dGguTWlncmF0aW9uUGF5bG9hZC5PdHBQYXJhbWV0ZXJzUg1vdHBQYXJhbWV0ZXJzEhgKB3ZlcnNpb24YAiABKAVSB3ZlcnNpb24SHQoKYmF0Y2hfc2l6ZRgDIAEoBVIJYmF0Y2hTaXplEh8KC2JhdGNoX2luZGV4GAQgASgFUgpiYXRjaEluZGV4EhkKCGJhdGNoX2lkGAUgASgFUgdiYXRjaElkGucCCg1PdHBQYXJhbWV0ZXJzEhYKBnNlY3JldBgBIAEoDFIGc2VjcmV0EhIKBG5hbWUYAiABKAlSBG5hbWUSFgoGaXNzdWVyGAMgASgJUgZpc3N1ZXISVwoJYWxnb3JpdGhtGAQgASgOMjkuY29tLmVsb3F1ZW50aWFzdHVkaW9zLmFpcmF1dGguTWlncmF0aW9uUGF5bG9hZC5BbGdvcml0aG1SCWFsZ29yaXRobRJSCgZkaWdpdHMYBSABKA4yOi5jb20uZWxvcXVlbnRpYXN0dWRpb3MuYWlyYXV0aC5NaWdyYXRpb25QYXlsb2FkLkRpZ2l0Q291bnRSBmRpZ2l0cxJLCgR0eXBlGAYgASgOMjcuY29tLmVsb3F1ZW50aWFzdHVkaW9zLmFpcmF1dGguTWlncmF0aW9uUGF5bG9hZC5PdHBUeXBlUgR0eXBlEhgKB2NvdW50ZXIYByABKANSB2NvdW50ZXIieQoJQWxnb3JpdGhtEhkKFUFMR09SSVRITV9VTlNQRUNJRklFRBAAEhIKDkFMR09SSVRITV9TSEExEAESFAoQQUxHT1JJVEhNX1NIQTI1NhACEhQKEEFMR09SSVRITV9TSEE1MTIQAxIRCg1BTEdPUklUSE1fTUQ1EAQiVQoKRGlnaXRDb3VudBIbChdESUdJVF9DT1VOVF9VTlNQRUNJRklFRBAAEhMKD0RJR0lUX0NPVU5UX1NJWBABEhUKEURJR0lUX0NPVU5UX0VJR0hUEAIiSQoHT3RwVHlwZRIYChRPVFBfVFlQRV9VTlNQRUNJRklFRBAAEhEKDU9UUF9UWVBFX0hPVFAQARIRCg1PVFBfVFlQRV9UT1RQEAI=');
