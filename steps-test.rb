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
hcm = HtmlCssMatcher.new('There is "html>body>h1.head.hod#hind" root hierarchy', '<html>
  <head>
  </head>
  <body>
    <h1 class="head hod" id="hind">Hello, World</h1>
    <img src="" alt="">
  </body>
  </html>')
hcm.run

puts '-----'
hcm = HtmlCssMatcher.new('There is "html>body>h1.head.hod#hind" root hierarchy', '<html>
  <head>
  </head>
  <body>
    <h1 class="hod head" id="hind">Hello, World</h1>
    <img src="" alt="">
  </body>
  </html>')
hcm.run

puts '-----'
hcm = HtmlCssMatcher.new('There is "html>body>h1.head.hod#hind" root hierarchy', '<html>
  <head>
  </head>
  <body>
    <h1 class="head ha hod" id="hind">Hello, World</h1>
    <img src="" alt="">
  </body>
  </html>')
hcm.run

puts '-----'
hcm = HtmlCssMatcher.new('There is "html>body>h1.head.hod#hind" root hierarchy', '<html>
  <head>
  </head>
  <body>
    <h1 class="head" id="hind">Hello, World</h1>
    <img src="" alt="">
  </body>
  </html>')
hcm.run

puts '-----'
hcm = HtmlCssMatcher.new('There is "body>h1.head.hod#hind" hierarchy', '<html>
  <head>
  </head>
  <body>
    <h1 class="head hod" id="hind">Hello, World</h1>
    <img src="" alt="">
  </body>
  </html>')
hcm.run

puts '-----'
hcm = HtmlCssMatcher.new('There is "body>h1.head.hod#hind" hierarchy', '<html>
  <head>
  </head>
  <body>
    <h1 class="head hod" id="hend">Hello, World</h1>
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
