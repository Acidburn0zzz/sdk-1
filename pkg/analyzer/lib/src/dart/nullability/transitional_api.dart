// Copyright (c) 2019, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/src/dart/nullability/conditional_discard.dart';
import 'package:analyzer/src/dart/nullability/constraint_gatherer.dart';
import 'package:analyzer/src/dart/nullability/constraint_variable_gatherer.dart';
import 'package:analyzer/src/dart/nullability/decorated_type.dart';
import 'package:analyzer/src/dart/nullability/expression_checks.dart';
import 'package:analyzer/src/dart/nullability/unit_propagation.dart';
import 'package:analyzer/src/generated/resolver.dart';
import 'package:analyzer/src/generated/source.dart';

/// Type of a [ConstraintVariable] representing the addition of a null check.
class CheckExpression extends ConstraintVariable
    implements PotentialModification {
  final int _offset;

  @override
  final Source source;

  CheckExpression(this.source, Expression expression)
      : _offset = expression.end;

  @override
  bool get isEmpty => !value;

  @override
  Iterable<Modification> get modifications =>
      value ? [Modification(_offset, '!')] : [];

  @override
  toString() => 'checkNotNull($_offset)';
}

/// Records information about how a conditional expression or statement might
/// need to be modified.
class ConditionalModification extends PotentialModification {
  final int offset;

  final int end;

  final bool isStatement;

  final ConditionalDiscard discard;

  final _KeepNode condition;

  final _KeepNode thenStatement;

  final _KeepNode elseStatement;

  @override
  final Source source;

  factory ConditionalModification(
      Source source, AstNode node, ConditionalDiscard discard) {
    if (node is IfStatement) {
      return ConditionalModification._(
          node.offset,
          node.end,
          node is Statement,
          discard,
          _KeepNode(node.condition),
          _KeepNode(node.thenStatement),
          _KeepNode(node.elseStatement),
          source);
    } else {
      throw new UnimplementedError('TODO(paulberry)');
    }
  }

  ConditionalModification._(
      this.offset,
      this.end,
      this.isStatement,
      this.discard,
      this.condition,
      this.thenStatement,
      this.elseStatement,
      this.source);

  @override
  bool get isEmpty => discard.keepTrue.value && discard.keepFalse.value;

  @override
  Iterable<Modification> get modifications {
    if (isEmpty) return const [];
    // TODO(paulberry): move the following logic into DartEditBuilder (see
    // dartbug.com/35872).
    var result = <Modification>[];
    var keepNodes = <_KeepNode>[];
    if (!discard.pureCondition) {
      keepNodes.add(condition); // TODO(paulberry): test
    }
    if (discard.keepTrue.value) {
      keepNodes.add(thenStatement); // TODO(paulberry): test
    }
    if (discard.keepFalse.value) {
      keepNodes.add(elseStatement); // TODO(paulberry): test
    }
    // TODO(paulberry): test thoroughly
    for (int i = 0; i < keepNodes.length; i++) {
      var keepNode = keepNodes[i];
      if (i == 0 && keepNode.offset != offset) {
        result.add(Modification(offset, '/* '));
      }
      if (i != 0 || keepNode.offset != offset) {
        result.add(Modification(keepNode.offset, '*/ '));
      }
      if (i != keepNodes.length - 1 || keepNode.end != end) {
        result.add(Modification(keepNode.end,
            keepNode.isExpression && isStatement ? '; /*' : ' /*'));
      }
      if (i == keepNodes.length - 1 && keepNode.end != end) {
        result.add(Modification(end, ' */'));
      }
    }
    return result;
  }
}

/// Representation of a single location in the code that needs to be modified
/// by the migration tool.
///
/// TODO(paulberry): unify with SourceEdit.
class Modification {
  final int location;

  final String insert;

  Modification(this.location, this.insert);
}

/// Transitional migration API.
///
/// Usage: pass each input source file to [prepareInput].  Then pass each input
/// source file to [processInput].  Then call [finish] to obtain the
/// modifications that need to be made to each source file.
///
/// TODO(paulberry): this implementation keeps a lot of CompilationUnit objects
/// around.  Can we do better?
class NullabilityMigration {
  final _variables = Variables();

