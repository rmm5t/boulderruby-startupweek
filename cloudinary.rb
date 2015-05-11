require "bundler/setup"
Bundler.require(:cloudinary)
Cloudinary.config(YAML.load(IO.read("config/cloudinary.yml")))
include CloudinaryHelper

###########################################################################

# Basic Gravatar
url = gravatar_profile_image_path "ryan@mcgeary.org"

# # Bigger Gravatar
# url = gravatar_profile_image_path "ryan@mcgeary.org",
#                                   crop: :fill, size: "500x500"

# # Hulk Gravatar
# url = gravatar_profile_image_path "ryan@mcgeary.org",
#                                   crop: :fill, size: "300x300",
#                                   effect: "green:40", radius: 50

# # Twitter Profile Image
# url = twitter_name_profile_image_path "billclinton",
#                                       crop: :fill, size: "200x200"

# # Twitter w/ border radius and seia
# url = twitter_name_profile_image_path "billclinton",
#                               crop: :fill, size: "400x400",
#                               radius: 40, effect: :sepia

# # Twitter w/ pixelated face
# url = twitter_name_profile_image_path "billclinton",
#                               crop: :fill, size: "400x400",
#                               radius: 40, effect: "pixelate_faces:15"

# # Facebook Profile Image
# url = facebook_profile_image_path "georgewbush",
#                                   crop: :fill, size: "400x400"

# # Facebook w/ pixelated faces
# url = facebook_profile_image_path "georgewbush",
#                                   crop: :fill, size: "400x400",
#                                   effect: "pixelate_faces:5"

# # Facebook w/ crop on one face
# url = facebook_profile_image_path "georgewbush",
#                                   crop: :thumb, size: "300x300",
#                                   gravity: :face

# # Facebook w/ crop and focus on faces
# url = facebook_profile_image_path "georgewbush",
#                                   crop: :thumb, size: "600x300",
#                                   gravity: :faces

# # Fetch Example (original 4096x2731)
# url = "https://www.whitehouse.gov/sites/default/files/image/12152011-family-portrait-high-res.jpg"

# url = cl_image_path "https://www.whitehouse.gov/sites/default/files/image/12152011-family-portrait-high-res.jpg",
#                      type: "fetch",
#                      crop: "fill", width: "300"

# # Fetch w/ combination different transformations
# url = cl_image_path "https://www.whitehouse.gov/sites/default/files/image/12152011-family-portrait-high-res.jpg",
#                      type: "fetch",
#                      transformation: [
#                        { width: "800", height: "200", gravity: "faces", crop: "fill" },
#                        { effect: "grayscale", radius: "30" },
#                        { overlay: "whitehouse", width: 130,
#                          gravity: "west", x: 15, opacity: 75 }]

# # Addons: Website screenshot
# url = cl_image_path "http://cnn.com/", type: 'url2png', sign_url: true,
#                     width: 300, crop: "fill"

# # Addons: Enhanced Facial Recognition
# url = "http://upload.wikimedia.org/wikipedia/commons/1/1a/Five_Presidents_2009.jpg"

# url = cl_image_path "http://upload.wikimedia.org/wikipedia/commons/1/1a/Five_Presidents_2009.jpg",
#                     type: "fetch", sign_url: true,
#                     overlay: "glasses",  width: 2.1,
#                     flags: "region_relative", gravity: "rek_eyes"

puts url
File.open("demo.md", "w") do |f|
  f.puts "# ImageWitchcraft! (w/ Cloudinary)"
  f.puts "![Demo Image](#{url})"
  f.puts "```\n#{url}\n```"
end
