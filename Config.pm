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
#  @date 04/23/12 9:55:01 AM
#
#
#-------------------------------------------------------------------------------

package Bugzilla::Extension::OpenID;

use strict;
use constant NAME => 'OpenID';
use constant REQUIRED_MODULES => [
    {
        package => 'Net::OpenID::Consumer',
        module  => 'Net::OpenID::Consumer',
        version => 1.13,
    },
    {
	package => 'Cache::File',
	module  => 'Cache::File',
	version => 'any',
    },
    {
	package => 'LWPx::ParanoidAgent',
	module  => 'LWPx::ParanoidAgent',
	version => 'any',
    }
];

__PACKAGE__->NAME;
