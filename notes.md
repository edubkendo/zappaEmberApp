Putting together Zappa, Brunch w/ Ember, Mongoose and Sockets.

npm install -g brunch

git clone git://github.com/icholy/ember-brunch.git -b coffee

brunch new myapp -s ./ember-brunch/

(or 
npm install -g brunch
git clone ######
npm install .
brunch build
)

set up server.coffee to start our server with zappajs, and serve the public folder. We also go ahead and set up 'mongoose' to be our MongoDB adapter:

```coffee
require('zappajs') ->

  mongoose = require 'mongoose'
  db = mongoose.connect('mongodb://localhost/zapp_ember_database')

  @use 'static'
```

