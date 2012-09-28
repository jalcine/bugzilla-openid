#-------------------------------------------------------------------------------
#
#   This file is part of Bugzilla-OpenID.
#
#   Copyright (C) 2012 Jacky Alciné <jackyalcine@gmail.com>
#
#   Bugzilla-OpenID is free software; you can redistribute it and/or
#   modify it under the terms of the GNU Library General Public
#   License as published by the Free Software Foundation; either
#   version 2 of the License, or (at your option) any later version.
#
#   Bugzilla-OpenID is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#   Library General Public License for more details.
#
#   You should have received a copy of the GNU Library General Public
#   License along with Bugzilla-OpenID.
#   If not, write to the Free Software Foundation, Inc.,
#   51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
#
#  @author Jacky Alciné <jackyalcine@gmail.com>
#  @date 04/23/12 9:53:48 AM
#
#
#-------------------------------------------------------------------------------

package Bugzilla::Extension::OpenID::Util;
use strict;
use warnings;

use Bugzilla::Util qw(correct_urlbase);
use Cache::File;
use LWPx::ParanoidAgent;
use Net::OpenID::Consumer;
our @EXPORT = qw(
    get_consumer
    get_identity
);

sub get_consumer {
    return Net::OpenID::Consumer->new(
        ua              => LWPx::ParanoidAgent->new,
        cache           => Cache::File->new (
                            cache_root => '/tmp'
        ),
        args            => Bugzilla->cgi(),
        consumer_secret => "04ByswYpRSyAtw7Re4hN6kOdw5M34nyAAlLldk",
        required_root   => correct_urlbase()
    );
}

sub get_identity {
    my ($url) = @_;

    my $consumer = get_consumer();
    my $cident = $consumer->claimed_identity(
        {
            return_to      =>  correct_urlbase() + "/?page.cgi=openid_authenticate.html",
            trust_root     =>  correct_urlbase(),
            delayed_return => 1
        }
    );

    unless ($cident){
        return {
            error   => $consumer->err,
            claimed => 0
        }
    } else {
        return {
            identity => \$cident,
            consumer   => bless($consumer,"Net::OpenID::Consumer"),
            error      => $consumer->err(),
            error_code => $consumer->errcode(),
            error_json => $consumer->json_err(),
            claimed    => 1
        }
    }
}

1;
