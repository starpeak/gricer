Rails.application.routes.draw do


  get 'error' => 'dashboard#error'
  get 'forbidden' => 'dashboard#forbidden'
  get 'redirect' => 'dashboard#redirect'
  
  root to: "dashboard#index", format: 'html'  
  
  #mount Gricer::Engine => "/gricer"
end
