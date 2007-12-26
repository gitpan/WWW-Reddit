package WWW::Reddit; {

    use warnings;
    use strict;
    
    use Object::InsideOut;
    use WWW::Mechanize;
    use XML::RSS;

=head1 NAME

WWW::Reddit - interface with reddit.com

=head1 VERSION

Version 0.05

=cut

    our $VERSION = '0.05';


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

    my $id = $r->post( url   => 'http://www.example.com'
                       title => 'The new and wonderful example website' );

    required parameters:
      url - the address of the url that you'd like to post
      title - the title that you would like to have appear on reddit.

    returns: the string that represents the reddit ID of the URL
    posted.

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
	$self->set_id( $self->get_id_from_url( $mech->uri() ) );
        
        return $self->get_id();

    }

=head2 get_id

  my $id = $r->get_id();

  get the reddit ID of the current submission.

=head2 set_id

  $r->set_id( '63iup' );

  pass in the ID of the reddit submission.

=head2 details

  fetch the details for a reddit submission

  takes an optional reddit ID for a submisstion. Otherwise, uses the
  ID already in the object.

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

      # If we have an ID passed in, set it.
      if ( my $id = shift ) {
          $self->set_id( $id );
      }

      return unless $self->get_id();

      my $mech = $self->get_mech();
      my $url = sprintf( 'http://reddit.com/info/%s/details', $self->get_id );
      $mech->get( $url );

      my $details = { submitted => undef, # DD Mon YYYY
                      points    => undef,
                      upvotes   => undef,
                      downvotes => undef,
                      url       => undef,
                      title     => undef,
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
      if ( $body =~ /class="title loggedin\s*"\s*href="([^"]+)"\s*>(.+?)<\/a>/i ) {
          $details->{'url'} = $1;
          $details->{'title'} = $2;
      }
      return $details;

    }

=head2 get_ids_from_feed

  my @listlist = $r->get_ids_from_feed();

  fetches the RSS feed from reddit and returns the list of reddit IDS
  in it. You can pass those IDs into the C<details> method to learn
  more about them.

=cut

    sub get_ids_from_feed {
        my $self = shift;
        
        my $mech = $self->get_mech();
        $mech->get( 'http://www.reddit.com/.rss' );

        my $parser = XML::RSS->new();
        $parser->parse( $mech->content() );

        my @idlist;
        
        # print the title and link of each RSS item
        foreach my $item ( @{$parser->{'items'}} ) {
            my $id = $self->get_id_from_url( $item->{'link'} );
            push @idlist, $id if $id;
        }
        return @idlist;
    }

=head2 get_id_from_url

  pass in a reddit url, and this method attempts to return the reddit
  ID in it. This works on both URLs from the website and those from
  the RSS feed.

=cut

    sub get_id_from_url {
        my $self = shift;

        my $url = shift or return;
        if ( $url =~ /info\/(\w+)\/comments\/$/ ) {
            # http://reddit.com/info/abc123/comments/
            return $1;
        } elsif ( $url =~ /goto\?rss=true&id=t3_(\w+)/ ) {
            # http://reddit.com/goto?rss=true&id=t3_63kie
            return $1
        }
        return;
    }
}

=head1 AUTHOR

Andrew Moore, C<< <amoore at cpan.org> >>

=head1 USAGE NOTE

reddit currently requires you to fill out a CAPTCHA to post a
submission when using a relatively new account, or maybe one with low
karma. This module does not circumvent that check. You therefore need
to have a more established reddit account to use this module to submit
to reddit. I do not have any intentions of changing this.

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

=item * Google Code repository

L<http://code.google.com/p/www-reddit/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2007 Andrew Moore, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of WWW::Reddit
