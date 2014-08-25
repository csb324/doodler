class DoodlesController < ApplicationController

  respond_to :json

  def index
  end

  def show
    @doodle = Doodle.find(params[:id])
  end

  def create
    @doodle = Doodle.new
    @doodle.image = convert_data_uri_to_upload(params[:doodle][:imagedata])
    @doodle.user = current_user

    @doodle.doodleable = doodleable

    @doodle.save
    if params[:doodleable_type] == "Mission"
      respond_with doodleable
    else
      redirect_to doodleable
    end
  end


  private

  # these methods are here so i can pass a base64 string into the json
  # and upload them to carrierwave as an image file

  def doodleable
    doodleable_id = params["#{params[:doodleable_type].underscore}_id"]
    params[:doodleable_type].constantize.find(doodleable_id)
  end

  def convert_data_uri_to_upload(image_string)
    image_data = split_base64(image_string)
    image_data_string = image_data[:data]
    image_data_binary = Base64.decode64(image_data_string)

    temp_img_file = Tempfile.new("data_uri-upload")
    temp_img_file.binmode
    temp_img_file << image_data_binary
    temp_img_file.rewind

    img_params = {
      :filename => "data-uri-img.#{image_data[:extension]}",
      :type => image_data[:type],
      :tempfile => temp_img_file}

    uploaded_file = ActionDispatch::Http::UploadedFile.new(img_params)
    uploaded_file

  end

  # this method turns the data-uri into an object with some data
  def split_base64(uri_str)
    if uri_str.match(%r{^data:(.*?);(.*?),(.*)$})
      uri = Hash.new
      uri[:type] = $1 # "image/gif"
      uri[:encoder] = $2 # "base64"
      uri[:data] = $3 # data string
      uri[:extension] = $1.split('/')[1] # "gif"
      return uri
    else
      return nil
    end
  end

end
