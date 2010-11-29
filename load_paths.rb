%w[rocket rocket-core rocket-server rocket-js].each { |component|
  $:.unshift(File.expand_path("../#{component}/lib", __FILE__))
}
