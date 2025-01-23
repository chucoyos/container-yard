class PagesController < ApplicationController
  before_action :authenticate_user!, only: [ :catalogs ]
  def index
  end

  def catalogs
  end
end
