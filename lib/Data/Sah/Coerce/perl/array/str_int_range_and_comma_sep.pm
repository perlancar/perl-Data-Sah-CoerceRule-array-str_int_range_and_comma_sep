package Data::Sah::Coerce::perl::array::str_int_range_and_comma_sep;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

sub meta {
    +{
        v => 3,
        enable_by_default => 0,
        might_fail => 1,
        prio => 60, # a bit lower than normal
    };
}

sub coerce {
    my %args = @_;

    my $dt = $args{data_term};

    my $res = {};

    $res->{expr_match} = "!ref($dt)";

    $res->{expr_coerce} = join(
        "",
        "do { ",
        "my \$res; my \$ary = []; ",
        "for my \$elem (split /\\s*,\\s*/, $dt) { ",
        "  my (\$int1, \$int2) = \$elem =~ /\\A\\s*([+-]?\\d+)(?:\\s*(?:-|\\.\\.)\\s*([+-]?\\d+))?\\s*\\z/; ",
        "  if (!defined \$int1) { \$res = [\"Invalid elem '\$elem': must be INT or INT1-INT2\"]; last } ",
        "  if (defined \$int2) { ",
        "    if (\$int2 - \$int1 > 1_000_000) { \$res = [\"Elem '\$elem': Range too big\"]; last } ",
        "    push \@\$ary, \$int1+0 .. \$int2+0; ",
        "  } else { push \@\$ary, \$int1 } ",
        "}", # for
        "\$res ||= [undef, \$ary]; ",
        "\$res }",
    );

    $res;
}

1;
# ABSTRACT: Coerce array of ints from comma-separated ints/int ranges

=for Pod::Coverage ^(meta|coerce)$

=head1 DESCRIPTION

The rule is not enabled by default. You can enable it in a schema using e.g.:

 ["array*", of=>"int", "x.coerce_rules"=>["str_int_range_and_comma_sep"]]
