# frozen_string_literal: true

require 'rubygems'
require 'bundler'

Bundler.setup
$LOAD_PATH << './lib'

require 'international_transfers_service'
run InternationalTransfersServiceApp
