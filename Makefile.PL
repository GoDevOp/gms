#!/usr/bin/env perl
# IMPORTANT: if you delete this file your app will not work as
# expected.  You have been warned.
use inc::Module::Install;

name 'GMS-Web';
all_from 'lib/GMS/Web.pm';

requires 'Catalyst::Runtime' => '5.80005';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Action::RenderView';
requires 'Catalyst::Helper::View::TT';
requires 'parent';
requires 'Config::General'; # This should reflect the config file format you've chosen
                 # See Catalyst::Plugin::ConfigLoader for supported formats

requires 'Error';
requires 'RPC::XML';
requires 'DBIx::Class';

catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;