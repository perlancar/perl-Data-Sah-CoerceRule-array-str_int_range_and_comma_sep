package Data::Sah::Coerce::perl::array::str_int_range_and_comma_sep;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

sub meta {
    +{
        v => 2,
        enable_by_default => 0,
        might_die => 1,
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
        "my \$res = []; ",
        "for my \$elem (split /\\s*,\\s*/, $dt) { ",
        "my (\$int1, \$int2) = \$elem =~ /\\A\\s*([+-]?\\d+)(?:\\s*(?:-|\\.\\.)\\s*([+-]?\\d+))?\\s*\\z/; ",
        "defined(\$int1) or die \"Invalid elem '\$elem': must be INT or INT1-INT2\"; ",
        "if (defined \$int2) { ",
        "if (\$int2 - \$int1 > 1_000_000) { die \"Elem '\$elem': Range too big\" } ",
        "push \@\$res, \$int1+0 .. \$int2+0; ",
        "} else { push \@\$res, \$int1 } ",
        "}", # for
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
