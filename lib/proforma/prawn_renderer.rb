# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'acts_as_hashable'
require 'forwardable'
require 'prawn'
require 'prawn/table'
require 'proforma'

require_relative 'prawn_renderer/banner_renderer'
require_relative 'prawn_renderer/header_renderer'
require_relative 'prawn_renderer/pane_renderer'
require_relative 'prawn_renderer/renderer'
require_relative 'prawn_renderer/separator_renderer'
require_relative 'prawn_renderer/spacer_renderer'
require_relative 'prawn_renderer/table_renderer'
require_relative 'prawn_renderer/text_renderer'
require_relative 'prawn_renderer/util/font'
require_relative 'prawn_renderer/util/options'

module Proforma
  # This main class to use as a Proforma renderer.
  class PrawnRenderer
    EXTENSION = '.pdf'

    RENDERERS = {
      Modeling::Banner => BannerRenderer,
      Modeling::Header => HeaderRenderer,
      Modeling::Pane => PaneRenderer,
      Modeling::Separator => SeparatorRenderer,
      Modeling::Spacer => SpacerRenderer,
      Modeling::Table => TableRenderer,
      Modeling::Text => TextRenderer
    }.freeze

    private_constant :RENDERERS

    attr_reader :options

    def initialize(options = {})
      @options = Util::Options.make(options)

      clear
    end

    def render(prototype)
      clear

      render_children(prototype.children)

      Proforma::Document.new(
        contents: pdf.render,
        extension: EXTENSION,
        title: prototype.title
      )
    end

    private

    attr_reader :pdf, :renderers

    def clear
      @pdf = fresh_pdf

      @renderers = RENDERERS.each_with_object({}) do |(model_class, renderer_class), hash|
        hash[model_class] = renderer_class.new(pdf, options)
      end
    end

    def fresh_pdf
      Prawn::Document.new.tap do |p|
        options.fonts.each do |font|
          p.font_families.update(font.prawn_config)
        end

        p.font(options.font_name)
      end
    end

    def render_children(children)
      children.each do |child|
        raise ArgumentError, "Cannot render: #{child.class.name}" unless renderable?(child)

        renderer(child).render(child)
      end
    end

    def renderable?(child)
      renderers.key?(child.class)
    end

    def renderer(child)
      renderers[child.class]
    end
  end
end
