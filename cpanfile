requires 'perl', '5.010001';

requires 'Hash::Merge', '0.200';
requires 'File::Basename';
requires 'Path::Tiny';

on test => sub {
    requires 'Test::More', '0.96';
    requires 'Test::Deep', '0.110';
};
