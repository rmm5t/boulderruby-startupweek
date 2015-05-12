guard :shell do
  watch(/^cloudinary.rb$/) do |m|
    command = "ruby #{m[0]} 2>&1"
    puts "Running: #{command}"
    puts output = `ruby #{m[0]} 2>&1`

    File.open("demo.md", "w") do |f|
      f.write "# Whoops there was an error!"
      f.write "\n```\n#{output}\n```"
    end unless $?.success?
  end
end
