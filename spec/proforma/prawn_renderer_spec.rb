# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe ::Proforma::PrawnRenderer do
  let(:snapshot_dir) { File.join('spec', 'fixtures', 'snapshots', '*.yml') }

  let(:snapshot_filenames) { Dir[snapshot_dir] }

  it 'should process each snapshot successfully' do
    snapshot_filenames.each do |file|
      contents = yaml_read(file)

      documents = Proforma.render(
        contents['data'],
        contents['template'],
        evaluator: contents['evaluator'] || Proforma::HashEvaluator.new,
        renderer: contents['renderer'] || Proforma::PrawnRenderer.new
      )

      documents.each_with_index do |document, index|
        expected_strings = contents['strings'][index]

        text_analysis = PDF::Inspector::Text.analyze(document.contents)

        actual_strings = text_analysis.strings.join(' ')

        expect(actual_strings).to eq(expected_strings)
      end
    end
  end
end
