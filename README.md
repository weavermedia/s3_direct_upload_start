# S3_Direct_Upload_Start
---

A basic Rails app with 'direct to S3' upload functionality supplied by the excellent [s3_direct_upload](http://github.com/waynehoover/s3_direct_upload) gem.

This is here more for my own reference than anything else but if you'd like to use it please read on.

To get this working all you need is two things:

### 1. Your S3 Access settings

Make a file in **/config/initializers** called `s3_direct_upload.rb` with the following content:


    S3DirectUpload.config do |c|
      c.access_key_id = ""       # your access key id
      c.secret_access_key = ""   # your secret access key
      c.bucket = ""              # your bucket name
      c.region = nil             # region prefix of your bucket url (optional), eg. "s3-eu-west-1"
      c.url = nil                # S3 API endpoint (optional), eg. "https://#{c.bucket}.s3.amazonaws.com/"
    end

Paste your S3 credentials into the first three fields. If your bucket region is anything other than US Standard you'll need to set the fourth field too.

If you're using this app with GitHub or other online version control you should move these out into environment variables to hide your AWS secret information from public eyes. If you just want to have a play with this app locally you could just add `s3_direct_upload.rb` to your **.gitignore** file.

### 2. Your S3 CORS settings

Make this your bucket CORS configuration. This is easily done through the AWS console, under the Properties tab of your bucket.

    <CORSConfiguration>
        <CORSRule>
            <AllowedOrigin>*</AllowedOrigin>
            <AllowedMethod>GET</AllowedMethod>
            <AllowedMethod>POST</AllowedMethod>
            <AllowedMethod>PUT</AllowedMethod>
            <MaxAgeSeconds>3000</MaxAgeSeconds>
            <AllowedHeader>*</AllowedHeader>
        </CORSRule>
    </CORSConfiguration>
    
Make sure `<AllowedOrigin>` is set to your development URL. This will usually be `http://localhost:3000` but if you're using Anvil, POW or similar to test your Rack apps it would something like `s3-direct-upload-start.dev`. You could set it to `*` but that leaves your bucket open to anyone.

## Usage
---

In the directory of your app, run the setup commands:

    $ bundle install
    $ rake db:migrate
    $ rails server
    
- Open the app in your browser (localhost:3000 or whatever).
- You will see the Photos `index` page with a **"Choose Files"** button. 
- You can either use this or simply drag and drop photos onto the page. 
- As soon as you've added photos they will start to upload and you will see progress bars for each image. 
- When each upload completes you will see a thumbnail image of the photo with it's ID and a link to delete the photo.

**Note:** the delete link only destroy the Photo record in the database, it does not delete the actual image from S3. You will need to tidy up manually or add the functionality yourself.

**Also note:** the thumbnail images are actually the full-sized images downloaded from S3 then sized with CSS. You will probably want to change this behaviour. You could make a thumbnail client-side and show it immediately. You might also want to upload that thumbnail to S3 (with a `-tn` suffix, for example) for use next time the image is called.
