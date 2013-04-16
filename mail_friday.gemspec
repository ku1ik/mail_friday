Gem::Specification.new do |gem|
  gem.name = "mail_friday"
  gem.version = '0.1'
  gem.authors = [ "Marcin Kulik" ]
  gem.email = [ "marcin.kulik@gmail.com" ]
  gem.description = "Blah"
  gem.summary = gem.description
  gem.homepage = "https://github.com/sickill/mail_friday"

  gem.require_paths = [ "lib" ]
  gem.files = `git ls-files`.split("\n")
  gem.test_files = `git ls-files -- {spec}/*`.split("\n")
  gem.extra_rdoc_files = %w[LICENSE README.md]

  gem.add_runtime_dependency('girl_friday')
end
