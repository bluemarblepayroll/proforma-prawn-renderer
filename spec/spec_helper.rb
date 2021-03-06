# frozen_string_literal: true

#
# Copyright (c) 2018-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'yaml'
require 'pdf/inspector'
require 'pry'
require 'pry-byebug'

unless ENV['DISABLE_SIMPLECOV'] == 'true'
  require 'simplecov'
  require 'simplecov-console'

  SimpleCov.formatter = SimpleCov::Formatter::Console
  SimpleCov.start do
    add_filter %r{\A/spec/}
  end
end

require './lib/proforma/prawn_renderer'

def read(file)
  File.open(file, 'rb').read
end

def yaml_read(file)
  YAML.safe_load(File.open(file))
end

def pdf_strings(rendered_pdf)
  PDF::Inspector::Text.analyze(rendered_pdf).strings.join(' ')
end
