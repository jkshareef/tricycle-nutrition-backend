require 'aws-sdk-rekognition'
require 'aws-sdk-s3'
require 'rmagick'
require 'base64'

class Api::V1::PhotosController < ApplicationController
  def create; end

  def computer_vision
    @photo = Photo.create(vision_params)
    # credentials = Aws::Credentials.new(
    #    ENV['AWS_ACCESS_KEY_ID'],
    #    ENV['AWS_SECRET_ACCESS_KEY']
    # )
    # client = Aws::Rekognition::Client.new credentials: credentials
    # # photo = 'photo.jpg'
    # # path = File.expand_path(photo) # expand path relative to the current directory
    # # file = File.read(path)
    # require 'aws-sdk-rekognition'

    credentials =
      Aws::Credentials.new(
        ENV['AWS_ACCESS_KEY_ID'],
        ENV['AWS_SECRET_ACCESS_KEY']
      )

    s3 = Aws::S3::Resource.new(region: 'us-west-2')
    bucket = 'tricycle-nutrition-app.images'
    obj = s3.bucket(bucket).object('temp.jpg')

    # var data = {
    #     Key: req.body.userId, 
    #     Body: buf,
    #     ContentEncoding: 'base64',
    #     ContentType: 'image/jpeg'
    #   };

    

    obj.put(body: Base64.decode64(@photo.base64))
      
    image = Magick::Image.read_inline(@photo.base64).first

    # photo  = 'key'# the name of file
    client = Aws::Rekognition::Client.new credentials: credentials
    attrs = {
        image: {
          s3_object: {
            bucket: bucket,
            name: 'temp.jpg'
          }
        },
          max_labels: 10
      }

    # attrs = {
    #   image: {
    #     bytes: vision_params["base64"]
    #   },
    #   max_labels: 10
    # }

    response = client.detect_labels attrs
    puts 'Detected labels for photo'
    response.labels.each do |label|
      puts "Label:      #{label.name}"
      puts "Confidence: #{label.confidence}"
      puts 'Instances:'

      label['instances'].each do |instance|
        box = instance['bounding_box']
        x_start = box.left * @photo.width
        y_start = box.top * @photo.height
        x_end = (box.left + box.width) * @photo.width
        y_end = (box.top + box.height) * @photo.height
        gc = Magick::Draw.new
        gc.stroke = 'white'
        gc.fill = 'white'
        gc.rectangle(x_start, y_start, x_end, y_end)
        gc.draw(image)
        puts '  Bounding box:'
        puts "    Top:        #{box.top}"
        puts "    Left:       #{box.left}"
        puts "    Width:      #{box.width}"
        puts "    Height:     #{box.height}"
        puts "  Confidence: #{instance.confidence}"
      end
      puts 'Parents:'
      label.parents.each { |parent| puts "  #{parent.name}" }
      puts '------------'
      puts ''
    end

    # s3 = Aws::S3::Resource.new(region:'us-west-2')
    # bucket = 'tricycle-nutrition-app.images'
    # obj = s3.bucket(bucket).object('key')

    # obj.put(body: image)
    image = Base64.encode64(image)

    render json: image, status: :accepted
  end

  private

  def vision_params
    params.require(:photo).permit(:width, :height, :exif, :base64)
  end
end
