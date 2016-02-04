# NAME

Postfix::Mailgroups::Expand - Expand postfix mailgroups.

# VERSION

version 1.160350

# SYNOPSIS

        use Postfix::Mailgroups::Expand;
        
        my $groups = new Postfix::Mailgroups::Expand('groups'=>'/etc/postfix/virtual.groups','aliases'=>'/etc/postfix/aliases');

        $groups->write2dir('dirname');

# METHODS

## my $groups = new Postfix::Mailgroups::Expand('groups'=>'/etc/postfix/virtual.groups','aliases'=>'/etc/postfix/aliases');

Create new object instance.

## $groups->write2dir($outdir);

Write expanded groups to $outdir.

## $groups->\_get\_virtual\_alias\_maps($alias\_file);

Return virtual aliases maps.

## $groups->\_get\_alias\_maps($alias\_file);

Return aliases maps.

## $groups->\_get\_addresses($filename);

Read addresses from file.

# SEE ALSO

https://metacpan.org/module/Mail::ExpandAliases

# AUTHOR

Petr Kletecka &lt;pek@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2016 by Petr Kletecka.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
