:- dynamic(property/3).
:- dynamic(vcard_property/2).

% vCard data and construct AST
parse_vcard :-
    assert_properties_ast([
        property('VERSION', single, ['4.0']),
        property('FN', single, ['Simon Perreault']),
        property('N', single, ['Perreault', 'Simon', '', '', 'ing. jr,M.Sc.']),
        property('BDAY', single, ['--0203']),
        property('GENDER', single, ['M']),
        property('EMAIL', multiple, ['simon.perreault@viagenie.ca']),
        property('LANG', multiple, ['fr', 'en']),
        property('ORG', single, ['Viagenie']),
        property('ADR', multiple, ['Suite D2-630', '2875 Laurier', 'Quebec', 'QCG1V 2M2', 'Canada']),
        property('TEL', multiple, ['+1-418-262-6501', '+1-418-656-9254;ext=102']),
        property('GEO', single, ['46.772673,-71.282945']),
        property('KEY', single, ['http://www.viagenie.ca/simon.perreault/simon.asc']),
        property('TZ', single, ['-0500']),
        property('URL', multiple, ['http://nomis80.org'])
    ]).

% Assert vCard property into AST
assert_properties_ast([]).
assert_properties_ast([Property|Rest]) :-
    assertz(vcard_property(Property, _)),
    assert_properties_ast(Rest).

% vCard properties AST to HTML
vcard_to_html :-
    html_begin,
    vcard_properties_to_html,
    html_end.

% vCard properties AST to HTML format
vcard_properties_to_html :-
    vcard_property(Property, Values),
    html_property(Property, Values),
    fail. % Backtrack to find all properties
vcard_properties_to_html.

% HTML conversion predicates
html_begin :- writeln('<html>'), writeln('<body>').
html_end :- writeln('</body>'), writeln('</html>').

html_property(property(Property, _, [Value]), _) :-
    format('<p><b>~w:</b> ~w</p>', [Property, Value]).
html_property(property(Property, _, Values), _) :-
    format('<p><b>~w:</b> ', [Property]),
    html_values(Values),
    writeln('</p>').

html_values([]).
html_values([Value|Rest]) :-
    write(Value), write(' '),
    html_values(Rest).

% main
main :-
    parse_vcard,
    vcard_to_html.
