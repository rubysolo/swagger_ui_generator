# Swagger UI Generator

Rails generator to add Swagger UI API documentation to your application.

[Swagger UI](https://github.com/wordnik/swagger-ui) is a dependency-free
collection of HTML, Javascript, and CSS assets that dynamically generate
beautiful documentation from a Swagger-compliant API.

## Usage

Run the generator to create the Swagger UI structure:

    rails generate swagger_ui_generator:install

By default, Swagger UI will be created at `public/api-docs.html`, and all the
assets will be created in the `public/swagger` folder.  It will expect the root
swagger definition file to be accessible at: `/swagger/api-docs.json` from your
rails server.  If you use [swagger-docs](https://github.com/richhollis/swagger-docs)
to dynamically generate the API spec files, you can use an initializer something
like:

```ruby
endpoints = {
  "production"  => "http://api.my-service.com",
  "staging"     => "http://api-staging.my-service.com",
  "development" => "http://localhost:3000",
}

Swagger::Docs::Config.register_apis({
  "1.0" => {
    api_extension_type:  :json,
    api_file_path:       "public/swagger/",
    base_path:           "#{ endpoints[Rails.env] }",
    clean_directory:     true
  }
})

class Swagger::Docs::Config
  def self.transform_path(path)
    "swagger/#{ path }"
  end
end
```

This will create `api-docs.json` and an additional spec file per endpoint in the
`public/swagger` directory.


## Installation

Add this line to your application's Gemfile:

    gem 'swagger_ui_generator'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install swagger_ui_generator

## Contributing

1. Fork it ( http://github.com/<my-github-username>/swagger_ui_generator/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
