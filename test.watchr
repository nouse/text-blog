watch( 'app_spec\.rb' ) {|md| system("rspec #{md[0]}") }
watch( 'app\.rb' ) {|md| system("rspec app_spec.rb") }

