module.exports = grammar({
  name: 'pli',

  extras: $ => [
    /\s/,
    $.comment,
  ],

  conflicts: $ => [
    [$._expression, $.reference],
    [$.attribute, $.identifier],
    [$._preprocessor_expression, $._preprocessor_reference],
    [$.reference, $.identifier],
    [$._statement, $.identifier],
    [$.declare_statement, $.identifier],
    [$.procedure_statement, $.identifier],
    // FIX: Resolve ambiguity between Reference arguments and Call arguments
    [$.call_statement, $.reference],
  ],

  word: $ => $.identifier,

  rules: {
    source_file: $ => repeat(choice($._statement, $._percent_statement)),

    // --- Top Level Statements ---

    _statement: $ => seq(
      repeat(seq($.identifier, ':')), // Label prefixes
      choice(
        $.procedure_statement,
        $.declare_statement,
        $.assignment_statement,
        $.if_statement,
        $.do_statement,
        $.end_statement,
        $.call_statement,
        $.put_statement,
        $.get_statement,
        $.on_statement,
        $.signal_statement,
        $.revert_statement,
        $.open_statement,
        $.close_statement,
        $.allocate_statement,
        $.free_statement,
        $.return_statement,
        $.goto_statement,
        $.display_statement,
        $.delay_statement,
        $.stop_statement,
        $.exit_statement,
        $.wait_statement,
        $.read_statement,
        $.write_statement,
        $.rewrite_statement,
        $.delete_statement,
        $.locate_statement,
        $.unlock_statement,
        $.begin_statement,
        $.default_statement,
        $.null_statement
      )
    ),

    _percent_statement: $ => seq(
      '%',
      repeat(seq($.identifier, ':')),
      choice(
        $.pp_declare,
        $.pp_assignment,
        $.pp_if,
        $.pp_do,
        $.pp_end,
        $.pp_include,
        $.pp_activate,
        $.pp_deactivate,
        $.pp_goto,
        $.pp_note,
        $.pp_page,
        $.pp_skip,
        $.pp_null
      )
    ),

    // --- Core Statements ---

    null_statement: $ => ';',

    procedure_statement: $ => seq(
      choice('PROCEDURE', 'PROC'),
      optional($.parameter_list),
      repeat($.attribute),
      ';'
    ),

    declare_statement: $ => seq(
      choice('DECLARE', 'DCL'),
      commaSep1($.declaration_item),
      ';'
    ),

    declaration_item: $ => seq(
      optional($.number), // Level number
      $.identifier,
      repeat($.attribute)
    ),

    assignment_statement: $ => seq(
      commaSep1($.reference),
      '=',
      $._expression,
      optional(seq(',', 'BY', 'NAME')),
      ';'
    ),

    if_statement: $ => prec.right(seq(
      'IF',
      field('condition', $._expression),
      'THEN',
      field('consequence', choice($._statement, $._percent_statement)),
      optional(seq(
        optional('%'),
        'ELSE',
        field('alternative', choice($._statement, $._percent_statement))
      ))
    )),

    do_statement: $ => seq(
      'DO',
      optional(choice(
        seq($.reference, '=', commaSep1($.specification)),
        seq(choice('WHILE', 'UNTIL'), '(', $._expression, ')'),
        seq('WHILE', '(', $._expression, ')', 'UNTIL', '(', $._expression, ')')
      )),
      ';'
    ),

    specification: $ => seq(
      $._expression,
      optional(seq('TO', $._expression, optional(seq('BY', $._expression)))),
      optional(seq('REPEAT', $._expression)),
      optional(choice(
        seq('WHILE', '(', $._expression, ')'),
        seq('UNTIL', '(', $._expression, ')')
      ))
    ),

    end_statement: $ => seq('END', optional($.identifier), ';'),

    call_statement: $ => seq(
      'CALL',
      $.reference,
      // Optional args here handle cases like CALL A(1)(2) 
      // where A(1) is the reference and (2) are the call args.
      optional($.argument_list), 
      optional(seq('TASK', optional(seq('(', $.reference, ')')))),
      optional(seq('EVENT', '(', $.reference, ')')),
      ';'
    ),

    allocate_statement: $ => seq('ALLOCATE', commaSep1($.reference), ';'),
    begin_statement: $ => seq('BEGIN', optional(choice('ORDER', 'REORDER')), ';'),
    close_statement: $ => seq('CLOSE', commaSep1(seq('FILE', '(', $.reference, ')')), ';'),
    default_statement: $ => seq('DEFAULT', '(', commaSep1($._default_specification), ')', ';'),
    delay_statement: $ => seq('DELAY', '(', $._expression, ')', ';'),
    delete_statement: $ => seq('DELETE', 'FILE', '(', $.reference, ')', optional(seq('KEY', '(', $._expression, ')')), ';'),
    display_statement: $ => seq('DISPLAY', '(', $._expression, ')', optional(seq('REPLY', '(', $.reference, ')')), ';'),
    exit_statement: $ => seq('EXIT', ';'),
    free_statement: $ => seq('FREE', commaSep1($.reference), ';'),
    goto_statement: $ => seq(choice('GOTO', 'GO TO'), $.identifier, ';'),
    locate_statement: $ => seq('LOCATE', $.identifier, 'FILE', '(', $.reference, ')', ';'),
    on_statement: $ => seq('ON', $.identifier, choice('SYSTEM', $._statement), ';'),
    open_statement: $ => seq('OPEN', commaSep1(seq('FILE', '(', $.reference, ')', repeat($.attribute))), ';'),
    read_statement: $ => seq('READ', 'FILE', '(', $.reference, ')', choice('INTO', 'SET'), '(', $.reference, ')', ';'),
    release_statement: $ => seq('RELEASE', $.identifier, ';'),
    return_statement: $ => seq('RETURN', optional(seq('(', $._expression, ')')), ';'),
    revert_statement: $ => seq('REVERT', $.identifier, ';'),
    rewrite_statement: $ => seq('REWRITE', 'FILE', '(', $.reference, ')', ';'),
    signal_statement: $ => seq('SIGNAL', $.identifier, ';'),
    stop_statement: $ => seq('STOP', ';'),
    unlock_statement: $ => seq('UNLOCK', 'FILE', '(', $.reference, ')', ';'),
    wait_statement: $ => seq('WAIT', '(', commaSep1($.reference), ')', ';'),
    write_statement: $ => seq('WRITE', 'FILE', '(', $.reference, ')', 'FROM', '(', $.reference, ')', ';'),
    
    put_statement: $ => seq(
      'PUT', 
      optional(choice('LIST', 'EDIT', 'DATA')), 
      '(', commaSep1($._expression), ')', 
      ';'
    ),
    
    get_statement: $ => seq(
      'GET', 
      optional(choice('LIST', 'EDIT', 'DATA')), 
      '(', commaSep1($.reference), ')', 
      ';'
    ),

    _default_specification: $ => choice(
        'RANGE',
        'DESCRIPTORS'
    ),

    // --- Preprocessor Statements ---

    pp_declare: $ => seq(choice('DECLARE', 'DCL'), $.identifier, repeat($.attribute), ';'),
    pp_assignment: $ => seq($.identifier, '=', $._preprocessor_expression, ';'),
    pp_if: $ => prec.right(seq('IF', $._preprocessor_expression, '%', 'THEN', choice($._percent_statement, $.pp_do), optional(seq('%', 'ELSE', choice($._percent_statement, $.pp_do))))),
    pp_do: $ => seq('DO', optional(seq($.identifier, '=', $._preprocessor_expression, 'TO', $._preprocessor_expression)), ';'),
    pp_end: $ => seq('END', optional($.identifier), ';'),
    pp_include: $ => seq('INCLUDE', commaSep1(choice($.identifier, $.string)), ';'),
    pp_activate: $ => seq(choice('ACTIVATE', 'ACT'), $.identifier, optional(choice('RESCAN', 'NORESCAN')), ';'),
    pp_deactivate: $ => seq(choice('DEACTIVATE', 'DEACT'), $.identifier, ';'),
    pp_goto: $ => seq(choice('GOTO', 'GO TO'), $.identifier, ';'),
    pp_note: $ => seq('NOTE', '(', $.string, optional(seq(',', $.number)), ')', ';'),
    pp_page: $ => seq('PAGE', ';'),
    pp_skip: $ => seq('SKIP', optional(seq('(', $.number, ')')), ';'),
    pp_null: $ => ';',

    // --- Attributes ---

    attribute: $ => choice(
      'ALIGNED', 'ALGN',
      'AUTOMATIC', 'AUTO',
      'BASED',
      'BINARY', 'BIN',
      'BIT',
      'BUILTIN',
      'CHARACTER', 'CHAR',
      'COMPLEX', 'CPLX',
      'CONDITION', 'COND',
      'CONTROLLED', 'CTL',
      'DECIMAL', 'DEC',
      'DECLARE', 'DCL',
      'DEFINED', 'DEF',
      'DIMENSION', 'DIM',
      'DIRECT',
      'ENVIRONMENT', 'ENV',
      'EXTERNAL', 'EXT',
      'FIXED',
      'FLOAT',
      'INITIAL', 'INIT',
      'INTERNAL', 'INT',
      'LABEL',
      'LIKE',
      'NONVARYING', 'NONVAR',
      'OFFSET',
      seq('OPTIONS', '(', $.characteristic_list, ')'), 
      'PARAMETER', 'PARM',
      'PICTURE', 'PIC',
      'POINTER', 'PTR',
      'POSITION', 'POS',
      'PRECISION', 'PREC',
      'REAL',
      seq('RETURNS', '(', repeat1($.attribute), ')'), 
      'SEQUENTIAL', 'SEQL',
      'STATIC',
      'STREAM',
      'UNALIGNED', 'UNAL',
      'VARYING', 'VAR',
      'RECURSIVE', 
      'ORDER', 
      'REORDER',
      'REDUCIBLE', 
      'IRREDUCIBLE',
      seq('(', commaSep1($.bound), ')')
    ),

    // --- Expressions ---

    _expression: $ => choice(
      $.reference,
      $.number,
      $.string,
      $.binary_expression,
      $.unary_expression,
      $.parenthesized_expression
    ),

    binary_expression: $ => choice(
      ...[
        ['||', 1],
        ['*', 2], ['/', 2],
        ['+', 3], ['-', 3],
        ['>', 4], ['<', 4], ['>=', 4], ['<=', 4], ['=', 4], ['^=', 4],
        ['&', 5],
        ['|', 6],
      ].map(([op, p]) => prec.left(p, seq($._expression, op, $._expression)))
    ),

    unary_expression: $ => prec(7, seq(choice('+', '-', '^'), $._expression)),

    parenthesized_expression: $ => seq('(', $._expression, ')'),

    // --- Preprocessor Expressions ---

    _preprocessor_expression: $ => choice(
      $._preprocessor_reference,
      $.number,
      $.string,
      prec.left(1, seq($._preprocessor_expression, choice('+', '-', '*', '/', '||', '=', '>', '<', '&', '|'), $._preprocessor_expression))
    ),

    _preprocessor_reference: $ => $.identifier,

    // --- Basic Tokens ---

    // FIX: prec.right ensures 'A(B)' is parsed as one reference,
    // rather than Reference 'A' followed by Call Argument '(B)'
    reference: $ => prec.right(seq(
      optional(seq($.identifier, '->')), 
      $.identifier,
      optional($.argument_list), 
      repeat(seq('.', $.identifier, optional($.argument_list)))
    )),

    argument_list: $ => seq('(', commaSep1(choice($._expression, '*')), ')'),
    parameter_list: $ => seq('(', commaSep1($.identifier), ')'),
    bound: $ => seq(optional(seq($._expression, ':')), choice($._expression, '*')),
    characteristic_list: $ => commaSep1($.identifier),
    
    identifier: $ => /[a-zA-Z#@$][a-zA-Z0-9#@$_. ]*/,
    number: $ => /\d+(\.\d*)?([eE][+-]?\d+)?/,
    string: $ => choice(
      seq("'", repeat(choice(/[^']/, "''")), "'"),
      seq("'", repeat(/[0-1]/), "'B"),
      seq("'", repeat(/[0-9a-fA-F]/), "'X")
    ),
    comment: $ => token(seq('/*', /[^*]*\*+([^/*][^*]*\*+)*/, '/')),
  }
});

function commaSep1(rule) {
  return seq(rule, repeat(seq(',', rule)));
}
