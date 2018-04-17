package Data::Sah::CoerceRule::array::str_int_range_and_comma_sep;

# DATE
# VERSION

1;
# ABSTRACT: Coerce array of ints from comma-separated ints/int ranges

=head1 DESCRIPTION

This distribution contains Data::Sah coercion rule to coerce array of ints from
string in the form of comma-separated integers/integer ranges, for example:

 1
 1,2,4
 5-10
 5..10
 1, 5-10, 15, 20-23

The rule is not enabled by default. You can enable it in a schema using e.g.:

 ["array*", of=>"int", "x.coerce_rules"=>["str_int_range_and_comma_sep"]]


=head1 SEE ALSO

L<Data::Sah::CoerceRule::array::str_comma_sep>

L<Data::Sah::CoerceRule::array::str_int_range>

L<Data::Sah::Coerce>

L<Data::Sah>
