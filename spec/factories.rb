require 'ffaker'

FactoryGirl.define do
  factory :user do
    username { FFaker::Internet.user_name }
    password { FFaker::Internet.password }
  end

  factory :article do
    title   { FFaker::HipsterIpsum.sentence }
    content { FFaker::HipsterIpsum.paragraphs }
  end

  factory :comment do
    content { FFaker::HipsterIpsum.paragraph }
  end
end