  final _constraints = Solver();

  Source _source;

  List<PotentialModification> finish() {
    _constraints.applyHeuristics();
    return _variables.getPotentialModifications();
  }

  void prepareInput(CompilationUnit unit) {
    // TODO(paulberry): allow processing of multiple files
    assert(_source == null);
    var source = unit.declaredElement.source;
    _source = source;
    unit.accept(ConstraintVariableGatherer(_variables, source));
  }

  void processInput(CompilationUnit unit, TypeProvider typeProvider) {
    unit.accept(
        ConstraintGatherer(typeProvider, _variables, _constraints, _source));
  }

  static String applyModifications(
      String code, List<Modification> modifications) {
    var migrated = code;
    for (var modification in modifications) {
      migrated = migrated.substring(0, modification.location) +
          modification.insert +
          migrated.substring(modification.location);
    }
    return migrated;
  }
}

/// Type of a [ConstraintVariable] representing the addition of `?` to a type.
class NullableTypeAnnotation extends ConstraintVariable
    implements PotentialModification {
  int _offset;

  @override
  final Source source;

  NullableTypeAnnotation(this.source, TypeAnnotation node) : _offset = node.end;

  @override
  bool get isEmpty => !value;

  @override
  Iterable<Modification> get modifications =>
      value ? [Modification(_offset, '?')] : [];

  @override
  toString() => 'nullable($_offset)';
}

/// Interface used by data structures representing potential modifications to
/// the code being migrated.
abstract class PotentialModification {
  bool get isEmpty;

  /// Gets the individual migrations that need to be done, considering the
  /// solution to the constraint equations.
  Iterable<Modification> get modifications;

  Source get source;
}

class Variables implements VariableRecorder, VariableRepository {
  final _decoratedElementTypes = <Element, DecoratedType>{};

  final _potentialModifications = <PotentialModification>[];

  @override
  ConstraintVariable checkNotNullForExpression(
      Source source, Expression expression) {
    var variable = CheckExpression(source, expression);
    _potentialModifications.add(variable);
    return variable;
  }

  @override
  DecoratedType decoratedElementType(Element element, {bool create: false}) =>
      _decoratedElementTypes[element] ??= create
          ? DecoratedType.forElement(element)
          : throw StateError('No element found');

  List<PotentialModification> getPotentialModifications() =>
      _potentialModifications.where((m) => !m.isEmpty).toList();

  @override
  ConstraintVariable nullableForExpression(Expression expression) =>
      _NullableExpression(expression);

  @override
  ConstraintVariable nullableForTypeAnnotation(
      Source source, TypeAnnotation node) {
    var variable = NullableTypeAnnotation(source, node);
    _potentialModifications.add(variable);
    return variable;
  }

  @override
  void recordConditionalDiscard(
      Source source, AstNode node, ConditionalDiscard conditionalDiscard) {
    _potentialModifications
        .add(ConditionalModification(source, node, conditionalDiscard));
  }

  void recordDecoratedElementType(Element element, DecoratedType type) {
    _decoratedElementTypes[element] = type;
  }

  void recordDecoratedExpressionType(Expression node, DecoratedType type) {}

  void recordDecoratedTypeAnnotation(TypeAnnotation node, DecoratedType type) {}

  @override
  void recordExpressionChecks(Expression expression, ExpressionChecks checks) {}
}

/// Helper object used by [ConditionalModification] to keep track of AST nodes
/// within the conditional expression.
class _KeepNode {
  final int offset;

  final int end;

  final bool isExpression;

  factory _KeepNode(AstNode node) {
    int offset = node.offset;
    int end = node.end;
    if (node is Block && node.statements.isNotEmpty) {
      offset = node.statements.beginToken.offset;
      end = node.statements.endToken.end;
    }
    return _KeepNode._(offset, end, node is Expression);
  }

  _KeepNode._(this.offset, this.end, this.isExpression);
}

/// Type of a [ConstraintVariable] representing the fact that a subexpression's
/// type is nullable.
class _NullableExpression extends ConstraintVariable {
  final int _offset;

  _NullableExpression(Expression expression) : _offset = expression.offset;

  @override
  toString() => 'nullable($_offset)';
}
