package WWW::Reddit; {

    use warnings;
    use strict;
    
    use Object::InsideOut;
    use WWW::Mechanize;

=head1 NAME

WWW::Reddit - interface with reddit.com

=head1 VERSION

Version 0.01

=cut

    our $VERSION = '0.02';


=head1 SYNOPSIS

    use WWW::Reddit;

    my $r = WWW::Reddit->new( username => $username,
                              password => $password );

    $r->post( url   => 'http://www.example.com',
              title => 'The new and wonderful example website' );

=head1 METHODS

=head2 new

    used for instantiation.

    my $r = WWW::Reddit->new( username => $username,
                              password => $password );

    required arguments:
      username - your reddit.com username
      password - your reddit.com password

=cut

    # Fields containing username and password
    #  with standard get_* and set_* accessors
    #  and automatic paramter processing upon object creation
    my @username :Field :Std_All(username);
    my @password :Field :Std_All(password);

    # Field containing WWW::Mechanize objects
    #   With combined accessor
    #   no automatic parameter processing on object creation. We instantiate this object.
    my @mech
      :Field
      :Type(WWW::Mechanize)
      :Std(mech);

    # Field containing the reddit ID for the current post.
    #   combined accessor
    #   no parameter procssing
    my @id :Field :Std(id);

    sub _init :Init {
        my $self = shift;

        $self->_login();

    }

    sub _login {
        my $self = shift;

        my $mech = WWW::Mechanize->new();

        $mech->get( 'http://www.reddit.com/' );

        $mech->submit_form( form_number => 2,
                            fields      => { user_login   => $self->get_username(),
                                             passwd_login => $self->get_password(),
                                        }
                       );

        $self->set_mech( $mech );
    }


=head2 post

    add a URL to reddit.com

    $r->post( url   => 'http://www.example.com'
              title => 'The new and wonderful example website' );

    required parameters:
      url - the address of the url that you'd like to post
      title - the title that you would like to have appear on reddit.

=cut

    sub post {
        my $self = shift;
        my %args = @_;

        my $mech = $self->get_mech();

        $mech->get( 'http://reddit.com/submit' );

        $mech->submit_form( form_number => 2,
                            fields      => { url   => $args{'url'},
                                             title => $args{'title'},
                                        }
                       );

	my $uri = $mech->uri();
        # http://reddit.com/info/abc123/comments/

        if ( $uri =~ /info\/(\w+)\/comments\/$/ ) {
            $self->set_id( $1 );
        } else {
            $self->set_id( undef );
        }
        
        return $self->get_id();

    }

=head2 details

  fetch the details for a reddit submission

  takes no paramters, uses the id already in the object.

  returns a hashref that looks like:

     {
       'submitted' => '29 Nov 2007',
       'points'    => '2',
       'upvotes'   => '17',
       'downvotes' => '15'
     };

=cut

    sub details {
      my $self = shift;

      return unless $self->get_id();

      my $mech = $self->get_mech();
      my $url = sprintf( 'http://reddit.com/info/%s/details', $self->get_id );
      $mech->get( $url );

      my $details = { submitted => undef,
                      points    => undef,
                      upvotes   => undef,
                      downvotes => undef,
                 };
      
      my $body = $mech->content();
      return unless $body;
      if ( $body =~ /submitted<\/td><td>(\d+\s+\w+\s+\d+)<\/td>/i ) {
          $details->{'submitted'} = $1;
      }
      if ( $body =~ /points<\/td><td>(\d+)<\/td>/i ) {
          $details->{'points'} = $1;
      }
      if ( $body =~ /up votes<\/td><td>(\d+)<\/td>/i ) {
          $details->{'upvotes'} = $1;
      }
      if ( $body =~ /down votes<\/td><td>(\d+)<\/td>/i ) {
          $details->{'downvotes'} = $1;
      }

      return $details;

    }

}

=head1 AUTHOR

Andrew Moore, C<< <amoore at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-www-reddit at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WWW-Reddit>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WWW::Reddit


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=WWW-Reddit>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/WWW-Reddit>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/WWW-Reddit>

=item * Search CPAN

L<http://search.cpan.org/dist/WWW-Reddit>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2007 Andrew Moore, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of WWW::Reddit
