class StaticpagesController < ApplicationController
  def index

  end

  def readme

  end

  def status
    @vertify_202 = ENV['vertify_202']
    @vertify_210 = ENV['vertify_210']
    @vertify_002 = ENV['vertify_002']
    @rent_202 = ENV['rent_202']
    @rent_210 = ENV['rent_210']
    @rent_002 = ENV['rent_002']
  end

end
