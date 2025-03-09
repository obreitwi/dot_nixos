module.exports = grammar({
  name: 'timesheet',

  word: $ => $._identifier,

  rules: {
    source_file: $ => repeat(choice($.time_entry, $.task_entry, $._newline)),

    timestamp: $ => seq($._number, $._number, ':', $._number, $._number),

    time_entry: $ => seq(
      $.timestamp,
      optional($.title),
      optional($.story),
      $._newline
    ),

    task_entry: $ => seq($.entry_operator, $.entry, $._newline),

    entry_operator: $ => choice('*', '-'),

    title: $ => $.words,
    entry: $ => $.words,

    story: $ => seq(
      '#STORY',
      field('details', $.words)
    ),

    words: $ => repeat1($._identifier),

    _identifier: $ => /\S+/,

    _number: $ => /[0-9]/,

    _newline: $ => '\n',

    _whitespace: $ => /\s+/
  }
});
