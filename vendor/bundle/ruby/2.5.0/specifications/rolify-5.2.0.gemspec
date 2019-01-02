# -*- encoding: utf-8 -*-
# stub: rolify 5.2.0 ruby lib

Gem::Specification.new do |s|
  s.name = "rolify".freeze
  s.version = "5.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Florent Monbillard".freeze, "Wellington Cordeiro".freeze]
  s.date = "2017-12-19"
  s.description = "Very simple Roles library without any authorization enforcement supporting scope on resource objects (instance or class). Supports ActiveRecord and Mongoid ORMs.".freeze
  s.email = ["f.monbillard@gmail.com".freeze, "wellington@wellingtoncordeiro.com".freeze]
  s.homepage = "https://github.com/RolifyCommunity/rolify".freeze
  s.licenses = ["MIT".freeze]
  s.rubyforge_project = "rolify".freeze
  s.rubygems_version = "2.7.8".freeze
  s.summary = "Roles library with resource scoping".freeze

  s.installed_by_version = "2.7.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<ammeter>.freeze, ["~> 1.1"])
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.10"])
      s.add_development_dependency(%q<rake>.freeze, ["~> 10.4"])
      s.add_development_dependency(%q<rspec-rails>.freeze, ["~> 3.4"])
    else
      s.add_dependency(%q<ammeter>.freeze, ["~> 1.1"])
      s.add_dependency(%q<bundler>.freeze, ["~> 1.10"])
      s.add_dependency(%q<rake>.freeze, ["~> 10.4"])
      s.add_dependency(%q<rspec-rails>.freeze, ["~> 3.4"])
    end
  else
    s.add_dependency(%q<ammeter>.freeze, ["~> 1.1"])
    s.add_dependency(%q<bundler>.freeze, ["~> 1.10"])
    s.add_dependency(%q<rake>.freeze, ["~> 10.4"])
    s.add_dependency(%q<rspec-rails>.freeze, ["~> 3.4"])
  end
end
