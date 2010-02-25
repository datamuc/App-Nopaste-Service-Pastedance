package App::Nopaste::Service::Pastedance;

use warnings;
use strict;
use Scalar::Util 'blessed';
use Encode;

our $VERSION = '0.01';

use base q[App::Nopaste::Service];

sub uri { return 'http://pb.rbfh.de/' }


sub fill_form {
    my ($self, $mech) = (shift, shift);
    my %args = @_;

    my $content = {
        code    => decode('UTF-8', $args{text}),
        subject => decode('UTF-8', $args{desc}),
        lang    => exists( $self->FORMATS->{ $args{lang} } )
          ? $self->FORMATS->{ $args{lang} }
          : 'txt',
    };

    $mech->agent_alias('Linux Mozilla');
    my $form = $mech->form_number(1) || return;

    # do not follow redirect please
    @{$mech->requests_redirectable} = ();

    my $paste = HTML::Form::Input->new(
        type => 'text',
        value => 'Send',
        name => 'paste'
    )->add_to_form($form);

    return $mech->submit_form( form_number => 1, fields => $content );
}

sub return {
    my $self = shift;
    my $mech = shift;
    my $response = $mech->response;
    if($response->is_redirect) {
      return (1,$response->header("Location"));
    } else {
      return (0, "Cannot find URL");
    }
}

sub FORMATS {
    {
        ada         => "Ada",
        applescript => "Applescript",
        asm         => "Assembler",
        bib         => "Bib",
        yacc        => "Bison",
        shell       => "Bourne Shell",
        c           => "C",
        csharp      => "C#",
        'c++'       => "C++",
        caml        => "CAML",
        changelog   => "changelog",
        cobol       => "COBOL",
        conf        => "conf",
        css         => "CSS",
        d           => "D",
        diff        => "diff",
        bat         => "DOS Batch",
        erl         => "Erlang",
        flex        => "Flex",
        f77         => "Fortran (Fixed)",
        f90         => "Fortran (Free)",
        glsl        => "GLSL",
        haskell     => "Haskell",
        html        => "HTML",
        ini         => "INI",
        java        => "Java",
        js          => "Javascript",
        latex       => "LaTeX",
        ldif        => "LDIF",
        lua         => "Lua",
        m4          => "m4",
        make        => "Makefile",
        pascal      => "Pascal",
        perl        => "Perl",
        php         => "PHP",
        ps          => "Postscript",
        python      => "Python",
        ruby        => "Ruby",
        scala       => "Scala",
        slang       => "Slang",
        sql         => "SQL",
        txt         => "txt",
        tcl         => "tcl/tk",
        vb          => "VB Script",
        xml         => "XML",
        xorg        => "Xorg",
    };
}

__END__
