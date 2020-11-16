# frozen_string_literal: true

guard :rspec,
      cmd: 'bundle exec rspec --pattern spec/unit/**/*_spec.rb',
      all_on_start: true do
  spec_dir = 'spec/unit'
  watch('spec/spec_helper.rb') { spec_dir }
  watch(%r{spec/support/.*}) { spec_dir }
  watch(%r{spec/unit/.*}) { spec_dir }
  watch(%r{lib/.*}) { spec_dir }
end

guard :rubocop do
  ignore(%r{^.bundle-cache/})
  ignore(%r{^.batect/})
  watch(/.+\.rb$/)
  watch('Gemfile')
  watch('Guardfile')
  watch('Rakefile')
  watch(%r{(?:.+/)?\.rubocop(?:_todo)?\.yml$}) { |m| File.dirname(m[0]) }
end
