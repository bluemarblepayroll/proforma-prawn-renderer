# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Proforma
  class PrawnRenderer
    # A list of options available for customizing the rendering engine.
    class Options < AttributeBasedObject
      DEFAULT_BOLD_FONT_STYLE   = :bold
      DEFAULT_FONT_NAME         = ''
      DEFAULT_TEXT_FONT_SIZE    = 10
      DEFAULT_HEADER_FONT_SIZE  = DEFAULT_TEXT_FONT_SIZE + 5

      attr_writer :bold_font_style,
                  :header_font_size,
                  :text_font_size

      attr_accessor :font_name

      def bold_font_style
        @bold_font_style || DEFAULT_BOLD_FONT_STYLE
      end

      def header_font_size
        @header_font_size ? @header_font_size.to_f : DEFAULT_HEADER_FONT_SIZE
      end

      def text_font_size
        @text_font_size ? @text_font_size.to_f : DEFAULT_TEXT_FONT_SIZE
      end
    end
  end
end
