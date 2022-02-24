# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Api::Helpers::Rescuers::ErrorsRescue
  include Api::Helpers::Rescuers::ActiveRecordErrorsRescue
end
