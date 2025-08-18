/// GraphQL-related exceptions
///
/// This module provides exception classes for handling GraphQL-related errors
/// such as query failures, mutation errors, and schema validation issues.
library;

import 'base_exception.dart';

/// Base class for GraphQL-related exceptions
abstract class GraphQLException extends AppException {
  GraphQLException({
    required super.message,
    required super.code,
    super.details,
    super.timestamp,
  });
}

/// Exception thrown when a GraphQL query fails
class GraphQLQueryException extends GraphQLException {
  final String query;
  final List<dynamic>? errors;

  GraphQLQueryException({
    required this.query,
    this.errors,
    String? message,
    super.code = 'graphql_query_error',
    super.details,
    super.timestamp,
  }) : super(
          message: message ?? 'GraphQL query failed',
        );

  @override
  Map<String, dynamic> toMap() => {
        ...super.toMap(),
        'query': query,
        'errors': errors,
      };
}

/// Exception thrown when GraphQL mutation fails
class GraphQLMutationException extends GraphQLException {
  final String mutation;
  final List<dynamic>? errors;

  GraphQLMutationException({
    required this.mutation,
    this.errors,
    String? message,
    String code = 'graphql_mutation_error',
    super.details,
    super.timestamp,
  }) : super(
          message: message ?? 'GraphQL mutation failed',
          code: code,
        );

  @override
  Map<String, dynamic> toMap() => {
        ...super.toMap(),
        'mutation': mutation,
        'errors': errors,
      };
}

/// Exception thrown when GraphQL schema is invalid
class GraphQLSchemaException extends GraphQLException {
  GraphQLSchemaException({
    required super.message,
    super.code = 'graphql_schema_error',
    super.details,
    super.timestamp,
  });
}

/// Exception thrown when GraphQL network transport fails
class GraphQLNetworkException extends GraphQLException {
  GraphQLNetworkException({
    required super.message,
    super.code = 'graphql_network_error',
    super.details,
    super.timestamp,
  });
}
