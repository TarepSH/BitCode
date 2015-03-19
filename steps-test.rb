hcm = HtmlCssMatcher.new('"html" tag is exsist', '<html>
  <head>
  </head>
  <body>
    <h1 style="color: red">Hello, World</h1>
    <img src="" alt="">
  </body>
  </html>')
hcm.run

puts '-----'
hcm = HtmlCssMatcher.new('There is "body" tag inside the "html" tag', '<html>
  <head>
  </head>
  <body>
    <h1 style="color: red">Hello, World</h1>
    <img src="" alt="">
  </body>
  </html>')
hcm.run

puts '-----'
hcm = HtmlCssMatcher.new('There is "h1" tag inside the "body" tag', '<html>
  <head>
  </head>
  <body>
    <h1 style="color: red">Hello, World</h1>
    <img src="" alt="">
  </body>
  </html>')
hcm.run

puts '-----'
hcm = HtmlCssMatcher.new('There is "Hello, World" inside the "h1" tag', '<html>
  <head>
  </head>
  <body>
    <h1 style="color: red">Hello, World</h1>
    <img src="" alt="">
  </body>
  </html>')
hcm.run
