class DocsController < ActionController::Base
  
  def index
    render file: Rails.root.join('openapi.yml'), content_type: 'text/yaml'
  end

  def ui
    render html: redoc_html.html_safe, layout: false
  end

  private

  def redoc_html
    <<~HTML
      <!DOCTYPE html>
      <html>
        <head>
          <title>Thanx Rewards API Documentation</title>
          <meta charset="utf-8"/>
          <meta name="viewport" content="width=device-width, initial-scale=1">
          <link href="https://fonts.googleapis.com/css?family=Montserrat:300,400,700|Roboto:300,400,700" rel="stylesheet">
          <style>
            body {
              margin: 0;
              padding: 0;
            }
          </style>
        </head>
        <body>
          <redoc spec-url="/api-docs"></redoc>
          <script src="https://cdn.redoc.ly/redoc/latest/bundles/redoc.standalone.js"></script>
        </body>
      </html>
    HTML
  end
end 